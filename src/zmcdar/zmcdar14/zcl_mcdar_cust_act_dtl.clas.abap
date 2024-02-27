CLASS zcl_mcdar_cust_act_dtl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDAR_CUST_ACT_DTL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    TRY.
        DATA(lv_search) = io_request->get_search_expression( ).
        REPLACE ALL OCCURRENCES OF REGEX '[^[:alnum:]]' IN lv_search WITH ''.
        DATA(lt_params) = io_request->get_parameters( ).
        DATA(lt_ranges) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_root INTO DATA(lcx_exception).
*          DATA(lo_exception)          = cl_message_helper=>get_latest_t100_exception( lcx_exception ).
*          DATA(lo_exception_t100_key) = cl_message_helper=>get_latest_t100_exception( lcx_exception )->t100key.
*
*          RAISE EXCEPTION TYPE zfi_cl_exception01
*            EXPORTING
*              textid = VALUE scx_t100key(
*               msgid = lo_exception_t100_key-msgid
*               msgno = lo_exception_t100_key-msgno
*               attr1 = lo_exception_t100_key-attr1
*               attr2 = lo_exception_t100_key-attr2
*               attr3 = lo_exception_t100_key-attr3
*               attr4 = lo_exception_t100_key-attr4 ).
    ENDTRY.

    DATA(lv_top)    = io_request->get_paging( )->get_page_size( ).

    IF lv_top < 0.
      lv_top = 1.
    ENDIF.
    DATA(lv_skip)   = io_request->get_paging( )->get_offset( ).
    DATA(lt_fields) = io_request->get_requested_elements( ).
    DATA(lt_sort)   = io_request->get_sort_elements( ).

    DATA(lt_req_elements) = io_request->get_requested_elements( ).

    DATA: lv_year   TYPE n LENGTH 4,
          lv_period TYPE n LENGTH 3.

    READ TABLE lt_ranges WITH KEY name = 'FISCALYEAR' INTO DATA(ls_year).
    READ TABLE lt_ranges WITH KEY name = 'FISCALPERIOD' INTO DATA(ls_period).
    lv_year = ls_year-range[ 1 ]-low.
    lv_period = ls_period-range[ 1 ]-low.

*     Compose Sort
    DATA: lv_sort TYPE string,
          lv_desc TYPE string.

    LOOP AT lt_sort INTO DATA(ls_sort).
      CASE ls_sort-descending.
        WHEN 'X'.
          lv_desc = 'DESCENDING'.
        WHEN OTHERS.
          lv_desc = ''.
      ENDCASE.
      IF lv_sort IS INITIAL.
        lv_sort = |{ ls_sort-element_name } { lv_desc }|.
*          CONCATENATE ls_sort-element_name lv_desc INTO lv_sort.
      ELSE.
        lv_sort = |{ lv_sort }, { ls_sort-element_name } { lv_desc }|.
*          CONCATENATE lv_sort ', ' ls_sort-element_name lv_desc INTO lv_sort.
      ENDIF.
    ENDLOOP.

    TYPES: BEGIN OF ts_smst,
             smartstore TYPE n LENGTH 3,
             formula    TYPE c LENGTH 256,
             calcamt    TYPE zmcdar_i_act_dtl_src-acctamt,
             errmsg     TYPE c LENGTH 1300,
           END OF ts_smst,
           BEGIN OF ts_def_smst,
             smartstore TYPE c LENGTH 3,
             formula    TYPE c LENGTH 256,
             calcamt    TYPE zmcdar_i_act_dtl_src-acctamt,
           END OF ts_def_smst.

    DATA:
