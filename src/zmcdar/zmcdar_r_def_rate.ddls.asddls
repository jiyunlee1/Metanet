@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 비율 정의'
define root view entity zmcdar_r_def_rate
  as select from zmcdar_i_def_rate

{
  key ID,

      Company,

      ProfitCenter,

      CostType,

      RoleType,

      Rate,

      ValidFrDate,

      ShutDownDate,

      CostCenter,

      BusinessPartner,

      CreatedBy,

      CreatedAt,

      LocalLastChangedBy,

      LocalLastChangedAt,

      LastChangedAt,

      LastChangedBy,
      
      _ProfitCenterVH
}
