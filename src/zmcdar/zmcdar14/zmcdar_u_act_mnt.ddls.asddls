@EndUserText.label: '[AR] Export Smartstore PL -Act Mntly'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MCDAR_CUST_ACT_MNT'
@UI.presentationVariant: [
  {
    maxItems: 5010
  }
]
define custom entity ZMCDAR_U_ACT_MNT
{
  key FiscalYear    : abap.numc(4);
  key FiscalPeriod  : abap.numc(3);
  key StoreCode     : abap.char(4);
  key SmartStore    : abap.numc(3);
  key SubSite       : abap.char(1);
  key GLAccount     : abap.char(10);
      SourceLedger  : abap.char(2);
      CompanyCode   : abap.char(4);
      Ledger        : abap.char(2);
      ProfitCenter  : abap.char(10);
      Currency      : abap.cuky(5);
      GLAccountName : abap.char(4);
      @Semantics.amount.currencyCode: 'Currency'
      MntlyAmt      : abap.curr(28,2);
      Cnt           : abap.int8;
      IsComb        : abap_boolean;
      Formula       : abap.char(256);
      ErrMsg        : abap.char(1300);
}
