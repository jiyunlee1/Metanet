CLASS lhc_subsite DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR subsite RESULT result.

    METHODS determinonsubsite FOR DETERMINE ON MODIFY
      IMPORTING keys FOR subsite~determinonsubsite.

    METHODS validatedata FOR VALIDATE ON SAVE
      IMPORTING keys FOR subsite~validatedata.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR subsite RESULT result.

ENDCLASS.

CLASS lhc_subsite IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determinonsubsite.
    READ ENTITIES OF zmcdar_r_sub_site IN LOCAL MODE
    ENTITY subsite
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_subsite).

    LOOP AT lt_subsite INTO DATA(ls_subsite).
      IF ls_subsite-subsite CO '0123456789'.
        DATA(lv_numcheck) = ' '.
      ELSE.
        lv_numcheck = 'X'.

        CONTINUE.
      ENDIF.

      IF ls_subsite-subsite IS NOT INITIAL AND lv_numcheck IS INITIAL.
        SELECT SINGLE subsitename
          FROM zmcdar_r_sub_site
          WHERE subsite = @ls_subsite-subsite
          INTO @DATA(lv_subsitenm).

        IF sy-subrc <> 0 OR lv_subsitenm IS INITIAL.
          CONTINUE.

        ELSEIF lv_subsitenm <> ls_subsite-subsitename.
          MODIFY ENTITIES OF zmcdar_r_sub_site IN LOCAL MODE
                   ENTITY subsite UPDATE FIELDS ( subsitename )
                   WITH VALUE #( ( %tky = ls_subsite-%tky
                                   subsitename = lv_subsitenm
                                   %control-subsitename = if_abap_behv=>mk-on ) ).

          RETURN.
        ENDIF.
        CLEAR : lv_subsitenm, lv_numcheck.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validatedata.
    CLEAR : failed, reported.

    READ ENTITIES OF zmcdar_r_sub_site IN LOCAL MODE
        ENTITY subsite
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_subsite).

    IF lt_subsite IS NOT INITIAL.
      LOOP AT lt_subsite REFERENCE INTO DATA(lr_subsite).
        APPEND VALUE #( %is_draft   = lr_subsite->%is_draft
                        %tky        = lr_subsite->%tky
                        %state_area = 'validation01' ) TO reported-subsite.

        IF lr_subsite->subsite IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_subsite->%is_draft
                          %tky            = lr_subsite->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-subsite.
          APPEND VALUE #( %is_draft             = lr_subsite->%is_draft
                          %tky                  = lr_subsite->%tky
                          %element-subsite      = if_abap_behv=>mk-on
                          %state_area           = 'validation01'
                          %msg                  = new_message_with_text(
                            severity  = if_abap_behv_message=>severity-error
                            text      = |Subsite is required| ) ) TO reported-subsite.
        ELSE.
          IF lr_subsite->subsite CN '1234567890'.
            APPEND VALUE #( %is_draft       = lr_subsite->%is_draft
                            %tky            = lr_subsite->%tky
                            %create         = if_abap_behv=>mk-on
                            %update         = if_abap_behv=>mk-on
                            %action-prepare = if_abap_behv=>mk-on
                            %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-subsite.
            APPEND VALUE #( %is_draft             = lr_subsite->%is_draft
                            %tky                  = lr_subsite->%tky
                            %element-subsite      = if_abap_behv=>mk-on
                            %state_area           = 'validation01'
                            %msg                  = new_message_with_text(
                              severity  = if_abap_behv_message=>severity-error
                              text      = |Subsite is not number| ) ) TO reported-subsite.
          ENDIF.
        ENDIF.

        IF lr_subsite->subsitename IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_subsite->%is_draft
                          %tky            = lr_subsite->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-subsite.

          APPEND VALUE #( %is_draft            = lr_subsite->%is_draft
                          %tky                 = lr_subsite->%tky
                          %element-subsitename = if_abap_behv=>mk-on
                          %state_area          = 'validation01'
                          %msg                 = new_message_with_text(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 text      = |Subsite Name is required| ) ) TO reported-subsite.
        ENDIF.

        IF lr_subsite->costcentertype IS INITIAL.
          APPEND VALUE #( %is_draft       = lr_subsite->%is_draft
                          %tky            = lr_subsite->%tky
                          %create         = if_abap_behv=>mk-on
                          %update         = if_abap_behv=>mk-on
                          %action-prepare = if_abap_behv=>mk-on
                          %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-subsite.

          APPEND VALUE #( %is_draft               = lr_subsite->%is_draft
                          %tky                    = lr_subsite->%tky
                          %element-costcentertype = if_abap_behv=>mk-on
                          %state_area             = 'validation01'
                          %msg                    = new_message_with_text(
                                                    severity  = if_abap_behv_message=>severity-error
                                                    text      = |Cost Center Type is required| ) ) TO reported-subsite.
        ELSE.
          SELECT lowvalue
            FROM zmcdar_v_costcenter_type
           WHERE lowvalue = @lr_subsite->costcentertype
            INTO TABLE @DATA(lt_costcentertp).

          IF lt_costcentertp IS INITIAL.
            APPEND VALUE #( %is_draft      = lr_subsite->%is_draft
                           %tky            = lr_subsite->%tky
                           %create         = if_abap_behv=>mk-on
                           %update         = if_abap_behv=>mk-on
                           %action-prepare = if_abap_behv=>mk-on
                           %fail-cause     = if_abap_behv=>cause-unspecific ) TO failed-subsite.

            APPEND VALUE #( %is_draft               = lr_subsite->%is_draft
                            %tky                    = lr_subsite->%tky
                            %element-costcentertype = if_abap_behv=>mk-on
                            %state_area             = 'validation01'
                            %msg                    = new_message_with_text(
                                                      severity  = if_abap_behv_message=>severity-error
                                                      text      = |Cost Center Type is wrong data.| ) ) TO reported-subsite.
          ENDIF.

        ENDIF.

        CHECK failed-subsite IS INITIAL.

        " 중복 데이터 체크
        IF lr_subsite->subsite IS NOT INITIAL
           AND lr_subsite->costcentertype IS NOT INITIAL.

          SELECT DISTINCT id,
                          subsite         AS subsite,
                          costcenter_type AS costcentertp,
                          ' '             AS isdraft
            FROM zmcdtar0060 AS table
           WHERE subsite          = @lr_subsite->subsite
             AND costcenter_type  = @lr_subsite->costcentertype
             AND id              <> @lr_subsite->id
          UNION
          SELECT DISTINCT id,
                          subsite          AS subsite,
                          costcentertype   AS costcentertp,
                          'X'              AS isdraft
            FROM zmcddar0060 AS draft
           WHERE subsite         = @lr_subsite->subsite
             AND costcentertype  = @lr_subsite->costcentertype
             AND id              <> @lr_subsite->id
            INTO TABLE @DATA(lt_origin).

          SORT lt_origin[] BY id isdraft DESCENDING.

          READ TABLE lt_origin[]
              WITH KEY subsite      = lr_subsite->subsite
                       costcentertp = lr_subsite->costcentertype
              TRANSPORTING NO FIELDS.

          IF sy-subrc = 0.
            APPEND VALUE #( %is_draft   = lr_subsite->%is_draft
                            %tky        = lr_subsite->%tky
                            %create     = if_abap_behv=>mk-on
                            %update     = if_abap_behv=>mk-on
                            %action-prepare = if_abap_behv=>mk-on
                            %fail-cause = if_abap_behv=>cause-unspecific ) TO failed-subsite.
            APPEND VALUE #( %is_draft                = lr_subsite->%is_draft
                            %tky                     = lr_subsite->%tky
                            %element-subsite         = if_abap_behv=>mk-on
                            %element-costcentertype  = if_abap_behv=>mk-on
                            %state_area           = 'validation01'
                            %msg                  = new_message_with_text(
                              severity  = if_abap_behv_message=>severity-error
                              text      = |Duplicate history exists| ) ) TO reported-subsite.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zmcdar_r_sub_site IN LOCAL MODE
         ENTITY subsite
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_subsite).


    LOOP AT lt_subsite INTO DATA(ls_subsite).

      SELECT SINGLE @abap_true FROM zmcdar_i_sub_site
      WHERE id = @ls_subsite-id
      INTO @DATA(is_edit).
      result = VALUE #( FOR groups IN keys (
                        %tky = ls_subsite-%tky
                        %field-subsite = COND #( WHEN is_edit eq abap_true
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-f-mandatory )
                        %field-subsitename = COND #( WHEN is_edit eq abap_true
                                                     THEN if_abap_behv=>fc-f-read_only
                                                     ELSE if_abap_behv=>fc-f-mandatory )
                       ) ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
