CLASS lhc_docacct DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR docacct RESULT result.

    METHODS determinonmodify FOR DETERMINE ON MODIFY
      IMPORTING keys FOR docacct~determinonmodify.

    METHODS determinonaccount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR docacct~determinonaccount.

    METHODS validatedata FOR VALIDATE ON SAVE
      IMPORTING keys FOR docacct~validatedata.

ENDCLASS.

CLASS lhc_docacct IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determinonmodify.
    READ ENTITIES OF zmcdar_r_doc_acct IN LOCAL MODE
        ENTITY docacct
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_docacct).
    LOOP AT lt_docacct[] INTO DATA(ls_docacct).
      CHECK ls_docacct-company IS INITIAL.
      TRANSLATE ls_docacct-costtype TO UPPER CASE.
      MODIFY ENTITIES OF zmcdar_r_doc_acct IN LOCAL MODE
          ENTITY docacct UPDATE FIELDS ( company )
          WITH VALUE #( ( %tky = ls_docacct-%tky
                          company = '1000'
                          %control-company = if_abap_behv=>mk-on ) ).

    ENDLOOP.
  ENDMETHOD.


  METHOD determinonaccount.
    READ ENTITIES OF zmcdar_r_doc_acct IN LOCAL MODE
        ENTITY docacct
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_docacct).
    LOOP AT lt_docacct INTO DATA(ls_docacct).
      SELECT SINGLE glaccountname FROM zmcdar_v_gl_account
       WHERE glaccount = @ls_docacct-account
        INTO @DATA(lv_acctnm).

      MODIFY ENTITIES OF zmcdar_r_doc_acct IN LOCAL MODE
          ENTITY docacct UPDATE FIELDS ( accountnm )
          WITH VALUE #( ( %tky = ls_docacct-%tky
                          accountnm = lv_acctnm
                          %control-accountnm = if_abap_behv=>mk-on ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD validatedata.
    CLEAR : failed, reported.

    READ ENTITIES OF zmcdar_r_doc_acct IN LOCAL MODE
        ENTITY docacct
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_docacct).

    IF lt_docacct IS NOT INITIAL.
      LOOP AT lt_docacct REFERENCE INTO DATA(lr_docacct).
        APPEND VALUE #( %is_draft   = lr_docacct->%is_draft
                        %tky        = lr_docacct->%tky
                        %state_area = 'validation01' ) TO reported-docacct.

        IF lr_docacct->costtype IS INITIAL.
          APPEND VALUE #( %is_draft   = lr_docacct->%is_draft
                          %tky        = lr_docacct->%tky
                          %create     = if_abap_behv=>mk-on
                          %update     = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-docacct.
          APPEND VALUE #( %is_draft             = lr_docacct->%is_draft
                          %tky                  = lr_docacct->%tky
                          %element-costtype      = if_abap_behv=>mk-on
                          %state_area           = 'validation01'
                          %msg                  = new_message_with_text(
                            severity  = if_abap_behv_message=>severity-error
                            text      = |Cost Type is required| ) ) TO reported-docacct.
        ELSE.
          SELECT SINGLE costtype
            FROM zmcdar_i_cost_type
            WHERE costtype = @lr_docacct->costtype
            INTO @DATA(lv_costtype).

          IF lv_costtype IS INITIAL.
            APPEND VALUE #( %is_draft   = lr_docacct->%is_draft
                  %tky        = lr_docacct->%tky
                  %create     = if_abap_behv=>mk-on
                  %update     = if_abap_behv=>mk-on
                  %action-prepare = if_abap_behv=>mk-on
                  %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-docacct.
            APPEND VALUE #( %is_draft             = lr_docacct->%is_draft
                            %tky                  = lr_docacct->%tky
                            %element-costtype      = if_abap_behv=>mk-on
                            %state_area           = 'validation01'
                            %msg                  = new_message_with_text(
                              severity  = if_abap_behv_message=>severity-error
                              text      = |Cost Type is wrong data| ) ) TO reported-docacct.
          ENDIF.
        ENDIF.

        IF lr_docacct->roletype IS INITIAL.
          APPEND VALUE #( %is_draft   = lr_docacct->%is_draft
                          %tky        = lr_docacct->%tky
                          %create     = if_abap_behv=>mk-on
                          %update     = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-docacct.
          APPEND VALUE #( %is_draft             = lr_docacct->%is_draft
                          %tky                  = lr_docacct->%tky
                          %element-roletype     = if_abap_behv=>mk-on
                          %state_area           = 'validation01'
                          %msg                  = new_message_with_text(
                            severity  = if_abap_behv_message=>severity-error
                            text      = |Role Type is required| ) ) TO reported-docacct.
        ELSE.
          SELECT SINGLE lowvalue
          FROM zmcdar_v_role_type
          WHERE lowvalue = @lr_docacct->roletype
          INTO @DATA(lv_roletype).

          IF lv_roletype IS INITIAL.
            APPEND VALUE #( %is_draft   = lr_docacct->%is_draft
                   %tky        = lr_docacct->%tky
                   %create     = if_abap_behv=>mk-on
                   %update     = if_abap_behv=>mk-on
                   %action-prepare = if_abap_behv=>mk-on
                   %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-docacct.
            APPEND VALUE #( %is_draft             = lr_docacct->%is_draft
                            %tky                  = lr_docacct->%tky
                            %element-roletype     = if_abap_behv=>mk-on
                            %state_area           = 'validation01'
                            %msg                  = new_message_with_text(
                              severity  = if_abap_behv_message=>severity-error
                              text      = |Role Type is wrong data| ) ) TO reported-docacct.
          ENDIF.
        ENDIF.

        IF lr_docacct->postingkey IS INITIAL.
          APPEND VALUE #( %is_draft   = lr_docacct->%is_draft
                          %tky        = lr_docacct->%tky
                          %create     = if_abap_behv=>mk-on
                          %update     = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-docacct.
          APPEND VALUE #( %is_draft             = lr_docacct->%is_draft
                          %tky                  = lr_docacct->%tky
                          %element-postingkey   = if_abap_behv=>mk-on
                          %state_area           = 'validation01'
                          %msg                  = new_message_with_text(
                            severity  = if_abap_behv_message=>severity-error
                            text      = |Account Type code is required| ) ) TO reported-docacct.
        ELSE.
          SELECT SINGLE accttpcode
                   FROM zmcdar_v_acct_type
                  WHERE accttpcode = @lr_docacct->postingkey
                   INTO @DATA(lv_posting).

          IF lv_posting IS INITIAL.
            APPEND VALUE #( %is_draft   = lr_docacct->%is_draft
                  %tky        = lr_docacct->%tky
                  %create     = if_abap_behv=>mk-on
                  %update     = if_abap_behv=>mk-on
                  %action-prepare = if_abap_behv=>mk-on
                  %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-docacct.
            APPEND VALUE #( %is_draft             = lr_docacct->%is_draft
                            %tky                  = lr_docacct->%tky
                            %element-postingkey   = if_abap_behv=>mk-on
                            %state_area           = 'validation01'
                            %msg                  = new_message_with_text(
                              severity  = if_abap_behv_message=>severity-error
                              text      = |Account Type Code is wrong data| ) ) TO reported-docacct.
          ENDIF.
        ENDIF.

        IF lr_docacct->doctype IS INITIAL.
          APPEND VALUE #( %is_draft   = lr_docacct->%is_draft
                          %tky        = lr_docacct->%tky
                          %create     = if_abap_behv=>mk-on
                          %update     = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-docacct.
          APPEND VALUE #( %is_draft             = lr_docacct->%is_draft
                          %tky                  = lr_docacct->%tky
                          %element-doctype      = if_abap_behv=>mk-on
                          %state_area           = 'validation01'
                          %msg                  = new_message_with_text(
                            severity  = if_abap_behv_message=>severity-error
                            text      = |Document Type is required| ) ) TO reported-docacct.
        ELSE.
          SELECT SINGLE doctype
                   FROM zmcdar_v_doc_type
                  WHERE doctype = @lr_docacct->doctype
                   INTO @DATA(lv_doctype).

          IF lv_doctype IS INITIAL.
            APPEND VALUE #( %is_draft   = lr_docacct->%is_draft
                  %tky        = lr_docacct->%tky
                  %create     = if_abap_behv=>mk-on
                  %update     = if_abap_behv=>mk-on
                  %action-prepare = if_abap_behv=>mk-on
                  %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-docacct.
            APPEND VALUE #( %is_draft             = lr_docacct->%is_draft
                            %tky                  = lr_docacct->%tky
                            %element-doctype      = if_abap_behv=>mk-on
                            %state_area           = 'validation01'
                            %msg                  = new_message_with_text(
                              severity  = if_abap_behv_message=>severity-error
                              text      = |Document Type is wrong data| ) ) TO reported-docacct.
          ENDIF.
        ENDIF.

        IF lr_docacct->account IS INITIAL.
          APPEND VALUE #( %is_draft   = lr_docacct->%is_draft
                          %tky        = lr_docacct->%tky
                          %create     = if_abap_behv=>mk-on
                          %update     = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-docacct.
          APPEND VALUE #( %is_draft             = lr_docacct->%is_draft
                          %tky                  = lr_docacct->%tky
                          %element-account      = if_abap_behv=>mk-on
                          %state_area           = 'validation01'
                          %msg                  = new_message_with_text(
                            severity  = if_abap_behv_message=>severity-error
                            text      = |Account is required| ) ) TO reported-docacct.
        ELSE.
          SELECT SINGLE glaccount
            FROM zmcdar_v_gl_account
           WHERE glaccount = @lr_docacct->account
            INTO @DATA(lv_account).

          IF lv_account IS INITIAL.
            APPEND VALUE #( %is_draft   = lr_docacct->%is_draft
                            %tky        = lr_docacct->%tky
                            %create     = if_abap_behv=>mk-on
                            %update     = if_abap_behv=>mk-on
                            %action-prepare = if_abap_behv=>mk-on
                            %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-docacct.
            APPEND VALUE #( %is_draft             = lr_docacct->%is_draft
                            %tky                  = lr_docacct->%tky
                            %element-account      = if_abap_behv=>mk-on
                            %state_area           = 'validation01'
                            %msg                  = new_message_with_text(
                              severity  = if_abap_behv_message=>severity-error
                              text      = |Account is wrong data| ) ) TO reported-docacct.
          ENDIF.
        ENDIF.

        CHECK failed-docacct IS INITIAL.

        " 중복 데이터 체크
        IF     lr_docacct->company IS NOT INITIAL
           AND lr_docacct->costtype IS NOT INITIAL.
          SELECT DISTINCT id
                        , role_type   AS roletype
                        , doc_type    AS doctype
                        , posting_key AS postingkey
                        , cost_type   AS costtype
                        , ' '         AS isdraft
            FROM zmcdtar0030
           WHERE role_type   = @lr_docacct->roletype
             AND doc_type    = @lr_docacct->doctype
             AND posting_key = @lr_docacct->postingkey
             AND cost_type   = @lr_docacct->CostType
             AND id         <> @lr_docacct->id
           UNION
          SELECT DISTINCT id
                        , roletype   AS roletype
                        , doctype    AS doctype
                        , postingkey AS postingkey
                        , costtype   AS costtype
                        , 'X'        AS isdraft
            FROM zmcddar0030
           WHERE roletype   = @lr_docacct->roletype
             AND doctype    = @lr_docacct->doctype
             AND postingkey = @lr_docacct->postingkey
             AND costtype   = @lr_docacct->CostType
             AND id        <> @lr_docacct->id
            INTO TABLE @DATA(lt_original).

          SORT lt_original[] BY id isdraft DESCENDING.

          READ TABLE lt_original[]
              WITH KEY roletype   = lr_docacct->roletype
                       doctype    = lr_docacct->doctype
                       postingkey = lr_docacct->postingkey
                       costtype   = lr_docacct->CostType
                       isdraft    = ' '
              TRANSPORTING NO FIELDS.

          IF sy-subrc = 0.
              APPEND VALUE #( %is_draft   = lr_docacct->%is_draft
                              %tky        = lr_docacct->%tky
                              %create     = if_abap_behv=>mk-on
                              %update     = if_abap_behv=>mk-on
                              %action-prepare = if_abap_behv=>mk-on
                              %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-docacct.
              APPEND VALUE #( %is_draft             = lr_docacct->%is_draft
                              %tky                  = lr_docacct->%tky
                              %element-company      = if_abap_behv=>mk-on
                              %element-costtype     = if_abap_behv=>mk-on
                              %state_area           = 'validation01'
                              %msg                  = new_message_with_text(
                                severity  = if_abap_behv_message=>severity-error
                                text      = |Duplicate history exists.| ) ) TO reported-docacct.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
