@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 합산 계정 Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZMCDAR_V_SALES_ACCT as select from ZMCDAR_I_SALES_ACCT
{
  key ID,
  Company,
  CostType,
  CostcenterType,
  Account,
  AccountNM,
  /* Associations */
  _CompanyCode,
  _Costcenter,
  _CostType,
  _GLAccount
}
