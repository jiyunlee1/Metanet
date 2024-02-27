@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 비용 유형 Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_V_COST_TYPE
  as select from ZMCDAR_I_COST_TYPE
{
      @UI.hidden: true
      @Consumption.valueHelpDefault.display: false
  key ID,

      @EndUserText.label: '회사 코드'
      @Consumption.valueHelpDefault.display: false
      Company,

      @EndUserText.label: '비용 유형'
      @Consumption.valueHelpDefault.display: true
      CostType,

      @EndUserText.label: '비용 유형 Text'
      @Consumption.valueHelpDefault.display: true
      CostTypeNM
}
