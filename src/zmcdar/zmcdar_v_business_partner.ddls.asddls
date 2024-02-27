@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] BusinessPartner Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZMCDAR_V_BUSINESS_PARTNER as select from I_BusinessPartner
{
  key BusinessPartner,

      @Consumption.valueHelpDefault.display: true
      @EndUserText.label: 'BusinessPartner Name'
      BusinessPartnerName



}
