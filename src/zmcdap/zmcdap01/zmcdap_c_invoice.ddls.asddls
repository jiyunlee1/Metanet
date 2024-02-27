@EndUserText.label: '[AP] Supplier Tax Invoice'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZMCDAP_C_INVOICE
  provider contract transactional_query
  as projection on ZMCDAP_R_INVOICE
{
  key ID,

      BizPlace,

      IssueNo,
      @Consumption.filter.selectionType: #INTERVAL
      MakeDt,

      ByrBizNo,

      ClientKey,

      EntKey,

      BillType,

      @Consumption.filter.selectionType: #INTERVAL
      IssueDt,

      @Consumption.filter.selectionType: #INTERVAL
      SendDt,

      SupBizNo,

      SupBizSubNo,

      SupCorpNm,

      SupRepNm,

      SupAddress,

      ByrBizSubNo,

      ByrCorpNm,

      ByrRepNm,

      ByrAddress,

      TotAmt,

      SupAmt,

      TaxAmt,

      TaxClsf,

      TaxKnd,

      IsnType,

      Bigo,

      DemandGb,

      SupEmail,

      ByrEmail1,

      ByrEmail2,

      @Consumption.filter.selectionType: #INTERVAL
      ItemDt,

      ItemNm,

      ItemStd,

      ItemQty,

      ItemUnt,

      ItemSupAmt,

      ItemTaxAmt,

      ItemBigo,

      Currency,
      
      @Consumption.filter.hidden: true
      CstnBizNO,
      
      @Consumption.filter.hidden: true
      CstnCorpNm,

      ItemState,

      @Semantics.user.createdBy: true
      CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,

      @Semantics.user.lastChangedBy: true
      LastChangedBy,

      /* Associations */
      _Items : redirected to composition child ZMCDAP_C_INVOICE_ITEM
}
