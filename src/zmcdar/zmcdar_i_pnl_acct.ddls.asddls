@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Export Smartstore PL - PNL Acct DTL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_PNL_ACCT
  as select from ZMCDAR_I_SMST_CODE
  association [1] to ZMCDAR_I_DEF_SMST   as _SmartStore on  $projection.SmartStore = _SmartStore.SmartStore
  association [1] to I_GLAccount         as _GLAccount  on  $projection.Account    = _GLAccount.GLAccount
                                                        and _GLAccount.CompanyCode = '1000'
  association [1] to ZMCDAR_V_GL_ACCOUNT as _AccountVH  on  $projection.Account = _AccountVH.GLAccount
{
  key Id                            as Id,
      Account                       as Account,
      Lineuse                       as LineUse,
      SmartStore,
      cast(SmartStore as abap.int2) as Line_No,
      cast('R' as abap.char(1))     as AccountType,
      _AccountVH.GLAccountName      as AccountName,
      _SmartStore.SmartStoreName,
      _SmartStore.Indent
}
