@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[IF] Profit Center Interface Macfin'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDIF_I_PROFITCENTER_01
  as select from I_ProfitCenterText
{
  key ProfitCenter         as ProfitCenter,
  
  key ControllingArea      as ControllingArea,
  
  key Language             as Language,
  
      ProfitCenterName     as ProfitCenterName,
      
      ProfitCenterLongName as ProfitCenterLongName,
      
      ValidityStartDate    as ValidityStartDate,
      
      ValidityEndDate      as ValidityEndDate
}where ValidityEndDate >= $session.system_date
