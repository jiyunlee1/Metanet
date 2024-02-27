@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Item State Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZMCDAP_V_ITEM_STATE 
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZMCDDO_ITEM_STATE_TYPE')
{
      @Consumption.valueHelpDefault.display: false
  key domain_name    as DomainName,

      @Consumption.valueHelpDefault.display: false
  key value_position as ValuePosition,

      @Semantics.language: true
      @Consumption.valueHelpDefault.display: false
  key language       as Language,

      @EndUserText.label: 'Item State'
      @ObjectModel.text.element: ['ItemStateText']
      @Consumption.valueHelpDefault.display: false
      @Search : {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.8
      }
      value_low      as ItemState,

      @EndUserText.label: 'Item State'
      @Semantics.text: true
      @Consumption.valueHelpDefault.display: true
      @Search : {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.8
      }
      text           as ItemStateText
}
where domain_name = 'ZMCDDO_ITEM_STATE_TYPE'
  and language = 'E'
