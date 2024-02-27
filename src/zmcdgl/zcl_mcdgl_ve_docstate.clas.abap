CLASS zcl_mcdgl_ve_docstate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDGL_VE_DOCSTATE IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_processdata TYPE TABLE OF zmcdgl_c_auto_post WITH DEFAULT KEY.

    lt_processdata = CORRESPONDING #( it_original_data ).

    LOOP AT lt_processdata ASSIGNING FIELD-SYMBOL(<fs_processdata>).
      SELECT COUNT( DISTINCT isreversed ) FROM zmcdgl_i_reverse_check
      WHERE headerid = @<fs_processdata>-id
      INTO @DATA(lv_count).

      IF <fs_processdata>-state EQ '0'.
        IF lv_count EQ 1.
          SELECT SINGLE isreversed FROM zmcdgl_i_reverse_check
          WHERE headerid = @<fs_processdata>-id
          INTO @DATA(lv_isreversed).
          IF lv_isreversed IS INITIAL.
            <fs_processdata>-docstate = '0'.
            <fs_processdata>-docstatetext = <fs_processdata>-docstatetext.
          ELSE.
            <fs_processdata>-docstate = '5'.
            <fs_processdata>-docstatetext = 'Reversed'.
          ENDIF.
        ELSE.
          <fs_processdata>-docstate = '2'.
          <fs_processdata>-docstatetext = 'Reversal in progress'.
        ENDIF.
*      ELSE.
*        <fs_processdata>-docstate = <fs_processdata>-state.
*        <fs_processdata>-docstatetext = <fs_processdata>-statetext.
      ENDIF.
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( lt_processdata ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
