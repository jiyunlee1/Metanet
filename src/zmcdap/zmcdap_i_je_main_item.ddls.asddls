@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier ETax Invoice Comparison List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAP_I_JE_MAIN_ITEM
  as select distinct from ZMCDAP_I_INVOICE_MAPPING
  association [0..1] to ZMCDAP_I_JE_ITEM_MAIN as _MainJE on  $projection.IssueNo = _MainJE.IssueNo
  association [0..1] to ZMCDAP_I_JE_ITEM_SUB  as _SubJE  on  $projection.IssueNo =  _SubJE.IssueNo
                                                         and _SubJE.IsReversed   <> 'X'
                                                         and _SubJE.IsReversal   <> 'X'
{
  IssueNo,
  
  _MainJE.MainDoc
//  case
//    when _MainJE.MainDoc is not null and _MainJE.MainDoc is not initial
//      then _MainJE.MainDoc
//    else
//      case
//        when _SubJE.SubDoc is not null and _SubJE.SubDoc is not initial
//          then _SubJE.SubDoc
//        else ''
//      end
//  end as MainDoc
  
  
}
where
  IssueNo is not null
