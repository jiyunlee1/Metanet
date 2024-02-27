@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier Tax Invoice'
define view entity ZMCDAP_R_INVOICE_ITEM
  as select from ZMCDAP_I_INVOICE_ITEM
  association to parent ZMCDAP_R_INVOICE as _Header on $projection.HeaderID = _Header.ID
{
  key ID,
      HeaderID,
      BizPlace,
      IssueNo,
      ClientKey,
      EntKey,
      ItemNo,
      SupBizNo,
      ByrBizNo,
      ItemDt,
      ItemNm,
      ItemStd,
      ItemQty,
      ItemUnt,
      ItemSupAmt,
      ItemTaxAmt,
      ItemBigo,
      Currency,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      LastChangedBy,
      _Header // Make association public
}
