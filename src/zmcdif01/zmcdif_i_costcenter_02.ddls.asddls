@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[IF] Cost Center Interface AutoBill'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDIF_I_COSTCENTER_02 
    as select from I_CostCenter
{
  key CostCenter                                                         as CostCenter,
  
  key ControllingArea                                                    as ControllingArea,

      _Text[ Language = $session.system_language ].CostCenterName        as CostCenterName,

      _Text[ Language = $session.system_language ].CostCenterDescription as CostCenterDesc,

      ValidityStartDate                                                  as ValidityStartDate,

      ValidityEndDate                                                    as ValidityEndDate,
      
      ProfitCenter                                                       as ProfitCenter
} where CompanyCode = '1000';
