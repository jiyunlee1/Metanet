@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Export Smartstore PL -Act Mntly CNT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_ACT_MNT_CNT as select from ZMCDAR_I_ACT_MNT_SRC
{
  key FiscalYear,
  key FiscalPeriod,
      sum(CNT) as CNT
}
group by
  FiscalYear,
  FiscalPeriod
