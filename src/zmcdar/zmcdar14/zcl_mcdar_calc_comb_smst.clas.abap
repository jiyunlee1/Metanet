CLASS zcl_mcdar_calc_comb_smst DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: tv_formula   TYPE c LENGTH 256,
           tv_smst      TYPE n LENGTH 3,
           tv_err       TYPE c LENGTH 1300,
           tv_calcamt   TYPE zmcdar_i_act_mnt_src-mntlyamt,
           tv_storecode TYPE zmcdar_i_act_mnt_src-storecode,
           tv_subsite   TYPE zmcdar_i_act_mnt_src-subsite,
           tv_year      TYPE n LENGTH 4,
           tv_period    TYPE n LENGTH 3,
           tv_glaccount TYPE c LENGTH 10,
           BEGIN OF ts_formula,
             symbol     TYPE c LENGTH 1,
             smartstore TYPE n LENGTH 3,
           END OF ts_formula,
           BEGIN OF ts_smst,
             smartstore TYPE n LENGTH 3,
             formula    TYPE tv_formula,
             calcamt    TYPE zmcdar_i_act_mnt_src-mntlyamt,
             errmsg     TYPE c LENGTH 1300,
           END OF ts_smst,
           BEGIN OF ts_base_smst,
             smartstore TYPE n LENGTH 3,
             iscomb     TYPE abap_boolean,
             formula    TYPE c LENGTH 256,
             possible   TYPE abap_boolean,
             depth      TYPE int1,
           END OF ts_base_smst,
           BEGIN OF ts_comb_base,
             smartstore TYPE n LENGTH 3,
             iscomb     TYPE abap_boolean,
             formula    TYPE c LENGTH 256,
             possible   TYPE abap_boolean,
             depth      TYPE int1,
             calcamt    TYPE zmcdar_i_act_mnt_src-MntlyAmt,
             errmsg     TYPE c LENGTH 1300,
           END OF ts_comb_base,
           tt_formula   TYPE STANDARD TABLE OF ts_formula WITH DEFAULT KEY,
           tt_smst      TYPE SORTED TABLE OF ts_smst WITH NON-UNIQUE KEY smartstore,
           tt_actmnt    TYPE SORTED TABLE OF zmcdar_u_act_mnt WITH NON-UNIQUE KEY fiscalyear fiscalperiod storecode subsite smartstore,
           tt_base_smst TYPE STANDARD TABLE OF ts_base_smst WITH KEY smartstore,
           tt_comb_base TYPE SORTED TABLE OF ts_comb_base WITH NON-UNIQUE KEY depth smartstore.
    CLASS-METHODS:
      comp_formula     IMPORTING VALUE(iv_formula) TYPE tv_formula
                       RETURNING VALUE(it_formula) TYPE tt_formula,
      calc_smst        IMPORTING VALUE(iv_smst)         TYPE tv_smst
                                 VALUE(iv_storecode)    TYPE tv_storecode
                                 VALUE(iv_subsite)      TYPE tv_subsite
                                 VALUE(iv_fiscalyear)   TYPE tv_year
                                 VALUE(iv_fiscalperiod) TYPE tv_period
                                 VALUE(it_actmnt)       TYPE tt_actmnt
                       CHANGING  VALUE(ct_smst)         TYPE tt_smst
                                 VALUE(cv_err)          TYPE tv_err
                       RETURNING VALUE(ev_calcamt)      TYPE tv_calcamt,
      calc_comb_smst    IMPORTING VALUE(iv_smst)         TYPE tv_smst
                                 VALUE(iv_storecode)    TYPE tv_storecode
                                 VALUE(iv_subsite)      TYPE tv_subsite
                                 VALUE(iv_fiscalyear)   TYPE tv_year
                                 VALUE(iv_fiscalperiod) TYPE tv_period
*                                 VALUE(iv_glaccount)    TYPE tv_glaccount
                                 VALUE(it_actmnt)       TYPE tt_actmnt
                       CHANGING  VALUE(ct_smst)         TYPE tt_comb_base
                                 VALUE(cv_err)          TYPE tv_err
                       RETURNING VALUE(ev_calcamt)      TYPE tv_calcamt,
      comp_depth_smst  IMPORTING VALUE(is_base_smst) TYPE ts_base_smst
                       CHANGING  VALUE(ct_base_smst) TYPE tt_base_smst
                       RETURNING VALUE(es_base_smst) TYPE ts_base_smst.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDAR_CALC_COMB_SMST IMPLEMENTATION.


  METHOD calc_comb_smst.

    READ TABLE ct_smst WITH KEY smartstore = iv_smst ASSIGNING FIELD-SYMBOL(<fs_now>).
