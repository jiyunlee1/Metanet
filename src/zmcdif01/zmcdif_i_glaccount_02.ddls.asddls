@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[IF] GL Account Interface AutoBill'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDIF_I_GLACCOUNT_02
  as select from I_GLAccount
{
  key ChartOfAccounts                                                as ChartOfAccounts,
  
  key GLAccount                                                      as GLAccount,
  
      _Text[ Language = $session.system_language ].GLAccountName     as GLAccountName,
      
      _Text[ Language = $session.system_language ].GLAccountLongName as GLAccountLongName,
      
      _GLAccountInChartOfAccounts.AccountIsBlockedForPosting         as PostingBlock
      
}where CompanyCode = '1000';
