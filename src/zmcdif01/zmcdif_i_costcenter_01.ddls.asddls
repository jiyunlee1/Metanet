@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[IF] Cost Center Interface Macfin'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDIF_I_COSTCENTER_01
  as select from I_CostCenterText
{
  key CostCenter            as CostCenter,
  
  key ControllingArea       as ControllingArea,
  
  key Language              as Language,
  
      CostCenterName        as CostCenterName,
      
      CostCenterDescription as CostCenterDescription,
      
      ValidityStartDate     as ValidityStartDate,
      
      ValidityEndDate       as ValidityEndDate
}where ValidityEndDate >= $session.system_date
