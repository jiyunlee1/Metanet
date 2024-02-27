@EndUserText.label: '[LI] 빈도 Value Help'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MCDLI_CUST_VH_RE_RHYTHM'
define custom entity ZMCDLI_U_VH_RE_RHYTHM
{
  key InternalRealEstateNumber  : abap.char(13);
  key RETermType                : abap.char(4);
  key ValidityStartEndDateValue : abap.char(16);
  key RETermNumber              : abap.char(4);
      RETermName                : abap.char(60);
      ValidityStartDate         : abap.dats(8);
      ValidityEndDate           : abap.dats(8);
      REStartFrequencyWeek      : abap.char(1);
      REFrequencyStart          : abap.char(2);
}
