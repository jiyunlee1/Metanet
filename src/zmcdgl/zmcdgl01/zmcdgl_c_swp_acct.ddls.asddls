@EndUserText.label: '[GL] Sweeping Account 정의'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZMCDGL_C_SWP_ACCT
  provider contract transactional_query
  as projection on ZMCDGL_R_SWP_ACCT

{
  key Id,


      @Consumption.valueHelpDefinition: [
          {
           entity.name: 'ZMCDGL_V_BANK',
           entity.element: 'BankID'
          }
          ]
      Bank,

      Account,

      @Consumption.valueHelpDefinition: [
      {
       entity.name: 'ZMCDGL_V_GL_ACCOUNT',
       entity.element: 'GLAccount'
      }
      ]
      GLAccount,

      @Consumption.valueHelpDefinition: [
      {
      entity.name: 'zmcdar_v_profit_center',
      entity.element: 'ProfitCenter'
      }
      ]
      ProfitCenter,

      Description,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      LastChangedBy
}
