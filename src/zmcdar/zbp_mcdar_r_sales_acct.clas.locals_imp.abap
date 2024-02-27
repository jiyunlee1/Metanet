CLASS lhc_sales_acct DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR sales_acct RESULT result.

    METHODS determinonmodify FOR DETERMINE ON MODIFY
      IMPORTING keys FOR sales_acct~determinonmodify.

    METHODS validatedata FOR VALIDATE ON SAVE
      IMPORTING keys FOR sales_acct~validatedata.
    METHODS determinonaccount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR sales_acct~determinonaccount.

ENDCLASS.


CLASS lhc_sales_acct IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determinonmodify.
    READ ENTITIES OF zmcdar_r_sales_acct IN LOCAL MODE
          ENTITY sales_acct
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(lt_defacc).

    LOOP AT lt_defacc[] INTO DATA(ls_defacc).
      CHECK ls_defacc-company IS INITIAL.

      IF sy-subrc = 0.
        MODIFY ENTITIES OF zmcdar_r_sales_acct IN LOCAL MODE
               ENTITY sales_acct
               UPDATE FIELDS ( company )
               WITH VALUE #( ( %tky = ls_defacc-%tky
                               company = '1000'
                               %control-company = if_abap_behv=>mk-on ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD validatedata.
    CLEAR : failed, reported.

    READ ENTITIES OF zmcdar_r_sales_acct IN LOCAL MODE
           ENTITY sales_acct
           ALL FIELDS WITH CORRESPONDING #( keys )
           RESULT DATA(lt_defacc).

    IF lt_defacc IS NOT INITIAL.
      "빈값 여부
      LOOP AT lt_defacc REFERENCE INTO DATA(lr_defacc).
        APPEND VALUE #( %is_draft   = lr_defacc->%is_draft
                        %tky        = lr_defacc->%tky
                        %state_area = 'validation02' ) TO reported-sales_acct.

        "cost type
        IF lr_defacc->costtype IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_defacc->%is_draft
                          %tky            = lr_defacc->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-sales_acct.
          APPEND VALUE #( %is_draft             = lr_defacc->%is_draft
                          %tky                  = lr_defacc->%tky
                          %element-costtype      = if_abap_behv=>mk-on
                          %state_area           = 'validation02'
                          %msg                  = new_message_with_text(
                            severity  = if_abap_behv_message=>severity-error
                            text      = |Cost Type is required| ) ) TO reported-sales_acct.
        ELSE.
          SELECT SINGLE costtype
          FROM zmcdar_i_cost_type
          WHERE costtype = @lr_defacc->costtype
          INTO @DATA(lv_costtype).

          IF lv_costtype IS INITIAL.
            APPEND VALUE #( %is_draft       = lr_defacc->%is_draft
                           %tky            = lr_defacc->%tky
                           %create         = if_abap_behv=>mk-on
                           %update         = if_abap_behv=>mk-on
                           %action-prepare = if_abap_behv=>mk-on
                           %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-sales_acct.
            APPEND VALUE #( %is_draft             = lr_defacc->%is_draft
                            %tky                  = lr_defacc->%tky
                            %element-costtype      = if_abap_behv=>mk-on
                            %state_area           = 'validation02'
                            %msg                  = new_message_with_text(
                              severity  = if_abap_behv_message=>severity-error
                              text      = |Cost Type is wrong data| ) ) TO reported-sales_acct.
          ENDIF.

        ENDIF.

        "costcenter type
        IF lr_defacc->costcentertype IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_defacc->%is_draft
                          %tky            = lr_defacc->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-sales_acct.

          APPEND VALUE #( %is_draft        = lr_defacc->%is_draft
                          %tky             = lr_defacc->%tky
                          %element-costcentertype = if_abap_behv=>mk-on
                          %state_area      = 'validation02'
                          %msg             = new_message_with_text(
                                               severity  = if_abap_behv_message=>severity-error
                                               text      = |Costcenter Type is required| ) ) TO reported-sales_acct.
        ELSE.
          SELECT SINGLE lowvalue
          FROM zmcdar_v_costcenter_type
          WHERE lowvalue = @lr_defacc->costcentertype
          INTO @DATA(lv_costcenterty).

          IF lv_costcenterty IS INITIAL.
            APPEND VALUE #( %is_draft       = lr_defacc->%is_draft
                           %tky            = lr_defacc->%tky
                           %create         = if_abap_behv=>mk-on
                           %update         = if_abap_behv=>mk-on
                           %action-prepare = if_abap_behv=>mk-on
                           %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-sales_acct.

            APPEND VALUE #( %is_draft        = lr_defacc->%is_draft
                            %tky             = lr_defacc->%tky
                            %element-costcentertype = if_abap_behv=>mk-on
                            %state_area      = 'validation02'
                            %msg             = new_message_with_text(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 text      = |Costcenter Type is wrong data.| ) ) TO reported-sales_acct.
          ENDIF.
        ENDIF.

        "Account
        IF lr_defacc->account IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_defacc->%is_draft
                          %tky            = lr_defacc->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-sales_acct.

          APPEND VALUE #( %is_draft        = lr_defacc->%is_draft
                          %tky             = lr_defacc->%tky
                          %element-account = if_abap_behv=>mk-on
                          %state_area      = 'validation02'
                          %msg             = new_message_with_text(
                                               severity  = if_abap_behv_message=>severity-error
                                               text      = |Account is required| ) ) TO reported-sales_acct.
        ELSE.
          SELECT SINGLE glaccount
             FROM zmcdar_v_gl_account
             WHERE glaccount = @lr_defacc->account
             INTO @DATA(lv_account).

          IF lv_account IS INITIAL.
            APPEND VALUE #( %is_draft       = lr_defacc->%is_draft
                            %tky            = lr_defacc->%tky
                            %create         = if_abap_behv=>mk-on
                            %update         = if_abap_behv=>mk-on
                            %action-prepare = if_abap_behv=>mk-on
                            %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-sales_acct.

            APPEND VALUE #( %is_draft        = lr_defacc->%is_draft
                            %tky             = lr_defacc->%tky
                            %element-account = if_abap_behv=>mk-on
                            %state_area      = 'validation02'
                            %msg             = new_message_with_text(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 text      = |Account is wrong data.| ) ) TO reported-sales_acct.
          ENDIF.
        ENDIF.

      ENDLOOP.
    ENDIF.


    " 중복 데이터 체크
    IF lr_defacc->company IS NOT INITIAL
       AND lr_defacc->costtype IS NOT INITIAL
       AND lr_defacc->costcentertype IS NOT INITIAL
       AND lr_defacc->account IS NOT INITIAL.

      SELECT DISTINCT  id,
                      company            AS company,
                      cost_type          AS costtype,
                      costcenter_type    AS costcenterty,
                      account            AS account,
                      account_name       AS accountnm,
                      ' '       AS isdraft
         FROM zmcdtar0020
        WHERE company   = @lr_defacc->company
          AND cost_type = @lr_defacc->costtype
          AND costcenter_type = @lr_defacc->costcentertype
          AND id       <> @lr_defacc->id
        UNION
       SELECT DISTINCT  id,
                      company            AS company,
                      costtype           AS costtype,
                      costcentertype    AS costcenterty,
                      account            AS account,
                      accountnm          AS accountnm,
                      'X'                AS isdraft
         FROM zmcddar0020
        WHERE company        = @lr_defacc->company
          AND costtype       = @lr_defacc->costtype
          AND costcentertype = @lr_defacc->costcentertype
          AND account        = @lr_defacc->account
          AND id             <> @lr_defacc->id
         INTO TABLE @DATA(lt_original).

      SORT lt_original[] BY id isdraft DESCENDING.

      READ TABLE lt_original[]
          WITH KEY company       = lr_defacc->company
                   costtype      = lr_defacc->costtype
                   costcenterty  = lr_defacc->costcentertype
                   account       = lr_defacc->account
          TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        APPEND VALUE #( %is_draft   = lr_defacc->%is_draft
                        %tky        = lr_defacc->%tky
                        %create     = if_abap_behv=>mk-on
                        %update     = if_abap_behv=>mk-on
                        %action-prepare = if_abap_behv=>mk-on
                        %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-sales_acct.
        APPEND VALUE #( %is_draft             = lr_defacc->%is_draft
                        %tky                  = lr_defacc->%tky
                        %element-company      = if_abap_behv=>mk-on
                        %element-costtype     = if_abap_behv=>mk-on
                        %state_area           = 'validation02'
                        %msg                  = new_message_with_text(
                          severity  = if_abap_behv_message=>severity-error
                          text      = |Duplicate history exists.| ) ) TO reported-sales_acct.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD determinonaccount.
    READ ENTITIES OF zmcdar_r_sales_acct IN LOCAL MODE
         ENTITY sales_acct
             ALL FIELDS WITH CORRESPONDING #( keys )
             RESULT DATA(lt_salesacct).
    LOOP AT lt_salesacct INTO DATA(ls_salesacct).
      SELECT SINGLE glaccountname FROM zmcdar_v_gl_account
       WHERE glaccount = @ls_salesacct-account
        INTO @DATA(lv_acctnm).

      MODIFY ENTITIES OF zmcdar_r_sales_acct IN LOCAL MODE
          ENTITY sales_acct UPDATE FIELDS ( accountnm )
          WITH VALUE #( ( %tky = ls_salesacct-%tky
                          accountnm = lv_acctnm
                          %control-accountnm = if_abap_behv=>mk-on ) ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
