@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] Sweeping Account 정의'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZMCDGL_I_SWP_ACCT
  as select from zmcdtgl0010
  association [1] to ZMCDGL_V_BANK             as _Bank on  $projection.Bank           = _Bank.BankID
  association [1] to I_GLAccount               as _GLAccount on  $projection.Account   = _GLAccount.GLAccount
                                                             and _GLAccount.CompanyCode = '1000'
  association [1] to ZMCDGL_V_GL_ACCOUNT       as _AccountVH on  $projection.GLAccount = _AccountVH.GLAccount

{
      @EndUserText.label: 'ID'
  key id                    as Id,

      @EndUserText.label: 'Bank ID'
      bank                  as Bank,

      @EndUserText.label: 'Bank Account'
      account               as Account,

      @EndUserText.label: 'GLAccount'
      gl_account            as GLAccount,

      @EndUserText.label: 'Profit Center'
      profit_center         as ProfitCenter,

      @EndUserText.label: 'Description'
      description           as Description,

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
        
      _Bank,
      _GLAccount,
      _AccountVH

}
