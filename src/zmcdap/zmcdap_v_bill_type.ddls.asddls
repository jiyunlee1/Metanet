@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] NTS Date Mode Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
define view entity ZMCDAP_V_BILL_TYPE
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZMCDDO_BILL_TP_TYPE')
{
      @Consumption.valueHelpDefault.display: false
  key domain_name    as DomainName,

      @Consumption.valueHelpDefault.display: false
  key value_position as ValuePosition,

      @Semantics.language: true
      @Consumption.valueHelpDefault.display: false
  key language       as Language,

      @EndUserText.label: 'Tax Classification'
      @ObjectModel.text.element: ['BillTypeText']
      @Consumption.valueHelpDefault.display: false
      @UI.textArrangement: #TEXT_ONLY
      value_low      as BillType,

      @EndUserText.label: 'Tax Classification'
      @Semantics.text: true
      @Consumption.valueHelpDefault.display: true
      @Search : {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.8
      }
      cast(text as abap.char(20))           as BillTypeText
}
