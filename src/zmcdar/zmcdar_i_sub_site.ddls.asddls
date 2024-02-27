@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] SubSite 관리'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZMCDAR_I_SUB_SITE
  as select from zmcdtar0060
  association [0..*] to ZMCDAR_I_COST_CENTER as _CostCenter on $projection.CostcenterType = _CostCenter.CostCenterType
{
      @EndUserText.label: 'ID'
  key id                    as Id,

      @EndUserText.label: 'Subsite Code'
      subsite               as Subsite,

      @EndUserText.label: 'Subsite Name'
      subsite_name          as SubsiteName,

      @EndUserText.label: 'Cost Center Type'
      costcenter_type       as CostcenterType,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      
      _CostCenter

}
