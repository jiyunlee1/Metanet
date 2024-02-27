@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] Bank Statement Auto - Posting _ Distinct Check'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDGL_I_DISTINCT_CHECK
  as select from ZMCDGL_I_POST_DETAIL
{
      HeaderID,
      count( distinct _JEItem.IsReversed ) as DistCount
}
where
  JournalEntry is not initial
group by
  HeaderID,
  _JEItem.IsReversed
