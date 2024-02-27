@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 매출액 합산 계정 관리'
define root view entity ZMCDAR_R_SALES_ACCT
  as select from ZMCDAR_I_SALES_ACCT
{
      key ID,

      Company,

      CostType,

      CostcenterType,

      Account,

      AccountNM,

      CreatedBy,

      CreatedAt,

      LocalLastChangedBy,

      LocalLastChangedAt,

      LastChangedAt,

      LastChangedBy
}
