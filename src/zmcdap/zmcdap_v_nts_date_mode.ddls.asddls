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
define view entity ZMCDAP_V_NTS_DATE_MODE
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZMCDDO_DATE_MD_TYPE')
{
      @Consumption.valueHelpDefault.display: false
  key domain_name                 as DomainName,

      @Consumption.valueHelpDefault.display: false
  key value_position              as ValuePosition,

      @Semantics.language: true
      @Consumption.valueHelpDefault.display: false
  key language                    as Language,

      @EndUserText.label: 'Reference Date Type'
      @ObjectModel.text.element: ['NTSDateMd']
      @Consumption.valueHelpDefault.display: false
      @UI.textArrangement: #TEXT_ONLY
      @Search : {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.8
      }
      value_low                   as NTSDateMdCode,

      @EndUserText.label: 'Reference Date Type'
      @Semantics.text: true
      @Consumption.valueHelpDefault.display: true
      @Search : {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.8
      }
      cast(text as abap.char(20)) as NTSDateMd
}
where
      domain_name = 'ZMCDDO_DATE_MD_TYPE'
  and language    = 'E'

