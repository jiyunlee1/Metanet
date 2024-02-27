@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 비용 유형 관리'
define root view entity ZMCDAR_R_COST_TYPE 
  as select from ZMCDAR_I_COST_TYPE
{
  key ID,

      Company,

      CostType,

      CostTypeNM,

      CreatedBy,

      CreatedAt,

      LocalLastChangedBy,

      LocalLastChangedAt,

      LastChangedAt,

      LastChangedBy
}
