@EndUserText.label: '[AP] Supplier Tax Invoice'
@Search.searchable: true
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MCDAP_CUST_INVOICE'
@UI: {
    headerInfo: {
        typeName: 'Supplier ETax Invoice',
        typeNamePlural: 'Supplier ETax Invoice',
        title: {
            type: #STANDARD, value: 'IssueNo'
        }
    },
    presentationVariant: [ 
      {
        sortOrder: [
          {
            by: 'NTSDt'
          }
        ],
        visualizations: [ 
          {
            type: #AS_LINEITEM
          } 
        ],

        maxItems: 5010

      } 
   ]
}

define root custom entity ZMCDAP_U_INVOICE
{
      @UI.facet             : [
        {
          type              : #COLLECTION,
          id                : 'GeneralInfo',
          position          : 10,
          label             : 'General Information'
        },


        {
          id                : 'ItemStateHeader',
          purpose           : #HEADER,
          type              : #DATAPOINT_REFERENCE,
          position          : 10,
          targetQualifier   : 'ItemState'
        },
        {
          id                : 'BasicDataSH',
          label             : 'BasicData',
          parentId          : 'GeneralInfo',
          type              : #IDENTIFICATION_REFERENCE,
          purpose           : #STANDARD,
          position          : 10,
          targetQualifier   : 'idt001'
        },
        {
          id                : 'DateSH',
          label             : 'Date',
          parentId          : 'GeneralInfo',
          type              : #IDENTIFICATION_REFERENCE,
          purpose           : #STANDARD,
          position          : 10,
          targetQualifier   : 'idt002'
        },
        {
          id                : 'AmountsSH',
          label             : 'Amounts',
          parentId          : 'GeneralInfo',
          type              : #IDENTIFICATION_REFERENCE,
          purpose           : #STANDARD,
          position          : 10,
          targetQualifier   : 'idt003'
        },
        {
          id                : 'BuyerDataSH',
          label             : 'Buyer Data',
          parentId          : 'GeneralInfo',
          type              : #IDENTIFICATION_REFERENCE,
          purpose           : #STANDARD,
          position          : 10,
          targetQualifier   : 'idt004'
        },
        {
          id                : 'SupplierDataSH',
          label             : 'Supplier Data',
          parentId          : 'GeneralInfo',
          type              : #IDENTIFICATION_REFERENCE,
          purpose           : #STANDARD,
          position          : 10,
          targetQualifier   : 'idt005'
        },
        {
          id                : 'LineItemsSH',
          label             : 'Line Item',
          parentId          : 'GeneralInfo',
          type              : #IDENTIFICATION_REFERENCE,
          purpose           : #STANDARD,
          position          : 10,
          targetQualifier   : 'idt006'
        },

        {
          id                : 'LineItems',
          purpose           : #STANDARD,
      //          parentId          : 'LineInfos',
          type              : #LINEITEM_REFERENCE,
          label             : 'Line Items',
          position          : 20,
          targetElement     : '_InvoiceItem'
        }
      ]



      @UI.lineItem          : [
        {
          type              : #FOR_ACTION,
          position          : 1,
          dataAction        : 'CallHeaderData',
          label             : 'Create'
        }
      ]
      @UI.hidden            : true
  key ID                    : sysuuid_x16;



      @EndUserText.label    : 'Business Place'
      @Search               : {
        defaultSearchElement: true,
        fuzzinessThreshold  : 0.8
      }
      //      @Consumption          : {
      //        valueHelpDefinition : [{
      //          entity            :{
      //            name            : 'ZMCDAP_V_BUSINEES_PLACE',
      //            element         : 'BusinessPlaceName'
      //          },
      //          additionalBinding : [{  element: 'VATRegistration', localElement: 'BizPlace' }]
      //        }]
      //      }
      @UI.hidden            : true
      @Semantics.text       : true
      BusinessPlaceName     : abap.char(30);

      @UI.identification    : [ { position: 10, qualifier: 'idt001' } ]
      @UI.lineItem          : [{ position: 10, cssDefault. width: '10rem'}]
      @EndUserText.label    : 'Business Place'
      @Search               : {
        defaultSearchElement: true,
        fuzzinessThreshold  : 0.8
      }
      @UI.selectionField    : [{ position: 10 }]
      @Consumption          : {
        valueHelpDefinition : [{
          entity            :{
            name            : 'ZMCDAP_V_BUSINEES_PLACE',
            element         : 'Branch'
          },
          additionalBinding : [{  element: 'BusinessPlaceName', localElement: 'BusinessPlaceName' }]
        }]
      }
      @UI.textArrangement   : #TEXT_ONLY
      @ObjectModel.text.element: ['BusinessPlaceName']
      BizPlace              : abap.char(4);

      @EndUserText.label    : 'Approval No'
      @Search               : {
        defaultSearchElement: true,
        fuzzinessThreshold  : 0.8
      }
      @UI.selectionField    : [{ position: 170 }]
      @UI.identification    : [ { position: 150, qualifier: 'idt001' } ]
      @UI.lineItem          : [{ position: 170 }]
      IssueNo               : abap.char(24);

      @EndUserText.label    : 'Reference Date Type'
      @UI.selectionField    : [{ position: 50 }]
      @UI.lineItem: [{ hidden: true }]
      @Consumption          : {
        filter              : {
          defaultValue      : 'MAKEDT',
          mandatory         : true,
          selectionType     : #SINGLE
        },
        valueHelpDefinition : [{
          entity            :{
            name            : 'ZMCDAP_V_NTS_DATE_MODE',
            element         : 'NTSDateMdCode'
          }
        }]
      }
      @ObjectModel.text.element: ['DateModeTxt']
      @Consumption.valueHelpDefault.display: true
      DateMode              : zmcdde_date_md_type;

      @Semantics.text       : true
      @UI.hidden            : true
      DateModeTxt           : abap.char(60);

      @EndUserText.label    : 'NTS Date'
      @Consumption          : {
        filter              : {
          mandatory         : true,
          selectionType     : #INTERVAL
        }
      }
      @UI.lineItem: [{ position: 50 }]
      NTSDt                 : abap.dats;

      @EndUserText.label    : 'Start Date'
      @UI.identification    : [ { position: 10, qualifier: 'idt002' } ]
      MakeDt                : abap.dats;

      @EndUserText.label    : 'Issue Date'
      @UI.identification    : [ { position: 30, qualifier: 'idt002' } ]
      IssueDt               : abap.dats;

      @EndUserText.label    : 'Send Date'
      @UI.identification    : [ { position: 50, qualifier: 'idt002' } ]
      SendDt                : abap.dats;

      @EndUserText.label    : 'Buyer Business No'
      @UI.identification    : [ { label: 'Business No', position: 30, qualifier: 'idt004' } ]
      ByrBizNo              : abap.char(13);

      @UI.hidden            : true
      ClientKey             : abap.char(10);

      @UI.hidden            : true
      EntKey                : abap.char(12);

      @EndUserText.label    : 'Tax Classification 1'
      @UI.identification    : [ { position: 30, qualifier: 'idt001' } ]
      @UI.lineItem          : [{ position: 30, cssDefault.width: '10rem'}]
      @ObjectModel.text.element: [ 'BillTypeText' ]
      @Search               : {
        defaultSearchElement: true,
        fuzzinessThreshold  : 0.8
      }
      @UI.selectionField    : [{ position: 70 }]
      @Consumption          : {
        filter              : {
          selectionType     : #SINGLE
        },
        valueHelpDefinition : [{
          entity            :{
            name            : 'ZMCDAP_V_BILL_TYPE',
            element         : 'BillType'
          },
          additionalBinding : [{  element: 'BillTypeText', localElement: 'BillTypeText' }]
        }]
      }
      @UI.textArrangement   : #TEXT_ONLY
      BillType              : zmcdde_bill_tp_type;


      @EndUserText.label    : 'Tax Classification 1'
      @UI.hidden            : true
      @Semantics.text       : true
      @Search               : {
        defaultSearchElement: true,
        fuzzinessThreshold  : 0.8
      }
      BillTypeText          : abap.char(60);

      @Search               : {
        defaultSearchElement: true,
        fuzzinessThreshold  : 0.8
      }
      @UI.selectionField    : [{ position: 110 }]
      @UI.identification    : [ { position: 30, qualifier: 'idt005', label: 'Business No'} ]
      @UI.lineItem          : [{ position: 90, label: 'Supplier Business No' }]
      @EndUserText.label: 'Business No'
      SupBizNo              : abap.char(13);

      @EndUserText.label    : 'Supplier Business Sub Number'
      @UI.identification    : [ { label: 'Business Sub Number', position: 50, qualifier: 'idt005' } ]
      SupBizSubNo           : abap.char(4);

      @EndUserText.label: 'Supplier'
      @UI.identification    : [ { position: 10, qualifier: 'idt005', label: 'Business Name' } ]
      @UI.lineItem          : [{ position: 70, cssDefault.width: '15rem' }]
      SupCorpNm             : abap.char(200);

      @EndUserText.label    : 'Supplier CEO'
      @UI.identification    : [ { label: 'CEO', position: 70, qualifier: 'idt005' } ]
      SupRepNm              : abap.char(100);

      @EndUserText.label    : 'Supplier Address'
      @UI.identification    : [ { label: 'Address', position: 90, qualifier: 'idt005' } ]
      SupAddress            : abap.char(1000);

      @EndUserText.label    : 'Buyer Business Sub Number'
      @UI.identification    : [ { label: 'Business Sub Number', position: 50, qualifier: 'idt004' } ]
      ByrBizSubNo           : abap.char(4);

      @EndUserText.label    : 'Buyer'
      @UI.identification    : [ { label: 'Business Name', position: 10, qualifier: 'idt004' } ]
      ByrCorpNm             : abap.char(200);

      @EndUserText.label    : 'Buyer CEO'
      @UI.identification    : [ { label: 'CEO', position: 70, qualifier: 'idt004' } ]
      ByrRepNm              : abap.char(100);

      @EndUserText.label    : 'Buyer Address'
      @UI.identification    : [ { label: 'Address', position: 90, qualifier: 'idt004' } ]
      ByrAddress            : abap.char(1000);

      @EndUserText.label    : 'Gross Amount'
      @UI.identification    : [ { position: 50, qualifier: 'idt003' } ]
      @UI.lineItem          : [{ position: 150, cssDefault.width: '11rem', criticality: 'DummyCritAmt', criticalityRepresentation: #WITHOUT_ICON }]
      @Semantics.amount.currencyCode: 'Currency'
      TotAmt                : abap.curr(23,2);

      @EndUserText.label    : 'Net Amount'
      @UI.identification    : [ { position: 10, qualifier: 'idt003' } ]
      @UI.lineItem          : [{ position: 110, cssDefault.width: '11rem', criticality: 'DummyCritAmt', criticalityRepresentation: #WITHOUT_ICON }]
      @Semantics.amount.currencyCode: 'Currency'
      SupAmt                : abap.curr(23,2);

      @EndUserText.label    : 'Tax Amount'
      @UI.identification    : [ { position: 30, qualifier: 'idt003' } ]
      @UI.lineItem          : [{ position: 130, cssDefault.width: '11rem', criticality: 'DummyCritAmt', criticalityRepresentation: #WITHOUT_ICON }]
      @Semantics.amount.currencyCode: 'Currency'
      TaxAmt                : abap.curr(23,2);

      @UI.hidden : true
      DummyCritAmt                 : abap.char(1);
      
      @EndUserText.label    : 'Tax Classification 2'
      @Search               : {
        defaultSearchElement: true,
        fuzzinessThreshold  : 0.8
      }
      @UI.selectionField    : [{ position: 90 }]
      @UI.identification    : [ { position: 50, qualifier: 'idt001' } ]
      TaxClsf               : abap.char(30);

      @EndUserText.label    : 'Issue Type 2'
      @UI.identification    : [ { position: 90, qualifier: 'idt001' } ]
      IsnType               : abap.char(30);

      @EndUserText.label    : 'Note'
      @UI.identification    : [ { position: 130, qualifier: 'idt001' } ]
      @UI.lineItem          : [{ position: 230 }]
      Bigo                  : abap.char(1333);

      @EndUserText.label    : 'Demand Type'
      @UI.identification    : [ { position: 110, qualifier: 'idt001' } ]
      DemandGb              : abap.char(30);

      @EndUserText.label    : 'Supplier Email'
      @Search               : {
        defaultSearchElement: true,
        fuzzinessThreshold  : 0.8
      }
      @UI.selectionField    : [{ position: 150 }]
      @UI.identification    : [ { position: 110, qualifier: 'idt005', label : 'Email' } ]
      @UI.lineItem          : [{ position: 210, label: 'Supplier Email', cssDefault.width: '15rem' }]
      SupEmail              : abap.char(200);

      @EndUserText.label    : 'Buyer Email'
      @Search               : {
        defaultSearchElement: true,
        fuzzinessThreshold  : 0.8
      }
      @UI.selectionField    : [{ position: 130 }]
      @UI.identification    : [ { position: 110, qualifier: 'idt004', label: 'Email 1' } ]
      @UI.lineItem          : [{ position: 190, label: 'Buyer Email', cssDefault.width: '15rem' }]
      ByrEmail1             : abap.char(200);

      @EndUserText.label    : 'Buyer Email 2'
      @Search               : {
        defaultSearchElement: true,
        fuzzinessThreshold  : 0.8
      }
      @UI.identification    : [ { label: 'Email 2', position: 130, qualifier: 'idt004', cssDefault.width: '15rem' } ]

      ByrEmail2             : abap.char(200);

      @EndUserText.label    : 'Item Date'
      @UI.identification    : [ { position: 10, qualifier: 'idt006' } ]
      ItemDt                : abap.dats;

      @EndUserText.label    : 'Item Name'
      @Search               : {
        defaultSearchElement: true,
        fuzzinessThreshold  : 0.8
      }
      @UI.selectionField    : [{ position: 180 }]
      @UI.identification    : [ { position: 30, qualifier: 'idt006' } ]
      ItemNm                : abap.char(200);

      @EndUserText.label    : 'Item Standard'
      @UI.identification    : [ { position: 70, qualifier: 'idt006' } ]
      ItemStd               : abap.char(200);

      @EndUserText.label    : 'Item Quantity'
      @UI.identification    : [ { position: 50, qualifier: 'idt006' } ]
      ItemQty               : abap.char(30);

      @EndUserText.label    : 'Item Unit Price'
      @UI.identification    : [ { position: 90, qualifier: 'idt006' } ]
      @Semantics.amount.currencyCode: 'Currency'
      ItemUnt               : abap.curr(30,2);

      @EndUserText.label    : 'Item Net Amount'
      @UI.identification    : [ { position: 110, qualifier: 'idt006' } ]
      @Semantics.amount.currencyCode: 'Currency'
      ItemSupAmt            : abap.curr(23,2);

      @EndUserText.label    : 'Item Tax Amount'
      @UI.identification    : [ { position: 130, qualifier: 'idt006' } ]
      @Semantics.amount.currencyCode: 'Currency'
      ItemTaxAmt            : abap.curr(23,2);

      @EndUserText.label    : 'Item Note'
      @UI.identification    : [ { position: 150, qualifier: 'idt006' } ]
      ItemBigo              : abap.char(200);

      @EndUserText.label    : 'Currency Key'
      Currency              : abap.cuky;
      
      @Consumption.filter.hidden: true
      @EndUserText.label    : 'Consignee Business No'
      CstnBizNO             : abap.char(10);
      
      @Consumption.filter.hidden: true
      @EndUserText.label    : 'Consignee Business Name'
      CstnCorpNm            : abap.char(250);

      @EndUserText.label    : 'Item State'
      @UI.lineItem:[{ hidden: true }]
      ItemState             : zmcdde_item_state_type;

      @EndUserText.label    : 'Item State'
      @UI.dataPoint         : { qualifier: 'ItemState', title: 'Item Status', criticality: 'ItemState' }
      ItemStateText         : abap.char(60);

      @Semantics.user.createdBy: true
      @EndUserText.label: 'Create By'
      CreatedBy            : abp_creation_user;

      @Semantics.systemDateTime.createdAt: true
      @EndUserText.label: 'Create At'
      CreatedAt            : abp_creation_tstmpl;

      @Semantics.user.localInstanceLastChangedBy: true
      @EndUserText.label: 'Local Changed By'
      LocalLastChangedBy : abp_locinst_lastchange_user;

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      @EndUserText.label: 'Local Changed At'
      LocalLastChangedAt : abp_locinst_lastchange_tstmpl;

      @Semantics.systemDateTime.lastChangedAt: true
      @EndUserText.label: 'Changed At'
      LastChangedAt       : abp_lastchange_tstmpl;

      @Semantics.user.lastChangedBy: true
      @EndUserText.label: 'Changed By'
      LastChangedBy       : abp_lastchange_user;


      @EndUserText.label    : 'Issue Type 1'
      @Search               : {
        defaultSearchElement: true,
        fuzzinessThreshold  : 0.8
      }
      @UI.selectionField    : [{ position: 190 }]
      @UI.identification    : [ { position: 70, qualifier: 'idt001' } ]
      TaxKnd                : abap.char(30);

      _InvoiceItem          : composition [0..*] of ZMCDAP_R_CUST_ITEM;

      //            _InvoiceItem          : association [0..*] to ZMCDAP_I_INVOICE_ITEM on $projection.ID = _InvoiceItem.HeaderID;
}
