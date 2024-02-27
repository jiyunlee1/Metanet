@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] GL Account 조회'
define root view entity ZMCDGL_R_GL_ACCT as select from ZMCDGL_I_GL_ACCT

{
  key ChartOfAccounts,
  key GLAccount,
  GLAccountShort,
  GLAccountLong,
  BlockedPost,
  Company,
  AlterChartAcct,
  AlterGLAcct,
  ZccgShort,
  GroupChartAcct,
  GroupAcct,
  GroupAcctShort
}
