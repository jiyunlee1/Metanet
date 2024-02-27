@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Smart Store 정의'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZMCDAR_I_DEF_SMST
  as select from zmcdtar0070
  association [0..*] to ZMCDAR_I_SMST_CODE as _StoreMap on $projection.SmartStore = _StoreMap.SmartStore
{
      @EndUserText.label: 'Smart Store Code'
  key smart_store           as SmartStore,

      //      @EndUserText.label: 'GLAccount'
      @EndUserText.label: 'Smart Store Name'
      smart_store_name      as SmartStoreName,

      @EndUserText.label: 'Indent'
      indent                as Indent,

      @EndUserText.label: 'Is Combination'
      is_comb               as IsComb,
      
      @EndUserText.label: 'Formula'
      formula               as Formula,

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

      _StoreMap

}
