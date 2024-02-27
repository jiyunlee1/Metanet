@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Cost Center Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMCDAR_V_COST_CENTER
  as select distinct from I_CostCenter

  association     to ZMCDAR_V_PROFIT_CENTER as _ProfitCenter on  $projection.ProfitCenter    = _ProfitCenter.ProfitCenter
                                                             and $projection.ControllingArea = _ProfitCenter.ControllingArea
  association [1] to I_CostCenterText       as _text         on  $projection.ControllingArea = _text.ControllingArea
                                                             and $projection.CostCenter      = _text.CostCenter
                                                             and $projection.ValidityEndDate = _text.ValidityEndDate
                                                             and _text.Language              = $session.system_language
{
      @Consumption.valueHelpDefault.display: false
  key ControllingArea,

      @Consumption.valueHelpDefault.display: true
  key CostCenter,

      @Consumption.valueHelpDefault.display: false
  key ValidityEndDate,


      @Consumption.valueHelpDefault.display: true
      ProfitCenter,
      
      _ProfitCenter.ProfitCenterNM,

      @Consumption.valueHelpDefault.display: true
      _text.CostCenterName,

      @Consumption.valueHelpDefault.display: true
      _text.CostCenterDescription
}
