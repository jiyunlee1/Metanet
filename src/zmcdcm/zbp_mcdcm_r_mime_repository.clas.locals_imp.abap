CLASS lhc_zmcdcm_r_mime_repository DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR mimerep RESULT result.
    METHODS determinonmodify FOR DETERMINE ON MODIFY
      IMPORTING keys FOR mimerep~determinonmodify.
    METHODS validationonsave FOR VALIDATE ON SAVE
      IMPORTING keys FOR mimerep~validationonsave.

ENDCLASS.

CLASS lhc_zmcdcm_r_mime_repository IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determinonmodify.

    READ ENTITIES OF zmcdcm_r_mime_repository IN LOCAL MODE
        ENTITY mimerep
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_mimerep).
    DATA lv_xstring TYPE xstring.
    LOOP AT lt_mimerep[] INTO DATA(ls_mimerep).
      lv_xstring = ls_mimerep-attachment.
    ENDLOOP.
  ENDMETHOD.

  METHOD validationonsave.
    CLEAR : failed, reported.
    READ ENTITIES OF zmcdcm_r_mime_repository IN LOCAL MODE
        ENTITY mimerep
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_mimerep).

    IF lt_mimerep IS NOT INITIAL.
      LOOP AT lt_mimerep REFERENCE INTO DATA(ls_mimerep).
        APPEND VALUE #( %is_draft   = ls_mimerep->%is_draft
                        %tky        = ls_mimerep->%tky
                        %state_area = 'validation01' ) TO reported-mimerep.

        IF ls_mimerep->attachment IS INITIAL.
          APPEND VALUE #( %is_draft       = ls_mimerep->%is_draft
                          %tky            = ls_mimerep->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-mimerep.
          APPEND VALUE #( %is_draft             = ls_mimerep->%is_draft
                          %tky                  = ls_mimerep->%tky
                          %element-attachment   = if_abap_behv=>mk-on
                          %state_area           = 'validation01'
                          %msg                  = new_message_with_text(
                            severity  = if_abap_behv_message=>severity-error
                            text      = |Attachment is required| ) ) TO reported-mimerep.
        ENDIF.

        IF ls_mimerep->progpackage IS INITIAL.
          APPEND VALUE #( %is_draft       = ls_mimerep->%is_draft
                          %tky            = ls_mimerep->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-mimerep.

          APPEND VALUE #( %is_draft            = ls_mimerep->%is_draft
                          %tky                 = ls_mimerep->%tky
                          %element-progpackage = if_abap_behv=>mk-on
                          %state_area          = 'validation01'
                          %msg                 = new_message_with_text(
                                               severity  = if_abap_behv_message=>severity-error
                                               text      = |Program Package is required| ) ) TO reported-mimerep.
        ENDIF.

        IF ls_mimerep->purpose IS INITIAL.
          APPEND VALUE #( %is_draft       = ls_mimerep->%is_draft
                          %tky            = ls_mimerep->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-mimerep.

          APPEND VALUE #( %is_draft        = ls_mimerep->%is_draft
                          %tky             = ls_mimerep->%tky
                          %element-purpose = if_abap_behv=>mk-on
                          %state_area      = 'validation01'
                          %msg             = new_message_with_text(
                                               severity  = if_abap_behv_message=>severity-error
                                               text      = |Purpose of attachment is required| ) ) TO reported-mimerep.
        ENDIF.

        CHECK failed-mimerep IS INITIAL.

        " 중복 데이터 체크
        IF     ls_mimerep->progpackage IS NOT INITIAL
           AND ls_mimerep->purpose     IS NOT INITIAL.
          SELECT DISTINCT id
                        , prog_package AS progpackage
                        , purpose      AS purpose
                        , ' '          AS isdraft
            FROM zmcdtcm0010
           WHERE prog_package  = @ls_mimerep->progpackage
             AND purpose = @ls_mimerep->purpose
           UNION
          SELECT DISTINCT id
                        , progpackage AS progpackage
                        , purpose     AS purpose
                        , 'X'        AS isdraft
            FROM zmcddcm0010
           WHERE progpackage = @ls_mimerep->progpackage
             AND purpose     = @ls_mimerep->purpose
             AND id         <> @ls_mimerep->id
            INTO TABLE @DATA(lt_original).

          SORT lt_original[] BY id isdraft DESCENDING.

          READ TABLE lt_original[]
              WITH KEY purpose     = ls_mimerep->purpose
                       progpackage = ls_mimerep->progpackage
              TRANSPORTING NO FIELDS.
          IF sy-subrc = 0.
            APPEND VALUE #( %is_draft   = ls_mimerep->%is_draft
                            %tky        = ls_mimerep->%tky
                            %create     = if_abap_behv=>mk-on
                            %update     = if_abap_behv=>mk-on
                            %action-prepare = if_abap_behv=>mk-on
                            %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-mimerep.
            APPEND VALUE #( %is_draft             = ls_mimerep->%is_draft
                            %tky                  = ls_mimerep->%tky
                            %element-progpackage  = if_abap_behv=>mk-on
                            %element-purpose      = if_abap_behv=>mk-on
                            %state_area           = 'validation01'
                            %msg                  = new_message_with_text(
                              severity  = if_abap_behv_message=>severity-error
                              text      = |Duplicate history exists.| ) ) TO reported-mimerep.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
