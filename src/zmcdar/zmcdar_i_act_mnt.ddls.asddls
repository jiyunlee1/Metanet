@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Export Smartstore PL - Act Mntly'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_ACT_MNT 
  as select from ZMCDAR_I_ACT_DTL
{ 
  key FiscalYear,
  key FiscalPeriod,
  key StoreCode,
  key SubSite,
  key SmartStore,
      SourceLedger,
      CompanyCode,
      Ledger,
      //    CostCenterType,
      ProfitCenter,
      Currency,
      @Semantics.amount.currencyCode: 'Currency'
      sum(AcctAmt) as MntlyAmt
}
group by
  FiscalYear,
  FiscalPeriod,
  StoreCode,
  SubSite,
  SmartStore,
  CompanyCode,
  SourceLedger,
  Ledger,
  ProfitCenter,
  Currency

