@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier Tax Invoice'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAP_I_INVOICE
  as select from zmcdtap0010
  association [1] to ZMCDAP_V_BUSINEES_PLACE as _BizPlace  on  $projection.BizPlace = _BizPlace.Branch
  association [1] to ZMCDAP_V_BILL_TYPE      as _BillType  on  $projection.BillType = _BillType.BillType
                                                           and _BillType.DomainName = 'ZMCDDO_BILL_TP_TYPE'
                                                           and _BillType.Language   = 'E'
  association [1] to ZMCDAP_V_ITEM_STATE     as _ItemState on  $projection.ItemState = _ItemState.ItemState
{
  key id                    as ID,

      @EndUserText.label: 'Business Place'
      biz_place             as BizPlace,

      @EndUserText.label: 'Approval Number'
      issue_no              as IssueNo,

      @EndUserText.label: 'Start Date'
      make_dt               as MakeDt,

      @EndUserText.label: 'Buyer Business No'
      byr_biz_no            as ByrBizNo,

      @EndUserText.label: '고객번호'
      client_key            as ClientKey,

      @EndUserText.label: '인증정보 고유키'
      ent_key               as EntKey,

      @EndUserText.label: 'Tax Classification'
      bill_type             as BillType,

      @EndUserText.label: 'Issue Date'
      issue_dt              as IssueDt,

      @EndUserText.label: 'Send Date'
      send_dt               as SendDt,

      @EndUserText.label: 'Business No'
      sup_biz_no            as SupBizNo,

      @EndUserText.label: 'Business Sub Number'
      sup_biz_sub_no        as SupBizSubNo,

      @EndUserText.label: 'Business Name'
      sup_corp_nm           as SupCorpNm,

      @EndUserText.label: 'CEO'
      sup_rep_nm            as SupRepNm,

      @EndUserText.label: 'Address'
      sup_address           as SupAddress,

      @EndUserText.label: 'Business Sub Number'
      byr_biz_sub_no        as ByrBizSubNo,

      @EndUserText.label: 'Business Name'
      byr_corp_nm           as ByrCorpNm,

      @EndUserText.label: 'CEO'
      byr_rep_nm            as ByrRepNm,

      @EndUserText.label: 'Address'
      byr_address           as ByrAddress,

      @Semantics.amount.currencyCode: 'Currency'
      @EndUserText.label: 'Gross Amount'
      tot_amt               as TotAmt,

      @Semantics.amount.currencyCode: 'Currency'
      @EndUserText.label: 'Net Amount'
      sup_amt               as SupAmt,

      @Semantics.amount.currencyCode: 'Currency'
      @EndUserText.label: 'Tax Amount'
      tax_amt               as TaxAmt,

      @EndUserText.label: 'Issue Classification'
      tax_clsf              as TaxClsf,

      @EndUserText.label: 'Issue Type1'
      tax_knd               as TaxKnd,

      @EndUserText.label: 'Issue Type2'
      isn_type              as IsnType,

      @EndUserText.label: 'Bigo'
      bigo                  as Bigo,

      @EndUserText.label: 'Demand Type'
      demand_gb             as DemandGb,

      @EndUserText.label: 'Email'
      sup_email             as SupEmail,

      @EndUserText.label: 'Email1'
      byr_email1            as ByrEmail1,

      @EndUserText.label: 'Email2'
      byr_email2            as ByrEmail2,

      @EndUserText.label: 'Item Date'
      item_dt               as ItemDt,

      @EndUserText.label: 'Item Name'
      item_nm               as ItemNm,

      @EndUserText.label: 'Item Standard'
      item_std              as ItemStd,

      @EndUserText.label: 'Item Quantity'
      item_qty              as ItemQty,

      @Semantics.amount.currencyCode: 'Currency'
      @EndUserText.label: 'Item Unit Price'
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
      
      @EndUserText.label: 'Consignee Business No'
      cstn_biz_no           as CstnBizNO,
      
      @EndUserText.label: 'Consignee Business Name'
      cstn_corp_nm          as CstnCorpNm,

      @EndUserText.label: 'Item State'
      item_state            as ItemState,

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
      last_changed_by       as LastChangedBy,

      _BizPlace.BusinessPlaceName,

      _BillType.BillTypeText,

      _ItemState.ItemStateText
}
