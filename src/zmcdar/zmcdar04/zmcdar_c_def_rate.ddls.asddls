@EndUserText.label: '[AR] 계산 비율 정의'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity zmcdar_c_def_rate
  provider contract transactional_query
  as projection on zmcdar_r_def_rate
{
  key ID,

      @Consumption.valueHelpDefinition: [
        {
          entity.name: 'ZMCDCM_V_COMPANY_CODE',
          entity.element: 'CompanyCode'
        }
      ]
      Company,

      @Consumption.valueHelpDefinition: [{
        entity:{
          name: 'ZMCDAR_V_PROFIT_CENTER',
          element: 'ProfitCenter'
        }
      }]
      ProfitCenter,


      @Consumption.valueHelpDefinition: [
        {
          entity.name: 'ZMCDAR_V_COST_TYPE',
          entity.element: 'CostType'
        }
      ]
      CostType,

      @Consumption.valueHelpDefinition: [
        {
          entity.name: 'ZMCDAR_V_ROLE_TYPE',
          entity.element: 'LowValue'
        }
      ]
      RoleType,

      Rate,

      ValidFrDate,

      ShutDownDate,

      @Consumption.valueHelpDefinition: [
          {
            entity.name: 'ZMCDAR_V_COST_CENTER',
            entity.element: 'CostCenter'
          }
      ]
      CostCenter,


      @Consumption.valueHelpDefinition: [
             {
               entity.name: 'ZMCDAR_V_Business_Partner',
               entity.element: 'BusinessPartner'
             }
           ]
      BusinessPartner,

      CreatedBy,

      CreatedAt,

      LocalLastChangedBy,

      LocalLastChangedAt,

      LastChangedAt,

      LastChangedBy,
      
      _ProfitCenterVH
}