*    IF sy-subrc <> 0.
*
*    ELSE.
    DATA lv_err LIKE cv_err.

    IF <fs_now>-possible = abap_false.
      ev_calcamt = 0.
      <fs_now>-errmsg = 'Missing Child Smart Store Data'.
      RETURN.
    ELSEIF <fs_now>-iscomb IS INITIAL.
      READ TABLE it_actmnt WITH KEY smartstore   = <fs_now>-smartstore
                                    fiscalperiod = iv_fiscalperiod
                                    fiscalyear   = iv_fiscalyear
*                                    glaccount    = iv_glaccount
                                    storecode    = iv_storecode
                                    subsite      = iv_subsite INTO DATA(ls_actmnt).
      IF sy-subrc <> 0.
        IF <fs_now>-errmsg IS INITIAL.
          <fs_now>-errmsg = |No Data for SmartStore : { <fs_now>-smartstore } StoreCode : { iv_storecode }|.
        ELSE.
          lv_err = |\nNo Data for SmartStore : { <fs_now>-smartstore } StoreCode : { iv_storecode }|.
          CONCATENATE <fs_now>-errmsg lv_err INTO <fs_now>-errmsg.
        ENDIF.
        ev_calcamt = 0.
        <fs_now>-calcamt = ev_calcamt.
      ELSE.
        ev_calcamt = ls_actmnt-MntlyAmt.
        <fs_now>-calcamt = ev_calcamt.
      ENDIF.
      RETURN.
    ENDIF.


    FIELD-SYMBOLS <fv_smst> TYPE zmcdar_i_def_smst-smartstore.
    DATA: lv_smst        TYPE zmcdar_i_def_smst-smartstore,
          lv_idx         TYPE i,
          ls_defsmstdata TYPE ts_comb_base,
          ls_defsmst     TYPE zmcdar_i_def_smst,
          ls_act_dtl     TYPE zmcdar_u_act_dtl.
    IF <fs_now>-calcamt IS NOT INITIAL.
      ev_calcamt = <fs_now>-calcamt.
      <fs_now>-calcamt = ev_calcamt.
    ELSE.
      DATA: lt_formula TYPE tt_formula,
            lv_nowamt  TYPE tv_calcamt.

      zcl_mcdar_calc_comb_smst=>comp_formula(
        EXPORTING
          iv_formula = <fs_now>-formula
        RECEIVING
          it_formula = lt_formula
      ).

      LOOP AT lt_formula INTO DATA(ls_formula).
*        ASSIGN ls_formula-smartstore TO <fv_smst> CASTING.
*        CLEAR lv_idx.
*        WHILE lv_idx < strlen( <fv_smst> ).
*          IF <fv_smst>+lv_idx(1) = '0'.
*            lv_idx += 1.
*          ELSE.
*            EXIT.
*          ENDIF.
*        ENDWHILE.
*        <fv_smst> = <fv_smst>+lv_idx.
*        CLEAR: ls_defsmst, ls_act_dtl.
        SHIFT ls_formula-smartstore LEFT DELETING LEADING '0'.
        READ TABLE ct_smst WITH KEY smartstore = ls_formula-smartstore INTO ls_defsmstdata.
*        SELECT SINGLE * FROM zmcdar_i_def_smst
*        WHERE smartstore = @<fv_smst>
*        INTO @ls_defsmst.
*
*        UNASSIGN <fv_smst>.
*        IF sy-subrc <> 0.
*          IF <fs_now> IS NOT ASSIGNED.
*            READ TABLE ct_smst WITH KEY smartstore = iv_smst ASSIGNING <fs_now>.
*          ENDIF.
*          IF <fs_now>-errmsg IS INITIAL.
*            <fs_now>-errmsg = |No Data for SmartStore : { iv_smst }|.
*          ELSE.
*            lv_err = |\nNo Data for SmartStore : { iv_smst }|.
*            CONCATENATE <fs_now>-errmsg lv_err INTO <fs_now>-errmsg.
*          ENDIF.
*          lv_nowamt = 0.
*        ELSE.
        IF ls_defsmstdata-errmsg IS NOT INITIAL.
          IF <fs_now>-errmsg IS INITIAL.
            <fs_now>-errmsg = ls_defsmstdata-errmsg.
          ELSE.
            <fs_now>-errmsg = |{ <fs_now>-errmsg } \n{ ls_defsmstdata-errmsg }|.
