@AbapCatalog.preserveKey: true
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.sqlViewName: 'ZCFIGLACCTFLOW'
@EndUserText.label: 'G/L Account Balance with Flow-Measure'
@Analytics.query: true
@AccessControl.authorizationCheck: #PRIVILEGED_ONLY

@Analytics.settings.maxProcessingEffort: #HIGH
@ClientHandling.algorithm: #SESSION_VARIABLE
@AbapCatalog.buffering.status: #NOT_ALLOWED
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType.sizeCategory: #XXL
@ObjectModel.usageType.serviceQuality: #D
@ObjectModel.usageType.dataClass:  #MIXED

@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define view ZMCDGL_C_GLACCOUNTFLOW 
as select from ZMCDGL_I_GLACCOUNTBALANCE
{
  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  SourceLedger,

  ------------------------------------------------------------------------------------------------------
  -- FREE
  ------------------------------------------------------------------------------------------------------
  @Consumption.filter: {selectionType: #SINGLE, multipleSelections: false, mandatory: true }
//  @Consumption.derivation: { lookupEntity: 'I_LedgerStdVH',
//        resultElement: 'Ledger', binding: [
//        { targetElement : 'IsLeadingLedger' , type : #CONSTANT, value : 'X' } ]
//       }
  //    @Consumption.valueHelp: '_Ledger'
  @AnalyticsDetails.query.variableSequence: 10
  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  Ledger,

  @Consumption.filter: { selectionType: #SINGLE, multipleSelections: true, mandatory: true }
  @AnalyticsDetails.query.variableSequence: 20
  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  //    @AnalyticsDetails.query.display: #KEY_TEXT
  CompanyCode,

  @Consumption.filter: { selectionType: #RANGE, multipleSelections: true, mandatory: false }
  @AnalyticsDetails.query.variableSequence: 30
  @AnalyticsDetails.query.axis: #ROWS
  //    @AnalyticsDetails.query.totals: #SHOW
  @AnalyticsDetails.query.display: #KEY_TEXT
  GLAccount,

  @Consumption.filter: { selectionType: #SINGLE, multipleSelections: false, mandatory: false}
  @AnalyticsDetails.query.variableSequence: 40
  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  LedgerFiscalYear,

  @Consumption.filter: {selectionType: #RANGE, multipleSelections: false, mandatory: false}
  @AnalyticsDetails.query.variableSequence : 50
  @AnalyticsDetails.query.axis: #ROWS
  //    @AnalyticsDetails.query.totals: #SHOW
  FiscalYearPeriod,

  @Consumption.filter: {selectionType: #RANGE, multipleSelections: false, mandatory: false}
  @AnalyticsDetails.query.variableSequence : 51
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PostingDate,

  @Consumption.filter: {selectionType: #SINGLE, multipleSelections: true, mandatory: false}
  //  @Consumption.valueHelp: '_GLAccountTypeFlowType'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_GLAccountTypeFlowType' , element: 'GLAccountTypeFlowType' } }]
  @AnalyticsDetails.query.variableSequence : 70
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  @AnalyticsDetails.query.display: #KEY_TEXT
  GLAccountTypeFlowType,

  //  @Consumption.filter: {selectionType: #RANGE, multipleSelections: true, mandatory: false}
  //  @Consumption.valueHelp: '_GLAccountFlowType'
  //  @AnalyticsDetails.query.variableSequence : 50
  @AnalyticsDetails.query.axis: #ROWS
  //    @AnalyticsDetails.query.totals: #SHOW
  @AnalyticsDetails.query.display: #KEY_TEXT
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_GLAccountFlowType' , element: 'GLAccountFlowType' } }]
  GLAccountFlowType,

  //    @Consumption.filter: {selectionType: #SINGLE, multipleSelections: true, mandatory: false}
  //    @AnalyticsDetails.query.variableSequence : 60
  @AnalyticsDetails.query.axis: #ROWS
  //    @AnalyticsDetails.query.totals: #SHOW
  IsBalanceSheetAccount,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  AccountingDocument,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  LedgerGLLineItem,

  @Consumption.filter: {selectionType: #SINGLE, multipleSelections: false, mandatory: false}
  //  @Consumption.valueHelp: '_GLAccountTypeFlowType'
  @AnalyticsDetails.query.variableSequence : 99
  @AnalyticsDetails.query.axis: #FREE
  //  //    @AnalyticsDetails.query.totals: #SHOW
  FiscalYear,

  /*
      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.totals: #SHOW
  GLRecordType,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  ChartOfAccounts,

  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #FREE
  @AnalyticsDetails.query.display: #KEY_TEXT
  ControllingArea,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  FinancialTransactionType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  BusinessTransactionType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  ReferenceDocumentType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  LogicalSystem,

  /*
      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  ReferenceDocumentContext,

      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  ReferenceDocument,

      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  ReferenceDocumentItem,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  ReferenceDocumentItemGroup,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  IsReversal,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  IsReversed,

  /*
      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  ReversalReferenceDocumentCntxt,

      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  ReversalReferenceDocument,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  IsSettlement,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  IsSettled,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PredecessorReferenceDocType,

  /*
      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  PredecessorReferenceDocCntxt,

      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  PredecessorReferenceDocument,

      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  PredecessorReferenceDocItem,

      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  SourceReferenceDocumentType,

      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  SourceLogicalSystem,

      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  SourceReferenceDocumentCntxt,

      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  SourceReferenceDocument,

      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  SourceReferenceDocumentItem,

      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  SourceReferenceDocSubitem,

      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  IsCommitment,

      @AnalyticsDetails.query.axis: #FREE
      @AnalyticsDetails.query.display: #KEY_TEXT
  JrnlEntryItemObsoleteReason,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  CostCenter,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  ProfitCenter,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  FunctionalArea,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  BusinessArea,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  Segment,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerCostCenter,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerProfitCenter,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerFunctionalArea,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerBusinessArea,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerCompany,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerSegment,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  DebitCreditCode,

  @Consumption.filter: {selectionType: #RANGE, multipleSelections: false, mandatory: false}
  @AnalyticsDetails.query.variableSequence : 52
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  FiscalPeriod,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  //@Consumption.derivation: { lookupEntity: 'I_FiscalYearPeriodForLedger',
  //                           resultElement: 'FiscalYearVariant', binding: [
  //    { targetElement : 'CompanyCode' , type : #ELEMENT, value : 'CompanyCode' },
  //    { targetElement : 'Ledger' , type : #ELEMENT , value : 'Ledger'},
  //    { targetElement : 'FiscalYear' , type : #CONSTANT , value : '2018'} ,
  //    { targetElement : 'FiscalPeriod' , type : #CONSTANT , value : '001'} ]
  //   }
  FiscalYearVariant,

  /*
  DocumentDate,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  AccountingDocumentType,

  /*
  AccountingDocumentItem,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  AssignmentReference,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  AccountingDocumentCategory,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PostingKey,

  ------------------------------------------------------------------------------------------------------
  -- MEASURES
  ------------------------------------------------------------------------------------------------------

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  @Semantics.currencyCode:true
  BalanceTransactionCurrency,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'BalanceTransactionCurrency'
  AmountInBalanceTransacCrcy,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'BalanceTransactionCurrency'
//  FlowAmountInBalanceTransCrcy,
//  @AnalyticsDetails.query.hidden: true
//  @AnalyticsDetails.query.axis: #COLUMNS
//  @DefaultAggregation: #SUM
//  @Semantics.amount.currencyCode: 'BalanceTransactionCurrency'
  DebitAmountInBalanceTransCrcy,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'BalanceTransactionCurrency'
  CreditAmountInBalanceTransCrcy,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  @Semantics.currencyCode:true
  TransactionCurrency,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'TransactionCurrency'
  AmountInTransactionCurrency,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'TransactionCurrency'
//  FlowAmountInTransCrcy,
//  @AnalyticsDetails.query.hidden: true
//  @AnalyticsDetails.query.axis: #COLUMNS
//  @DefaultAggregation: #SUM
//  @Semantics.amount.currencyCode: 'TransactionCurrency'
  DebitAmountInTransCrcy,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'TransactionCurrency'
  CreditAmountInTransCrcy,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  @Semantics.currencyCode:true
  CompanyCodeCurrency,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  AmountInCompanyCodeCurrency,
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//  FlowAmountInCoCodeCrcy,
//  @AnalyticsDetails.query.hidden: true
//  @AnalyticsDetails.query.axis: #COLUMNS
//  @DefaultAggregation: #SUM
//  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  DebitAmountInCoCodeCrcy,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  CreditAmountInCoCodeCrcy,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  @Semantics.currencyCode:true
  GlobalCurrency,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'GlobalCurrency'
  AmountInGlobalCurrency,
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'GlobalCurrency'
//  FlowAmountInGlobalCrcy,
//  @AnalyticsDetails.query.hidden: true
//  @AnalyticsDetails.query.axis: #COLUMNS
//  @DefaultAggregation: #SUM
//  @Semantics.amount.currencyCode: 'GlobalCurrency'
  DebitAmountInGlobalCrcy,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'GlobalCurrency'
  CreditAmountInGlobalCrcy,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  @Semantics.currencyCode:true
  FreeDefinedCurrency1,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency1'
  AmountInFreeDefinedCurrency1,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency1'
//  FlowAmountInFreeDfndCrcy1,
//  @AnalyticsDetails.query.hidden: true
//  @AnalyticsDetails.query.axis: #COLUMNS
//  @DefaultAggregation: #SUM
//  @Semantics.amount.currencyCode: 'FreeDefinedCurrency1'
  DebitAmountInFreeDfndCrcy1,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency1'
  CreditAmountInFreeDfndCrcy1,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  @Semantics.currencyCode:true
  FreeDefinedCurrency2,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency2'
  AmountInFreeDefinedCurrency2,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency2'
//  FlowAmountInFreeDfndCrcy2,
//  @AnalyticsDetails.query.hidden: true
//  @AnalyticsDetails.query.axis: #COLUMNS
//  @DefaultAggregation: #SUM
//  @Semantics.amount.currencyCode: 'FreeDefinedCurrency2'
  DebitAmountInFreeDfndCrcy2,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency2'
  CreditAmountInFreeDfndCrcy2,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  @Semantics.currencyCode:true
  FreeDefinedCurrency3,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency3'
  AmountInFreeDefinedCurrency3,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency3'
//  FlowAmountInFreeDfndCrcy3,
//  @AnalyticsDetails.query.hidden: true
//  @AnalyticsDetails.query.axis: #COLUMNS
//  @DefaultAggregation: #SUM
//  @Semantics.amount.currencyCode: 'FreeDefinedCurrency3'
  DebitAmountInFreeDfndCrcy3,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency3'
  CreditAmountInFreeDfndCrcy3,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  @Semantics.currencyCode:true
  FreeDefinedCurrency4,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency4'
  AmountInFreeDefinedCurrency4,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency4'
//  FlowAmountInFreeDfndCrcy4,
//  @AnalyticsDetails.query.hidden: true
//  @AnalyticsDetails.query.axis: #COLUMNS
//  @DefaultAggregation: #SUM
//  @Semantics.amount.currencyCode: 'FreeDefinedCurrency4'
  DebitAmountInFreeDfndCrcy4,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency4'
  CreditAmountInFreeDfndCrcy4,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  @Semantics.currencyCode:true
  FreeDefinedCurrency5,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency5'
  AmountInFreeDefinedCurrency5,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency5'
//  FlowAmountInFreeDfndCrcy5,
//  @AnalyticsDetails.query.hidden: true
//  @AnalyticsDetails.query.axis: #COLUMNS
//  @DefaultAggregation: #SUM
//  @Semantics.amount.currencyCode: 'FreeDefinedCurrency5'
  DebitAmountInFreeDfndCrcy5,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency5'
  CreditAmountInFreeDfndCrcy5,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  @Semantics.currencyCode:true
  FreeDefinedCurrency6,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency6'
  AmountInFreeDefinedCurrency6,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency6'
//  FlowAmountInFreeDfndCrcy6,
//  @AnalyticsDetails.query.hidden: true
//  @AnalyticsDetails.query.axis: #COLUMNS
//  @DefaultAggregation: #SUM
//  @Semantics.amount.currencyCode: 'FreeDefinedCurrency6'
  DebitAmountInFreeDfndCrcy6,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency6'
  CreditAmountInFreeDfndCrcy6,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  @Semantics.currencyCode:true
  FreeDefinedCurrency7,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency7'
  AmountInFreeDefinedCurrency7,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency7'
//  FlowAmountInFreeDfndCrcy7,
//  @AnalyticsDetails.query.hidden: true
//  @AnalyticsDetails.query.axis: #COLUMNS
//  @DefaultAggregation: #SUM
//  @Semantics.amount.currencyCode: 'FreeDefinedCurrency7'
  DebitAmountInFreeDfndCrcy7,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency7'
  CreditAmountInFreeDfndCrcy7,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  @Semantics.currencyCode:true
  FreeDefinedCurrency8,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency8'
  AmountInFreeDefinedCurrency8,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency8'
//  FlowAmountInFreeDfndCrcy8,
//  @AnalyticsDetails.query.hidden: true
//  @AnalyticsDetails.query.axis: #COLUMNS
//  @DefaultAggregation: #SUM
//  @Semantics.amount.currencyCode: 'FreeDefinedCurrency8'
  DebitAmountInFreeDfndCrcy8,
  @AnalyticsDetails.query.hidden: true
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'FreeDefinedCurrency8'
  CreditAmountInFreeDfndCrcy8,

  /*
  FixedAmountInGlobalCrcy,
  GrpValnFixedAmtInGlobCrcy,
  PrftCtrValnFxdAmtInGlobCrcy,
  TotalPriceVarcInGlobalCrcy,
  GrpValnTotPrcVarcInGlobCrcy,
  PrftCtrValnTotPrcVarcInGlbCrcy,
  FixedPriceVarcInGlobalCrcy,
  GrpValnFixedPrcVarcInGlobCrcy,
  PrftCtrValnFxdPrcVarcInGlbCrcy,
  ControllingObjectCurrency,
  AmountInObjectCurrency,
  BaseUnit,
  Quantity,
  FixedQuantity,
  CostSourceUnit,
  ValuationQuantity,
  ValuationFixedQuantity,
  AdditionalQuantity1Unit,
  AdditionalQuantity1,
  AdditionalQuantity2Unit,
  AdditionalQuantity2,
  AdditionalQuantity3Unit,
  AdditionalQuantity3,
      ------------------------------------------------------------------------------------------------------
      -- MEASURES
      ------------------------------------------------------------------------------------------------------
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  TransactionTypeDetermination,

  /*
  SubLedgerAcctLineItemType,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  AccountingDocCreatedByUser,

  /*
  LastChangeDateTime,
  CreationDateTime,
  CreationDate,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  EliminationProfitCenter,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  OriginObjectType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  GLAccountType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  @AnalyticsDetails.query.display: #KEY_TEXT
  AlternativeGLAccount,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  CountryChartOfAccounts,

  /*
  InvoiceReference,
  InvoiceReferenceFiscalYear,
  FollowOnDocumentType,
  InvoiceItemReference,
  ReferencePurchaseOrderCategory,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PurchasingDocument,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PurchasingDocumentItem,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  AccountAssignmentNumber,

  /*
  DocumentItemText,
  */

  @AnalyticsDetails.query.axis: #FREE
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'SalesDocument'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'SalesDocument'
  //    @AnalyticsDetails.query.totals: #SHOW
  SalesOrder,

  @AnalyticsDetails.query.axis: #FREE
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'SalesDocumentItem'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'SalesDocumentItem'
  //    @AnalyticsDetails.query.totals: #SHOW
  SalesOrderItem,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  SalesDocument,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  SalesDocumentItem,

  @AnalyticsDetails.query.axis: #FREE
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'Product'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'Product'
  //    @AnalyticsDetails.query.totals: #SHOW
  cast( Product as matnr preserving type )                                                   as Material,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  Product,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  Plant,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  Supplier,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  Customer,

  /*
  ServicesRenderedDate,
  ConditionContract,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  FinancialAccountType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  SpecialGLCode,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  TaxCode,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  HouseBank,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  HouseBankAccount,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  IsOpenItemManaged,

  /*
  ClearingDate,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:    'ClearingJournalEntry'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'ClearingJournalEntry'
  ClearingAccountingDocument,

  @AnalyticsDetails.query.axis: #FREE
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:    'ClearingJournalEntryFiscalYear'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'ClearingJournalEntryFiscalYear'
  ClearingDocFiscalYear,
  @AnalyticsDetails.query.axis: #FREE
  ClearingJournalEntry,
  @AnalyticsDetails.query.axis: #FREE
  ClearingJournalEntryFiscalYear,
  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  AssetDepreciationArea,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  MasterFixedAsset,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  FixedAsset,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  AssetValueDate,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  AssetTransactionType,


  /*AssetAcctTransClassfctn,
  DepreciationFiscalPeriod,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  GroupMasterFixedAsset,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  GroupFixedAsset,

  /*
  CostEstimate,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'InvtrySpecialStockValnType_2'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'InvtrySpecialStockValnType_2'
  InventorySpecialStockValnType,
  @AnalyticsDetails.query.axis: #FREE
  InvtrySpecialStockValnType_2,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  InventorySpecialStockType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  InventorySpclStkSalesDocument,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  InventorySpclStkSalesDocItm,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  InvtrySpclStockWBSElmntIntID,

//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'InvtrySpclStockWBSElmntExtID'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'InvtrySpclStockWBSElmntExtID'
  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
//  _InvtrySpclStkWBSElmntBscData.WBSElement                                                   as InventorySpclStockWBSElement,
//  @AnalyticsDetails.query.axis: #FREE
//  cast(_InvtrySpclStkWBSElmntBscData.WBSElementExternalID as fis_invspstock_wbsext_no_conv ) as InvtrySpclStockWBSElmntExtID,

//  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  InventorySpecialStockSupplier,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  InventoryValuationType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  ValuationArea,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  SenderGLAccount,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  SenderAccountAssignment,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  SenderAccountAssignmentType,

  /*
  CostOriginGroup,
  OriginSenderObject,
  ControllingDebitCreditCode,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  ControllingObjectDebitType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  QuantityIsIncomplete,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  OffsettingAccount,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  OffsettingAccountType,

  /*
  OffsettingChartOfAccounts,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  LineItemIsCompleted,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PersonnelNumber,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  ControllingObjectClass,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerCompanyCode,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerControllingObjectClass,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  OriginCostCenter,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  OriginProfitCenter,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  OriginCostCtrActivityType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  AccountAssignment,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  AccountAssignmentType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  CostCtrActivityType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  OrderID,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  OrderCategory,


  @AnalyticsDetails.query.axis: #FREE
  //      @AnalyticsDetails.query.totals: #SHOW
  WBSElementInternalID,

//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'WBSElementExternalID'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'WBSElementExternalID'
  @AnalyticsDetails.query.axis: #FREE
//  cast( WBSElement as fis_wbs preserving type ) as WBSElement,

//  @AnalyticsDetails.query.axis: #FREE
//  cast( _WBSElementBasicData.WBSElementExternalID as fis_wbsext_no_conv )                    as WBSElementExternalID,


//  @AnalyticsDetails.query.axis: #FREE
  //      @AnalyticsDetails.query.totals: #SHOW
  ProjectInternalID,

//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'ProjectExternalID'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'ProjectExternalID'
  @AnalyticsDetails.query.axis: #FREE
//  cast( Project as fis_project preserving type ) as Project,
  
//  @AnalyticsDetails.query.axis: #FREE
//  cast( _ProjectBasicData.ProjectExternalID as fis_projectext_no_conv )                      as ProjectExternalID,

//  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  OperatingConcern,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  ProjectNetwork,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  RelatedNetworkActivity,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  BusinessProcess,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  CostObject,

  /*
  BillableControl,
  CostAnalysisResource,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  CustomerServiceNotification,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerAccountAssignment,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerAccountAssignmentType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  WorkPackage,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  WorkItem,
  @AnalyticsDetails.query.axis: #FREE
  ServiceDocumentType,
  @AnalyticsDetails.query.axis: #FREE
  ServiceDocument,
  @AnalyticsDetails.query.axis: #FREE
  ServiceDocumentItem,
  @AnalyticsDetails.query.axis: #FREE
  ServiceContractType,
  @AnalyticsDetails.query.axis: #FREE
  ServiceContract,
  @AnalyticsDetails.query.axis: #FREE
  ServiceContractItem,
  @AnalyticsDetails.query.axis: #FREE
  TimeSheetOvertimeCategory,
  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerCostCtrActivityType,
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:    'PartnerOrder_2'
//  @VDM.lifecycle.status:     #DEPRECATED
//  @VDM.lifecycle.successor:  'PartnerOrder_2'
  @AnalyticsDetails.query.axis: #FREE
  PartnerOrder,
  @AnalyticsDetails.query.axis: #FREE
  PartnerOrder_2,
  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerOrderCategory,
  
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'PartnerWBSElementExternalID'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'PartnerWBSElementExternalID'
//  @AnalyticsDetails.query.axis: #FREE
//  cast( PartnerWBSElement as fis_partner_wbs preserving type ) as PartnerWBSElement,
//  @AnalyticsDetails.query.axis: #FREE
//  cast( _PartnerWBSElementBasicData.WBSElementExternalID as fis_partner_wbsext_no_conv )     as PartnerWBSElementExternalID,
  
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'PartnerProjectExternalID'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'PartnerProjectExternalID'
//  @AnalyticsDetails.query.axis: #FREE
//  cast( PartnerProject as fis_part_project preserving type ) as PartnerProject,
//  @AnalyticsDetails.query.axis: #FREE
//  cast( _PartnerProjectBasicData.ProjectExternalID as fis_part_projectext_no_conv )          as PartnerProjectExternalID,


  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerSalesDocument,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerSalesDocumentItem,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerProjectNetwork,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerProjectNetworkActivity,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerBusinessProcess,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerCostObject,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  BillingDocumentType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  SalesOrganization,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  DistributionChannel,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  OrganizationDivision,

//  @AnalyticsDetails.query.axis: #FREE
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'SoldProduct'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'SoldProduct'
  //    @AnalyticsDetails.query.totals: #SHOW
//  cast( SoldProduct as abap.char( 40 ) preserving type )                                   as SoldMaterial,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  SoldProduct,

  @AnalyticsDetails.query.axis: #FREE
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'SoldProductGroup'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'SoldProductGroup'
  //    @AnalyticsDetails.query.totals: #SHOW
//  cast( SoldProductGroup as abap.char( 9 ) preserving type )                                  as MaterialGroup,

//  @AnalyticsDetails.query.axis: #FREE
  ProductGroup,
  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  SoldProductGroup,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  CustomerGroup,

  /*
  CustomerSupplierCountry,
  CustomerSupplierIndustry,
  SalesDistrict,
  BillToParty,
  ShipToParty,
  CustomerSupplierCorporateGroup,
  */

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  FinancialManagementArea,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  Fund,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  GrantID,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  BudgetPeriod,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerFund,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerGrant,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  PartnerBudgetPeriod,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  FundsCenter,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  FundedProgram,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  JointVenture,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  JointVentureEquityGroup,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  JointVentureCostRecoveryCode,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  JointVentureEquityType,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  SettlementReferenceDate,

  /*
  WorkCenterInternalID,
  OrderOperation,
  OrderItem,
  OrderSuboperation,
  Equipment,
  FunctionalLocation,
  Assembly,
  MaintenanceActivityType,
  MaintenanceOrderPlanningCode,
  MaintPriorityType,
  MaintPriority,
  SuperiorOrder,
  ProductGroup,
  MaintenanceOrderIsPlanned,


  IsStatisticalOrder,
  IsStatisticalCostCenter,
  IsStatisticalSalesDocument,
  WBSIsStatisticalWBSElement,
  */
  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  CalendarYear,
  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  CalendarQuarter,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  CalendarYearQuarter,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  CalendarMonth,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  CalendarYearMonth,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  CalendarWeek,

  @AnalyticsDetails.query.axis: #FREE
  //    @AnalyticsDetails.query.totals: #SHOW
  CalendarYearWeek,
  @AnalyticsDetails.query.axis: #FREE
  FiscalQuarter,

  @AnalyticsDetails.query.axis: #FREE
  FiscalWeek,

  @AnalyticsDetails.query.axis: #FREE
  FiscalYearQuarter,

  @AnalyticsDetails.query.axis: #FREE
  FiscalYearWeek,

  @AnalyticsDetails.query.axis: #FREE
  AccrualObjectType,
  @AnalyticsDetails.query.axis: #FREE
  AccrualObject,
  @AnalyticsDetails.query.axis: #FREE
  AccrualSubobject,
  @AnalyticsDetails.query.axis: #FREE
  AccrualItemType,
  @AnalyticsDetails.query.axis: #FREE
  AssetClass

  /*
  GLAccountAuthorizationGroup,
  SupplierBasicAuthorizationGrp,
  CustomerBasicAuthorizationGrp,
  AcctgDocTypeAuthorizationGroup,
  OrderType,
  SalesOrderType,
  AssetClass,
  */
}
