CLASS lhc_defrate DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR defrate RESULT result.

    METHODS validation_check FOR READ
      IMPORTING keys FOR FUNCTION defrate~validation_check RESULT result.

    METHODS determinmodify FOR DETERMINE ON MODIFY
      IMPORTING keys FOR defrate~determinmodify.

    METHODS validationdata FOR VALIDATE ON SAVE
      IMPORTING keys FOR defrate~validationdata.
    METHODS excel_validation FOR READ
      IMPORTING keys FOR FUNCTION defrate~excel_validation RESULT result.

ENDCLASS.

CLASS lhc_defrate IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD validation_check.
    TYPES: BEGIN OF ts_rawdata,
             company         TYPE zmcdar_c_def_rate-company,
             costtype        TYPE zmcdar_c_def_rate-costtype,
             costcenter      TYPE zmcdar_c_def_rate-costcenter,
             rate            TYPE zmcdar_c_def_rate-rate,
             businesspartner TYPE zmcdar_c_def_rate-businesspartner,
             profitcenter    TYPE zmcdar_c_def_rate-profitcenter,
             roletype        TYPE zmcdar_c_def_rate-roletype,
             validfrdate     TYPE zmcdar_c_def_rate-validfrdate,
             localpath       TYPE zmcdar_a_exp_err_01-localpath,
           END OF ts_rawdata.
    TYPES: BEGIN OF ts_compare,
             company         TYPE zmcdar_c_def_rate-company,
             costtype        TYPE zmcdar_c_def_rate-costtype,
             costcenter      TYPE zmcdar_c_def_rate-costcenter,
             rate            TYPE p LENGTH 7 DECIMALS 5,
             businesspartner TYPE zmcdar_c_def_rate-businesspartner,
             profitcenter    TYPE zmcdar_c_def_rate-profitcenter,
             roletype        TYPE zmcdar_c_def_rate-roletype,
             validfrdate     TYPE zmcdar_c_def_rate-validfrdate,
             localpath       TYPE zmcdar_a_exp_err_01-localpath,
           END OF ts_compare.
    DATA: ls_rawdata  TYPE ts_rawdata,
          lt_rawdata  TYPE STANDARD TABLE OF ts_rawdata,
          ls_compare  TYPE ts_compare,
          lt_compare  TYPE STANDARD TABLE OF ts_compare,
          lv_msgcheck TYPE c LENGTH 1.

    CLEAR: lt_rawdata, ls_rawdata, lt_compare, ls_compare.

    "데이터 불러오기
    LOOP AT keys[] INTO DATA(ls_keys).
      DATA(lv_json) = ls_keys-%param-importparameter.

      CLEAR: lt_rawdata, ls_rawdata, lt_compare, ls_compare.
      /ui2/cl_json=>deserialize(
       EXPORTING
         json             = lv_json
       CHANGING
         data             = lt_rawdata
     ).

      /ui2/cl_json=>deserialize(
      EXPORTING
        json             = lv_json
      CHANGING
        data             = lt_compare
    ).
    ENDLOOP.

    LOOP AT lt_rawdata INTO ls_rawdata.
      CLEAR : lv_msgcheck.
      FIELD-SYMBOLS <fs_result> LIKE LINE OF result.
      "profitcenter conversion
      DATA(lv_profit) = |{ ls_rawdata-profitcenter ALPHA = IN }|.
      "Null 값 check
      IF ls_rawdata-company IS INITIAL OR ls_rawdata-costcenter IS INITIAL OR ls_rawdata-costtype IS INITIAL OR ls_rawdata-profitcenter IS INITIAL
         OR ls_rawdata-rate IS INITIAL OR ls_rawdata-roletype IS INITIAL OR ls_rawdata-validfrdate IS INITIAL.
        APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
        <fs_result>-%param-localpath = ls_rawdata-localpath.
        <fs_result>-%param-errmsg    = '필수 입력값 누락'.

        lv_msgcheck = 'X'.
        UNASSIGN <fs_result>.
        CONTINUE.
      ENDIF.


      IF lv_msgcheck IS INITIAL.
        "중복 check - excel 데이터 내부
        SELECT *
          FROM @lt_rawdata AS rawdata
         WHERE rawdata~costtype     = @ls_rawdata-costtype
           AND rawdata~costcenter   = @ls_rawdata-costcenter
           AND rawdata~profitcenter = @ls_rawdata-profitcenter
           AND rawdata~roletype     = @ls_rawdata-roletype
           AND rawdata~validfrdate  = @ls_rawdata-validfrdate
           AND rawdata~localpath   <> @ls_rawdata-localpath
         INTO TABLE @DATA(lt_duplidata).

        IF lt_duplidata[] IS NOT INITIAL.
          APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
          <fs_result>-%param-localpath = ls_rawdata-localpath.
          <fs_result>-%param-errmsg = 'Duplicated Data within Local Data'.
          lv_msgcheck = 'X'.
          UNASSIGN <fs_result>.
          CONTINUE.
        ENDIF.
      ENDIF.

      IF lv_msgcheck IS INITIAL.
        "중복 check - 기존 데이터와 비교

        SELECT *
          FROM zmcdar_c_def_rate
         WHERE costtype          = @ls_rawdata-costtype
           AND costcenter        = @ls_rawdata-costcenter
           AND profitcenter      = @lv_profit
           AND rate              = @ls_rawdata-rate
           AND roletype          = @ls_rawdata-roletype
           AND validfrdate       = @ls_rawdata-validfrdate
         INTO TABLE @DATA(lt_origin).

        IF lt_origin IS NOT INITIAL.
          APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
          <fs_result>-%param-localpath = ls_rawdata-localpath.
          <fs_result>-%param-errmsg = 'Duplicated Data within DB Data'.
          lv_msgcheck = 'X'.
          UNASSIGN <fs_result>.
          CONTINUE.
        ENDIF.
      ENDIF.

      "필드별 유효성 체크
      "CompanyCode
      IF lv_msgcheck IS INITIAL.
        IF ls_rawdata-company <> 1000.
          APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
          <fs_result>-%param-localpath = ls_rawdata-localpath.
          <fs_result>-%param-errmsg = 'Invalid Company Code'.
          lv_msgcheck = 'X'.
          UNASSIGN <fs_result>.
          CONTINUE.
        ENDIF.

        DATA lv_boolean LIKE abap_true.

        "CostType
        CLEAR lv_boolean.
        SELECT SINGLE @abap_true FROM zmcdar_i_cost_type
        WHERE costtype = @ls_rawdata-costtype
        INTO @lv_boolean.

        IF lv_boolean <> abap_true.
          APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
          <fs_result>-%param-localpath = ls_rawdata-localpath.
          <fs_result>-%param-errmsg = 'Invalid Cost Type'.
          lv_msgcheck = 'X'.
          UNASSIGN <fs_result>.
          CONTINUE.
        ENDIF.

        "RoleType
        CLEAR lv_boolean.
        SELECT SINGLE @abap_true FROM zmcdar_v_role_type
        WHERE lowvalue = @ls_rawdata-roletype
        INTO @lv_boolean.

        IF lv_boolean <> abap_true.
          APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
          <fs_result>-%param-localpath = ls_rawdata-localpath.
          <fs_result>-%param-errmsg = 'Invalid Role Type'.
          lv_msgcheck = 'X'.
          UNASSIGN <fs_result>.
          CONTINUE.
        ENDIF.

        "Rate
        IF ls_rawdata-rate IS NOT INITIAL.
          CLEAR lv_boolean.

          SELECT SINGLE rawdata~rate
              FROM @lt_rawdata AS rawdata
           INNER JOIN @lt_compare AS comparedata
                   ON rawdata~rate EQ comparedata~rate
                WHERE rawdata~rate = @ls_rawdata-rate
                INTO @DATA(lv_checkeq).

          IF lv_checkeq IS INITIAL.
            APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
            <fs_result>-%param-localpath = ls_rawdata-localpath.
            <fs_result>-%param-errmsg = 'Check Rate length'.
            lv_msgcheck = 'X'.
            UNASSIGN <fs_result>.

            CONTINUE.
          ENDIF.

          CLEAR lv_checkeq.
        ENDIF.

        "Business Partner
        IF ls_rawdata-businesspartner IS NOT INITIAL.
          CLEAR lv_boolean.
          DATA(lv_businesspartner)  = |{ ls_rawdata-businesspartner ALPHA = IN }|.
          SELECT SINGLE @abap_true FROM zmcdar_v_business_partner
          WHERE businesspartner = @lv_businesspartner
          INTO @lv_boolean.

          IF lv_boolean <> abap_true.
            APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
            <fs_result>-%param-localpath = ls_rawdata-localpath.
            <fs_result>-%param-errmsg = 'Invalid Business Partner'.
            lv_msgcheck = 'X'.
            UNASSIGN <fs_result>.
            CONTINUE.
          ENDIF.
        ENDIF.

        "Cost Center
        CLEAR lv_boolean.
        SELECT SINGLE @abap_true FROM zmcdar_i_cost_center
        WHERE costcenter = @ls_rawdata-costcenter
        INTO @lv_boolean.

        IF lv_boolean <> abap_true.
          APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
          <fs_result>-%param-localpath = ls_rawdata-localpath.
          <fs_result>-%param-errmsg = 'Invalid Cost Center'.
          lv_msgcheck = 'X'.
          UNASSIGN <fs_result>.
          CONTINUE.
        ENDIF.

        "Profit Center
        CLEAR lv_boolean.
        SELECT SINGLE @abap_true FROM zmcdar_v_cost_center
        WHERE costcenter = @ls_rawdata-costcenter
          AND profitcenter = @lv_profit
        INTO @lv_boolean.

        IF lv_boolean <> abap_true.
          APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
          <fs_result>-%param-localpath = ls_rawdata-localpath.
          <fs_result>-%param-errmsg = 'Invalid Profit Center'.
          lv_msgcheck = 'X'.
          UNASSIGN <fs_result>.
          CONTINUE.
        ENDIF.
      ENDIF.


      "폐점 확인
      CLEAR lv_boolean.
      SELECT SINGLE @abap_true FROM zmcdar_i_def_rate
      WHERE profitcenter = @lv_profit
        AND shutdowndate IS NOT INITIAL
      INTO @lv_boolean.

      IF lv_boolean EQ abap_true.
        APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
        <fs_result>-%param-localpath = ls_rawdata-localpath.
        <fs_result>-%param-errmsg = |Profit Center '{ ls_rawdata-profitcenter }' is closed Profit Center|.
        lv_msgcheck = 'X'.
        UNASSIGN <fs_result>.
        CONTINUE.
      ENDIF.

      "유효 시작일 체크
      DATA : lv_validfrdate TYPE dats,
             lr_validfrdate TYPE RANGE OF dats.

      lr_validfrdate = VALUE #( ( sign = 'I' option = 'GT' low = ls_rawdata-validfrdate ) ).

      "유효 시작일 체크 - 비율 정의
      CLEAR lv_validfrdate.
      SELECT  validfrdate
      FROM zmcdar_c_def_rate
      WHERE costtype          = @ls_rawdata-costtype
        AND costcenter        = @ls_rawdata-costcenter
        AND profitcenter      = @lv_profit
        AND rate              = @ls_rawdata-rate
        AND roletype          = @ls_rawdata-roletype
        AND validfrdate      IN @lr_validfrdate
      ORDER BY validfrdate DESCENDING
      INTO @lv_validfrdate
      UP TO 1 ROWS.
      ENDSELECT.

      IF lv_validfrdate IS NOT INITIAL.
        APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
        <fs_result>-%param-localpath = ls_rawdata-localpath.
        <fs_result>-%param-errmsg = |Set after than existing ValidFrDate:'{ lv_validfrdate }'|.
        lv_msgcheck = 'X'.
        UNASSIGN <fs_result>.
        CONTINUE.
      ENDIF.

      "유효 시작일 체크 - 전표
      CLEAR lv_validfrdate.
      SELECT  validfrdate
      FROM zmcdar_i_mass_post
      WHERE costtype          = @ls_rawdata-costtype
        AND profitcenter      = @lv_profit
        AND rate              = @ls_rawdata-rate
        AND roletype          = @ls_rawdata-roletype
        AND validfrdate      IN @lr_validfrdate
      ORDER BY validfrdate DESCENDING
      INTO @lv_validfrdate
      UP TO 1 ROWS.
      ENDSELECT.

      IF lv_validfrdate IS NOT INITIAL.
        APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
        <fs_result>-%param-localpath = ls_rawdata-localpath.
        <fs_result>-%param-errmsg = |There is a Journal Entry Items on a date after this ValidFrDate|.
        lv_msgcheck = 'X'.
        UNASSIGN <fs_result>.
        CONTINUE.
      ENDIF.
      CLEAR lv_profit.
    ENDLOOP.

    IF result IS INITIAL.

    ELSE.

    ENDIF.
  ENDMETHOD.

  "Draft
  METHOD determinmodify.
    READ ENTITIES OF zmcdar_r_def_rate IN LOCAL MODE
         ENTITY defrate
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_draft).

    LOOP AT lt_draft INTO DATA(ls_draft).
      CHECK ls_draft-company IS INITIAL.

      IF sy-subrc = 0.
        MODIFY ENTITIES OF zmcdar_r_def_rate IN LOCAL MODE
                ENTITY defrate UPDATE FIELDS ( company )
                WITH VALUE #( ( %tky = ls_draft-%tky
                                company = '1000'
                                %control-company = if_abap_behv=>mk-on ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validationdata.
    CLEAR: failed, reported.

    READ ENTITIES OF zmcdar_r_def_rate IN LOCAL MODE
         ENTITY defrate
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_draft).

    "빈값 확인
    IF lt_draft IS NOT INITIAL.
      LOOP AT lt_draft REFERENCE INTO DATA(lr_draft).
        APPEND VALUE #( "%is_draft    = lr_draft->%is_draft
                        %tky         = lr_draft->%tky
                        %state_area  = 'error01') TO reported-defrate.

        "costtype
        IF lr_draft->costtype IS INITIAL.
          APPEND VALUE #( "%is_draft         = lr_draft->%is_draft
                          %tky              = lr_draft->%tky
                          %create           = if_abap_behv=>mk-on
                          %update           = if_abap_behv=>mk-on
                          %action-prepare   = if_abap_behv=>mk-on
                          %fail-cause       = if_abap_behv=>cause-unspecific  ) TO failed-defrate.
          APPEND VALUE #( "%is_draft         = lr_draft->%is_draft
                          %tky              = lr_draft->%tky
                          %element-costtype = if_abap_behv=>mk-on
                          %state_area       = 'error01'
                          %msg              = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = |Cost type is required| ) ) TO reported-defrate.
        ELSE.
          SELECT SINGLE costtype
          FROM zmcdar_i_cost_type
              WHERE costtype = @lr_draft->costtype
              INTO @DATA(lv_costtype).

          IF lv_costtype IS INITIAL.
            APPEND VALUE #( "%is_draft         = lr_draft->%is_draft
                    %tky              = lr_draft->%tky
                    %create           = if_abap_behv=>mk-on
                    %update           = if_abap_behv=>mk-on
                    %action-prepare   = if_abap_behv=>mk-on
                    %fail-cause       = if_abap_behv=>cause-unspecific  ) TO failed-defrate.
            APPEND VALUE #( "%is_draft         = lr_draft->%is_draft
                            %tky              = lr_draft->%tky
                            %element-costtype = if_abap_behv=>mk-on
                            %state_area       = 'error01'
                            %msg              = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = |Cost type is wrong data| ) ) TO reported-defrate.
          ENDIF.
        ENDIF.

        "costcenter
        IF lr_draft->costcenter IS INITIAL.
          APPEND VALUE #( "%is_draft           = lr_draft->%is_draft
                          %tky                = lr_draft->%tky
                          %create             = if_abap_behv=>mk-on
                          %update             = if_abap_behv=>mk-on
                          %action-prepare     = if_abap_behv=>mk-on
                          %fail-cause         = if_abap_behv=>cause-unspecific  ) TO failed-defrate.
          APPEND VALUE #( "%is_draft           = lr_draft->%is_draft
                          %tky                = lr_draft->%tky
                          %element-costcenter = if_abap_behv=>mk-on
                          %state_area         = 'error01'
                          %msg                = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = |Cost center is required| ) ) TO reported-defrate.
        ELSE.
          SELECT SINGLE costcenter
            FROM zmcdar_v_cost_center
           WHERE costcenter = @lr_draft->costcenter
          INTO @DATA(lv_costcenter).

          IF lv_costcenter IS INITIAL.
            APPEND VALUE #( "%is_draft           = lr_draft->%is_draft
                            %tky                = lr_draft->%tky
                            %create             = if_abap_behv=>mk-on
                            %update             = if_abap_behv=>mk-on
                            %action-prepare     = if_abap_behv=>mk-on
                            %fail-cause         = if_abap_behv=>cause-unspecific  ) TO failed-defrate.
            APPEND VALUE #( "%is_draft           = lr_draft->%is_draft
                            %tky                = lr_draft->%tky
                            %element-costcenter = if_abap_behv=>mk-on
                            %state_area         = 'error01'
                            %msg                = new_message_with_text(
                                       severity = if_abap_behv_message=>severity-error
                                       text     = |Wrong Data : Cost Center.| ) ) TO reported-defrate.
          ENDIF.
        ENDIF.

        "profitcenter
        IF lr_draft->profitcenter IS INITIAL.
          APPEND VALUE #( "%is_draft             = lr_draft->%is_draft
                          %tky                  = lr_draft->%tky
                          %create               = if_abap_behv=>mk-on
                          %update               = if_abap_behv=>mk-on
                          %action-prepare       = if_abap_behv=>mk-on
                          %fail-cause           = if_abap_behv=>cause-unspecific  ) TO failed-defrate.
          APPEND VALUE #( "%is_draft             = lr_draft->%is_draft
                          %tky                  = lr_draft->%tky
                          %element-profitcenter = if_abap_behv=>mk-on
                          %state_area           = 'error01'
                          %msg                  = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = |Profit Center is required| ) ) TO reported-defrate.
        ELSE.
          SELECT SINGLE profitcenter, profitcenternm
            FROM zmcdar_v_cost_center
           WHERE costcenter   = @lr_draft->costcenter
             AND profitcenter = @lr_draft->profitcenter
          INTO @DATA(ls_profit).

          IF ls_profit-profitcenter IS INITIAL.
            APPEND VALUE #( "%is_draft             = lr_draft->%is_draft
                            %tky                  = lr_draft->%tky
                            %create               = if_abap_behv=>mk-on
                            %update               = if_abap_behv=>mk-on
                            %action-prepare       = if_abap_behv=>mk-on
                            %fail-cause           = if_abap_behv=>cause-unspecific  ) TO failed-defrate.
            APPEND VALUE #( "%is_draft             = lr_draft->%is_draft
                            %tky                  = lr_draft->%tky
                            %element-profitcenter = if_abap_behv=>mk-on
                            %state_area           = 'error01'
                            %msg                  = new_message_with_text(
                                         severity = if_abap_behv_message=>severity-error
                                         text     = |Profit Center not in Cost Center ({ lr_draft->costcenter }).| ) ) TO reported-defrate.
          ENDIF.

        ENDIF.

        "rate
        IF lr_draft->rate IS INITIAL.
          APPEND VALUE #( "%is_draft         = lr_draft->%is_draft
                          %tky              = lr_draft->%tky
                          %create           = if_abap_behv=>mk-on
                          %update           = if_abap_behv=>mk-on
                          %action-prepare   = if_abap_behv=>mk-on
                          %fail-cause       = if_abap_behv=>cause-unspecific  ) TO failed-defrate.
          APPEND VALUE #( "%is_draft         = lr_draft->%is_draft
                          %tky              = lr_draft->%tky
                          %element-rate     = if_abap_behv=>mk-on
                          %state_area       = 'error01'
                          %msg              = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = |Rate is required| ) ) TO reported-defrate.
        ENDIF.

        "roletype
        IF lr_draft->roletype IS INITIAL.
          APPEND VALUE #( "%is_draft         = lr_draft->%is_draft
                          %tky              = lr_draft->%tky
                          %create           = if_abap_behv=>mk-on
                          %update           = if_abap_behv=>mk-on
                          %action-prepare   = if_abap_behv=>mk-on
                          %fail-cause       = if_abap_behv=>cause-unspecific  ) TO failed-defrate.
          APPEND VALUE #( "%is_draft         = lr_draft->%is_draft
                          %tky              = lr_draft->%tky
                          %element-roletype = if_abap_behv=>mk-on
                          %state_area       = 'error01'
                          %msg              = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = |Role type is required| ) ) TO reported-defrate.
        ELSE.
          SELECT SINGLE lowvalue
                   FROM zmcdar_v_role_type
                  WHERE lowvalue = @lr_draft->roletype
                   INTO @DATA(lv_roletype).

          IF lv_roletype IS INITIAL.
            APPEND VALUE #( "%is_draft             = lr_draft->%is_draft
                             %tky                  = lr_draft->%tky
                             %create               = if_abap_behv=>mk-on
                             %update               = if_abap_behv=>mk-on
                             %action-prepare       = if_abap_behv=>mk-on
                             %fail-cause           = if_abap_behv=>cause-unspecific  ) TO failed-defrate.
            APPEND VALUE #( "%is_draft             = lr_draft->%is_draft
                            %tky                   = lr_draft->%tky
                            %element-roletype      = if_abap_behv=>mk-on
                            %state_area            = 'error01'
                            %msg                   = new_message_with_text(
                                         severity  = if_abap_behv_message=>severity-error
                                         text      = |Wrong data : Role type.| ) ) TO reported-defrate.
          ENDIF.
        ENDIF.

        "validfrdate
        IF lr_draft->validfrdate IS INITIAL.
          APPEND VALUE #( "%is_draft            = lr_draft->%is_draft
                          %tky                 = lr_draft->%tky
                          %create              = if_abap_behv=>mk-on
                          %update              = if_abap_behv=>mk-on
                          %action-prepare      = if_abap_behv=>mk-on
                          %fail-cause          = if_abap_behv=>cause-unspecific  ) TO failed-defrate.
          APPEND VALUE #( "%is_draft            = lr_draft->%is_draft
                          %tky                 = lr_draft->%tky
                          %element-validfrdate = if_abap_behv=>mk-on
                          %state_area       = 'error01'
                          %msg              = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = |Valid from Date is required| ) ) TO reported-defrate.
        ENDIF.

        DATA lv_boolean LIKE abap_true.

        "폐점 확인
        CLEAR lv_boolean.
        SELECT SINGLE @abap_true FROM zmcdar_i_def_rate
        WHERE profitcenter = @lr_draft->profitcenter
          AND shutdowndate IS NOT INITIAL
        INTO @lv_boolean.

        IF lv_boolean EQ abap_true.
          APPEND VALUE #( "%is_draft            = lr_draft->%is_draft
                          %tky                 = lr_draft->%tky
                          %create              = if_abap_behv=>mk-on
                          %update              = if_abap_behv=>mk-on
                          %action-prepare      = if_abap_behv=>mk-on
                          %fail-cause          = if_abap_behv=>cause-unspecific  ) TO failed-defrate.
          APPEND VALUE #( "%is_draft            = lr_draft->%is_draft
                          %tky                 = lr_draft->%tky
                          %element-profitcenter = if_abap_behv=>mk-on
                          %state_area       = 'error01'
                          %msg              = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = |Profit Center '{ ls_profit-profitcenternm }({ ls_profit-profitcenter })' is closed Profit Center| ) ) TO reported-defrate.
        ENDIF.

        "유효 시작일 체크
        DATA : lv_validfrdate TYPE dats,
               lr_validfrdate TYPE RANGE OF dats.
        DATA(lv_profitcenter) = |{ lr_draft->profitcenter ALPHA = IN }|.

        lr_validfrdate = VALUE #( ( sign = 'I' option = 'GT' low = lr_draft->validfrdate ) ).

        "유효 시작일 체크 - 비율 정의
        CLEAR lv_validfrdate.
        SELECT  validfrdate
        FROM zmcdar_c_def_rate
        WHERE costtype          = @lr_draft->costtype
          AND costcenter        = @lr_draft->costcenter
          AND profitcenter      = @lv_profitcenter
          AND rate              = @lr_draft->rate
          AND roletype          = @lr_draft->roletype
          AND validfrdate      IN @lr_validfrdate
        ORDER BY validfrdate DESCENDING
        INTO @lv_validfrdate
        UP TO 1 ROWS.
        ENDSELECT.

        IF lv_validfrdate IS NOT INITIAL.
          APPEND VALUE #( "%is_draft            = lr_draft->%is_draft
                          %tky                 = lr_draft->%tky
                          %create              = if_abap_behv=>mk-on
                          %update              = if_abap_behv=>mk-on
                          %action-prepare      = if_abap_behv=>mk-on
                          %fail-cause          = if_abap_behv=>cause-unspecific  ) TO failed-defrate.
          APPEND VALUE #( "%is_draft            = lr_draft->%is_draft
                          %tky                 = lr_draft->%tky
                          %element-validfrdate = if_abap_behv=>mk-on
                          %state_area       = 'error01'
                          %msg              = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = |Set after the existing ValidFrDate:'{ lv_validfrdate }'| ) ) TO reported-defrate.
        ENDIF.

        "유효 시작일 체크 - 전표
        CLEAR lv_validfrdate.
        SELECT  validfrdate
        FROM zmcdar_i_mass_post
        WHERE costtype          = @lr_draft->costtype
          AND profitcenter      = @lv_profitcenter
          AND rate              = @lr_draft->rate
          AND roletype          = @lr_draft->roletype
          AND validfrdate      IN @lr_validfrdate
        ORDER BY validfrdate DESCENDING
        INTO @lv_validfrdate
        UP TO 1 ROWS.
        ENDSELECT.

        IF lv_validfrdate IS NOT INITIAL.
          APPEND VALUE #( "%is_draft            = lr_draft->%is_draft
                          %tky                 = lr_draft->%tky
                          %create              = if_abap_behv=>mk-on
                          %update              = if_abap_behv=>mk-on
                          %action-prepare      = if_abap_behv=>mk-on
                          %fail-cause          = if_abap_behv=>cause-unspecific  ) TO failed-defrate.
          APPEND VALUE #( "%is_draft            = lr_draft->%is_draft
                          %tky                 = lr_draft->%tky
                          %element-validfrdate = if_abap_behv=>mk-on
                          %state_area       = 'error01'
                          %msg              = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = |There is a Journal Entry Items on a date after this ValidFrDate| ) ) TO reported-defrate.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD excel_validation.

    DATA: lt_excel   TYPE TABLE OF zmcdar_a_excel_return_04,
          lt_rawdata TYPE TABLE OF zmcdar_i_def_rate,
          ls_rawdata TYPE zmcdar_i_def_rate.
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

