@EndUserText.label: '[LI] 매출 유형 별 매출액'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZMCDLI_I_SALES_AMOUNT
  as select from zmcdtli0010
  association [0..*] to ZMCDLI_V_PLATFORM_TYPE as _PlatformType on $projection.PlatformType = _PlatformType.LowValue

{

      @EndUserText.label: 'ID'
  key id                           as Id,

      @EndUserText.label: '회사코드'
      company                      as Company,

      @EndUserText.label: '결산연월'
      fiscal_year                  as FiscalYear,

      @EndUserText.label: '매출유형'
      platform_type                as PlatformType,

      @EndUserText.label: '매출액'
      @Semantics.amount.currencyCode: 'Currency'
      sales_amount                 as SalesAmount,

      @EndUserText.label: '통화'
      currency                     as Currency,

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

      _PlatformType

}
