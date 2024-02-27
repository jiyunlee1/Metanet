@EndUserText.label: '[AP] Supplier ETax Invoice Comparison List'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MCDAP_CUST_COMP_INVOICE'
@UI: {
    headerInfo: {
        typeName: 'Supplier ETax Invoice Comparison List',
        typeNamePlural: 'Supplier ETax Invoice Comparison List'
    },
    presentationVariant: [
      {
        sortOrder: [
          {
            by: 'IssueNo'
          },
          {
            by: 'IsMain',
            direction: #DESC
          }
        ],
        visualizations: [
          {
            type: #AS_LINEITEM
          }
        ],

        requestAtLeast: [ 'CompanyCode', 'FiscalYear', 'AccountingDocument', 'IsMain' ],

        maxItems: 5010

      }
   ]
}
define root custom entity ZMCDAP_U_COMP_INVOICE
{

      @EndUserText.label         : 'Journal Entry'
      @Consumption.semanticObject: 'AccountingDocument'
      @UI.lineItem               : [
        { position               : 90 },
        {
            type                 : #FOR_INTENT_BASED_NAVIGATION,
            semanticObjectAction : 'manage',
            hidden               : true,
            semanticObject       : 'AccountingDocument'
        }
      ]
      @UI.selectionField         : [{ position: 70 }]
  key AccountingDocument         : abap.char(10);

      @EndUserText.label         : 'Fiscal Year'
      @UI.hidden                 : true
  key FiscalYear                 : fis_gjahr_no_conv;

      @EndUserText.label         : 'Approval No'
      @UI.lineItem               : [{ position: 70 }]
      @UI.selectionField         : [{ position: 350 }]
  key IssueNo                    : abap.char(24);

      @EndUserText.label         : 'Company Code'
      CompanyCode                : abap.char(4);

      @EndUserText.label         : 'Business Place'
      @Consumption               : {
        valueHelpDefinition      : [{
          entity                 :{
            name                 : 'ZMCDAP_V_BUSINEES_PLACE',
            element              : 'Branch'
          }
        }]
      }
      @ObjectModel.text.element  : ['BusinessPlaceName']
      @UI.textArrangement        : #TEXT_ONLY
      @UI.lineItem               : [{ position: 10, cssDefault.width: '10rem' }]
      @UI.selectionField         : [{ position: 50 }]
      BizPlace                   : abap.char(4);

      @EndUserText.label         : 'Supplier (Jaurnal Entry)'
      JESupCorpNm                : abap.char(80);

      @EndUserText.label         : 'Supplier (NTS)'
      NTSSupCorpNm               : abap.char(200);

      @EndUserText.label         : 'Supplier'
      @Consumption               : {
        valueHelpDefinition      : [{
          entity                 :{
            name                 : 'ZMCDAP_V_SUPPLIER',
            element              : 'SupplierName'
          }
        }]
      }
      @UI.lineItem               : [{ position: 30, cssDefault.width: '15rem' }]
      SupCorpNm                  : abap.char(80);

      @EndUserText.label         : 'Business No (Jaurnal Entry)'
      JESupBizNo                 : abap.char(10);

      @EndUserText.label         : 'Business No (NTS)'
      NTSSupBizNo                : abap.char(10);

      @EndUserText.label         : 'Supplier'
      @Consumption               : {

        valueHelpDefinition      : [{
          entity                 :{
            name                 : 'ZMCDAP_V_SUPPLIER',
            element              : 'Supplier'
          }
        }]
      }
      @UI.selectionField         : [{ position: 170 }]
      @UI.textArrangement        : #TEXT_SEPARATE
      @ObjectModel.text.element  : [ 'SupCorpNm' ]
      @UI.lineItem               : [{ position: 50, label: 'Business No' }]
      SupBizNo                   : abap.char(10);

      @UI.hidden                 : true
      MainIssueNo                : abap.char(80);

      @EndUserText.label         : 'Profit Center'
      @UI.lineItem               : [{ position: 100 }]
      ProfitCenter               : abap.char(10);

      @EndUserText.label         : 'Profit Center Name'
      @UI.lineItem               : [{ position: 110, cssDefault.width: '9rem'  }]
      ProfitCenterNM             : abap.char(20);

      @EndUserText.label         : 'Journal Entry Date'
      @Consumption               : {
        filter                   : {
          selectionType          : #INTERVAL,
          mandatory              : true
        }
      }
      @UI.lineItem               : [{ position: 130 }]
      //      @UI.selectionField         : [{ position: 90 }]
      DocumentDate               : abap.dats(8);

      @EndUserText.label         : 'Currency'
      @Consumption.filter.hidden : true
      @UI.hidden                 : true
      CompanyCodeCurrency        : abap.cuky(5);

      @EndUserText.label         : 'Net Amount (SAP)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      @UI.lineItem               : [{ position: 150, cssDefault.width: '11rem', criticality: 'DummyCritAmt', criticalityRepresentation: #WITHOUT_ICON }]
      JESupAmt                   : abap.curr(23, 2);

      @EndUserText.label         : 'Currency'
      @Consumption.filter.hidden : true
      @UI.hidden                 : true
      TransactionCurrency        : abap.cuky(5);

      @EndUserText.label         : 'Tax Amount (SAP)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      @UI.lineItem               : [{ position: 170, cssDefault.width: '11rem', criticality: 'DummyCritAmt', criticalityRepresentation: #WITHOUT_ICON }]
      JETaxAmt                   : abap.curr(23, 2);

      @EndUserText.label         : 'Gross Amount (SAP)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      @UI.lineItem               : [{ position: 190, cssDefault.width: '11rem', criticality: 'DummyCritAmt', criticalityRepresentation: #WITHOUT_ICON }]
      JETotAmt                   : abap.curr(23,2);

      @EndUserText.label         : 'Start Date'
      @Consumption               : {
        filter                   : {
          selectionType          : #INTERVAL,
          mandatory              : true
        }
      }
      @UI.lineItem               : [{ position: 210 }]
      //      @UI.selectionField         : [{ position: 190 }]
      MakeDt                     : abap.dats(8);

      @EndUserText.label         : 'Currency'
      @Consumption.filter.hidden : true
      @UI.hidden                 : true
      Currency                   : abap.cuky(5);

      @EndUserText.label         : 'Net Amount (NTS)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      @UI.lineItem               : [{ position: 230, cssDefault.width: '11rem', criticality: 'DummyCritAmt', criticalityRepresentation: #WITHOUT_ICON }]
      SupAmt                     : abap.curr(23,2);

      @EndUserText.label         : 'Tax Amount (NTS)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      @UI.lineItem               : [{ position: 250, cssDefault.width: '11rem', criticality: 'DummyCritAmt', criticalityRepresentation: #WITHOUT_ICON }]
      TaxAmt                     : abap.curr(23,2);

      @EndUserText.label         : 'Gross Amount (NTS)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      @UI.lineItem               : [{ position: 270, cssDefault.width: '11rem', criticality: 'DummyCritAmt', criticalityRepresentation: #WITHOUT_ICON }]
      TotAmt                     : abap.curr(23,2);

      @EndUserText.label         : 'Date (Diff)'
      @UI.hidden                 : true
      isDifDate                  : abap.char(1);

      @EndUserText.label         : 'Date (Diff)'
      @UI.lineItem               : [{ position: 290, criticality: 'isDifDate', criticalityRepresentation: #WITHOUT_ICON }]
      isDifDateCol               : abap.char(1);

      @EndUserText.label         : 'Net Amount (Diff)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      @UI.lineItem               : [{ position: 310, cssDefault.width: '11rem', criticality: 'IsDiffAmt', criticalityRepresentation: #WITHOUT_ICON  }]
      DifSupAmt                  : abap.curr(23,2);

      @EndUserText.label         : 'Tax Amount (Diff)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      @UI.lineItem               : [{ position: 330, cssDefault.width: '11rem', criticality: 'IsDiffAmt', criticalityRepresentation: #WITHOUT_ICON  }]
      DifTaxAmt                  : abap.curr(23,2);

      @EndUserText.label         : 'Gross Amount (Diff)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      @UI.lineItem               : [{ position: 350, cssDefault.width: '11rem', criticality: 'IsDiffAmt', criticalityRepresentation: #WITHOUT_ICON  }]
      DifTotAmt                  : abap.curr(23,2);

      @EndUserText.label         : 'Currency'
      @Consumption.filter.hidden : true
      @UI.hidden                 : true
      DefCurrency                : abap.cuky(5);

      @UI.hidden                 :true
      IsDiffAmt                  : abap.char(1);

      @UI.hidden                 : true
      DummyCritAmt               : abap.char(1);

      @EndUserText.label         : 'Difference Type'
      @Consumption               : {
        filter                   : {
          selectionType          : #SINGLE
        },
        valueHelpDefinition      : [{
          entity                 :{
            name                 : 'ZMCDAP_V_IS_DIFF',
            element              : 'IsDiff'
          }
        }]
      }
      @ObjectModel.text.element  : [ 'IsDiffText' ]
      @UI.selectionField         : [{ position: 430 }]
      @UI.textArrangement        : #TEXT_ONLY
      IsDiff                     : zmcdde_diff_stat_type;

      @UI.hidden                 : true
      IsDiffText                 : abap.char(80);

      @EndUserText.label         : 'Excluding Status'
      @Consumption               : {
        filter                   : {
          selectionType          : #SINGLE
        },
        valueHelpDefinition      : [{
          entity                 :{
            name                 : 'ZMCDAP_V_EXCPT_STATE',
            element              : 'IsExcepted'
          }
        }]
      }
      @ObjectModel.text.element  : [ 'IsExceptedText' ]
      @UI.textArrangement        : #TEXT_ONLY
      //      @UI.lineItem               : [{ position: 370 }]
      @UI.selectionField         : [{ position: 450 }]
      ExptStat                   : zmcdde_expt_status_type;

      @EndUserText.label         : 'Excluding Status'
      @UI.lineItem               : [
        { position               : 370 },
        {
          label                  : 'Except',
          dataAction             : 'setExceptAction',
          type                   : #FOR_ACTION,
          position               : 370,
          invocationGrouping     : #CHANGE_SET
        },
        {
          label                  : 'Cancel',
          dataAction             : 'cancelExceptAction',
          type                   : #FOR_ACTION,
          position               : 370,
          invocationGrouping     : #CHANGE_SET
        }
      ]
      ExcludingStat              : abap.char( 10 );

      @UI.hidden                 : true
      IsExceptedText             : abap.char(60);

      //    Journal Entry Hidden data
      @EndUserText.label         : 'Is Reversed'
      IsReversed                 : abap_boolean;

      @EndUserText.label         : 'Is Reversal'
      IsReversal                 : abap_boolean;

      @EndUserText.label         : 'Reversal Reference Document'
      ReversalReferenceDocument  : abap.char(10);

      @EndUserText.label         : 'Is Main Journal Entry'

      IsMain                     : abap_boolean;

      @EndUserText.label         : 'Source Ledger'
      @UI.hidden                 : true
      SourceLedger               : abap.char(2);

      @EndUserText.label         : 'Ledger GL Line Item'
      @UI.hidden                 : true
      LedgerGLLineItem           : abap.char(6);

      @EndUserText.label         : 'Ledger'
      @UI.hidden                 : true
      Ledger                     : fins_ledger;

      @EndUserText.label         : 'Ledger Group'
      @UI.hidden                 : true
      LedgerGroup                : abap.char(4);

      @EndUserText.label         : 'Posting Date'
      @Consumption               : {
        filter                   : {
          selectionType          : #INTERVAL
        }
      }
      @UI.selectionField         : [{ position: 110 }]
      PostingDate                : fis_budat;

      @EndUserText.label         : 'Accounting Document Created By User'
      AccountingDocCreatedByUser : abap.char(12);

      @EndUserText.label         : 'Accounting Document Type'
      @Consumption               : {
        valueHelpDefinition      : [{
          entity                 :{
            name                 : 'ZMCDAP_V_ACCTG_DOC_TYPE',
            element              : 'DocType'
          }
        }]
      }
      @UI.selectionField         : [{ position: 150 }]
      AccountingDocumentType     : abap.char(2);

      //    NTS Hidden data
      @EndUserText.label         : 'Business Place'
      @UI.hidden                 : true
      BusinessPlaceName          : abap.char(30);

      @EndUserText.label         : 'Supplier Business Sub Number'
      SupBizSubNo                : abap.char(4);

      @EndUserText.label         : 'Buyer Business No'
      ByrBizNo                   : abap.char(13);

      @EndUserText.label         : 'Tax Classification 1'
      @ObjectModel.text.element  : [ 'BillTypeText' ]
      @Consumption               : {
        filter                   : {
          selectionType          : #SINGLE
        },
        valueHelpDefinition      : [{
          entity                 :{
            name                 : 'ZMCDAP_V_BILL_TYPE',
            element              : 'BillType'
          }
        }]
      }
      @UI.selectionField         : [{ position: 250 }]
      @UI.textArrangement        : #TEXT_ONLY
      //      @UI.hidden: true
      BillType                   : abap.char(1);

      @EndUserText.label         : 'Issue Date'
      @Consumption               : {
        filter                   : {
          selectionType          : #INTERVAL
        }
      }
      IssueDt                    : abap.dats(8);

      @EndUserText.label         : 'Send Date'
      @Consumption               : {
        filter                   : {
          selectionType          : #INTERVAL
        }
      }
      SendDt                     : abap.dats(8);

      @EndUserText.label         : 'Supplier CEO'
      SupRepNm                   : abap.char(100);

      @EndUserText.label         : 'Supplier Address'
      SupAddress                 : abap.char(1000);

      @EndUserText.label         : 'Buyer Business Sub Number'
      ByrBizSubNo                : abap.char(4);

      @EndUserText.label         : 'Buyer Business Name'
      ByrCorpNm                  : abap.char(200);

      @EndUserText.label         : 'Buyer CEO'
      ByrRepNm                   : abap.char(100);

      @EndUserText.label         : 'Buyer Address'
      ByrAddress                 : abap.char(1000);

      @EndUserText.label         : 'Tax Classification 2'
      @UI.selectionField         : [{ position: 270 }]
      TaxClsf                    : abap.char(30);

      @EndUserText.label         : 'Issue Type1'
      TaxKnd                     : abap.char(30);

      @EndUserText.label         : 'Issue Type2'
      IsnType                    : abap.char(30);

      @EndUserText.label         : 'Note'
      Bigo                       : abap.char(1333);

      @EndUserText.label         : 'Demand Type'
      DemandGb                   : abap.char(30);

      @EndUserText.label         : 'Supplier Email'
      SupEmail                   : abap.char(200);

      @EndUserText.label         : 'Buyer Email1'
//      @UI.lineItem               : [{ position: 410 }]
      ByrEmail1                  : abap.char(200);

      @EndUserText.label         : 'Buyer Email2'
//      @UI.lineItem               : [{ position: 430 }]
      ByrEmail2                  : abap.char(200);

      @EndUserText.label         : 'Item Date'
      @Consumption.filter.hidden : true
      ItemDt                     : abap.dats(8);

      @EndUserText.label         : 'Item Name'
//      @UI.lineItem               : [{ position: 510  }]
      ItemNm                     : abap.char(200);

      @EndUserText.label         : 'Item Standard'
      @Consumption.filter.hidden : true
      ItemStd                    : abap.char(200);

      @EndUserText.label         : 'Item Quantity'
      @Consumption.filter.hidden : true
      ItemQty                    : abap.char(30);

      @EndUserText.label         : 'Item Unit Price'
      @Semantics.amount.currencyCode: 'DefCurrency'
      @Consumption.filter.hidden : true
      ItemUnt                    : abap.curr(30,2);

      @EndUserText.label         : 'Item Net Amount'
      @Semantics.amount.currencyCode: 'DefCurrency'
      @Consumption.filter.hidden : true
      ItemSupAmt                 : abap.curr(23,2);

      @EndUserText.label         : 'Item Tax Amount'
      @Semantics.amount.currencyCode: 'DefCurrency'
      @Consumption.filter.hidden : true
      ItemTaxAmt                 : abap.curr(23,2);

      @EndUserText.label         : 'Item Note'
      @Consumption.filter.hidden : true
      ItemBigo                   : abap.char(200);

      @EndUserText.label         : 'Item State'
      @UI.lineItem               :[{ hidden: true }]
      @Consumption.filter.hidden : true
      ItemState                  : zmcdde_item_state_type;

      @UI.hidden                 : true
      BillTypeText               : abap.char(60);

      @EndUserText.label         : 'Item State'
      @UI.hidden                 : true
      @Consumption.filter.hidden : true
      ItemStateText              : abap.char(60);
        
      @EndUserText.label: 'Consignee Business No'
//      @UI.lineItem               : [{ position: 450 }]
      CstnBizNO                  : abap.char(10);
      @EndUserText.label: 'Consignee Business Name'
      CstnCorpNm                 : abap.char(250);
      
      @EndUserText.label: 'Created At (NTS)'
//      @UI.lineItem               : [{ position: 470 }]
      CreatedAt                  : abp_creation_tstmpl;
      @EndUserText.label: 'Created By (NTS)'
      CreatedBy                  : abp_creation_user;
      @EndUserText.label: 'Last Changed At (NTS)'
//      @UI.lineItem               : [{ position: 490 }]
      LastChangedAt              : abp_lastchange_tstmpl;
      @EndUserText.label: 'Last Changed By (NTS)'
      LastChangedBy              : abp_lastchange_user;
      @EndUserText.label: 'Local Last Changed At (NTS)'
      LocalLastChangedAt         : abp_locinst_lastchange_tstmpl;
      @EndUserText.label: 'Local Last Changed By (NTS)'
      LocalLastChangedBy         : abp_locinst_lastchange_user;

      _VHSupplier                : association to ZMCDAP_V_SUPPLIER on $projection.SupBizNo = _VHSupplier.Supplier;

}
