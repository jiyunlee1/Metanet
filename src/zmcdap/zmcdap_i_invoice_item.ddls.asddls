@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier Tax Invoice'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAP_I_INVOICE_ITEM
  as select from zmcdtap0020
{
  key id                    as ID,
      
      header_id             as HeaderID,
      
      @EndUserText.label: 'Business Place'
      biz_place             as BizPlace,
      
      @EndUserText.label: 'Approval Number'
      issue_no              as IssueNo,
      
      @EndUserText.label: 'Client Key'
      client_key            as ClientKey,
      
      @EndUserText.label: 'Enter Key'
      ent_key               as EntKey,
      
      @EndUserText.label: 'Item No'
      item_no               as ItemNo,
      
      @EndUserText.label: 'Supplier Business No'
      sup_biz_no            as SupBizNo,
      
      @EndUserText.label: 'Buyer Business No'
      byr_biz_no            as ByrBizNo,
      
      @EndUserText.label: 'Item Date'
      item_dt               as ItemDt,
      
      @EndUserText.label: 'Item Name'
      item_nm               as ItemNm,
      
      @EndUserText.label: 'Item Standard'
      item_std              as ItemStd,
      
      @EndUserText.label: 'Item Quantity'
      item_qty              as ItemQty,
      
      @Semantics.amount.currencyCode: 'Currency'
      @EndUserText.label: 'Item Unit'
      item_unt              as ItemUnt,
      
      @Semantics.amount.currencyCode: 'Currency'
      @EndUserText.label: 'Item Net Amount'
      item_sup_amt          as ItemSupAmt,
      
      @Semantics.amount.currencyCode: 'Currency'
      @EndUserText.label: 'Item Tax Amount'
      item_tax_amt          as ItemTaxAmt,
      
      @EndUserText.label: 'Item Note'
      item_bigo             as ItemBigo,
      
      @EndUserText.label: 'Currency Key'
      currency              as Currency,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy
}