*            CONCATENATE <fs_now>-errmsg '\n' ls_defsmstdata-errmsg INTO <fs_now>-errmsg.
          ENDIF.
        ENDIF.
        CASE ls_formula-symbol.
          WHEN '+'.
            ev_calcamt += ls_defsmstdata-calcamt.
          WHEN '-'.
            ev_calcamt -= ls_defsmstdata-calcamt.
        ENDCASE.

*
*        IF ls_defsmstdata-iscomb = abap_false.
*          READ TABLE it_actdtl WITH KEY smartstore   = ls_formula-smartstore
*                                        fiscalperiod = iv_fiscalperiod
*                                        fiscalyear   = iv_fiscalyear
*                                        glaccount = iv_glaccount
*                                        storecode    = iv_storecode
*                                        subsite      = iv_subsite       INTO ls_act_dtl.
*          IF ls_act_dtl IS INITIAL.
*            IF <fs_now> IS NOT ASSIGNED.
*              READ TABLE ct_smst WITH KEY smartstore = iv_smst ASSIGNING <fs_now>.
*            ENDIF.
*            IF <fs_now>-errmsg IS INITIAL.
*              <fs_now>-errmsg = |No Data for SmartStore : { ls_formula-smartstore } StoreCode : { iv_storecode } G/LAccount : { iv_glaccount }|.
*            ELSE.
*              lv_err = |\nNo Data for SmartStore : { ls_formula-smartstore } StoreCode : { iv_storecode } G/LAccount : { iv_glaccount }|.
*              CONCATENATE <fs_now>-errmsg lv_err INTO <fs_now>-errmsg.
*            ENDIF.
*            lv_nowamt = 0.
*          ELSE.
*            lv_nowamt = ls_act_dtl-mntlyamt.
*          ENDIF.
*        ELSE.
*          zcl_mcdar_calc_comb_smst=>calc_comb_smst(
*            EXPORTING
*              iv_fiscalyear = iv_fiscalyear
*              iv_fiscalperiod = iv_fiscalperiod
*              iv_glaccount    = iv_glaccount
*              iv_storecode = iv_storecode
*              iv_subsite   = iv_subsite
*              iv_smst      = ls_formula-smartstore
*              it_actdtl    = it_actdtl
*            CHANGING
*              ct_smst      = ct_smst
*              cv_err       = cv_err
*            RECEIVING
*              ev_calcamt   = lv_nowamt
*          ).
*        ENDIF.
*        CASE ls_formula-symbol.
*          WHEN '+'.
*            ev_calcamt += lv_nowamt.
*          WHEN '-'.
*            ev_calcamt -= lv_nowamt.
*        ENDCASE.
*        CLEAR lv_nowamt.
*        ENDIF.
      ENDLOOP.
*      IF <fs_now> IS NOT ASSIGNED.
*        READ TABLE ct_smst WITH KEY smartstore = iv_smst ASSIGNING <fs_now>.
*      ENDIF.
      <fs_now>-calcamt = ev_calcamt.
    ENDIF.
  ENDMETHOD.


  METHOD calc_smst.
    READ TABLE ct_smst WITH KEY smartstore = iv_smst ASSIGNING FIELD-SYMBOL(<fs_now>).
