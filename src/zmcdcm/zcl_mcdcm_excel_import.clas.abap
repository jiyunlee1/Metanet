CLASS zcl_mcdcm_excel_import DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: tv_col TYPE c LENGTH 1,
           tv_row TYPE int2.
    CLASS-METHODS:
      base64_to_itab IMPORTING iv_excel_file     TYPE string
                               iv_fr_col         TYPE tv_col
                               iv_to_col         TYPE tv_col
                               iv_fr_row         TYPE tv_row
                     CHANGING  it_internal_table TYPE REF TO data.
  protected SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDCM_EXCEL_IMPORT IMPLEMENTATION.


  METHOD base64_to_itab.

    DATA(lv_original_xstring) = xco_cp=>string( iv_excel_file
        )->as_xstring( xco_cp_binary=>text_encoding->base64
        )->value.
    DATA(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_original_xstring )->read_access( ).
    DATA(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->for_name( iv_name = 'Sheet for Import' ).

    DATA lo_visitor TYPE REF TO if_xco_xlsx_ra_cs_visitor.

    DATA(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
      )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( iv_fr_col )
      )->to_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( iv_to_col )
      )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( CONV i( iv_fr_row ) ) )->get_pattern( ).

    ASSIGN it_internal_table->* TO FIELD-SYMBOL(<ft_itab>).

    lo_worksheet->select( lo_selection_pattern
    )->row_stream(
    )->operation->write_to( it_internal_table
    )->if_xco_xlsx_ra_operation~execute( ).
*    ASSIGN et_internal_table->* TO FIELD-SYMBOL(<ft_return>).

*    <ft_return> = <ft_itab>.

  ENDMETHOD.
ENDCLASS.
