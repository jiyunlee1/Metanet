@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Smart Store 관리'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_SMST_CODE
  as select from zmcdtar0080
  association [1] to ZMCDAR_I_DEF_SMST   as _SmartStore on  $projection.SmartStore = _SmartStore.SmartStore
  association [1] to I_GLAccount         as _GLAccount  on  $projection.Account    = _GLAccount.GLAccount
                                                        and _GLAccount.CompanyCode = '1000'
  association [1] to ZMCDAR_V_GL_ACCOUNT as _AccountVH  on  $projection.Account = _AccountVH.GLAccount
  association [1] to ZMCDAR_V_LINE_USE   as _LineUseVH  on  $projection.Lineuse = _LineUseVH.LineUse
                                                        and _LineUseVH.Language = $session.system_language
{
      @EndUserText.label: 'ID'
  key id                     as Id,

      @EndUserText.label: 'GLAccount'
      account                as Account,

      @EndUserText.label: '사용 여부'
      lineuse                as Lineuse,

      @EndUserText.label: '사용 여부'
      _LineUseVH.LineUseText as LineUseText,

      @EndUserText.label: 'Smart Store Code'
      smart_store            as SmartStore,

      @Semantics.user.createdBy: true
      created_by             as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at             as CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by  as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at  as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at        as LastChangedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by        as LastChangedBy,

      case lineuse
        when 'Y'
        then '3'
        else '1'
      end                    as LineUseState,

      _SmartStore,
      _GLAccount,
      _AccountVH,
      _LineUseVH
}
