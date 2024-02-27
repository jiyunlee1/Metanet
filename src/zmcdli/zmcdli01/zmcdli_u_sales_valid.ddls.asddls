@EndUserText.label: '[LI] 매출 유형 별 매출액'
define root custom entity ZMCDLI_U_SALES_VALID
{
  key excelkey     : abap.char(256);
      Company      : abap.char(4);
      FiscalYear   : abap.char(6);
      PlatformType : abap.char(2);
      SalesAmount  : abap.char(30);
      Currency     : abap.cuky;
}
