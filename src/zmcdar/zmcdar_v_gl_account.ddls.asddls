@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] GL 계정 Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_V_GL_ACCOUNT
  as select from I_GLAccount
{
      @Consumption.valueHelpDefault.display: false
  key ChartOfAccounts                                            as ChartOfAccounts,


      @EndUserText.label: 'GL 계정'
      @Consumption.valueHelpDefault.display: true
  key GLAccount                                                  as GLAccount,

      @EndUserText.label: 'GL 계정 명'
      @Consumption.valueHelpDefault.display: true
      _Text[ Language = $session.system_language ].GLAccountName as GLAccountName
}
where
  CompanyCode = '1000';
