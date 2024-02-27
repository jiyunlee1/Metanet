@EndUserText.label: '[AP] Supplier Tax Invoice'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZMCDAP_C_CUST_ITEM
  provider contract transactional_query
  as projection on ZMCDAP_R_CUST_ITEM
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
      /* Associations */
      _Header
}
