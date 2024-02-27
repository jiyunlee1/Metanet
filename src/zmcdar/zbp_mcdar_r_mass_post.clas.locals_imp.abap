CLASS lhc_zmcdar_r_mass_post DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmcdar_r_mass_post RESULT result.

ENDCLASS.

CLASS lhc_zmcdar_r_mass_post IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
