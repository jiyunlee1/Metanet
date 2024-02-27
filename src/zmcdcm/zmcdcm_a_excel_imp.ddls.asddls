@EndUserText.label: '[CM] Parameter for Excel Import'
define abstract entity ZMCDCM_A_EXCEL_IMP
{
  excel_file   : abap.string;
  fr_col       : abap.char(1);
  to_col       : abap.char(1);
  fr_row       : abap.int2;
}
