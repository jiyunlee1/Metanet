CLASS lhc_swpacct DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR swpacct RESULT result.

    METHODS validatedata FOR VALIDATE ON SAVE
      IMPORTING keys FOR swpacct~validatedata.

    METHODS validation_check FOR READ
      IMPORTING keys FOR FUNCTION swpacct~validation_check RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR swpacct RESULT result.
    METHODS excel_validation FOR READ
      IMPORTING keys FOR FUNCTION swpacct~excel_validation RESULT result.

ENDCLASS.

CLASS lhc_swpacct IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD validatedata.
    CLEAR : failed, reported.

    READ ENTITIES OF zmcdgl_r_swp_acct IN LOCAL MODE
        ENTITY swpacct
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_swpacct).

    IF lt_swpacct IS NOT INITIAL.
      LOOP AT lt_swpacct REFERENCE INTO DATA(lr_swpacct).
        APPEND VALUE #( %is_draft   = lr_swpacct->%is_draft
                        %tky        = lr_swpacct->%tky
                        %state_area = 'validation01' ) TO reported-swpacct.

        IF lr_swpacct->bank IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_swpacct->%is_draft
                          %tky            = lr_swpacct->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-swpacct.
          APPEND VALUE #( %is_draft             = lr_swpacct->%is_draft
                          %tky                  = lr_swpacct->%tky
                          %element-bank      = if_abap_behv=>mk-on
                          %state_area           = 'validation01'
                          %msg                  = new_message_with_text(
                            severity  = if_abap_behv_message=>severity-error
                            text      = |Bank is required| ) ) TO reported-swpacct.

        ELSE.
          SELECT SINGLE bankid
          FROM zmcdgl_v_bank
            WHERE bankid = @lr_swpacct->bank
            INTO @DATA(lv_bank).

          IF lv_bank IS INITIAL.
            APPEND VALUE #( %is_draft       = lr_swpacct->%is_draft
                                 %tky            = lr_swpacct->%tky
                                 %create         = if_abap_behv=>mk-on
                                 %update         = if_abap_behv=>mk-on
                                 %action-prepare = if_abap_behv=>mk-on
                                 %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-swpacct.
            APPEND VALUE #( %is_draft             = lr_swpacct->%is_draft
                            %tky                  = lr_swpacct->%tky
                            %element-bank      = if_abap_behv=>mk-on
                            %state_area           = 'validation01'
                            %msg                  = new_message_with_text(
                              severity  = if_abap_behv_message=>severity-error
                              text      = |Bank is wrong data| ) ) TO reported-swpacct.
          ENDIF.
        ENDIF.

        IF lr_swpacct->account IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_swpacct->%is_draft
                          %tky            = lr_swpacct->%tky
                          %create         = if_abap_behv=>mk-on
