@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 전기 Key Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_V_POSTING_KEY
  as select from I_PostingKey
{
      @EndUserText.label: '전기 키'
      @Consumption.valueHelpDefault.display: true
  key PostingKey                                                          as PostingKey,

      @EndUserText.label: '전기 키 Text'
      @Consumption.valueHelpDefault.display: true
      _PostingKeyText[Language = $session.system_language].PostingKeyName as PostingKeyNM
}
