@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] Bank Statement Auto - Posting _ Reverse Check'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDGL_i_REVERSE_CHECK as select from ZMCDGL_I_POST_DETAIL
{
    HeaderID,
    _JEItem.IsReversed
}
where JournalEntry is not initial
group by HeaderID, _JEItem.IsReversed
