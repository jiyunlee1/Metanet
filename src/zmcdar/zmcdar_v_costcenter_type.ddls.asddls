@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Costcenter 유형 Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_V_COSTCENTER_TYPE
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZMCDDO_COSTCENTER_TYPE')
{
      @Consumption.valueHelpDefault.display: false
  key domain_name    as DomainName,

      @Consumption.valueHelpDefault.display: false
  key value_position as ValuePosition,

      @Semantics.language: true
      @Consumption.valueHelpDefault.display: false
  key language       as Language,

      @EndUserText.label: 'Costcenter 유형'
      @ObjectModel.text.element: ['ValueText']
      @Consumption.valueHelpDefault.display: true
      value_low      as LowValue,

      @EndUserText.label: 'Costcenter 유형 명'
      @Semantics.text: true
      @Consumption.valueHelpDefault.display: true
      text           as ValueText
}
