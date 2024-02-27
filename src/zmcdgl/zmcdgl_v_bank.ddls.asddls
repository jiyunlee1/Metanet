@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL]Bank value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZMCDGL_V_BANK
  as select from I_Bank_2
{
      @Consumption.valueHelpDefault.display: false
  key BankCountry    as BankCountry,

      @ObjectModel.text.element: ['BankName']
  key BankInternalID as BankID,

      @Semantics.text: true
      @Consumption.valueHelpDefault.display: true
      BankName       as BankName
}
