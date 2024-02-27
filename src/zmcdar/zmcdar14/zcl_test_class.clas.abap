CLASS zcl_test_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TEST_CLASS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    TYPES: BEGIN OF ts_formula,
             symbol     TYPE c LENGTH 1,
             smartstore TYPE c LENGTH 3,
           END OF ts_formula,
           tv_formula TYPE c LENGTH 256.
    DATA : lv_formula TYPE tv_formula,
           lt_formula TYPE TABLE OF ts_formula.

    lv_formula = '50+10+10+20+30'.

    zcl_mcdar_calc_comb_smst=>comp_formula(
      EXPORTING
        iv_formula = lv_formula
      RECEIVING
        it_formula = lt_formula
    ).
  ENDMETHOD.
ENDCLASS.
