@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Smart Store 정의'
define root view entity ZMCDAR_R_DEF_SMST
  as select from ZMCDAR_I_DEF_SMST

{
  key SmartStore,
      SmartStoreName,
      Indent,
      IsComb,
      Formula,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      LastChangedBy

}
