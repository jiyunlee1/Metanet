@EndUserText.label: '[LI] 조직 Value Help'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MCDLI_CUST_VH_RE_ORGASSGMT'
define custom entity ZMCDLI_U_VH_RE_ORGASSGMT
{
  key InternalRealEstateNumber  : abap.char(13);
  key RETermType                : abap.char(4);
  key ValidityStartEndDateValue : abap.char(16);
  key RETermNumber              : abap.char(4);
      RETermName                : abap.char(60);
      ValidityStartDate         : abap.dats(8);
      ValidityEndDate           : abap.dats(8);
      ProfitCenter              : abap.char(10);
      ControllingArea           : abap.char(4);
}
