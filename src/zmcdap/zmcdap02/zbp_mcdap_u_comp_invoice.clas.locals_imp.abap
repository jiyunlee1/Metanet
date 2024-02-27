CLASS lhc_compinvoice DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR compinvoice RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR compinvoice RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ compinvoice RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK compinvoice.

    METHODS cancelexceptaction FOR MODIFY
      IMPORTING keys FOR ACTION compinvoice~cancelexceptaction RESULT result.

    METHODS setexceptaction FOR MODIFY
      IMPORTING keys FOR ACTION compinvoice~setexceptaction RESULT result.

ENDCLASS.

CLASS lhc_compinvoice IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD cancelexceptaction.

    DATA: lt_update_expt TYPE TABLE FOR UPDATE zmcdap_r_comp_excpt,
          lt_create_expt TYPE TABLE FOR CREATE zmcdap_r_comp_excpt.
    DATA: ls_create_expt LIKE LINE OF lt_create_expt,
          ls_update_expt LIKE LINE OF lt_update_expt.
    DATA: BEGIN OF ls_expt,
            id        TYPE sysuuid_x16,
            excptstat TYPE zmcdde_expt_status_type,
          END OF ls_expt,
          lv_check  TYPE abap_boolean,
          lv_failed TYPE abap_boolean VALUE abap_false.

    LOOP AT keys INTO DATA(ls_key).
      CLEAR: ls_expt, lv_check.
      SELECT SINGLE id, exptstat FROM zmcdap_i_comp_excpt
      WHERE issueno = @ls_key-issueno
      INTO @ls_expt.

      IF ls_expt IS INITIAL OR ls_expt-excptstat NE 'Y'.
        APPEND VALUE #( %tky = ls_key-%tky  ) TO failed-compinvoice.
        APPEND VALUE #( %tky = ls_key-%tky
                        %state_area = 'test'
                        %msg = new_message_with_text(
                                 severity  = if_abap_behv_message=>severity-error
                                 text      = |{ ls_key-issueno } is not Excepted.| ) )
               TO reported-compinvoice.
        lv_failed = abap_true.
      ENDIF.

      IF ls_expt-id IS INITIAL.
        SELECT SINGLE @abap_true FROM @lt_create_expt AS expt
        WHERE issueno = @ls_key-issueno
        INTO @lv_check.
        IF lv_check NE abap_true.
          ls_create_expt-%cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
          ls_create_expt-issueno = ls_key-issueno.
          ls_create_expt-exptstat = ' '.
          APPEND ls_create_expt TO lt_create_expt.
        ENDIF.
      ELSE.
        ls_update_expt-id = ls_expt-id.
        ls_update_expt-exptstat = ' '.
        APPEND ls_update_expt TO lt_update_expt.
      ENDIF.
    ENDLOOP.

    IF lv_failed NE abap_true.
      APPEND VALUE #( %tky = ls_key-%tky
                      %msg = new_message_with_text(
                               severity  = if_abap_behv_message=>severity-success
                               text      = |Exception Canceled.| ) )
             TO reported-compinvoice.
      MODIFY ENTITIES OF zmcdap_r_comp_excpt
      ENTITY zmcdap_r_comp_excpt
      UPDATE
      FIELDS ( exptstat )
      WITH lt_update_expt.
    ENDIF.
  ENDMETHOD.

  METHOD setexceptaction.
    DATA: lt_update_expt TYPE TABLE FOR UPDATE zmcdap_r_comp_excpt,
          lt_create_expt TYPE TABLE FOR CREATE zmcdap_r_comp_excpt.
    DATA: ls_create_expt LIKE LINE OF lt_create_expt,
          ls_update_expt LIKE LINE OF lt_update_expt.
    DATA: BEGIN OF ls_expt,
            id        TYPE sysuuid_x16,
            excptstat TYPE zmcdde_expt_status_type,
          END OF ls_expt,
          lv_check  TYPE abap_boolean,
          lv_failed TYPE abap_boolean VALUE abap_false.
    LOOP AT keys INTO DATA(ls_key).
      CLEAR: ls_expt, lv_check.

      SELECT SINGLE id, exptstat FROM zmcdap_i_comp_excpt
      WHERE issueno = @ls_key-issueno
      INTO @ls_expt.

      IF ls_expt IS NOT INITIAL AND ls_expt-excptstat EQ 'Y'.
        APPEND VALUE #( %tky = ls_key-%tky  ) TO failed-compinvoice.
        APPEND VALUE #( %tky = ls_key-%tky
                        %msg = new_message_with_text(
                                 severity  = if_abap_behv_message=>severity-error
                                 text      = |{ ls_key-issueno } is already Excepted.| ) )
               TO reported-compinvoice.
        lv_failed = abap_true.
      ENDIF.



      IF ls_expt-id IS INITIAL.
        SELECT SINGLE @abap_true FROM @lt_create_expt AS expt
        WHERE issueno = @ls_key-issueno
        INTO @lv_check.
        IF lv_check NE abap_true.
          ls_create_expt-%cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
          ls_create_expt-issueno = ls_key-issueno.
          ls_create_expt-exptstat = 'Y'.
          APPEND ls_create_expt TO lt_create_expt.
        ENDIF.
      ELSE.
        ls_update_expt-id = ls_expt-id.
        ls_update_expt-exptstat = 'Y'.
        APPEND ls_update_expt TO lt_update_expt.
      ENDIF.
    ENDLOOP.

    IF lv_failed NE abap_true.
      APPEND VALUE #( %tky = ls_key-%tky
                      %msg = new_message_with_text(
                               severity  = if_abap_behv_message=>severity-success
                               text      = |Relevant Approval Numbers have been Excepted.| ) )
             TO reported-compinvoice.
      lv_failed = abap_true.
      MODIFY ENTITIES OF zmcdap_r_comp_excpt
      ENTITY zmcdap_r_comp_excpt
      CREATE
      FIELDS ( issueno exptstat )
      WITH lt_create_expt
      ENTITY zmcdap_r_comp_excpt
      UPDATE
      FIELDS ( exptstat )
      WITH lt_update_expt.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmcdap_u_comp_invoice DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmcdap_u_comp_invoice IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
