@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Profit Center Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_V_PROFIT_CENTER
  as select from I_ProfitCenter
  association [1] to I_ProfitCenterText as _Text       on  $projection.ControllingArea = _Text.ControllingArea
                                                       and $projection.ProfitCenter    = _Text.ProfitCenter
                                                       and _Text.Language              = $session.system_language
  association [1] to I_CostCenter       as _CostCenter on  $projection.ProfitCenter    = _CostCenter.ProfitCenter
                                                       and $projection.ControllingArea = _CostCenter.ControllingArea

{
      @Consumption.valueHelpDefault.display: false
  key ControllingArea,

      @Consumption.valueHelpDefault.display: true
  key ProfitCenter,

      @Consumption.valueHelpDefault.display: false
  key ValidityEndDate,

//      @Consumption.valueHelpDefault.display: true
//      _CostCenter.CostCenter,

      @Consumption.valueHelpDefault.display: false
      _Text.ProfitCenterLongName,

      @Consumption.valueHelpDefault.display: true
      _Text.ProfitCenterName as ProfitCenterNM
}
