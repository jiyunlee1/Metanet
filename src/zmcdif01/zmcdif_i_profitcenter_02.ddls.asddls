@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[IF] Profit Center Interface AutoBill'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDIF_I_PROFITCENTER_02 
  as select from I_ProfitCenter
{
  key ProfitCenter         as ProfitCenter,
  
  key ControllingArea      as ControllingArea,
  
      _Text[ Language = $session.system_language ].ProfitCenterName     as ProfitCenterName,
      
      _Text[ Language = $session.system_language ].ProfitCenterLongName as ProfitCenterLongName,
      
      ValidityStartDate    as ValidityStartDate,
      
      ValidityEndDate      as ValidityEndDate
}
