@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Invoice Call Method Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
define view entity ZMCDAP_V_INVOICE_CALL_METHOD
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZMCDDO_INVOICE_CALL_TYPE')
{
      @Consumption.valueHelpDefault.display: false
  key domain_name    as DomainName,

      @Consumption.valueHelpDefault.display: false
  key value_position as ValuePosition,

      @Semantics.language: true
      @Consumption.valueHelpDefault.display: false
  key language       as Language,

      @EndUserText.label: 'Method Code'
      @ObjectModel.text.element: ['MethodText']
      @UI.textArrangement: #TEXT_ONLY
      @Search : {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.8
      }
      value_low      as MethodCode,

      @EndUserText.label: 'Method'
      @Semantics.text: true
      @UI.lineItem: [{ position: 20}]
      @Search : {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.8
      }
      text           as MethodText

}
