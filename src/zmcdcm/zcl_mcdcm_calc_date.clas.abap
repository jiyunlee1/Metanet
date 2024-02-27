CLASS zcl_mcdcm_calc_date DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF it_period,
             frst_date TYPE dats,
             last_date TYPE dats,
           END OF it_period.
    CLASS-METHODS:
      get_start_end_date IMPORTING VALUE(iv_date)   TYPE dats
                         RETURNING VALUE(is_period) TYPE it_period,
      period_of_month IMPORTING VALUE(iv_yyyymmm) TYPE zmcdde_fiscal_ym_type
                      RETURNING VALUE(is_period)  TYPE it_period.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDCM_CALC_DATE IMPLEMENTATION.


  METHOD get_start_end_date.
    CONCATENATE iv_date(4) iv_date+4(2) '01' INTO is_period-frst_date.
    DATA:
      BEGIN OF date,
        j(4),
        m(2),
        t(2),
      END OF date,
      lv_year  TYPE n LENGTH 4,
      lv_month TYPE n LENGTH 2.
    date = is_period-frst_date.

    IF date-m EQ '12'.
      lv_year = date-j + 1.
      date-j = lv_year.
      date-m = '01'.
    ELSE.
      lv_month = date-m + 1.
      date-m = lv_month.
    ENDIF.
    is_period-last_date = date.
    is_period-last_date -= 1.
  ENDMETHOD.


  METHOD period_of_month.
    CONCATENATE iv_yyyymmm(4) iv_yyyymmm+5(2) '01' INTO is_period-frst_date.
    DATA:
      BEGIN OF date,
        j(4),
        m(2),
        t(2),
      END OF date,
      lv_year  TYPE n LENGTH 4,
      lv_month TYPE n LENGTH 2.
    date = is_period-frst_date.

    IF date-m EQ '12'.
      lv_year = date-j + 1.
      date-j = lv_year.
      date-m = '01'.
    ELSE.
      lv_month = date-m + 1.
      date-m = lv_month.
    ENDIF.
    is_period-last_date = date.
    is_period-last_date -= 1.
  ENDMETHOD.
ENDCLASS.
