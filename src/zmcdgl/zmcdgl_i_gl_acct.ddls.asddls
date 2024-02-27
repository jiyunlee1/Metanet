@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] GL Account 조회'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZMCDGL_I_GL_ACCT
  as select from I_GLAccountInChartOfAccounts
  association [1] to ZMCDGL_I_GL_CompanyCode      as _Company   on  $projection.GLAccount = _Company.GLAccount

  association [1] to I_GLAccountInChartOfAccounts as _GroupAcct on  $projection.GroupChartAcct = _GroupAcct.ChartOfAccounts
                                                                and $projection.GroupAcct      = _GroupAcct.GLAccount

{
      @EndUserText.label: '계정과 목표'
  key ChartOfAccounts,

      @EndUserText.label: '계정 과목'
  key GLAccount,

      @EndUserText.label: '단문'
      _Text[Language = 'E'].GLAccountName            as GLAccountShort,

      @EndUserText.label: '장문'
      _Text[Language = 'E'].GLAccountLongName        as GLAccountLong,

      @EndUserText.label: '잠금'
      AccountIsBlockedForPosting                     as BlockedPost,

      @EndUserText.label: '회사 코드'
      _Company.CompanyCode                           as Company,

      @EndUserText.label: '대체계정과 목표'
      _Company.AlterChartAcct                        as AlterChartAcct,

      @EndUserText.label: '대체 계정 과목'
      _Company.AlterGLAcct                           as AlterGLAcct,

      @EndUserText.label: '단문'
      _Company.ShortZCCG                             as ZccgShort,

      @EndUserText.label: '그룹 계정과 목표'
      CorporateGroupChartOfAccounts                  as GroupChartAcct,

      @EndUserText.label: '그룹 계정 과목'
      CorporateGroupAccount                          as GroupAcct,

      @EndUserText.label: '단문'
      _GroupAcct._Text[Language = 'E'].GLAccountName as GroupAcctShort
}
