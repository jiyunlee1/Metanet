@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Account 유형 Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_V_ACCT_TYPE 
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZMCDDO_ACCT_TP_TYPE')
{
      @Consumption.valueHelpDefault.display: false
  key domain_name    as DomainName,

      @Consumption.valueHelpDefault.display: false
  key value_position as ValuePosition,

      @Semantics.language: true
      @Consumption.valueHelpDefault.display: false
  key language       as Language,

      @EndUserText.label: 'Account Type Code'
      @ObjectModel.text.element: ['AcctTpText']
      @Consumption.valueHelpDefault.display: true
      value_low      as AcctTpCode,

      @EndUserText.label: 'Account Type Description'
      @Semantics.text: true
      @Consumption.valueHelpDefault.display: true
      text           as AcctTpText
}
