@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZMCDAP_V_SUPPLIER
  as select from I_Supplier
  association to I_KR_SupplierVATInformation as _KRSupplierInfo on $projection.Supplier = _KRSupplierInfo.Supplier
{
      @Consumption.valueHelpDefault.display: true
      @UI.lineItem: [{ position: 10 }]
      @UI.selectionField: [{ position: 10 }]
      @ObjectModel.text.element  : [ 'SupplierName' ]
      @Search : {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.5
      }
  key Supplier,

      @Consumption.valueHelpDefault.display: true
      @EndUserText.label: 'Business No.'
      @UI.lineItem: [{ position: 50 }]
      @UI.selectionField: [{ position: 30 }]
      _KRSupplierInfo.TaxNumber2,

      @UI.selectionField: [{ position: 50 }]
      Country,

      @UI.selectionField: [{ position: 70 }]
      PostalCode,

      @UI.selectionField: [{ position: 90 }]
      CityName,

      @UI.selectionField: [{ position: 110 }]
      BPAddrStreetName,

      @UI.selectionField: [{ position: 130 }]
      DeletionIndicator,

      @Consumption.valueHelpDefault.display: true
      @UI.selectionField: [{ position: 20 }]
      @UI.lineItem: [{ position: 30 }]
      @Semantics.text: true
      SupplierName,
      
      @Search : {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.5
      }
      BusinessPartnerName1 as BusinessPartnerName,
      
       @Search : {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.5
      }     
      BusinessPartnerName2 as SubBusinessPartnerName


}
