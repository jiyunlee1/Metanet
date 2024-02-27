@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier ETax Invoice Comparison List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAP_I_JE_ITEM_SUB as select from ZMCDAP_I_JE_ITEM
  association to ZMCDAP_I_INVOICE as _INVOICE on $projection.IssueNo = _INVOICE.IssueNo
{
  min(AccountingDocument)    as SubDoc,
  JrnlEntryCntrySpecificRef1 as IssueNo,
  IsReversed,
  IsReversal
}
group by
  JrnlEntryCntrySpecificRef1,
  IsReversed,
  IsReversal