*     Excel Base64 => xstring => itab
*      DATA lv_int TYPE i.
*      lv_int = ls_key-%param-fr_row.
*      DATA(lv_len) = strlen( ls_key-%param-excel_file ).
*      DATA(lv_original_xstring) = xco_cp=>string( ls_key-%param-excel_file
*          )->as_xstring( xco_cp_binary=>text_encoding->base64
*          )->value.
*      DATA(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_original_xstring )->read_access( ).
*      DATA(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->for_name( iv_name = 'Sheet1' ).
*
*      DATA lo_visitor TYPE REF TO if_xco_xlsx_ra_cs_visitor.
*
*      DATA(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
*        )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( ls_key-%param-fr_col )
*        )->to_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( ls_key-%param-to_col )
*        )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( CONV i( ls_key-%param-fr_row ) ) )->get_pattern( ).
*
*      lo_worksheet->select( lo_selection_pattern
*      )->row_stream(
*      )->operation->write_to( REF #( lt_excel )
*      )->if_xco_xlsx_ra_operation~execute( ).



      DATA: lv_exceldt   TYPE i,
            lv_msgcheck  TYPE c LENGTH 1,
            lv_comp_rate TYPE p LENGTH 7 DECIMALS 5.
      CONSTANTS lc_excelstart TYPE dats VALUE '19000101'.


      LOOP AT lt_excel ASSIGNING FIELD-SYMBOL(<fs_excel>).
        DATA(lv_tabix) = sy-tabix.
        IF <fs_excel> IS INITIAL.
          CONTINUE.
        ENDIF.
        CLEAR: ls_rawdata, lv_exceldt, lv_msgcheck.

