@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Export Smartstore PL -Act Mntly'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_ACT_MNT_SRC
  as select distinct from ZMCDAR_I_ACT_MNT
  association [1] to ZMCDAR_I_DEF_SMST as _DefSmst on $projection.SmartStore = _DefSmst.SmartStore
{
  key FiscalYear,
  key FiscalPeriod,
  key StoreCode,
  key SubSite,
  key SmartStore,
      SourceLedger,
      CompanyCode,
      Ledger,
      ProfitCenter,
      Currency,
      @Semantics.amount.currencyCode: 'Currency'
      MntlyAmt,
      cast(1 as abap.int8) as CNT,
      _DefSmst.IsComb,
      _DefSmst.Formula
}
