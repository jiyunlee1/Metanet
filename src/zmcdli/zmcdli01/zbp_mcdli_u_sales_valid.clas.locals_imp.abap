CLASS lhc_salesvalid DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR salesvalid RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ salesvalid RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK salesvalid.

    METHODS valid_check FOR MODIFY
      IMPORTING keys FOR ACTION salesvalid~valid_check RESULT result.

ENDCLASS.

CLASS lhc_salesvalid IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.


  METHOD valid_check.
    TYPES: BEGIN OF ty_current,
             company      TYPE zmcdli_i_sales_amount-company,
             fiscalyear   TYPE zmcdli_i_sales_amount-fiscalyear,
             salesamount  TYPE zmcdli_i_sales_amount-salesamount,
             currency     TYPE zmcdli_i_sales_amount-currency,
             id           TYPE zmcdli_i_sales_amount-id,
             platformtype TYPE zmcdli_i_sales_amount-platformtype,
             mode         TYPE string,
           END OF  ty_current.
    DATA: ls_current TYPE ty_current.

    LOOP AT keys[] INTO DATA(ls_key).
      DATA(lv_json) = ls_key-%param-importparameter.
      CLEAR : ls_current.

      /ui2/cl_json=>deserialize(
        EXPORTING
          json             = lv_json
        CHANGING
          data             = ls_current
      ).
      IF ls_current-company IS INITIAL.
        APPEND  VALUE #( %cid = ls_key-%cid
                         %param-errmsg = |Company is required| ) TO result[].
      ENDIF.
      IF ls_current-fiscalyear IS INITIAL.
        APPEND  VALUE #( %cid = ls_key-%cid
                         %param-errmsg = |Fiscal Year is required| ) TO result[].
      ENDIF.
      IF ls_current-platformtype IS INITIAL.
        APPEND  VALUE #( %cid = ls_key-%cid
                         %param-errmsg = |Sales Type is required| ) TO result[].
      ENDIF.
      IF ls_current-salesamount IS INITIAL.
        APPEND  VALUE #( %cid = ls_key-%cid
                         %param-errmsg = |Sales Amount is required| ) TO result[].
      ENDIF.
      IF ls_current-currency IS INITIAL.
        APPEND  VALUE #( %cid = ls_key-%cid
                         %param-errmsg = |Currency is required| ) TO result[].
      ENDIF.

      IF ls_current-currency <> 'KRW'.
        APPEND  VALUE #( %cid = ls_key-%cid
                         %param-errmsg = |This currency key is not allowed| ) TO result[].
      ENDIF.

      CHECK result IS INITIAL.
      CHECK ls_current-mode = 'Create'.
      IF    ls_current-company IS NOT INITIAL
        AND ls_current-fiscalyear IS NOT INITIAL
        AND ls_current-platformtype IS NOT INITIAL.
        SELECT DISTINCT id
                      , company       AS company
                      , fiscal_year    AS fiscalyear
                      , platform_type  AS platformtype
                      , sales_amount   AS salesamount
                      , currency      AS currency
          FROM zmcdtli0010
         WHERE company    = @ls_current-company
           AND platform_type = @ls_current-platformtype
           AND fiscal_year = @ls_current-fiscalyear
           AND id         <> @ls_current-id
          INTO TABLE @DATA(lt_original).

        IF sy-subrc = 0.
          APPEND  VALUE #( %cid = ls_key-%cid
                           %param-errmsg = |Already Registed Data| ) TO result[].
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmcdli_u_sales_valid DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmcdli_u_sales_valid IMPLEMENTATION.

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
