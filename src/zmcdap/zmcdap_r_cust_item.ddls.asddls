@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier Tax Invoice'
define view entity ZMCDAP_R_CUST_ITEM
  as select from ZMCDAP_I_INVOICE_ITEM
  //  association to ZMCDAP_U_INVOICE as _Header on $projection.HeaderID = _Header.ID
  association to parent ZMCDAP_U_INVOICE as _Header on $projection.HeaderID = _Header.ID
{
      @UI.hidden: true
  key ID,

      @UI.hidden: true
      HeaderID,
      @UI.lineItem: [{ position: 10 }]
      ItemDt,

      @UI.lineItem: [{ position: 30 }]
      ItemNm,

      @UI.lineItem: [{ position: 50 }]
      ItemQty,

      @UI.lineItem: [{ position: 70 }]
      ItemStd,

      @UI.lineItem: [{ position: 90 }]
      ItemUnt,

      @UI.lineItem: [{ position: 110 }]
      ItemSupAmt,

      @UI.lineItem: [{ position: 130 }]
      ItemTaxAmt,

      @UI.lineItem: [{ position: 150 }]
      ItemBigo,
      BizPlace,
      IssueNo,
      ClientKey,
      EntKey,
      ItemNo,
      SupBizNo,
      ByrBizNo,
      Currency,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      LastChangedBy,
      _Header // Make association public
}
