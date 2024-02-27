@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 비용 유형'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_COST_TYPE
  as select from zmcdtar0010
  association [1..1] to I_CompanyCode as _CompanyCode on $projection.Company = _CompanyCode.CompanyCode
{

      @EndUserText.label: 'ID'
  key id                    as ID,

      @EndUserText.label: '회사 코드'
      company               as Company,

      @EndUserText.label: '비용 유형'
      cost_type             as CostType,

      @EndUserText.label: '비용 유형 명'
      type_name             as CostTypeNM,

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

      _CompanyCode
}