*                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-swpacct.

          APPEND VALUE #( %is_draft        = lr_swpacct->%is_draft
                          %tky             = lr_swpacct->%tky
                          %element-account = if_abap_behv=>mk-on
                          %state_area      = 'validation01'
                          %msg             = new_message_with_text(
                                             severity  = if_abap_behv_message=>severity-error
                                             text      = |Account is required| ) ) TO reported-swpacct.
        ENDIF.

        IF lr_swpacct->glaccount IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_swpacct->%is_draft
                          %tky            = lr_swpacct->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-swpacct.

          APPEND VALUE #( %is_draft        = lr_swpacct->%is_draft
                          %tky             = lr_swpacct->%tky
                          %element-glaccount = if_abap_behv=>mk-on
                          %state_area      = 'validation01'
                          %msg             = new_message_with_text(
                                             severity  = if_abap_behv_message=>severity-error
                                             text      = |GLAccount is required| ) ) TO reported-swpacct.
        ELSE.
          DATA(lv_glaccount) = |{ lr_swpacct->glaccount ALPHA = IN }|.

          SELECT SINGLE glaccount
          FROM zmcdgl_v_gl_account
          WHERE glaccount = @lv_glaccount
           INTO @DATA(ls_glaccount).

          IF ls_glaccount IS INITIAL.
            APPEND VALUE #( %is_draft       = lr_swpacct->%is_draft
                      %tky            = lr_swpacct->%tky
                      %create         = if_abap_behv=>mk-on
                      %update         = if_abap_behv=>mk-on
                      %action-prepare = if_abap_behv=>mk-on
                      %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-swpacct.

            APPEND VALUE #( %is_draft        = lr_swpacct->%is_draft
                            %tky             = lr_swpacct->%tky
                            %element-glaccount = if_abap_behv=>mk-on
                            %state_area      = 'validation01'
                            %msg             = new_message_with_text(
                                               severity  = if_abap_behv_message=>severity-error
                                               text      = |GL Account is wrong data| ) ) TO reported-swpacct.
          ENDIF.
        ENDIF.

        IF lr_swpacct->profitcenter IS INITIAL.
          DATA(lv_profit) = |{ lr_swpacct->profitcenter ALPHA = IN }|.

          APPEND VALUE #( %is_draft       = lr_swpacct->%is_draft
                          %tky            = lr_swpacct->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-swpacct.

          APPEND VALUE #( %is_draft        = lr_swpacct->%is_draft
                          %tky             = lr_swpacct->%tky
                          %element-profitcenter = if_abap_behv=>mk-on
                          %state_area      = 'validation01'
                          %msg             = new_message_with_text(
                                             severity  = if_abap_behv_message=>severity-error
                                             text      = |Profit Center is required| ) ) TO reported-swpacct.
        ELSE.
          SELECT SINGLE profitcenter
          FROM zmcdar_v_profit_center
          WHERE profitcenter = @lr_swpacct->profitcenter
          INTO @DATA(ls_profit).

          IF ls_profit IS INITIAL.
            APPEND VALUE #( %is_draft       = lr_swpacct->%is_draft
                    %tky            = lr_swpacct->%tky
                    %create         = if_abap_behv=>mk-on
                    %update         = if_abap_behv=>mk-on
                    %action-prepare = if_abap_behv=>mk-on
                    %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-swpacct.

            APPEND VALUE #( %is_draft        = lr_swpacct->%is_draft
                            %tky             = lr_swpacct->%tky
                            %element-profitcenter = if_abap_behv=>mk-on
                            %state_area      = 'validation01'
                            %msg             = new_message_with_text(
                                               severity  = if_abap_behv_message=>severity-error
                                               text      = |Profit Center is wrongdata| ) ) TO reported-swpacct.
          ENDIF.
        ENDIF.

        IF lr_swpacct->description IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_swpacct->%is_draft
                          %tky            = lr_swpacct->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-swpacct.

          APPEND VALUE #( %is_draft        = lr_swpacct->%is_draft
                          %tky             = lr_swpacct->%tky
                          %element-description = if_abap_behv=>mk-on
                          %state_area      = 'validation01'
                          %msg             = new_message_with_text(
                                             severity  = if_abap_behv_message=>severity-error
                                             text      = |Description is required| ) ) TO reported-swpacct.
        ENDIF.

        CHECK failed-swpacct IS INITIAL.

        " 중복 데이터 체크
        IF lr_swpacct IS NOT INITIAL.
          SELECT DISTINCT id,
                          account       AS account,
                          ' '           AS is_draft
                 FROM zmcdtgl0010
                 WHERE account         = @lr_swpacct->account
                  AND id              <> @lr_swpacct->id
            UNION
          SELECT DISTINCT id,
                          account       AS account,
                          'X'              AS is_draft
                    FROM zmcddgl0010
                   WHERE account         = @lr_swpacct->account
                     AND id              <> @lr_swpacct->id
                    INTO TABLE @DATA(lt_origin).

          SORT lt_origin[] BY id is_draft DESCENDING.

          READ TABLE lt_origin[]
               WITH KEY account      = lr_swpacct->account
               TRANSPORTING NO FIELDS.

          IF sy-subrc = 0.
            APPEND VALUE #( %is_draft                 = lr_swpacct->%is_draft
                             %tky                     = lr_swpacct->%tky
                             %create                  = if_abap_behv=>mk-on
                             %update                  = if_abap_behv=>mk-on
                             %action-prepare          = if_abap_behv=>mk-on
                             %fail-cause              = if_abap_behv=>cause-unspecific  ) TO failed-swpacct.
            APPEND VALUE #( %is_draft                = lr_swpacct->%is_draft
                            %tky                     = lr_swpacct->%tky
                            %state_area       = 'validation01'
                            %element-account = if_abap_behv=>mk-on
                            %msg              = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = |Duplicate history exists| ) ) TO reported-swpacct.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD validation_check.
    TYPES: BEGIN OF ts_rawdata,
             bank         TYPE zmcdgl_c_swp_acct-bank,
             account      TYPE zmcdgl_c_swp_acct-account,
             glaccount    TYPE zmcdgl_c_swp_acct-glaccount,
             profitcenter TYPE zmcdgl_c_swp_acct-profitcenter,
             description  TYPE zmcdgl_c_swp_acct-description,
             localpath    TYPE zmcdgl_a_exp_err_02-localpath,
           END OF ts_rawdata.
    DATA: ls_rawdata  TYPE ts_rawdata,
          lt_rawdata  TYPE STANDARD TABLE OF ts_rawdata,
          lv_msgcheck TYPE c LENGTH 1.

    CLEAR: lt_rawdata, ls_rawdata.

    LOOP AT keys[] INTO DATA(ls_keys).
      DATA(lv_json) = ls_keys-%param-importparameter.

      CLEAR: lt_rawdata, ls_rawdata.
      /ui2/cl_json=>deserialize(
       EXPORTING
         json             = lv_json
       CHANGING
         data             = lt_rawdata
     ).
    ENDLOOP.

    LOOP AT lt_rawdata INTO ls_rawdata.
      CLEAR : lv_msgcheck.

      "Null 값 check
      IF ls_rawdata-bank IS INITIAL OR ls_rawdata-glaccount IS INITIAL OR ls_rawdata-profitcenter IS INITIAL
         OR ls_rawdata-account IS INITIAL OR ls_rawdata-description IS INITIAL.
        APPEND INITIAL LINE TO result[] ASSIGNING FIELD-SYMBOL(<fs_result>).
        <fs_result>-%param-localpath = ls_rawdata-localpath.
        <fs_result>-%param-errmsg    = '필수 입력값 누락'.

        lv_msgcheck = 'X'.
      ELSE.
        "중복 check - excel 데이터 내부
        SELECT *
          FROM @lt_rawdata AS rawdata
         WHERE rawdata~account      = @ls_rawdata-account
           AND rawdata~localpath  <> @ls_rawdata-localpath
         INTO TABLE @DATA(lt_duplidata).

        IF lt_duplidata[] IS NOT INITIAL.
          APPEND INITIAL LINE TO result[] ASSIGNING FIELD-SYMBOL(<fs_result2>).
          <fs_result2>-%param-localpath = ls_rawdata-localpath.
          <fs_result2>-%param-errmsg = 'Duplicated Data within Local Data'.

          lv_msgcheck = 'X'.
        ENDIF.
      ENDIF.

      IF lv_msgcheck IS INITIAL.
        "중복 check - 기존 데이터와 비교
        DATA(lv_profit) = |{ ls_rawdata-profitcenter ALPHA = IN }|.
        DATA(lv_glaccount) = |{ ls_rawdata-glaccount ALPHA = IN }|.

        SELECT *
          FROM zmcdgl_c_swp_acct
         WHERE account      = @ls_rawdata-account
           INTO TABLE @DATA(lt_origin).

        IF lt_origin IS NOT INITIAL.
          APPEND INITIAL LINE TO result[] ASSIGNING <fs_result2>.
          <fs_result2>-%param-localpath = ls_rawdata-localpath.
          <fs_result2>-%param-errmsg = 'Duplicated Data within DB Data'.

        ELSE.
          SELECT SINGLE bankid
                 FROM zmcdgl_v_bank
                WHERE bankid = @ls_rawdata-bank
                 INTO @DATA(ls_bank).

          IF ls_bank IS INITIAL.
            APPEND INITIAL LINE TO result[] ASSIGNING <fs_result2>.
            <fs_result2>-%param-localpath = ls_rawdata-localpath.
            <fs_result2>-%param-errmsg = 'Invalid Bank data'.
          ENDIF.

          SELECT SINGLE glaccount
                 FROM i_glaccount
                 WHERE glaccount = @lv_glaccount
                  INTO @DATA(ls_glaccount).

          IF ls_glaccount IS INITIAL.
            APPEND INITIAL LINE TO result[] ASSIGNING <fs_result2>.
            <fs_result2>-%param-localpath = ls_rawdata-localpath.
            <fs_result2>-%param-errmsg = 'Invalid GLAccount'.
          ENDIF.

          SELECT SINGLE profitcenter
                   FROM zmcdar_v_profit_center
                  WHERE profitcenter = @lv_profit
                   INTO @DATA(ls_profitcenter).

          IF ls_profitcenter IS INITIAL.
            APPEND INITIAL LINE TO result[] ASSIGNING <fs_result2>.
            <fs_result2>-%param-localpath = ls_rawdata-localpath.
            <fs_result2>-%param-errmsg = 'Invalid ProfitCenter'.
          ENDIF.

          CLEAR: ls_bank, ls_profitcenter, ls_glaccount.
        ENDIF.

      ELSE.
        CONTINUE.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zmcdgl_r_swp_acct IN LOCAL MODE
         ENTITY swpacct
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_swpact).


    LOOP AT lt_swpact INTO DATA(ls_swpact).
      SELECT SINGLE @abap_true FROM zmcdgl_i_swp_acct
      WHERE id = @ls_swpact-id
      INTO @DATA(is_edit).
      result = VALUE #( FOR groups IN keys (
                        %tky = ls_swpact-%tky
                        %field-account = COND #( WHEN is_edit EQ abap_true
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-f-mandatory )
                        %field-bank = COND #( WHEN is_edit EQ abap_true
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-f-mandatory )
                       ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD excel_validation.
    DATA: lt_excel   TYPE TABLE OF zmcdgl_a_excel_return_01,
          lt_rawdata TYPE TABLE OF zmcdgl_i_swp_acct,
          ls_rawdata TYPE zmcdgl_i_swp_acct.
    FIELD-SYMBOLS: <fs_result> LIKE LINE OF result.

    LOOP AT keys INTO DATA(ls_key).

      DATA: lr_excel TYPE REF TO data.

      lr_excel = REF #( lt_excel[] ).

      zcl_mcdcm_excel_import=>base64_to_itab(
        EXPORTING
          iv_excel_file     = ls_key-%param-excel_file
          iv_fr_col         = ls_key-%param-fr_col
          iv_to_col         = ls_key-%param-to_col
          iv_fr_row         = ls_key-%param-fr_row
        CHANGING
          it_internal_table = lr_excel
      ).

      DATA lv_msgcheck  TYPE c LENGTH 1.

      LOOP AT lt_excel ASSIGNING FIELD-SYMBOL(<fs_excel>).
        DATA(lv_tabix) = sy-tabix.
        IF <fs_excel> IS INITIAL.
          CONTINUE.
        ENDIF.
        CLEAR: ls_rawdata, lv_msgcheck.

        TRY.
            ls_rawdata-bank         = <fs_excel>-bank.
            ls_rawdata-account      = <fs_excel>-account.
            ls_rawdata-glaccount    = <fs_excel>-glaccount.
            ls_rawdata-profitcenter = <fs_excel>-profitcenter.
            ls_rawdata-description  = <fs_excel>-description.
          CATCH cx_root.
            <fs_excel>-errmsg = 'Wrong Type Error.'.
            APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
            <fs_result>-%param = <fs_excel>.
            UNASSIGN <fs_result>.
            CONTINUE.
        ENDTRY.

        APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
        <fs_result>-%param = <fs_excel>.

        "Null 값 check
        IF ls_rawdata-bank IS INITIAL OR ls_rawdata-account IS INITIAL OR ls_rawdata-glaccount IS INITIAL OR ls_rawdata-profitcenter IS INITIAL
           OR ls_rawdata-description IS INITIAL.
          <fs_result>-%param-errmsg    = '필수 입력값 누락'.
          UNASSIGN <fs_result>.
          lv_msgcheck = 'X'.
          CONTINUE.
        ENDIF.


        IF lv_msgcheck IS INITIAL.
          "중복 check - excel 데이터 내부
          SELECT *
            FROM @lt_rawdata AS rawdata
           WHERE rawdata~account = @ls_rawdata-account
           INTO TABLE @DATA(lt_duplidata).

          IF lt_duplidata[] IS NOT INITIAL.
            <fs_result>-%param-errmsg = 'Duplicated Data within Local Data'.
            lv_msgcheck = 'X'.
            UNASSIGN <fs_result>.
            CONTINUE.
          ENDIF.
        ENDIF.

        IF lv_msgcheck IS INITIAL.
          "중복 check - 기존 데이터와 비교

          SELECT *
            FROM zmcdgl_c_swp_acct
           WHERE account = @ls_rawdata-account
           INTO TABLE @DATA(lt_origin).

          IF lt_origin IS NOT INITIAL.
            <fs_result>-%param-errmsg = 'Duplicated Data within DB Data'.
            lv_msgcheck = 'X'.
            UNASSIGN <fs_result>.
            CONTINUE.
          ENDIF.
        ENDIF.

        "필드별 유효성 체크
        IF lv_msgcheck IS INITIAL.
          DATA lv_boolean LIKE abap_true.

          SELECT SINGLE bankid
           FROM zmcdgl_v_bank
             WHERE bankid = @ls_rawdata-bank
             INTO @DATA(lv_bank).

          IF lv_bank IS INITIAL.
            <fs_result>-%param-errmsg = 'Invalid Bank'.
            lv_msgcheck = 'X'.
            UNASSIGN <fs_result>.
            CONTINUE.
          ENDIF.

          CLEAR lv_boolean.

          data(lv_glaccount) = |{ ls_rawdata-glaccount ALPHA = IN }|.

          SELECT SINGLE @abap_true
          FROM zmcdgl_v_gl_account
          WHERE GLAccount = @lv_glaccount
           INTO @lv_boolean.

          IF ls_rawdata-glaccount NE <fs_excel>-glaccount OR lv_boolean <> abap_true.
            <fs_result>-%param-errmsg = 'Invalid GL Account'.
            lv_msgcheck = 'X'.
            UNASSIGN <fs_result>.
            CONTINUE.
          ENDIF.

          CLEAR lv_boolean.

          DATA(lv_profit) = |{ ls_rawdata-profitcenter ALPHA = IN }|.

          SELECT SINGLE @abap_true "profitcenter
          FROM zmcdar_v_profit_center
          WHERE profitcenter = @lv_profit
          INTO @lv_boolean.

          IF ls_rawdata-profitcenter NE <fs_excel>-profitcenter OR lv_boolean <> abap_true.
            <fs_result>-%param-errmsg = 'Invalid ProfitCenter'.
            lv_msgcheck = 'X'.
            UNASSIGN <fs_result>.
            CONTINUE.
          ENDIF.
        ENDIF.

*       local 중복 체크를 위한 itab 구성
        APPEND INITIAL LINE TO lt_rawdata ASSIGNING FIELD-SYMBOL(<fs_rawdata>).
        <fs_rawdata>-account = <fs_excel>-account.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
