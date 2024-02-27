@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier Tax Invoice'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//      @Search : {
//        defaultSearchElement: true,
//        fuzzinessThreshold: 0.8
//      }
define view entity ZMCDAP_V_BUSINEES_PLACE
  as select from I_KR_BusinessPlace
{
      @ObjectModel.text.element: ['BusinessPlaceName']
      @Consumption.valueHelpDefault.display: true
  key Branch,
  key CompanyCode,

      @EndUserText.label: 'Business Place Code'
      @ObjectModel.text.element: ['BusinessPlaceName']
      @Consumption.valueHelpDefault.display: true
      VATRegistration,
      
      @EndUserText.label: 'Business Place Name'
      @Semantics.text: true
      @Consumption.valueHelpDefault.display: true
      BusinessPlaceName
}