*          lt_comb_base TYPE SORTED TABLE OF ts_smst
*                       WITH NON-UNIQUE KEY smartstore,
*          lt_comb      TYPE SORTED TABLE OF ts_smst
*                       WITH NON-UNIQUE KEY smartstore,
*          ls_comb_base TYPE ts_smst,
      ls_def_comb TYPE ts_def_smst,
      lv_smst     TYPE zmcdar_i_act_dtl_src-smartstore.

    FIELD-SYMBOLS: <fv_smst> TYPE zmcdar_i_act_dtl_src-smartstore.

    TYPES: BEGIN OF ts_base_smst_org,
             smartstore TYPE c LENGTH 3,
             iscomb     TYPE abap_boolean,
             formula    TYPE c LENGTH 256,
             possible   TYPE abap_boolean,
             depth      TYPE int1,
           END OF ts_base_smst_org,
           BEGIN OF ts_base_smst,
             smartstore TYPE n LENGTH 3,
             iscomb     TYPE abap_boolean,
             formula    TYPE c LENGTH 256,
             possible   TYPE abap_boolean,
             depth      TYPE int1,
           END OF ts_base_smst,
           tv_smst TYPE n LENGTH 3.
    DATA: lt_base_smst     TYPE STANDARD TABLE OF ts_base_smst WITH KEY smartstore,
          ls_base_smst_org TYPE ts_base_smst_org,
          ls_base_smst     TYPE ts_base_smst.

    SELECT smartstore, iscomb, formula
    FROM zmcdar_i_def_smst
    INTO CORRESPONDING FIELDS OF @ls_base_smst_org.
      ASSIGN ls_base_smst_org-smartstore TO <fv_smst> CASTING.
      ls_base_smst-depth = 0.
      ls_base_smst-possible = abap_true.
      ls_base_smst-iscomb = ls_base_smst_org-iscomb.
      ls_base_smst-formula = ls_base_smst_org-formula.
      ls_base_smst-smartstore = <fv_smst>.
      INSERT ls_base_smst INTO TABLE lt_base_smst.
      CLEAR ls_base_smst.
      UNASSIGN <fv_smst>.
    ENDSELECT.

    TYPES: BEGIN OF ts_comb_base,
             smartstore TYPE n LENGTH 3,
             iscomb     TYPE abap_boolean,
             formula    TYPE c LENGTH 256,
             possible   TYPE abap_boolean,
             depth      TYPE int1,
             calcamt    TYPE zmcdar_i_act_dtl_src-acctamt,
             errmsg     TYPE c LENGTH 1300,
           END OF ts_comb_base.

    DATA: lt_comb_base TYPE SORTED TABLE OF ts_comb_base WITH NON-UNIQUE KEY depth smartstore,
          ls_comb_base TYPE ts_comb_base,
          lt_comb      TYPE SORTED TABLE OF ts_comb_base WITH NON-UNIQUE KEY depth smartstore,
          ls_comb      TYPE ts_comb_base.


    CLEAR ls_base_smst.
    DATA lt_base_smst_ch LIKE lt_base_smst.
    lt_base_smst_ch = CORRESPONDING #( lt_base_smst ).
    LOOP AT lt_base_smst INTO ls_base_smst.
      zcl_mcdar_calc_comb_smst=>comp_depth_smst(
        EXPORTING
          is_base_smst = ls_base_smst
        CHANGING
          ct_base_smst = lt_base_smst_ch
        RECEIVING
          es_base_smst = ls_base_smst
      ).
      ls_comb_base = CORRESPONDING #( ls_base_smst ).
      CLEAR ls_comb_base.
    ENDLOOP.

    SORT lt_base_smst_ch BY depth smartstore.

    lt_comb_base = CORRESPONDING #( lt_base_smst_ch ).


*    SELECT * FROM zmcdar_i_def_smst
*             WHERE iscomb = 'X'
*             INTO CORRESPONDING FIELDS OF @ls_def_comb.
*      ASSIGN ls_def_comb-smartstore TO <fv_smst> CASTING.
*      ls_comb_base-calcamt = ls_def_comb-calcamt.
*      ls_comb_base-formula = ls_def_comb-formula.
*      ls_comb_base-smartstore = <fv_smst>.
*      INSERT ls_comb_base INTO TABLE lt_comb_base.
*      CLEAR ls_comb_base.
*      UNASSIGN <fv_smst>.
*    ENDSELECT.

    DATA: lv_store     TYPE zmcdar_i_act_dtl_src-storecode,
          lv_subsite   TYPE zmcdar_i_act_dtl_src-subsite,
          lv_nowamt    TYPE zmcdar_i_act_dtl_src-acctamt,
          lv_glaccount TYPE zmcdar_i_act_dtl_src-glaccount.
    DATA: lv_err TYPE c LENGTH 1300.

    DATA lt_result TYPE TABLE OF zmcdar_u_act_dtl.

