@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier ETax Invoice Comparison List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAP_I_JE_ITEM_MAIN
as select from ZMCDAP_I_JE_MAIN_PROC
{
    min(MainDoc) as MainDoc,
    IssueNo
}
where SupBizNo = 'X'
group by IssueNo
