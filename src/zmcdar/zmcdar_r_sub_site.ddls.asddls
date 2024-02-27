@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] SubSite 관리'
define root view entity ZMCDAR_R_SUB_SITE as select from ZMCDAR_I_SUB_SITE

{
  key Id,
  Subsite,
  SubsiteName,
  CostcenterType,
  CreatedBy,
  CreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt,
  LastChangedBy
  
}
