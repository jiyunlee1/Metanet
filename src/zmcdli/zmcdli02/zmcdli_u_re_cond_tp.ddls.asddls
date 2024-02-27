@EndUserText.label: '[LI] 조건 유형 등록 - Creat / Validation Check'
define root custom entity ZMCDLI_U_RE_COND_TP
{
  key ErrKey                  : abap.char(256);
      InternalRealEstateNumber  : abap.char(13);
      REStatusObjectCalculation : abap.char(22);
      REConditionType           : abap.char(4);
      REExtConditionPurpose     : abap.char(4);
      ValidityStartDate         : abap.dats(8);
      REPostingTerm             : abap.char(4);
      RERhythmTerm              : abap.char(4);
      REOrglAssignmentTerm      : abap.char(4);
      RECalculationRule         : abap.char(4);
      REUnitPrice               : abap.dec(19, 6);
      REConditionCurrency       : abap.cuky( 5 );
      LocalPath                 : abap.char(256);
}
