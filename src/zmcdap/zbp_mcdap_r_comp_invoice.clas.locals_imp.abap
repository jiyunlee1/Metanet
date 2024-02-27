CLASS lhc_zmcdap_r_comp_invoice DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.


    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR compinvoice RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR compinvoice RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ compinvoice RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK compinvoice.

    METHODS cancelexcept FOR MODIFY
      IMPORTING keys FOR ACTION compinvoice~cancelexcept RESULT result.

    METHODS setexcept FOR MODIFY
      IMPORTING keys FOR ACTION compinvoice~setexcept RESULT result.

ENDCLASS.

CLASS lhc_zmcdap_r_comp_invoice IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zmcdap_r_comp_invoice IN LOCAL MODE
    ENTITY compinvoice
    FIELDS ( exptstat ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_exptstats)
    FAILED failed.


    result = VALUE #(
      FOR ls_exptstat IN lt_exptstats (
        %tky                        = ls_exptstat-%tky
        %features-%action-setexcept = COND #( WHEN ls_exptstat-exptstat = 'Y'
                                              THEN if_abap_behv=>fc-o-disabled
                                              ELSE if_abap_behv=>fc-o-enabled )
        %features-%action-cancelexcept = COND #( WHEN ls_exptstat-exptstat = 'Y'
                                                 THEN if_abap_behv=>fc-o-enabled
                                                 ELSE if_abap_behv=>fc-o-disabled )

      ) ).

*    result = VALUE #(
*                FOR exptstat IN lt_exptstats
*                LET a = COND #( WHEN exptstat-exptstat = abap_true
*                                  THEN if_abap_behv=>fc-o-disabled )
*    ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD cancelexcept.
    DATA: lt_update_expt TYPE TABLE FOR UPDATE zmcdap_r_comp_excpt,
          lt_create_expt TYPE TABLE FOR CREATE zmcdap_r_comp_excpt.
    DATA: ls_create_expt LIKE LINE OF lt_create_expt,
          ls_update_expt LIKE LINE OF lt_update_expt.
    DATA: lv_id TYPE sysuuid_x16.
    LOOP AT keys INTO DATA(ls_key).
      CLEAR lv_id.
      SELECT SINGLE id FROM zmcdap_i_comp_excpt
      WHERE issueno = @ls_key-issueno
      INTO @lv_id.

      IF lv_id IS INITIAL.
        ls_create_expt-%cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
        ls_create_expt-issueno = ls_key-issueno.
        ls_create_expt-exptstat = ' '.
        APPEND ls_create_expt TO lt_create_expt.
      ELSE.
        ls_update_expt-id = lv_id.
        ls_update_expt-exptstat = ' '.
        APPEND ls_update_expt TO lt_update_expt.
      ENDIF.
    ENDLOOP.


    MODIFY ENTITIES OF zmcdap_r_comp_excpt
    ENTITY zmcdap_r_comp_excpt
    CREATE
    FIELDS ( issueno exptstat )
    WITH lt_create_expt
    ENTITY zmcdap_r_comp_excpt
    UPDATE
    FIELDS ( exptstat )
    WITH lt_update_expt.
  ENDMETHOD.

  METHOD setexcept.
*    DATA(ls_key) = keys[ 1 ].
    DATA: lt_update_expt TYPE TABLE FOR UPDATE zmcdap_r_comp_excpt,
          lt_create_expt TYPE TABLE FOR CREATE zmcdap_r_comp_excpt.
    DATA: ls_create_expt LIKE LINE OF lt_create_expt,
          ls_update_expt LIKE LINE OF lt_update_expt.
    DATA: lv_id TYPE sysuuid_x16.
    LOOP AT keys INTO DATA(ls_key).
      CLEAR lv_id.
      SELECT SINGLE id FROM zmcdap_i_comp_excpt
      WHERE issueno = @ls_key-issueno
      INTO @lv_id.

      IF lv_id IS INITIAL.
        ls_create_expt-%cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
        ls_create_expt-issueno = ls_key-issueno.
        ls_create_expt-exptstat = 'Y'.
        APPEND ls_create_expt TO lt_create_expt.
      ELSE.
        ls_update_expt-id = lv_id.
        ls_update_expt-exptstat = 'Y'.
        APPEND ls_update_expt TO lt_update_expt.
      ENDIF.
    ENDLOOP.


    MODIFY ENTITIES OF zmcdap_r_comp_excpt
    ENTITY zmcdap_r_comp_excpt
    CREATE
    FIELDS ( issueno exptstat )
    WITH lt_create_expt
    ENTITY zmcdap_r_comp_excpt
    UPDATE
    FIELDS ( exptstat )
    WITH lt_update_expt.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmcdap_r_comp_invoice DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmcdap_r_comp_invoice IMPLEMENTATION.

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
