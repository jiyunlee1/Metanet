@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Export Smartstore PL -ACT DTL ACCT COUNT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_DTL_ACCT_CNT
  as select from ZMCDAR_I_JE_ITEM
{
  key FiscalYear,
      FiscalPeriod,
      sum(Cnt) as Cnt
}
where 
  Lineuse = 'Y' 
  and IsReversal <> 'X'
  and IsReversed <> 'X'
group by 
  FiscalYear,
  FiscalPeriod
