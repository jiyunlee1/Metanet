@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Export Smartstore PL -Act Dtl CNT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_ACT_DTL_CNT as select from ZMCDAR_I_ACT_DTL_SRC
{
  key FiscalYear,
  key FiscalPeriod,
      sum(CNT) as CNT
}
group by
  FiscalYear,
  FiscalPeriod
