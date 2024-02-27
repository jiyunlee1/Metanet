@EndUserText.label: '[GL]Sweeping Account 정의 - Excel Return'
define abstract entity ZMCDGL_A_EXCEL_RETURN_01
{
  ErrMsg       : abap.string;
  Bank         : abap.string;
  Account      : abap.string;
  GLAccount    : abap.string;
  ProfitCenter : abap.string;
  Description  : abap.string;
}