*       Excel 날짜 일련번호 => 날짜 변환
        lv_exceldt = <fs_excel>-validfrdate.
        IF lv_exceldt > 60.
          lv_exceldt -= 2.
        ENDIF.
        ls_rawdata-validfrdate = lc_excelstart + lv_exceldt.
        <fs_excel>-validfrdate = ls_rawdata-validfrdate.

*       할당 및 기본적인 Type 체크
        TRY.
            ls_rawdata-company = <fs_excel>-company.
            ls_rawdata-profitcenter = <fs_excel>-profitcenter.
            ls_rawdata-costtype = <fs_excel>-costtype.
            ls_rawdata-roletype = <fs_excel>-roletype.
            ls_rawdata-rate = <fs_excel>-rate.
            ls_rawdata-validfrdate = <fs_excel>-validfrdate.
            ls_rawdata-costcenter = <fs_excel>-costcenter.
            ls_rawdata-businesspartner = <fs_excel>-businesspartner.
          CATCH cx_root.
            <fs_excel>-errmsg = 'Wrong Type Error.'.
            APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
            <fs_result>-%param = <fs_excel>.
            UNASSIGN <fs_result>.
            CONTINUE.
        ENDTRY.

        APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
        <fs_result>-%param = <fs_excel>.

        "profitcenter conversion
        DATA(lv_profit) = |{ ls_rawdata-profitcenter ALPHA = IN }|.

        "Null 값 check
        IF ls_rawdata-company IS INITIAL OR ls_rawdata-costcenter IS INITIAL OR ls_rawdata-costtype IS INITIAL OR ls_rawdata-profitcenter IS INITIAL
           OR ls_rawdata-roletype IS INITIAL OR ls_rawdata-validfrdate IS INITIAL.
          <fs_result>-%param-errmsg    = '필수 입력값 누락'.
          UNASSIGN <fs_result>.
          lv_msgcheck = 'X'.
          CONTINUE.
        ENDIF.


        IF lv_msgcheck IS INITIAL.
          "중복 check - excel 데이터 내부
          SELECT *
            FROM @lt_rawdata AS rawdata
           WHERE rawdata~costtype     = @ls_rawdata-costtype
             AND rawdata~costcenter   = @ls_rawdata-costcenter
             AND rawdata~profitcenter = @ls_rawdata-profitcenter
             AND rawdata~roletype     = @ls_rawdata-roletype
             AND rawdata~validfrdate  = @ls_rawdata-validfrdate
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
            FROM zmcdar_c_def_rate
           WHERE costtype          = @ls_rawdata-costtype
             AND costcenter        = @ls_rawdata-costcenter
             AND profitcenter      = @lv_profit
             AND roletype          = @ls_rawdata-roletype
             AND validfrdate       = @ls_rawdata-validfrdate
           INTO TABLE @DATA(lt_origin).

          IF lt_origin IS NOT INITIAL.
            <fs_result>-%param-errmsg = 'Duplicated Data within DB Data'.
            lv_msgcheck = 'X'.
            UNASSIGN <fs_result>.
            CONTINUE.
          ENDIF.
        ENDIF.

        "필드별 유효성 체크
        "CompanyCode
        IF lv_msgcheck IS INITIAL.
          IF ls_rawdata-company NE <fs_excel>-company OR ls_rawdata-company <> 1000.
            <fs_result>-%param-errmsg = 'Invalid Company Code'.
            lv_msgcheck = 'X'.
            UNASSIGN <fs_result>.
            CONTINUE.
          ENDIF.

          DATA lv_boolean LIKE abap_true.

          "CostType
          CLEAR lv_boolean.
          SELECT SINGLE @abap_true FROM zmcdar_i_cost_type
          WHERE costtype = @ls_rawdata-costtype
          INTO @lv_boolean.

          IF ls_rawdata-costtype NE <fs_excel>-costtype OR lv_boolean <> abap_true.
            <fs_result>-%param-errmsg = 'Invalid Cost Type'.
            lv_msgcheck = 'X'.
            UNASSIGN <fs_result>.
            CONTINUE.
          ENDIF.

          "RoleType
          CLEAR lv_boolean.
          SELECT SINGLE @abap_true FROM zmcdar_v_role_type
          WHERE lowvalue = @ls_rawdata-roletype
          INTO @lv_boolean.

          IF ls_rawdata-roletype NE <fs_excel>-roletype OR lv_boolean <> abap_true.
            <fs_result>-%param-errmsg = 'Invalid Role Type'.
            lv_msgcheck = 'X'.
            UNASSIGN <fs_result>.
            CONTINUE.
          ENDIF.

          "Rate
          lv_comp_rate = <fs_excel>-rate.
          IF ls_rawdata-rate NE lv_comp_rate OR ls_rawdata-rate IS INITIAL.
            <fs_result>-%param-errmsg = 'Check Rate length'.
            lv_msgcheck = 'X'.
            UNASSIGN <fs_result>.
          ENDIF.
