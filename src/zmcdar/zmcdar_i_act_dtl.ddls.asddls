@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Export Smartstore PL - Act Dtl'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_ACT_DTL
  as select from ZMCDAR_I_PNL_BASE
{
  key FiscalYear,
  key FiscalPeriod,
  key StoreCode,
  key cast(SmartStore as abap.numc(3)) as SmartStore,
  key SubSite,
  key GLAccount,
      SourceLedger,
      CompanyCode,
      Ledger,
      ProfitCenter,
      Currency,
      GLAccountName,
      @Semantics.amount.currencyCode: 'Currency'
      sum(BaseSumAmt) as AcctAmt
}
where SmartStore is not null 
  and SmartStore is not initial
  and SubSite is not null
  and SubSite is not initial
group by
  FiscalYear,
  FiscalPeriod,
  StoreCode,
  SubSite,
  SmartStore,
  GLAccount,
  CompanyCode,
  SourceLedger,
  Ledger,
  ProfitCenter,
  GLAccountName,
  Currency