*    IF sy-subrc <> 0.
*
*    ELSE.
    FIELD-SYMBOLS <fv_smst> TYPE zmcdar_i_def_smst-smartstore.
    DATA: lv_smst    TYPE zmcdar_i_def_smst-smartstore,
          lv_idx     TYPE i,
          ls_defsmst TYPE zmcdar_i_def_smst,
          ls_act_mnt TYPE zmcdar_u_act_mnt.
    IF <fs_now>-calcamt IS NOT INITIAL.
      ev_calcamt = <fs_now>-calcamt.
      <fs_now>-calcamt = ev_calcamt.
    ELSE.
      DATA: lt_formula TYPE tt_formula,
            lv_nowamt  TYPE tv_calcamt,
            lv_err     LIKE cv_err.

      zcl_mcdar_calc_comb_smst=>comp_formula(
        EXPORTING
          iv_formula = <fs_now>-formula
        RECEIVING
          it_formula = lt_formula
      ).

      LOOP AT lt_formula INTO DATA(ls_formula).
        ASSIGN ls_formula-smartstore TO <fv_smst> CASTING.
        CLEAR lv_idx.
        WHILE lv_idx < strlen( <fv_smst> ).
          IF <fv_smst>+lv_idx(1) = '0'.
            lv_idx += 1.
          ELSE.
            EXIT.
          ENDIF.
        ENDWHILE.
        <fv_smst> = <fv_smst>+lv_idx.
        CLEAR: ls_defsmst, ls_act_mnt.
        SELECT SINGLE * FROM zmcdar_i_def_smst
        WHERE smartstore = @<fv_smst>
        INTO @ls_defsmst.

        UNASSIGN <fv_smst>.
        IF sy-subrc <> 0.
          IF <fs_now> IS NOT ASSIGNED.
            READ TABLE ct_smst WITH KEY smartstore = iv_smst ASSIGNING <fs_now>.
          ENDIF.
          IF <fs_now>-errmsg IS INITIAL.
            <fs_now>-errmsg = |No Data for SmartStore : { iv_smst }|.
          ELSE.
            lv_err = |\nNo Data for SmartStore : { iv_smst }|.
            CONCATENATE <fs_now>-errmsg lv_err INTO <fs_now>-errmsg.
          ENDIF.
          lv_nowamt = 0.
        ELSE.
          IF ls_defsmst-iscomb = abap_false.
            READ TABLE it_actmnt WITH KEY smartstore   = ls_formula-smartstore
                                          fiscalperiod = iv_fiscalperiod
                                          fiscalyear   = iv_fiscalyear
                                          storecode    = iv_storecode
                                          subsite      = iv_subsite       INTO ls_act_mnt.
*            SELECT SINGLE * FROM zmcdar_i_act_mnt_src
*            WHERE smartstore = @ls_formula-smartstore
*              AND fiscalperiod = @iv_fiscalperiod
*              AND fiscalyear = @iv_fiscalyear
*              AND storecode = @iv_storecode
*              AND subsite = @iv_subsite
*            INTO @ls_act_mnt.
            IF ls_act_mnt IS INITIAL.
              IF <fs_now> IS NOT ASSIGNED.
                READ TABLE ct_smst WITH KEY smartstore = iv_smst ASSIGNING <fs_now>.
              ENDIF.
              IF <fs_now>-errmsg IS INITIAL.
                <fs_now>-errmsg = |No Data for SmartStore : { ls_formula-smartstore } StoreCode : { iv_storecode }|.
              ELSE.
                lv_err = |\nNo Data for SmartStore : { ls_formula-smartstore } StoreCode : { iv_storecode }|.
                CONCATENATE <fs_now>-errmsg lv_err INTO <fs_now>-errmsg.
              ENDIF.
              lv_nowamt = 0.
            ELSE.
              lv_nowamt = ls_act_mnt-mntlyamt.
            ENDIF.
          ELSE.
            zcl_mcdar_calc_comb_smst=>calc_smst(
              EXPORTING
                iv_fiscalyear = iv_fiscalyear
                iv_fiscalperiod = iv_fiscalperiod
                iv_storecode = iv_storecode
                iv_subsite   = iv_subsite
                iv_smst      = ls_formula-smartstore
                it_actmnt    = it_actmnt
              CHANGING
                ct_smst      = ct_smst
                cv_err       = cv_err
              RECEIVING
                ev_calcamt   = lv_nowamt
            ).
          ENDIF.
          CASE ls_formula-symbol.
            WHEN '+'.
              ev_calcamt += lv_nowamt.
            WHEN '-'.
              ev_calcamt -= lv_nowamt.
          ENDCASE.
          CLEAR lv_nowamt.
        ENDIF.
      ENDLOOP.
      IF <fs_now> IS NOT ASSIGNED.
        READ TABLE ct_smst WITH KEY smartstore = iv_smst ASSIGNING <fs_now>.
      ENDIF.
      <fs_now>-calcamt = ev_calcamt.
    ENDIF.
