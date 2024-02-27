CLASS zcl_mcdgl_ve_swjournalurl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

*    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDGL_VE_SWJOURNALURL IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_processdata TYPE TABLE OF ZMCDGL_C_SWEEP_DETAIL WITH DEFAULT KEY.

    lt_processdata = CORRESPONDING #( it_original_data ).

    LOOP AT lt_processdata ASSIGNING FIELD-SYMBOL(<fs_processdata>).
      CONCATENATE '/ui?sap-client=100#AccountingDocument-manageV2&/C_ManageJournalEntryTP'
                  `(CompanyCode='1000',FiscalYear='`
                  <fs_processdata>-postingdate+0(4)
                  `',AccountingDocument='`
                  <fs_processdata>-journalentry
                  `')/?FCLLayout=MidColumnFullScreen`
        INTO <fs_processdata>-JournalUrl.
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( lt_processdata ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
