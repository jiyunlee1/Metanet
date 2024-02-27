@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] GL Account조회-Company Code'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZMCDGL_I_GL_CompanyCode
  as select from I_GLAccountInCompanyCode
//  association [1] to ZMCDGL_I_GL_ACCT as _ChartOfAcct on  $projection.AlterGLAcct        = _ChartOfAcct.GLAccount
//                                                                  and _ChartOfAcct.ChartOfAccounts = 'ZCCG'

  association [*] to I_GLAccountText as _ChartOfAcct on  $projection.AlterGLAcct        = _ChartOfAcct.GLAccount
                                                                  and _ChartOfAcct.ChartOfAccounts = 'ZCCG'
{
  key GLAccount,

  key CompanyCode,

      AlternativeGLAccount         as AlterGLAcct,

      _ChartOfAcct.ChartOfAccounts as AlterChartAcct,

      _ChartOfAcct[language = 'E'].GLAccountName     as ShortZCCG
//      _ChartOfAcct._Text[Language = 'E'].GLAccountName     as ShortZCCG

}
where
  CompanyCode = '1000'
