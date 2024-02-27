CLASS lhc_smartstore DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR smartstore RESULT result.

    METHODS validatedata FOR VALIDATE ON SAVE
      IMPORTING keys FOR smartstore~validatedata.

    METHODS validation_check FOR READ
      IMPORTING keys FOR FUNCTION smartstore~validation_check RESULT result.

    METHODS validation_excel FOR READ
      IMPORTING keys FOR FUNCTION smartstore~validation_excel RESULT result.

    METHODS excel_validation FOR READ
      IMPORTING keys FOR FUNCTION smartstore~excel_validation RESULT result.

ENDCLASS.

CLASS lhc_smartstore IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD validatedata.
    CLEAR : failed, reported.

    READ ENTITIES OF zmcdar_r_smst_code IN LOCAL MODE
        ENTITY smartstore
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_smstcode).

    IF lt_smstcode IS NOT INITIAL.
      LOOP AT lt_smstcode REFERENCE INTO DATA(lr_smstcode).
        APPEND VALUE #( %is_draft   = lr_smstcode->%is_draft
                        %tky        = lr_smstcode->%tky
                        %state_area = 'validation01' ) TO reported-smartstore.

        IF lr_smstcode->smartstore IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_smstcode->%is_draft
                          %tky            = lr_smstcode->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-smartstore.
          APPEND VALUE #( %is_draft             = lr_smstcode->%is_draft
                          %tky                  = lr_smstcode->%tky
                          %element-smartstore      = if_abap_behv=>mk-on
                          %state_area           = 'validation01'
                          %msg                  = new_message_with_text(
                            severity  = if_abap_behv_message=>severity-error
                            text      = |Smart Store is required| ) ) TO reported-smartstore.
        ELSE.
          IF lr_smstcode->smartstore CO'1234567890 '.
            DATA(lv_nogap) = lr_smstcode->smartstore.

            CONDENSE lv_nogap NO-GAPS.

            IF lv_nogap <> lr_smstcode->smartstore.
              DATA(lv_error) = 'X'.
            ENDIF.

            SELECT SINGLE smartstore
                       FROM zmcdar_i_def_smst
                       WHERE smartstore = @lv_nogap
                       INTO @DATA(lv_smartstore).

            IF lv_smartstore IS INITIAL OR lv_error IS NOT INITIAL.
              APPEND VALUE #( %is_draft       = lr_smstcode->%is_draft
                              %tky            = lr_smstcode->%tky
                              %create         = if_abap_behv=>mk-on
                              %update         = if_abap_behv=>mk-on
                              %action-prepare = if_abap_behv=>mk-on
                              %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-smartstore.
              APPEND VALUE #( %is_draft             = lr_smstcode->%is_draft
                              %tky                  = lr_smstcode->%tky
                              %element-smartstore      = if_abap_behv=>mk-on
                              %state_area           = 'validation01'
                              %msg                  = new_message_with_text(
                                severity  = if_abap_behv_message=>severity-error
                                text      = |Smart Store is wrong data.| ) ) TO reported-smartstore.
            ENDIF.
          ELSE.
            APPEND VALUE #( %is_draft       = lr_smstcode->%is_draft
                            %tky            = lr_smstcode->%tky
                            %create         = if_abap_behv=>mk-on
                            %update         = if_abap_behv=>mk-on
                            %action-prepare = if_abap_behv=>mk-on
                            %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-smartstore.
            APPEND VALUE #( %is_draft             = lr_smstcode->%is_draft
                            %tky                  = lr_smstcode->%tky
                            %element-smartstore      = if_abap_behv=>mk-on
                            %state_area           = 'validation01'
                            %msg                  = new_message_with_text(
                              severity  = if_abap_behv_message=>severity-error
                              text      = |Smart Store is not number.| ) ) TO reported-smartstore.
          ENDIF.
        ENDIF.

        IF lr_smstcode->lineuse IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_smstcode->%is_draft
                          %tky            = lr_smstcode->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-smartstore.

          APPEND VALUE #( %is_draft        = lr_smstcode->%is_draft
                          %tky             = lr_smstcode->%tky
                          %element-lineuse = if_abap_behv=>mk-on
                          %state_area      = 'validation01'
                          %msg             = new_message_with_text(
                                             severity  = if_abap_behv_message=>severity-error
                                             text      = |Lineuse is required.| ) ) TO reported-smartstore.

        ELSEIF lr_smstcode->lineuse <> 'Y' AND lr_smstcode->lineuse <> 'N'.
          APPEND VALUE #( %is_draft       = lr_smstcode->%is_draft
                          %tky            = lr_smstcode->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-smartstore.

          APPEND VALUE #( %is_draft        = lr_smstcode->%is_draft
                          %tky             = lr_smstcode->%tky
                          %element-lineuse = if_abap_behv=>mk-on
                          %state_area      = 'validation01'
                          %msg             = new_message_with_text(
                                             severity  = if_abap_behv_message=>severity-error
                                             text      = |Lineuse is wrong data.| ) ) TO reported-smartstore.


        ENDIF.

        IF lr_smstcode->account IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_smstcode->%is_draft
                          %tky            = lr_smstcode->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-smartstore.

          APPEND VALUE #( %is_draft        = lr_smstcode->%is_draft
                          %tky             = lr_smstcode->%tky
                          %element-account = if_abap_behv=>mk-on
                          %state_area      = 'validation01'
                          %msg             = new_message_with_text(
                                             severity  = if_abap_behv_message=>severity-error
                                             text      = |GLAccount is required| ) ) TO reported-smartstore.
        ELSE.
          SELECT SINGLE glaccount
            FROM zmcdar_v_gl_account
            WHERE glaccount = @lr_smstcode->account
            INTO @DATA(lv_account).

          IF lv_account IS INITIAL.
            APPEND VALUE #( %is_draft       = lr_smstcode->%is_draft
                  %tky            = lr_smstcode->%tky
                  %create         = if_abap_behv=>mk-on
                  %update         = if_abap_behv=>mk-on
                  %action-prepare = if_abap_behv=>mk-on
                  %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-smartstore.

            APPEND VALUE #( %is_draft        = lr_smstcode->%is_draft
                            %tky             = lr_smstcode->%tky
                            %element-account = if_abap_behv=>mk-on
                            %state_area      = 'validation01'
                            %msg             = new_message_with_text(
                                               severity  = if_abap_behv_message=>severity-error
                                               text      = |GLAccount is wrong data| ) ) TO reported-smartstore.
          ENDIF.
        ENDIF.

        CHECK failed-smartstore IS INITIAL.

        " 중복 데이터 체크
        IF lr_smstcode IS NOT INITIAL.
          SELECT DISTINCT id,
                          account        AS account,
                          ' '            AS is_draft
                 FROM zmcdtar0080
                 WHERE account       = @lr_smstcode->account
                   AND id           <> @lr_smstcode->id
            UNION
          SELECT DISTINCT id,
                          account       AS account,
                          'X'           AS is_draft
                    FROM zmcddar0080
                   WHERE account       = @lr_smstcode->account
                     AND id           <> @lr_smstcode->id
          INTO TABLE @DATA(lt_origin).

          SORT lt_origin[] BY id is_draft DESCENDING.

          READ TABLE lt_origin[]
               WITH KEY account      = lr_smstcode->account
               TRANSPORTING NO FIELDS.

          IF sy-subrc = 0.
            APPEND VALUE #( %is_draft                = lr_smstcode->%is_draft
                             %tky                     = lr_smstcode->%tky
                             %create                  = if_abap_behv=>mk-on
                             %update                  = if_abap_behv=>mk-on
                             %action-prepare          = if_abap_behv=>mk-on
                             %fail-cause              = if_abap_behv=>cause-unspecific  ) TO failed-smartstore.
            APPEND VALUE #( %is_draft                = lr_smstcode->%is_draft
                            %tky                     = lr_smstcode->%tky
                            %element-account = if_abap_behv=>mk-on
                            %state_area       = 'error01'
                            %msg              = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = |Duplicate history exists| ) ) TO reported-smartstore.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD validation_check.
    TYPES: BEGIN OF ts_rawdata,
             account    TYPE zmcdar_c_smst_code-account,
             smartstore TYPE zmcdar_c_smst_code-smartstore,
             lineuse    TYPE zmcdar_c_smst_code-lineuse,
             localpath  TYPE zmcdar_a_exp_err_13-localpath,
           END OF ts_rawdata.
    DATA: ls_rawdata  TYPE ts_rawdata,
          lt_rawdata  TYPE STANDARD TABLE OF ts_rawdata,
          lv_msgcheck TYPE c LENGTH 1.

    CLEAR: lt_rawdata, ls_rawdata.

    "데이터 불러오기
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
      IF ls_rawdata-account IS INITIAL OR ls_rawdata-smartstore IS INITIAL OR ls_rawdata-lineuse IS INITIAL.
        APPEND INITIAL LINE TO result[] ASSIGNING FIELD-SYMBOL(<fs_result>).
        <fs_result>-%param-localpath = ls_rawdata-localpath.
        <fs_result>-%param-errmsg    = '필수 입력값 누락'.

        lv_msgcheck = 'X'.
      ELSE.
        "중복 check - excel 데이터 내부
        SELECT *
          FROM @lt_rawdata AS rawdata
         WHERE rawdata~account    = @ls_rawdata-account
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
        DATA(lv_account) = |{ ls_rawdata-account ALPHA = IN }|.

        SELECT *
          FROM zmcdar_c_smst_code
         WHERE account      = @lv_account
         INTO TABLE @DATA(lt_origin).

        IF lt_origin IS NOT INITIAL.
          APPEND INITIAL LINE TO result[] ASSIGNING <fs_result2>.
          <fs_result2>-%param-localpath = ls_rawdata-localpath.
          <fs_result2>-%param-errmsg = 'Duplicated Data within DB Data'.

        ELSE.
          SELECT SINGLE glaccount
                 FROM i_glaccount
                 WHERE glaccount = @lv_account
                   AND companycode = '1000'
                  INTO @DATA(ls_account).

          IF ls_account IS INITIAL.
            APPEND INITIAL LINE TO result[] ASSIGNING <fs_result2>.
            <fs_result2>-%param-localpath = ls_rawdata-localpath.
            <fs_result2>-%param-errmsg = 'Invalid GLAccount'.
          ENDIF.

          IF ls_rawdata-smartstore CO '1234567890 '.
            DATA(lv_nogap) = ls_rawdata-smartstore.

            CONDENSE lv_nogap NO-GAPS.

            IF lv_nogap <> ls_rawdata-smartstore.
              DATA(lv_error) = 'X'.
            ENDIF.

            SELECT SINGLE smartstore
                     FROM zmcdar_c_def_smst
                    WHERE smartstore = @ls_rawdata-smartstore
                     INTO @DATA(ls_smartstore).

            IF ls_smartstore IS INITIAL OR lv_error IS NOT INITIAL..
              APPEND INITIAL LINE TO result[] ASSIGNING <fs_result2>.
              <fs_result2>-%param-localpath = ls_rawdata-localpath.
              <fs_result2>-%param-errmsg = 'Invalid Smart Store'.
            ENDIF.
          ELSE.
            APPEND INITIAL LINE TO result[] ASSIGNING <fs_result2>.
            <fs_result2>-%param-localpath = ls_rawdata-localpath.
            <fs_result2>-%param-errmsg = 'Smart Store is not number'.
          ENDIF.

          IF ls_rawdata-lineuse <> 'Y' AND ls_rawdata-lineuse <> 'N'.
            APPEND INITIAL LINE TO result[] ASSIGNING <fs_result2>.
            <fs_result2>-%param-localpath = ls_rawdata-localpath.
            <fs_result2>-%param-errmsg = 'Invalid Lineuse'.
          ENDIF.

          CLEAR: ls_smartstore, ls_account, lv_error.
        ENDIF.

      ELSE.
        CONTINUE.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validation_excel.
