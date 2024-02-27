@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] GL Account value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZMCDGL_V_GL_ACCOUNT
  as select from I_GLAccount
{
      @Consumption.valueHelpDefault.display: false
  key ChartOfAccounts                                            as ChartOfAccounts,

      @Consumption.valueHelpDefault.display: true
      @EndUserText.label: 'GL 계정'
  key GLAccount                                                  as GLAccount,
  
      @Consumption.valueHelpDefault.display: true
      @EndUserText.label: 'GL 계정 명'
      _Text[ Language = $session.system_language ].GLAccountName as GLAccountName
}
where
      CompanyCode     = '1000'
  and ChartOfAccounts = 'YCOA';
