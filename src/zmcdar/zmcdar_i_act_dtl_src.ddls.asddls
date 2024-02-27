@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Export Smartstore PL -Act Dtl'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_ACT_DTL_SRC
  as select distinct from ZMCDAR_I_ACT_DTL
{
  key FiscalYear,
  key FiscalPeriod,
  key StoreCode,
  key GLAccount,
  key SmartStore,
  key SubSite,
      SourceLedger,
      CompanyCode,
      Ledger,
      ProfitCenter,
      Currency,
      GLAccountName,
      @Semantics.amount.currencyCode: 'Currency'
      AcctAmt,
      cast(1 as abap.int8) as CNT
}
