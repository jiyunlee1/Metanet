@EndUserText.label: '[LI] 전기 Value Help'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MCDLI_CUST_VH_RE_POSTING'
define custom entity ZMCDLI_U_VH_RE_POSTING
{
  key InternalRealEstateNumber  : abap.char(13);
  key RETermType                : abap.char(4);
  key ValidityStartEndDateValue : abap.char(16);
  key RETermNumber              : abap.char(4);
      BusinessPartner           : abap.char(10);
      BusinessPartnerName       : abap.char(40);
      RETermName                : abap.char(60);
      ValidityStartDate         : abap.dats(8);
      ValidityEndDate           : abap.dats(8);
      RETaxType                 : abap.char(4);
      TaxGroup                  : abap.char(20);
      TaxCountry                : abap.char(3);
}
