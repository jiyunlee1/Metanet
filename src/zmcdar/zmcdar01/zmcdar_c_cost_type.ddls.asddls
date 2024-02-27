@EndUserText.label: '[AR] 비용 유형 관리'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZMCDAR_C_COST_TYPE
  provider contract transactional_query
  as projection on ZMCDAR_R_COST_TYPE
{
  key ID,

      @Consumption.valueHelpDefinition: [
       {
         entity.name: 'ZMCDCM_V_COMPANY_CODE',
         entity.element: 'CompanyCode'
       }
      ]
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
