@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 비율 정의'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zmcdar_i_def_rate
  as select from zmcdtar0040

  association [1..1] to I_CompanyCode          as _CompanyCode    on  $projection.Company = _CompanyCode.CompanyCode
  association [1..*] to I_ProfitCenter         as _ProfitCenter   on  $projection.ProfitCenter = _ProfitCenter.ProfitCenter
  association [1]    to ZMCDAR_V_PROFIT_CENTER as _ProfitCenterVH on  $projection.ProfitCenter = _ProfitCenterVH.ProfitCenter
  association [1..1] to ZMCDAR_I_COST_TYPE     as _CostType       on  $projection.CostType = _CostType.CostType
  association [1..1] to ZMCDAR_V_ROLE_TYPE     as _RoleType       on  $projection.RoleType = _RoleType.ValueText
                                                                  and _RoleType.Language   = $session.system_language
  association [1..*] to I_CostCenter           as _Costcenter     on  $projection.CostCenter = _Costcenter.CostCenter
  association [1..1] to I_Customer             as _Customer       on  $projection.BusinessPartner = _Customer.Customer
{

      @EndUserText.label: 'ID'
  key id                    as ID,

      @EndUserText.label: '회사 코드'
      company               as Company,

      @EndUserText.label: 'Profit Center'
      profit_center         as ProfitCenter,

      //  @EndUserText.label: 'Profit Center Name'
      //  profitcenterN

      @EndUserText.label: '비용 유형'
      cost_type             as CostType,

      @EndUserText.label: 'Role 유형'
      role_type             as RoleType,

      @EndUserText.label: '비율'
      rate                  as Rate,

      @EndUserText.label: '시작 일자'
      valid_fr_date         as ValidFrDate,

      @EndUserText.label: '폐업 일자'
      shut_down_date        as ShutDownDate,

      @EndUserText.label: 'Cost Center'
      cost_center           as CostCenter,

      @EndUserText.label: '비즈니스 파트너'
      business_partner      as BusinessPartner,

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

      _CompanyCode,
      _ProfitCenter,
      _CostType,
      _RoleType,
      _Costcenter,
      _Customer,
      _ProfitCenterVH

}
