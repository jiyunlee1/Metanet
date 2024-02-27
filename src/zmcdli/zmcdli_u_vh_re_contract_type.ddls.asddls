@EndUserText.label: '[LI] RealEstate Contract Type Value Help'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MCDLI_CUST_VH_RE_CONTR_TP'
define custom entity ZMCDLI_U_VH_RE_CONTRACT_TYPE
{
      @EndUserText.label       : '계약 유형'
      @UI.lineItem: [{ position: 10 }]
  key REContractType     : abap.char(4);
      @EndUserText.label       : '계약 유형명'
      @UI.lineItem: [{ position: 20 }]
      REContractTypeName : abap.char(30);

}