*    ENDIF.
  ENDMETHOD.


  METHOD comp_depth_smst.
    DATA lv_done TYPE abap_boolean.
    READ TABLE ct_base_smst WITH KEY smartstore = is_base_smst-smartstore ASSIGNING FIELD-SYMBOL(<fs_base_smst>).

    IF sy-subrc <> 0.
      es_base_smst = is_base_smst.
      es_base_smst-depth = 0.
      es_base_smst-possible = abap_false.
    ENDIF.

*   기존 Depth 계산 완료 건
    IF <fs_base_smst>-depth IS NOT INITIAL OR <fs_base_smst>-possible = abap_false.
      es_base_smst = <fs_base_smst>.
      RETURN.
    ENDIF.
*   단일 Smart Store
    IF is_base_smst-iscomb <> 'X'.
      <fs_base_smst>-possible = abap_true.
      <fs_base_smst>-depth = 1.
      es_base_smst = <fs_base_smst>.
      RETURN.
    ENDIF.
*   Composite Smart Store
    DATA: lt_formula TYPE tt_formula,
          lv_nowamt  TYPE tv_calcamt.

    zcl_mcdar_calc_comb_smst=>comp_formula(
      EXPORTING
        iv_formula = <fs_base_smst>-formula
      RECEIVING
        it_formula = lt_formula
    ).
    DATA: lt_child TYPE TABLE OF ts_base_smst,
          ls_child TYPE ts_base_smst.
    LOOP AT lt_formula INTO DATA(ls_formula).
      CLEAR: ls_child.
      SHIFT ls_formula-smartstore LEFT DELETING LEADING '0'.
      READ TABLE ct_base_smst WITH KEY smartstore = ls_formula-smartstore INTO ls_child.
      APPEND ls_child TO lt_child.
    ENDLOOP.

    DATA ls_child_smst TYPE ts_base_smst.
    LOOP AT lt_child INTO ls_child.
      zcl_mcdar_calc_comb_smst=>comp_depth_smst(
        EXPORTING
          is_base_smst = ls_child
        CHANGING
          ct_base_smst = ct_base_smst
        RECEIVING
          es_base_smst = ls_child_smst
      ).
      IF <fs_base_smst> IS NOT ASSIGNED.
        READ TABLE ct_base_smst WITH KEY smartstore = is_base_smst-smartstore ASSIGNING <fs_base_smst>.
      ENDIF.
      IF <fs_base_smst>-depth < ls_child_smst-depth + 1.
        <fs_base_smst>-depth = ls_child_smst-depth + 1.
      ENDIF.
      IF ls_child_smst-possible = abap_false.
        <fs_base_smst>-depth = 0.
        <fs_base_smst>-possible = abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.

    es_base_smst = <fs_base_smst>.
  ENDMETHOD.


  METHOD comp_formula.
    DATA: lv_fr     TYPE i VALUE 0,
          lv_to     TYPE i VALUE 0,
          lv_sublen TYPE i,
          lv_now    TYPE c LENGTH 1,
          lv_symbor TYPE c LENGTH 1.

    DATA(lv_len) = strlen( iv_formula ).

    IF iv_formula+0(1) = '-' OR iv_formula+0(1) = '+'.
      lv_symbor = iv_formula+0(1).
      lv_fr = 1.
      lv_to = 1.
    ELSE.
      lv_symbor = '+'.
    ENDIF.

    WHILE lv_to < lv_len.
      lv_now = iv_formula+lv_to(1).
      IF lv_now = '-' OR lv_now = '+'.
        lv_sublen = lv_to - lv_fr.
        APPEND VALUE ts_formula( symbol = lv_symbor smartstore = iv_formula+lv_fr(lv_sublen) ) TO it_formula.
        lv_symbor = lv_now.
        lv_to += 1.
        lv_fr = lv_to.
      ELSE.
        lv_to += 1.
      ENDIF.
    ENDWHILE.
    lv_sublen = lv_to - lv_fr + 1.
    APPEND VALUE ts_formula( symbol = lv_symbor smartstore =  iv_formula+lv_fr(lv_sublen) ) TO it_formula.
  ENDMETHOD.
ENDCLASS.
