@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Smart Store 관리'
define root view entity ZMCDAR_R_SMST_CODE
  as select from ZMCDAR_I_SMST_CODE

{
  key Id,
  
      Account,
      
      Lineuse,
      
      SmartStore,
      
      LineUseText,
      
      LineUseState,
              
      CreatedBy,
      
      CreatedAt,
      
      LocalLastChangedBy,
      
      LocalLastChangedAt,
      
      LastChangedAt,
      
      LastChangedBy,
      
      _SmartStore,
      
      _GLAccount,
      
      _AccountVH,
      
      _LineUseVH

}
