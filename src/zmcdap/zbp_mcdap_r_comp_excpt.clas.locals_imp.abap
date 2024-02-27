CLASS lhc_zmcdap_r_comp_excpt DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmcdap_r_comp_excpt RESULT result.
    METHODS cancelexcept FOR MODIFY
      IMPORTING keys FOR ACTION zmcdap_r_comp_excpt~cancelexcept RESULT result.

    METHODS setexcept FOR MODIFY
      IMPORTING keys FOR ACTION zmcdap_r_comp_excpt~setexcept RESULT result.

ENDCLASS.

CLASS lhc_zmcdap_r_comp_excpt IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD cancelexcept.
    LOOP AT keys INTO DATA(ls_key).
        loop at ls_key-%param-_selecteditems into data(ls_item).

        ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD setexcept.
  ENDMETHOD.

ENDCLASS.
