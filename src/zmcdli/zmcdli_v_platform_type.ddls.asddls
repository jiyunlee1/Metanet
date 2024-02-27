@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Platform Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZMCDLI_V_PLATFORM_TYPE
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZMCDDO_PLATFORM_TYPE')
{
      @Consumption.valueHelpDefault.display: false
  key domain_name    as DomainName,

      @Consumption.valueHelpDefault.display: false
  key value_position as ValuePosition,

      @Semantics.language: true
      @Consumption.valueHelpDefault.display: false
  key language       as Language,

      @EndUserText.label: '매출 유형'
      @ObjectModel.text.element: ['ValueText']
      value_low      as LowValue,

      @EndUserText.label: '매출 유형 명'
      @Semantics.text: true
      text           as ValueText
}
