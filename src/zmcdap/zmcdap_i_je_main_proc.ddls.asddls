@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier ETax Invoice Comparison List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAP_I_JE_MAIN_PROC
  as select from ZMCDAP_I_JE_ITEM
  association to ZMCDAP_I_INVOICE as _Invoice on $projection.IssueNo = _Invoice.IssueNo
{
  AccountingDocument         as MainDoc,
  JrnlEntryCntrySpecificRef1 as IssueNo,

  case
    when _Invoice.SupBizNo is null
      then 'X'
    else
        case
          when JESupBizNo <> _Invoice.SupBizNo
            then ''
          else 'X'
        end
  end                        as SupBizNo
}
where IsReversed is initial
  and IsReversal is initial
