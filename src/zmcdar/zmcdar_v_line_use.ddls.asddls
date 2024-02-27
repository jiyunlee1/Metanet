@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Line Use Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_V_LINE_USE
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZMCDDO_USE_TYPE')
{
      @Consumption.valueHelpDefault.display: false
  key domain_name    as DomainName,

      @Consumption.valueHelpDefault.display: false
  key value_position as ValuePosition,

      @Semantics.language: true
      @Consumption.valueHelpDefault.display: false
  key language       as Language,

      @EndUserText.label: 'Line Use'
      @ObjectModel.text.element: ['LineUseText']
      @Consumption.valueHelpDefault.display: true
      value_low      as LineUse,

      @EndUserText.label: 'Text'
      @Semantics.text: true
      @Consumption.valueHelpDefault.display: true
      text           as LineUseText
}
