@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier ETax Invoice Comparison List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAP_I_INVOICE_MAPPING as select from ZMCDAP_I_INVOICE
association [0..*] to ZMCDAP_I_JE_ITEM as _JEItem on $projection.IssueNo = _JEItem.JrnlEntryCntrySpecificRef1
{
    _JEItem.AccountingDocument,
    IssueNo
}
