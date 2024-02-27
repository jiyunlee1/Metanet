CLASS lhc_zmcdar_r_cbo_handle DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmcdar_r_cbo_handle RESULT result.

ENDCLASS.

CLASS lhc_zmcdar_r_cbo_handle IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
