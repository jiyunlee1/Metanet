@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] Bank Linkage Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDGL_V_BANK_LINKAGE
  as select from I_HouseBankAccountLinkage
{
      @Consumption.valueHelpDefault.display: false
  key CompanyCode,
  
      @Consumption.valueHelpDefault.display: true
  key HouseBank,
  
       @Consumption.valueHelpDefault.display: true
  key HouseBankAccount,
  
      @Consumption.valueHelpDefault.display: true  
      BankName,
      
      BankAccount,
      
      BankAccountAlternative as GLAccount
}
