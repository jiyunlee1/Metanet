@EndUserText.label: '[LI] 계약 조건 추가 - Create / Valid Check'
define root custom entity ZMCDLI_U_REG_RE_CONDITION
{
  key dataKey                   : abap.char(256);
      InternalRealEstateNumber  : abap.char(13);
      REStatusObjectCalculation : abap.char(22);
      REConditionType           : abap.char(4);
      REExtConditionPurpose     : abap.char(4);
      ValidityStartDate         : abap.dats(8);
      ValidityEndDate           : abap.dats(8);
      REPostingTerm             : abap.char(4);
      RERhythmTerm              : abap.char(4);
      REOrglAssignmentTerm      : abap.char(4);
      RECalculationRule         : abap.char(4);
      REUnitPrice               : abap.dec(19, 6);
      REConditionCurrency       : abap.cuky( 5 );
      LocalPath                 : abap.char(256);
}
