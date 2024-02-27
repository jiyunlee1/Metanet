@EndUserText.label: '[AR] SubSite 관리'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZMCDAR_C_SUB_SITE
  provider contract transactional_query
  as projection on ZMCDAR_R_SUB_SITE
{
  key Id,

      Subsite,

      SubsiteName,

      @Consumption.valueHelpDefinition: [
          {
            entity.name: 'ZMCDAR_V_COSTCENTER_TYPE',
            entity.element: 'LowValue'
          }
        ]
      CostcenterType,

      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      LastChangedBy

}