*          IF ls_rawdata-rate IS NOT INITIAL.
*            CLEAR lv_boolean.
*
*            SELECT SINGLE rawdata~rate
*                FROM @lt_rawdata AS rawdata
*             INNER JOIN @lt_compare AS comparedata
*                     ON rawdata~rate EQ comparedata~rate
*                  WHERE rawdata~rate = @ls_rawdata-rate
*                  INTO @DATA(lv_checkeq).
*
*            IF lv_checkeq IS INITIAL.
*              APPEND INITIAL LINE TO result[] ASSIGNING <fs_result>.
*              <fs_result>-%param-localpath = ls_rawdata-localpath.
*              <fs_result>-%param-errmsg = 'Check Rate length'.
*              lv_msgcheck = 'X'.
*              UNASSIGN <fs_result>.
*
*              CONTINUE.
*            ENDIF.
*
*            CLEAR lv_checkeq.
*          ENDIF.

          "Business Partner
          IF ls_rawdata-businesspartner NE <fs_excel>-businesspartner OR ls_rawdata-businesspartner IS NOT INITIAL.
            CLEAR lv_boolean.
            DATA(lv_businesspartner)  = |{ ls_rawdata-businesspartner ALPHA = IN }|.
            SELECT SINGLE @abap_true FROM zmcdar_v_business_partner
            WHERE businesspartner = @lv_businesspartner
            INTO @lv_boolean.

            IF lv_boolean <> abap_true.
              <fs_result>-%param-errmsg = 'Invalid Business Partner'.
              lv_msgcheck = 'X'.
              UNASSIGN <fs_result>.
              CONTINUE.
            ENDIF.
          ENDIF.

          "Cost Center
          CLEAR lv_boolean.
          SELECT SINGLE @abap_true FROM zmcdar_i_cost_center
          WHERE costcenter = @ls_rawdata-costcenter
          INTO @lv_boolean.

          IF ls_rawdata-costcenter NE <fs_excel>-costcenter OR lv_boolean <> abap_true.
            <fs_result>-%param-errmsg = 'Invalid Cost Center'.
            lv_msgcheck = 'X'.
            UNASSIGN <fs_result>.
            CONTINUE.
          ENDIF.

          "Profit Center
          CLEAR lv_boolean.
          SELECT SINGLE @abap_true FROM zmcdar_v_cost_center
          WHERE costcenter = @ls_rawdata-costcenter
            AND profitcenter = @lv_profit
          INTO @lv_boolean.

          IF ls_rawdata-profitcenter NE <fs_excel>-profitcenter OR lv_boolean <> abap_true.
            <fs_result>-%param-errmsg = 'Invalid Profit Center'.
            lv_msgcheck = 'X'.
            UNASSIGN <fs_result>.
            CONTINUE.
          ENDIF.
        ENDIF.


        "폐점 확인
        CLEAR lv_boolean.
        SELECT SINGLE @abap_true FROM zmcdar_i_def_rate
        WHERE profitcenter = @lv_profit
          AND shutdowndate IS NOT INITIAL
        INTO @lv_boolean.

        IF lv_boolean EQ abap_true.
          <fs_result>-%param-errmsg = |Profit Center '{ ls_rawdata-profitcenter }' is closed Profit Center|.
          lv_msgcheck = 'X'.
          UNASSIGN <fs_result>.
          CONTINUE.
        ENDIF.

        "유효 시작일 체크
        DATA : lv_validfrdate TYPE dats,
               lr_validfrdate TYPE RANGE OF dats.

        lr_validfrdate = VALUE #( ( sign = 'I' option = 'GT' low = ls_rawdata-validfrdate ) ).

        "유효 시작일 체크 - 비율 정의
        CLEAR lv_validfrdate.
        SELECT  validfrdate
        FROM zmcdar_c_def_rate
        WHERE costtype          = @ls_rawdata-costtype
          AND costcenter        = @ls_rawdata-costcenter
          AND profitcenter      = @lv_profit
          AND rate              = @ls_rawdata-rate
          AND roletype          = @ls_rawdata-roletype
          AND validfrdate      IN @lr_validfrdate
        ORDER BY validfrdate DESCENDING
        INTO @lv_validfrdate
        UP TO 1 ROWS.
        ENDSELECT.

        IF lv_validfrdate IS NOT INITIAL.
          <fs_result>-%param-errmsg = |Set after than existing ValidFrDate:'{ lv_validfrdate }'|.
          lv_msgcheck = 'X'.
          UNASSIGN <fs_result>.
          CONTINUE.
        ENDIF.

        "유효 시작일 체크 - 전표
        CLEAR lv_validfrdate.
        SELECT  validfrdate
        FROM zmcdar_i_mass_post
        WHERE costtype          = @ls_rawdata-costtype
          AND profitcenter      = @lv_profit
          AND rate              = @ls_rawdata-rate
          AND roletype          = @ls_rawdata-roletype
          AND validfrdate      IN @lr_validfrdate
        ORDER BY validfrdate DESCENDING
        INTO @lv_validfrdate
        UP TO 1 ROWS.
        ENDSELECT.

        IF lv_validfrdate IS NOT INITIAL.
          <fs_result>-%param-errmsg = |There is a Journal Entry Items on a date after this ValidFrDate|.
          lv_msgcheck = 'X'.
          UNASSIGN <fs_result>.
          CONTINUE.
        ENDIF.

        CLEAR lv_profit.

*       local 중복 체크를 위한 itab 구성
        APPEND INITIAL LINE TO lt_rawdata ASSIGNING FIELD-SYMBOL(<fs_rawdata>).
        <fs_rawdata>-validfrdate = ls_rawdata-validfrdate.
        <fs_rawdata>-company = <fs_excel>-company.
        <fs_rawdata>-profitcenter = <fs_excel>-profitcenter.
        <fs_rawdata>-costtype = <fs_excel>-costtype.
        <fs_rawdata>-roletype = <fs_excel>-roletype.
        <fs_rawdata>-rate = <fs_excel>-rate.
        <fs_rawdata>-validfrdate = <fs_excel>-validfrdate.
        <fs_rawdata>-costcenter = <fs_excel>-costcenter.
        <fs_rawdata>-businesspartner = <fs_excel>-businesspartner.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
