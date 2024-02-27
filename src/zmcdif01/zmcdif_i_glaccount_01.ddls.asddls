@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[IF] GL Account Interface Macfin'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDIF_I_GLACCOUNT_01
  as select from I_GLAccountText
{
  key ChartOfAccounts   as ChartOfAccounts,
  
  key GLAccount         as GLAccount,
  
  key Language          as Language,
  
      GLAccountName     as GLAccountName,
      
      GLAccountLongName as GLAccountLongName
}
where ChartOfAccounts = 'YCOA'
