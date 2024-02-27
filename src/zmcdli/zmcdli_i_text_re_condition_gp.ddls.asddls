@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[LI] 조건 그룹 별 유형 / Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDLI_I_TEXT_RE_CONDITION_GP 
  as select from I_REConditionTypeByCndnGroup
  association [*] to I_REConditionTypeText as _CondTPText on  $projection.REConditionType = _CondTPText.REConditionType
                                                          and _CondTPText.Language        = $session.system_language
{
  key REConditionGroup,
  key REConditionType,
      _CondTPText.REConditionTypeName
}
