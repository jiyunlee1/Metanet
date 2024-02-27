@EndUserText.label: '[AP] Supplier Tax Invoice'
@Metadata.allowExtensions: true
define abstract entity ZMCDAP_A_INVOICE_OPTION
{
      @Consumption   : {
        filter       : {
          mandatory  : true,
          selectionType     : #SINGLE
        },
        valueHelpDefinition : [{
          entity     :{
            name     : 'ZMCDAP_V_BUSINEES_PLACE',
            element  : 'VATRegistration'
          }
        }]
      }
  key business_place : abap.char(11);
  
      @Consumption   : {
        filter       : {
          mandatory  : true,
          selectionType     : #SINGLE
        },
        valueHelpDefinition : [{
          entity     :{
            name     : 'ZMCDAP_V_NTS_DATE_MODE',
            element  : 'NTSDateMdCode'
          }
        }]
      }
  key search_kind    : zmcdde_date_md_type;
  
  key from_date      : abap.dats;

  key to_date        : abap.dats;
  
      @Consumption   : {
        defaultValue: '1',
        valueHelpDefinition : [{
          entity   :{
            name   : 'ZMCDAP_V_INVOICE_CALL_METHOD',
            element: 'MethodCode'
          }
        }]
      }
  key method         : zmcdde_invoice_call_type;
}