*    lt_result = CORRESPONDING #( lt_actdtl ).



    DATA lt_actmnt TYPE SORTED TABLE OF zmcdar_u_act_mnt WITH NON-UNIQUE KEY fiscalyear fiscalperiod storecode subsite smartstore.

    SELECT * FROM zmcdar_i_act_mnt_src
    WHERE fiscalyear   = @lv_year
      AND fiscalperiod = @lv_period
    INTO CORRESPONDING FIELDS OF TABLE @lt_actmnt.

    SELECT DISTINCT storecode, subsite, profitcenter FROM zmcdar_i_act_mnt_src
    WHERE fiscalyear   = @lv_year
      AND fiscalperiod = @lv_period
    GROUP BY fiscalyear, fiscalperiod, storecode, subsite, profitcenter
    INTO TABLE @DATA(lt_base).


    DATA ls_result LIKE LINE OF lt_result.

    SELECT
      fiscalyear,
      fiscalperiod,
      storecode,
      smartstore,
      glaccount,
      subsite,
      sourceledger,
      companycode,
      ledger,
      profitcenter,
      currency,
      glaccountname,
      acctamt
    FROM zmcdar_i_act_dtl_src
    WHERE fiscalyear   = @lv_year
      AND fiscalperiod = @lv_period
    INTO CORRESPONDING FIELDS OF @ls_result.
      ls_result-glaccount = |{ ls_result-glaccount ALPHA = OUT }|.
      APPEND ls_result TO lt_result.
    ENDSELECT.

    LOOP AT lt_base INTO DATA(ls_base).
      CLEAR: lv_store, lv_subsite, lv_glaccount, lt_comb.
      DATA: lv_idx TYPE i,
            lv_len TYPE i.
      lt_comb = CORRESPONDING #( lt_comb_base ).


*      SELECT a~smartstore acctamt FROM @lt_comb as a
*      inner join zmcdar_i_act_dtl_src AS b
*         on a~smartstore = b~SmartStore
*        and b~GLAccount = @ls_base-GLAccount
*      where a~iscomb <> 'X'
*        @data(ls_comb_proc).

      lv_store = ls_base-storecode.
      IF lv_store = '0005'.
        lv_store = '0005'.
      ENDIF.
      lv_subsite = ls_base-subsite.
      lv_idx = 1.
      lv_len = lines( lt_comb ).

      WHILE lv_idx LE lv_len.
        CLEAR: ls_comb.
        ls_comb = lt_comb[ lv_idx ].

        CLEAR lv_nowamt.
        zcl_mcdar_calc_comb_smst=>calc_comb_smst(
          EXPORTING
            iv_smst         = ls_comb-smartstore
            iv_storecode    = lv_store
            iv_subsite      = lv_subsite
            iv_fiscalyear   = lv_year
            iv_fiscalperiod = lv_period
            it_actmnt       = lt_actmnt
          CHANGING
            ct_smst      = lt_comb
            cv_err       = lv_err
          RECEIVING
            ev_calcamt   = lv_nowamt
        ).
        READ TABLE lt_comb WITH KEY smartstore = ls_comb-smartstore INTO DATA(ls_now).
        IF ls_now-iscomb = 'X'.
          APPEND INITIAL LINE TO lt_result ASSIGNING FIELD-SYMBOL(<fs_actdtl>).
          <fs_actdtl>-fiscalyear = lv_year.
          <fs_actdtl>-fiscalperiod = lv_period.
          <fs_actdtl>-storecode    = lv_store.
          <fs_actdtl>-subsite      = lv_subsite.
          <fs_actdtl>-smartstore   = ls_comb-smartstore.
          <fs_actdtl>-sourceledger = '0L'.
          <fs_actdtl>-companycode  = '1000'.
          <fs_actdtl>-ledger       = '0L'.
          <fs_actdtl>-profitcenter = ls_base-profitcenter.
          <fs_actdtl>-glaccount = 0.
          <fs_actdtl>-glaccountname = ''.
          <fs_actdtl>-currency     = 'KRW'.
          <fs_actdtl>-acctamt      = lv_nowamt.
          <fs_actdtl>-cnt          = 0.
          <fs_actdtl>-iscomb       = ls_comb-iscomb.
          <fs_actdtl>-formula      = ls_comb-formula.
          <fs_actdtl>-errmsg       = ls_now-errmsg.
        ENDIF.
        lv_idx += 1.
        UNASSIGN <fs_actdtl>.
      ENDWHILE.
*        LOOP AT lt_comb INTO DATA(ls_comb).
*        ENDLOOP.
    ENDLOOP.


    IF lv_sort IS INITIAL.
      SELECT * FROM @lt_result AS act
      WHERE fiscalyear   = @lv_year
        AND fiscalperiod = @lv_period
      ORDER BY profitcenter
      INTO TABLE @lt_result
      OFFSET @lv_skip
      UP TO @lv_top ROWS.
    ELSE.
      SELECT * FROM @lt_result AS act
      WHERE fiscalyear   = @lv_year
        AND fiscalperiod = @lv_period
      ORDER BY (lv_sort)
      INTO TABLE @lt_result
      OFFSET @lv_skip
      UP TO @lv_top ROWS.
    ENDIF.
    io_response->set_data( lt_result ).
    io_response->set_total_number_of_records( lines( lt_result )  ).

  ENDMETHOD.
ENDCLASS.
