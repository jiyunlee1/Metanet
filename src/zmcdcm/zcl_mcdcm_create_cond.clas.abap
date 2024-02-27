CLASS zcl_mcdcm_create_cond DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: tv_tabname         TYPE c LENGTH 30,
           ts_name_range_pair TYPE  if_rap_query_filter=>ty_name_range_pairs,
           ts_range           TYPE LINE OF ts_name_range_pair-range,
           tv_condition       TYPE c LENGTH 72,
           tt_conditions      TYPE TABLE OF zmcdscm0020 WITH DEFAULT KEY.
    CONSTANTS: char_minus TYPE c VALUE '-'.
    CLASS-METHODS:
      create_where_condition IMPORTING VALUE(iv_tabname)         TYPE tv_tabname
                                       VALUE(is_name_range_pair) TYPE ts_name_range_pair
                             RETURNING VALUE(et_conditions)      TYPE tt_conditions,
      string_double_character IMPORTING VALUE(iv_string) TYPE ts_range-low
                                        VALUE(iv_option) TYPE ts_range-option
                              EXPORTING VALUE(ev_string) TYPE ts_range-low.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDCM_CREATE_COND IMPLEMENTATION.


  METHOD create_where_condition.
    DATA(lv_fieldname) = is_name_range_pair-name.
    DATA(lr_range) = is_name_range_pair-range.

    DATA: lv_tabname(31)  VALUE IS INITIAL,
          lv_tabfield(61) VALUE IS INITIAL,
          lv_prefix(15),
          lv_option(10),
          lv_sel_line(72) TYPE c,
          lv_lines        LIKE sy-tabix.

    SORT lr_range BY sign option low high.
    DELETE ADJACENT DUPLICATES FROM lr_range.

    IF NOT iv_tabname IS INITIAL.
      CONCATENATE iv_tabname char_minus INTO lv_tabname.
    ENDIF.

    CLEAR et_conditions.

    SORT lr_range BY sign DESCENDING option.

    lv_lines = lines( lr_range ).
    CHECK lv_lines > 0.

    LOOP AT lr_range INTO DATA(ls_range).
      CLEAR lv_sel_line.
      string_double_character(
        EXPORTING
          iv_string = ls_range-low
          iv_option = ls_range-option
        IMPORTING
          ev_string = ls_range-low
      ).

      IF NOT ls_range-high IS INITIAL.
        string_double_character(
          EXPORTING
            iv_string = ls_range-high
            iv_option = ls_range-option
          IMPORTING
            ev_string = ls_range-high
        ).
      ENDIF.

      IF NOT lv_tabname IS INITIAL.
        CLEAR lv_tabfield.
        CONCATENATE lv_tabname lv_fieldname INTO lv_tabfield.
      ELSE.
        lv_tabfield = lv_fieldname.
      ENDIF.

      IF sy-tabix > 1.
        IF ( ls_range-sign = 'E' AND ls_range-option(1) NE 'N' ) OR ( ls_range-sign = 'I' AND ls_range-option(1) EQ 'N' ).
          lv_prefix = ' ) AND ( '.
        ELSE.
          lv_prefix = 'OR'.
        ENDIF.
      ELSE.
        lv_prefix = '('.
      ENDIF.
      IF ls_range-sign = 'E'.
        CONCATENATE lv_prefix 'NOT' INTO lv_prefix SEPARATED BY space.
      ENDIF.
      CASE ls_range-option.
        WHEN 'EQ' OR 'NE' OR 'LT' OR 'LE' OR 'GT' OR 'GE'.
          CASE ls_range-option.
            WHEN 'EQ'.
              lv_option = ' = '''.
            WHEN 'NE'.
              lv_option = ' <> '''.
            WHEN 'LT'.
              lv_option = ' < '''.
            WHEN 'LE'.
              lv_option = ' <= '''.
            WHEN 'GT'.
              lv_option = ' > '''.
            WHEN 'GE'.
              lv_option = ' >= '''.
            WHEN OTHERS.
              CLEAR lv_option.
          ENDCASE.
          CONCATENATE lv_prefix
                      lv_tabfield
                      INTO lv_sel_line SEPARATED BY space.
          CONCATENATE lv_sel_line
                      lv_option
                      ls_range-low ''''
                      INTO lv_sel_line.

        WHEN 'BT' OR 'NB'.
          IF ls_range-option = 'NB'.
            CONCATENATE lv_prefix
                        ' NOT'
                        INTO lv_prefix.
          ENDIF.
          CONCATENATE lv_prefix
                      lv_tabfield
                      INTO lv_sel_line SEPARATED BY space.
          CONCATENATE lv_sel_line
                      ' BETWEEN '''
                      ls_range-low '''' INTO lv_sel_line.
          APPEND lv_sel_line TO et_conditions.
          CLEAR lv_sel_line.
          CONCATENATE ' AND '''
                      ls_range-high ''''
                      INTO lv_sel_line.

        WHEN 'CP' OR 'NP'.
          IF ls_range-option = 'NP'.
            CONCATENATE lv_prefix
                        ' NOT'
                        INTO lv_prefix.
          ENDIF.
          CONCATENATE lv_prefix
                      lv_tabfield
                      INTO lv_sel_line SEPARATED BY space.
          IF iv_tabname IS INITIAL.
*          AND i_where_for_loop IS INITIAL.
            CONCATENATE lv_sel_line
                        ' LIKE '''
                        ls_range-low '''' ' ESCAPE ''#'' '
                        INTO lv_sel_line.
          ELSE.
            CONCATENATE lv_sel_line
                        ' CP '''
                        ls_range-low ''''
                        INTO lv_sel_line.
          ENDIF.
          IF iv_tabname IS INITIAL.
*          AND i_where_for_loop IS INITIAL.
* '*' durch '%' und '+' durch '_' ersetzen bei generischer Suche
            TRANSLATE lv_sel_line USING '*%+_'.
          ENDIF.
      ENDCASE.

      append lv_sel_line to et_conditions.
    ENDLOOP.

    append ')' to et_conditions.
  ENDMETHOD.


  METHOD string_double_character.

    DATA(lv_len) = strlen( iv_string ).
    DATA(lv_act_index) = 0.
    DATA: lv_back_counter       LIKE sy-tabix,
          lv_back_counter_plus  LIKE sy-tabix,
          lv_back_counter_plus2.

    DO lv_len TIMES.
      DATA(lv_char) = iv_string+lv_act_index(1).
      IF lv_char = '''' OR ( lv_char = '#' OR lv_char = '%' OR lv_char = '_' ) AND ( iv_option = 'CP' OR iv_option = 'NP' ).
        lv_back_counter = strlen( iv_string ).
        lv_back_counter_plus = lv_back_counter.
        lv_back_counter = lv_back_counter - 1.
        WHILE lv_back_counter > lv_act_index.
          lv_back_counter_plus2 = lv_back_counter_plus + 1.
          CONCATENATE iv_string(lv_back_counter_plus) iv_string+lv_back_counter(1) iv_string+lv_back_counter_plus2 INTO iv_string.
          lv_back_counter_plus = lv_back_counter_plus - 1.
        ENDWHILE.
        lv_back_counter_plus2 = lv_back_counter_plus + 1.
        CONCATENATE iv_string(lv_back_counter_plus) iv_string+lv_back_counter(1) iv_string+lv_back_counter_plus2 INTO iv_string.

        DATA(lv_back_counter2) = lv_back_counter + 1.
        CASE lv_char.
          WHEN ''''.
            CONCATENATE iv_string(lv_back_counter) '''' iv_string+lv_back_counter2 INTO iv_string.
          WHEN '#' OR '%' OR '_'.
            CONCATENATE iv_string(lv_back_counter) '#' iv_string+lv_back_counter2 INTO iv_string.
        ENDCASE.

        lv_act_index = lv_back_counter_plus + 1.
      ELSE.
        lv_act_index = lv_act_index + 1.
      ENDIF.
    ENDDO.

    ev_string = iv_string.
  ENDMETHOD.
ENDCLASS.
