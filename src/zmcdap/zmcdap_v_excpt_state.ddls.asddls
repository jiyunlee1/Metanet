@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Except Status Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
define view entity ZMCDAP_V_EXCPT_STATE as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZMCDDO_EXPT_STATUS_TYPE')
{
      @Consumption.valueHelpDefault.display: false
  key domain_name    as DomainName,

      @Consumption.valueHelpDefault.display: false
  key value_position as ValuePosition,

      @Semantics.language: true
      @Consumption.valueHelpDefault.display: false
  key language       as Language,

      @EndUserText.label: 'Excluding Status'
      @ObjectModel.text.element: ['IsExceptedText']
      @Consumption.valueHelpDefault.display: false
      @UI.textArrangement        : #TEXT_ONLY
      value_low      as IsExcepted,

      @EndUserText.label: 'Excluding Status Text'
      @Semantics.text: true
      @Consumption.valueHelpDefault.display: true
      @Search : {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.8
      }
      cast(text as abap.char(10))            as IsExceptedText
}
