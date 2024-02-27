@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 비용 유형 별 대량 전표 처리'
define root view entity ZMCDAR_R_RATE_BO
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
      LastChangedBy
}
