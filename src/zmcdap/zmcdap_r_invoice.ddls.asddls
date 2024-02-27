@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier Tax Invoice'
define root view entity ZMCDAP_R_INVOICE
  as select from ZMCDAP_I_INVOICE
  composition [0..*] of ZMCDAP_R_INVOICE_ITEM as _Items
{
  key ID,
      BizPlace,
      IssueNo,
      MakeDt,
      ByrBizNo,
      ClientKey,
      EntKey,
      BillType,
      IssueDt,
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
      ItemDt,
      ItemNm,
      ItemStd,
      ItemQty,
      ItemUnt,
      ItemSupAmt,
      ItemTaxAmt,
      ItemBigo,
      Currency,
      CstnBizNO,
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
      _Items
}
