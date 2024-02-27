@EndUserText.label: '[AR] Smart Store 관리'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZMCDAR_C_SMST_CODE
  provider contract transactional_query
  as projection on ZMCDAR_R_SMST_CODE
{
  key Id,

      @Consumption.valueHelpDefinition: [
        {
          entity.name: 'ZMCDAR_V_GL_ACCOUNT',
          entity.element: 'GLAccount'
        }
      ]
      Account,
      
      @Consumption.valueHelpDefinition: [
            {
              entity.name: 'ZMCDAR_V_LINE_USE',
              entity.element: 'LineUse'
            }
          ]
      Lineuse,
      
      LineUseText,
      
      LineUseState,
      
      @Consumption.valueHelpDefinition: [
        {
          entity.name: 'ZMCDAR_I_DEF_SMST',
          entity.element: 'SmartStore'
        }
      ]
      SmartStore,
      
      CreatedBy,
      
      CreatedAt,
      
      LocalLastChangedBy,
      
      LocalLastChangedAt,
      
      LastChangedAt,
      
      LastChangedBy,

      _AccountVH.GLAccountName   as GLAccountName,

      _SmartStore.SmartStoreName as SmartStoreName,

      @EndUserText.label: '들여 쓰기'
      _SmartStore.Indent         as Indent
}
