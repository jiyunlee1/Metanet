@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier ETax Invoice Comparison List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAP_I_INVOICE_SOURCE
  as select from ZMCDAP_I_INVOICE
  association [0..*] to ZMCDAP_I_JE_SOURCE    as _JESource on $projection.IssueNo = _JESource.IssueNo
  association [1]    to ZMCDAP_I_JE_MAIN_ITEM as _MainItem on $projection.IssueNo = _MainItem.IssueNo

{
  key ID,

      BizPlace,

      @EndUserText.label: 'Business Place'
      BusinessPlaceName,

      SupBizSubNo,

      SupCorpNm,

      SupBizNo,

      IssueNo,


      MakeDt,

      ByrBizNo,

      ClientKey,

      EntKey,

      BillType,

      IssueDt,

      SendDt,

      SupRepNm,

      SupAddress,

      ByrBizSubNo,

      ByrCorpNm,

      ByrRepNm,

      ByrAddress,

      @Semantics.amount.currencyCode: 'Currency'
      TotAmt,

      @Semantics.amount.currencyCode: 'Currency'
      SupAmt,

      @Semantics.amount.currencyCode: 'Currency'
      TaxAmt,

      TaxClsf,

      TaxKnd,

      IsnType,

      Bigo,

      DemandGb,

      SupEmail,

      ByrEmail1,

      ByrEmail2,

      ItemDt,

      ItemNm,

      ItemStd,

      ItemQty,

      @Semantics.amount.currencyCode: 'Currency'
      ItemUnt,

      @Semantics.amount.currencyCode: 'Currency'
      ItemSupAmt,

      @Semantics.amount.currencyCode: 'Currency'
      ItemTaxAmt,

      ItemBigo,

      Currency,

      ItemState,

      CreatedBy,

      CreatedAt,

      LocalLastChangedBy,

      LocalLastChangedAt,

      LastChangedAt,

      LastChangedBy,

      BillTypeText,

      ItemStateText,

      CstnBizNO,

      CstnCorpNm,

      _MainItem.MainDoc,
      _MainItem,

      _JESource.AccountingDocument,
      _JESource
}
