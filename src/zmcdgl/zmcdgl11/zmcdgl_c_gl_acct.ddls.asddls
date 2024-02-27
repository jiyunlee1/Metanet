@EndUserText.label: '[GL] GL Account 조회'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZMCDGL_C_GL_ACCT
  provider contract transactional_query
  as projection on ZMCDGL_R_GL_ACCT
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
