@EndUserText.label: '[LI] Real Estate Contract Value Help'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MCDLI_CUST_VH_RE_CONTRACT'
define custom entity ZMCDLI_U_VH_RE_CONTRACT
{
      //      @EndUserText.label       : '회사 코드'
      //      CompanyCode              : abap.char(4);

      @EndUserText.label : '계약 번호'
      @UI.selectionField : [{position: 10}]
  key RealEstateContract : abap.char(13);

      @EndUserText.label : '계약 명'
      @UI.selectionField : [{position: 30}]
      REContractName     : abap.char(80);

      @UI.textArrangement: #TEXT_ONLY
      @EndUserText.label : '계약 유형'
      @UI.selectionField : [{position: 50}]
      @Consumption.valueHelpDefinition: [{  entity: {   name: 'ZMCDLI_U_VH_RE_CONTRACT_TYPE' ,
                                                  element: 'REContractType'  }     }]
      @ObjectModel       : {
          text           : {
              element    : [ 'REContractTypeName' ]
           }
      }
      REContractType     : abap.char(4);

      @EndUserText.label : '계약 유형명'
      @UI.selectionField : [{position: 70}]
      REContractTypeName : abap.char(30);
}
