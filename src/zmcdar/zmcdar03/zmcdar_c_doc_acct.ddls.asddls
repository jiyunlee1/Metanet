@EndUserText.label: '[AR] 전표 사용 계정 관리'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZMCDAR_C_DOC_ACCT
  provider contract transactional_query
  as projection on ZMCDAR_R_DOC_ACCT
{
  key ID,

      @Consumption.valueHelpDefinition: [
        {
          entity.name: 'ZMCDCM_V_COMPANY_CODE',
          entity.element: 'CompanyCode'
        }
      ]
      Company,

      @Consumption.valueHelpDefinition: [
        {
          entity.name: 'ZMCDAR_V_COST_TYPE',
          entity.element: 'CostType'
        }
      ]
      CostType,

      @Consumption.valueHelpDefinition: [
        {
          entity.name: 'ZMCDAR_V_Role_TYPE',
          entity.element: 'LowValue'
        }
      ]
      RoleType,

      @Consumption.valueHelpDefinition: [
        {
          entity.name: 'ZMCDAR_V_DOC_TYPE',
          entity.element: 'DocType'
        }
      ]
      DocType,

      @Consumption.valueHelpDefinition: [
        {
          entity.name: 'ZMCDAR_V_ACCT_TYPE',
          entity.element: 'AcctTpCode'
        }
      ]
      PostingKey,

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
