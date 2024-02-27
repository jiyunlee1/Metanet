@EndUserText.label: '[LI] 조건 유형 등록 - RE Contract Main Data'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MCDLI_CUST_RE_CONTRACT'
define custom entity ZMCDLI_U_RE_CONTRACT
{

      @Consumption.filter.hidden: true
      @UI.hidden               : true
  key InternalRealEstateNumber : abap.char(13);

      @EndUserText.label       : '회사 코드'
      @Consumption.filter.hidden: true
      CompanyCode              : abap.char(4);

      @EndUserText.label       : '계약 번호'
      @UI.selectionField       : [{position: 10}]
      @Consumption.valueHelpDefinition: [{  entity: {   name: 'ZMCDLI_U_VH_RE_CONTRACT' ,
                                                  element: 'RealEstateContract'  }     }]
      RealEstateContract       : abap.char(13);

      @EndUserText.label       : '계약 명'
      @UI.selectionField       : [{position: 30}]
      REContractName           : abap.char(80);

      @UI.textArrangement      : #TEXT_ONLY
      @EndUserText.label       : '계약 유형'
      @UI.selectionField       : [{position: 50}]
      @Consumption.valueHelpDefinition: [{  entity: {   name: 'ZMCDLI_U_VH_RE_CONTRACT_TYPE' ,
                                                  element: 'REContractType'  }     }]
      REContractType           : abap.char(4);

      @EndUserText.label       : '계약 유형명'
      @UI.selectionField       : [{position: 70}]
      REContractTypeName       : abap.char(30);

      @EndUserText.label       : '통화'
      @Consumption.filter.hidden: true
      @UI.hidden               : true
      REContractCurrency       : abap.cuky;

      BusinessPartner          : abap.char(10);
      BusinessPartnerName      : abap.char(40);
}
