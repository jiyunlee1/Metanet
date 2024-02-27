@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] Sweeping Account 정의'
define root view entity ZMCDGL_R_SWP_ACCT as select from ZMCDGL_I_SWP_ACCT

{
  key Id,
  Bank,
  Account,
  GLAccount,
  ProfitCenter,
  Description,
  CreatedBy,
  CreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt,
  LastChangedBy,

  /* Associations */

    _GLAccount,
    _AccountVH
}
