@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[LI] 조건 유형 Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDLI_I_TEXT_RE_CONDITION_TP
  as select from I_REConditionTypeText
{
  key Language,
  key REConditionType,
      REConditionTypeName,
      /* Associations */
      _Language,
      _REConditionType
}
where
  Language = $session.system_language
