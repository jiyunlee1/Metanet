CLASS lhc_zmcdar_r_dtl_acct_m DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmcdar_r_dtl_acct_m RESULT result.

ENDCLASS.

CLASS lhc_zmcdar_r_dtl_acct_m IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
