@EndUserText.label: '[AR] 매출액 합산 계정 관리'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZMCDAR_C_SALES_ACCT
  provider contract transactional_query
  as projection on ZMCDAR_R_SALES_ACCT
{
  key ID,
  
      @Search.defaultSearchElement: true
      Company,
 
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [
        {
          entity.name: 'ZMCDAR_V_COST_TYPE',
          entity.element: 'CostType'
        }
      ]
      CostType,
 
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [
        {
          entity.name: 'ZMCDAR_V_COSTCENTER_TYPE',
          entity.element: 'LowValue'
        }
      ]
      CostcenterType,

      @Consumption.valueHelpDefinition: [{
        entity:{
          name: 'ZMCDAR_V_GL_Account',
          element: 'GLAccount'
        },
        additionalBinding: [{ 
          element: 'GLAccountName',
          localElement: 'AccountNM' ,
          usage: #RESULT
        }]
      }]
      Account,
 
      AccountNM,
  
      CreatedBy,
 
      CreatedAt,
 
      LocalLastChangedBy,
 
      LocalLastChangedAt,
 
      LastChangedAt,
 
      LastChangedBy    
      
}
