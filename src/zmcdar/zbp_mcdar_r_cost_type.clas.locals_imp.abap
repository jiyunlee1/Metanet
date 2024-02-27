CLASS lhc_costtype DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR costtype RESULT result.

    METHODS determinonmodify FOR DETERMINE ON MODIFY
      IMPORTING keys FOR costtype~determinonmodify.

    METHODS validatedata FOR VALIDATE ON SAVE
      IMPORTING keys FOR costtype~validatedata.

ENDCLASS.

CLASS lhc_costtype IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determinonmodify.
    READ ENTITIES OF zmcdar_r_cost_type IN LOCAL MODE
        ENTITY costtype
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_costtype).
    LOOP AT lt_costtype[] INTO DATA(ls_costtype).
      CHECK ls_costtype-company IS INITIAL.
      MODIFY ENTITIES OF zmcdar_r_cost_type IN LOCAL MODE
          ENTITY costtype UPDATE FIELDS ( company )
          WITH VALUE #( ( %tky = ls_costtype-%tky
                          company = '1000'
                          %control-company = if_abap_behv=>mk-on ) ).

    ENDLOOP.
  ENDMETHOD.

  METHOD validatedata.
    CLEAR : failed, reported.

    READ ENTITIES OF zmcdar_r_cost_type IN LOCAL MODE
        ENTITY costtype
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_costtype).

    IF lt_costtype IS NOT INITIAL.
      LOOP AT lt_costtype REFERENCE INTO DATA(lr_costtype).
        APPEND VALUE #( %is_draft   = lr_costtype->%is_draft
                        %tky        = lr_costtype->%tky
                        %state_area = 'validation01' ) TO reported-costtype.

        IF lr_costtype->costtype IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_costtype->%is_draft
                          %tky            = lr_costtype->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-costtype.
          APPEND VALUE #( %is_draft             = lr_costtype->%is_draft
                          %tky                  = lr_costtype->%tky
                          %element-company      = if_abap_behv=>mk-on
                          %state_area           = 'validation01'
                          %msg                  = new_message_with_text(
                            severity  = if_abap_behv_message=>severity-error
                            text      = |Cost Type is required| ) ) TO reported-costtype.
        ENDIF.

        IF lr_costtype->costtypenm IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_costtype->%is_draft
                          %tky            = lr_costtype->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-costtype.

          APPEND VALUE #( %is_draft        = lr_costtype->%is_draft
                          %tky             = lr_costtype->%tky
                          %element-company = if_abap_behv=>mk-on
                          %state_area      = 'validation01'
                          %msg             = new_message_with_text(
                                               severity  = if_abap_behv_message=>severity-error
                                               text      = |Cost Type Name is required| ) ) TO reported-costtype.
        ENDIF.

        CHECK failed-costtype IS INITIAL.

        " 중복 데이터 체크
        IF     lr_costtype->company IS NOT INITIAL
           AND lr_costtype->costtype IS NOT INITIAL.
          SELECT DISTINCT id
                        , company   AS company
                        , cost_type AS costtype
                        , type_name AS costtypenm
                        , ' '       AS isdraft
            FROM zmcdtar0010
           WHERE company   = @lr_costtype->company
             AND cost_type = @lr_costtype->costtype
             AND id       <> @lr_costtype->id
           UNION
          SELECT DISTINCT id
                        , company    AS company
                        , costtype   AS costtype
                        , costtypenm AS costtypenm
                        , 'X'        AS isdraft
            FROM zmcddar0010
           WHERE company   = @lr_costtype->company
             AND costtype  = @lr_costtype->costtype
             AND id       <> @lr_costtype->id
            INTO TABLE @DATA(lt_original).

          SORT lt_original[] BY id isdraft DESCENDING.

          READ TABLE lt_original[]
              WITH KEY company       = lr_costtype->company
                       costtype    = lr_costtype->costtype
              TRANSPORTING NO FIELDS.
          IF sy-subrc = 0.
            APPEND VALUE #( %is_draft   = lr_costtype->%is_draft
                            %tky        = lr_costtype->%tky
                            %create     = if_abap_behv=>mk-on
                            %update     = if_abap_behv=>mk-on
                            %action-prepare = if_abap_behv=>mk-on
                            %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-costtype.
            APPEND VALUE #( %is_draft             = lr_costtype->%is_draft
                            %tky                  = lr_costtype->%tky
                            %element-company      = if_abap_behv=>mk-on
                            %element-costtype     = if_abap_behv=>mk-on
                            %state_area           = 'validation01'
                            %msg                  = new_message_with_text(
                              severity  = if_abap_behv_message=>severity-error
                              text      = |Duplicate history exists.| ) ) TO reported-costtype.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