*    TYPES: BEGIN OF ts_excel,
*             smartstorename TYPE c LENGTH 1,
*             smartstore     TYPE dats,
*             indent         TYPE int1,
*           END OF ts_excel.
*    DATA lt_excel TYPE TABLE OF ts_excel.
*
*    LOOP AT keys INTO DATA(ls_key).
*      DATA(lv_len) = strlen( ls_key-%param-attachment ).
*      DATA(lv_original_xstring) = xco_cp=>string( ls_key-%param-attachment
*          )->as_xstring( xco_cp_binary=>text_encoding->base64
*          )->value.
*      DATA(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_original_xstring )->read_access( ).
*      DATA(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->for_name( iv_name = 'Sheet1' ).
*
*      DATA lo_visitor TYPE REF TO if_xco_xlsx_ra_cs_visitor.
*
*      DATA(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
*        )->to_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'C' )
*        )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 2 ) )->get_pattern( ).
*
*      lo_worksheet->select( lo_selection_pattern
*      )->row_stream(
*      )->operation->write_to( REF #( lt_excel )
*      )->if_xco_xlsx_ra_operation~execute( ).
*
*
*      IF ls_key IS INITIAL.
*      ELSE.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.

  METHOD excel_validation.
    DATA: lt_excel   TYPE TABLE OF zmcdar_a_excel_return_13,
          lt_rawdata TYPE TABLE OF zmcdar_i_smst_code,
          ls_rawdata TYPE zmcdar_i_smst_code.
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

      DATA : lv_msgcheck  TYPE c LENGTH 1.

      MOVE-CORRESPONDING lt_excel TO lt_rawdata.

      SELECT *
        FROM @lt_rawdata AS rawdata
       WHERE account IS NOT INITIAL
          OR smartstore IS NOT INITIAL
          OR lineuse    IS NOT INITIAL
        INTO TABLE @DATA(lt_rawtemp).

      IF sy-subrc = 0.
        CLEAR lt_rawdata.

        MOVE-CORRESPONDING lt_rawtemp TO lt_rawdata.
      ELSE.
        RETURN.
      ENDIF.

      LOOP AT lt_excel ASSIGNING FIELD-SYMBOL(<fs_excel>).
        IF <fs_excel> IS INITIAL.
          CONTINUE.
        ELSEIF <fs_excel>-account IS INITIAL OR <fs_excel>-lineuse IS INITIAL OR <fs_excel>-smartstore IS INITIAL.
          APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
          <fs_result>-%param = <fs_excel>.
          <fs_result>-%param-errmsg = '필수 값이 입력되지 않았습니다'.
          UNASSIGN <fs_result>.

          CONTINUE.
        ELSE.
          APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
          <fs_result>-%param = <fs_excel>.
        ENDIF.

        CLEAR : lv_msgcheck.

        READ TABLE lt_rawdata INTO ls_rawdata WITH KEY account = <fs_excel>-account smartstore = <fs_excel>-smartstore lineuse = <fs_excel>-lineuse.

        "excel내부 중복 확인
        SELECT *
          FROM @lt_rawdata AS rawdata
         WHERE account    = @ls_rawdata-account
          INTO TABLE @DATA(lt_duplicate).

        IF lt_duplicate IS NOT INITIAL.
          DATA(count) = lines( lt_duplicate ).

          IF count >= 2.
            <fs_result>-%param-errmsg = 'Duplicated Data within Local Data'.
            UNASSIGN <fs_result>.
            lv_msgcheck = 'X'.
            CONTINUE.
          ENDIF.
        ENDIF.

        "중복 check - 기존 데이터와 비교
        DATA(lv_account) = |{ ls_rawdata-account ALPHA = IN }|.

        SELECT *
          FROM zmcdar_c_smst_code
         WHERE account      = @lv_account
         INTO TABLE @DATA(lt_origin).

        IF lt_origin IS NOT INITIAL.
          <fs_result>-%param-errmsg = 'Duplicated Data within DB Data'.
          UNASSIGN <fs_result>.
          lv_msgcheck = 'X'.
          CONTINUE.

        ELSE.
          SELECT SINGLE glaccount
                 FROM i_glaccount
                 WHERE glaccount = @lv_account
                   AND companycode = '1000'
                  INTO @DATA(ls_account).

          IF ls_account IS INITIAL.
            <fs_result>-%param-errmsg = 'Invalid GLAccount'.
            UNASSIGN <fs_result>.
            lv_msgcheck = 'X'.
            CONTINUE.
          ENDIF.

          IF ls_rawdata-smartstore CO '1234567890 '.
            DATA(lv_nogap) = ls_rawdata-smartstore.

            CONDENSE lv_nogap NO-GAPS.

            IF lv_nogap <> ls_rawdata-smartstore.
              DATA(lv_error) = 'X'.
            ENDIF.

            SELECT SINGLE smartstore
                     FROM zmcdar_c_def_smst
                    WHERE smartstore = @lv_nogap
                     INTO @DATA(ls_smartstore).

            IF ls_smartstore IS INITIAL OR lv_error IS NOT INITIAL..
              <fs_result>-%param-errmsg = 'Invalid Smart Store'.
              UNASSIGN <fs_result>.
              lv_msgcheck = 'X'.
              clear lv_error.
              CONTINUE.
            ENDIF.
          ELSE.
            <fs_result>-%param-errmsg = 'Smart Store is not number'.
            UNASSIGN <fs_result>.
            lv_msgcheck = 'X'.
            CONTINUE.
          ENDIF.

          IF ls_rawdata-lineuse <> 'Y' AND ls_rawdata-lineuse <> 'N'.
            <fs_result>-%param-errmsg = 'Invalid Lineuse'.
            UNASSIGN <fs_result>.
            lv_msgcheck = 'X'.
            CONTINUE.
          ENDIF.

        ENDIF.
      ENDLOOP.
*      CLEAR: ls_smartstore, ls_account.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
