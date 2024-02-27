@AbapCatalog.preserveKey: true
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.sqlViewName: 'ZPIFIGLACOUNTBL'
@AccessControl.authorizationCheck: #CHECK
@ClientHandling.algorithm: #SESSION_VARIABLE
@AbapCatalog.buffering.status: #NOT_ALLOWED
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST, #UNION]
define view ZMCDGL_P_GLACCOUNTBALANCE 
as select from ZMCDGL_P_GLACCOUNTBALANCE2


  association [0..1] to I_FiscalYearPeriodForCmpnyCode as _FiscalPeriod               on  $projection.LedgerFiscalYear = _FiscalPeriod.FiscalYear
                                                                                      and $projection.FiscalPeriod     = _FiscalPeriod.FiscalPeriod
                                                                                      and $projection.CompanyCode      = _FiscalPeriod.CompanyCode
  association [0..1] to I_FiscalPeriodForVariant       as _FiscalPeriodForVariant     on  $projection.LedgerFiscalYear  = _FiscalPeriodForVariant.FiscalYear
                                                                                      and $projection.FiscalPeriod      = _FiscalPeriodForVariant.FiscalPeriod
                                                                                      and $projection.FiscalYearVariant = _FiscalPeriodForVariant.FiscalYearVariant
  association [0..1] to I_FiscalCalYearPeriodForCoCode as _FiscalYearPeriod           on  $projection.FiscalYearPeriod = _FiscalYearPeriod.FiscalYearPeriod
                                                                                      and $projection.CompanyCode      = _FiscalYearPeriod.CompanyCode
  association [0..1] to I_FiscalYearPeriodForVariant   as _FiscalYearPeriodForVariant on  $projection.FiscalYearPeriod  = _FiscalYearPeriodForVariant.FiscalYearPeriod
                                                                                      and $projection.FiscalYearVariant = _FiscalYearPeriodForVariant.FiscalYearVariant
  association [0..1] to I_ServiceDocumentType          as _ServiceDocumentType        on  $projection.ServiceDocumentType = _ServiceDocumentType.ServiceDocumentType

  association [0..1] to I_SrvcDocByDocumentType        as _ServiceDocument            on  $projection.ServiceDocumentType = _ServiceDocument.ServiceDocumentType
                                                                                      and $projection.ServiceDocument     = _ServiceDocument.ServiceDocument

  association [0..1] to I_SrvcDocItemByDocumentType    as _ServiceDocumentItem        on  $projection.ServiceDocumentType = _ServiceDocumentItem.ServiceDocumentType
                                                                                      and $projection.ServiceDocument     = _ServiceDocumentItem.ServiceDocument
                                                                                      and $projection.ServiceDocumentItem = _ServiceDocumentItem.ServiceDocumentItem

  association [0..1] to I_ServiceDocumentType          as _ServiceContractType        on  $projection.ServiceContractType = _ServiceContractType.ServiceDocumentType

  association [0..1] to I_SrvcDocByDocumentType        as _ServiceContract            on  $projection.ServiceContractType = _ServiceContract.ServiceDocumentType
                                                                                      and $projection.ServiceContract     = _ServiceContract.ServiceDocument

  association [0..1] to I_SrvcDocItemByDocumentType    as _ServiceContractItem        on  $projection.ServiceContractType = _ServiceContractItem.ServiceDocumentType
                                                                                      and $projection.ServiceContract     = _ServiceContractItem.ServiceDocument
                                                                                      and $projection.ServiceContractItem = _ServiceContractItem.ServiceDocumentItem

//  association [0..1] to I_AccrualObject                as _AccrualObject              on  $projection.AccrualObjectType          = _AccrualObject.AccrualObjectType
//                                                                                      and $projection.AccrualObjectLogicalSystem = _AccrualObject.AccrualObjectLogicalSystem
//                                                                                      and $projection.CompanyCode                = _AccrualObject.CompanyCode
//                                                                                      and $projection.AccrualObject              = _AccrualObject.AccrualObject

//  association [0..1] to I_AccrualSubObject             as _AccrualSubobject           on  $projection.AccrualObjectType          = _AccrualSubobject.AccrualObjectType
//                                                                                      and $projection.AccrualObjectLogicalSystem = _AccrualSubobject.AccrualObjectLogicalSystem
//                                                                                      and $projection.CompanyCode                = _AccrualSubobject.CompanyCode
//                                                                                      and $projection.AccrualObject              = _AccrualSubobject.AccrualObject
//                                                                                      and $projection.AccrualSubobject           = _AccrualSubobject.AccrualSubobject

//  association [0..*] to I_FunctionalLocationText       as _FunctionalLocationText     on  _FunctionalLocationText.FunctionalLocation = $projection.FunctionalLocation

//  association [1..1] to E_JournalEntryItem             as _Extension                  on  $projection.SourceLedger       = _Extension.SourceLedger
//                                                                                      and $projection.CompanyCode        = _Extension.CompanyCode
//                                                                                      and $projection.FiscalYear         = _Extension.FiscalYear
//                                                                                      and $projection.AccountingDocument = _Extension.AccountingDocument
//                                                                                      and $projection.LedgerGLLineItem   = _Extension.LedgerGLLineItem
{
      //I_GLAccountLineItem
      @ObjectModel.foreignKey.association: '_SourceLedger'
  key SourceLedger,
      @ObjectModel.foreignKey.association: '_CompanyCode'
  key CompanyCode,
      @ObjectModel.foreignKey.association: '_FiscalYear'
  key FiscalYear,
      @ObjectModel.foreignKey.association: '_JournalEntry'
  key AccountingDocument,
  key LedgerGLLineItem,
      @ObjectModel.foreignKey.association: '_Ledger'
  key Ledger,

      @ObjectModel.foreignKey.association: '_LedgerFiscalYearForVariant'
      @Semantics.fiscal.year: true
      LedgerFiscalYear,
      GLRecordType,
      @ObjectModel.foreignKey.association: '_ChartOfAccounts'
      ChartOfAccounts,
      @ObjectModel.foreignKey.association: '_ControllingArea'
      ControllingArea,
      @ObjectModel.foreignKey.association: '_FinancialTransactionType'
      FinancialTransactionType,
      @ObjectModel.foreignKey.association: '_BusinessTransactionType'
      BusinessTransactionType,
      @ObjectModel.foreignKey.association: '_ReferenceDocumentType'
      ReferenceDocumentType,
//      @ObjectModel.foreignKey.association: '_LogicalSystem'
      LogicalSystem,
      ReferenceDocumentContext,
      ReferenceDocument,
      ReferenceDocumentItem,
      ReferenceDocumentItemGroup,
      IsReversal,
      IsReversed,
      ReversalReferenceDocumentCntxt,
      ReversalReferenceDocument,
      IsSettlement,
      IsSettled,
      @ObjectModel.foreignKey.association: '_PredecessorReferenceDocType'
      PredecessorReferenceDocType,
      PredecessorReferenceDocCntxt,
      PredecessorReferenceDocument,
      PredecessorReferenceDocItem,
      SourceReferenceDocumentType,
      SourceLogicalSystem,
      SourceReferenceDocumentCntxt,
      SourceReferenceDocument,
      SourceReferenceDocumentItem,
      SourceReferenceDocSubitem,
      IsCommitment,
      JrnlEntryItemObsoleteReason,
      @ObjectModel.foreignKey.association: '_GLAccountInChartOfAccounts'
      GLAccount,
      @ObjectModel.foreignKey.association: '_CostCenter'
      CostCenter,
      @ObjectModel.foreignKey.association: '_ProfitCenter'
      ProfitCenter,
      @ObjectModel.foreignKey.association: '_FunctionalArea'
      FunctionalArea,
      @ObjectModel.foreignKey.association: '_BusinessArea'
      BusinessArea,
      @ObjectModel.foreignKey.association: '_Segment'
      Segment,
      @ObjectModel.foreignKey.association: '_PartnerCostCenter'
      PartnerCostCenter,
      @ObjectModel.foreignKey.association: '_PartnerProfitCenter'
      PartnerProfitCenter,
      @ObjectModel.foreignKey.association: '_PartnerFunctionalArea'
      PartnerFunctionalArea,
      @ObjectModel.foreignKey.association: '_PartnerBusinessArea'
      PartnerBusinessArea,
      @ObjectModel.foreignKey.association: '_PartnerCompany'
      PartnerCompany,
      PartnerSegment,

      @ObjectModel.foreignKey.association: '_BalanceTransactionCurrency'
      @Semantics.currencyCode:true
      BalanceTransactionCurrency,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'BalanceTransactionCurrency'} }
      AmountInBalanceTransacCrcy,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'BalanceTransactionCurrency'} }
//      FlowAmountInBalanceTransCrcy,
//      @DefaultAggregation: #SUM
//      @Semantics: { amount : {currencyCode: 'BalanceTransactionCurrency'} }
      DebitAmountInBalanceTransCrcy,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'BalanceTransactionCurrency'} }
      CreditAmountInBalanceTransCrcy,

      @ObjectModel.foreignKey.association: '_TransactionCurrency'
      @Semantics.currencyCode:true
      TransactionCurrency,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      AmountInTransactionCurrency,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
//      FlowAmountInTransCrcy,
//      @DefaultAggregation: #SUM
//      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      DebitAmountInTransCrcy,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      CreditAmountInTransCrcy,

      @ObjectModel.foreignKey.association: '_CompanyCodeCurrency'
      @Semantics.currencyCode:true
      CompanyCodeCurrency,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      AmountInCompanyCodeCurrency,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
//      FlowAmountInCoCodeCrcy,
//      @DefaultAggregation: #SUM
//      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      AmountInCompanyCodeCurrency                                                                  as HelpChangingAmountInCoCodeCrcy,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      DebitAmountInCoCodeCrcy,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      CreditAmountInCoCodeCrcy,

      @ObjectModel.foreignKey.association: '_GlobalCurrency'
      @Semantics.currencyCode:true
      GlobalCurrency,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'GlobalCurrency'} }
      AmountInGlobalCurrency,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'GlobalCurrency'} }
//      FlowAmountInGlobalCrcy,
//      @DefaultAggregation: #SUM
//      @Semantics: { amount : {currencyCode: 'GlobalCurrency'} }
      DebitAmountInGlobalCrcy,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'GlobalCurrency'} }
      CreditAmountInGlobalCrcy,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'GlobalCurrency'} }
      FixedAmountInGlobalCrcy,
      @ObjectModel.foreignKey.association: '_FreeDefinedCurrency1'
      @Semantics.currencyCode:true
      FreeDefinedCurrency1,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency1'} }
      AmountInFreeDefinedCurrency1,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency1'} }
//      FlowAmountInFreeDfndCrcy1,
//      @DefaultAggregation: #SUM
//      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency1'} }
      DebitAmountInFreeDfndCrcy1,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency1'} }
      CreditAmountInFreeDfndCrcy1,

      @ObjectModel.foreignKey.association: '_FreeDefinedCurrency2'
      @Semantics.currencyCode:true
      FreeDefinedCurrency2,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency2'} }
      AmountInFreeDefinedCurrency2,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency2'} }
//      FlowAmountInFreeDfndCrcy2,
//      @DefaultAggregation: #SUM
//      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency2'} }
      DebitAmountInFreeDfndCrcy2,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency2'} }
      CreditAmountInFreeDfndCrcy2,

      @ObjectModel.foreignKey.association: '_FreeDefinedCurrency3'
      @Semantics.currencyCode:true
      FreeDefinedCurrency3,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency3'} }
      AmountInFreeDefinedCurrency3,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency3'} }
//      FlowAmountInFreeDfndCrcy3,
//      @DefaultAggregation: #SUM
//      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency3'} }
      DebitAmountInFreeDfndCrcy3,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency3'} }
      CreditAmountInFreeDfndCrcy3,

      @ObjectModel.foreignKey.association: '_FreeDefinedCurrency4'
      @Semantics.currencyCode:true
      FreeDefinedCurrency4,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency4'} }
      AmountInFreeDefinedCurrency4,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency4'} }
//      FlowAmountInFreeDfndCrcy4,
//      @DefaultAggregation: #SUM
//      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency4'} }
      DebitAmountInFreeDfndCrcy4,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency4'} }
      CreditAmountInFreeDfndCrcy4,

      @ObjectModel.foreignKey.association: '_FreeDefinedCurrency5'
      @Semantics.currencyCode:true
      FreeDefinedCurrency5,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency5'} }
      AmountInFreeDefinedCurrency5,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency5'} }
//      FlowAmountInFreeDfndCrcy5,
//      @DefaultAggregation: #SUM
//      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency5'} }
      DebitAmountInFreeDfndCrcy5,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency5'} }
      CreditAmountInFreeDfndCrcy5,

      @ObjectModel.foreignKey.association: '_FreeDefinedCurrency6'
      @Semantics.currencyCode:true
      FreeDefinedCurrency6,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency6'} }
      AmountInFreeDefinedCurrency6,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency6'} }
//      FlowAmountInFreeDfndCrcy6,
//      @DefaultAggregation: #SUM
//      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency6'} }
      DebitAmountInFreeDfndCrcy6,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency6'} }
      CreditAmountInFreeDfndCrcy6,

      @ObjectModel.foreignKey.association: '_FreeDefinedCurrency7'
      @Semantics.currencyCode:true
      FreeDefinedCurrency7,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency7'} }
      AmountInFreeDefinedCurrency7,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency7'} }
//      FlowAmountInFreeDfndCrcy7,
//      @DefaultAggregation: #SUM
//      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency7'} }
      DebitAmountInFreeDfndCrcy7,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency7'} }
      CreditAmountInFreeDfndCrcy7,

      @ObjectModel.foreignKey.association: '_FreeDefinedCurrency8'
      @Semantics.currencyCode:true
      FreeDefinedCurrency8,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency8'} }
      AmountInFreeDefinedCurrency8,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency8'} }
//      FlowAmountInFreeDfndCrcy8,
//      @DefaultAggregation: #SUM
//      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency8'} }
      DebitAmountInFreeDfndCrcy8,
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'FreeDefinedCurrency8'} }
      CreditAmountInFreeDfndCrcy8,
      @ObjectModel.foreignKey.association: '_CostSourceUnit'
      @Semantics.unitOfMeasure:true
      CostSourceUnit,
      @DefaultAggregation: #SUM
      @Semantics: { quantity : {unitOfMeasure: 'CostSourceUnit'} }
      ValuationQuantity,
//      @Consumption.valueHelp: '_GLAccountFlowType'
      @ObjectModel.foreignKey.association: '_GLAccountFlowType'
      GLAccountFlowType,

//      @Consumption.valueHelp: '_GLAccountTypeFlowType'
      @ObjectModel.foreignKey.association: '_GLAccountTypeFlowType'
      GLAccountTypeFlowType,

      IsBalanceSheetAccount,


      @ObjectModel.foreignKey.association: '_DebitCreditCode'
      DebitCreditCode,
      @ObjectModel.foreignKey.association: '_FiscalPeriodForVariant'
      @Semantics.fiscal.period: true
      FiscalPeriod,
      @ObjectModel.foreignKey.association: '_FiscalYearVariant'
      @Semantics.fiscal.yearVariant: true
      FiscalYearVariant,
      @ObjectModel.foreignKey.association: '_FiscalYearPeriodForVariant'
      @Semantics.fiscal.yearPeriod: true
      FiscalYearPeriod,
      //FiscalYearPeriod,
      PostingDate,
      DocumentDate,
      @ObjectModel.foreignKey.association: '_AccountingDocumentType'
      AccountingDocumentType,
      AccountingDocumentItem,
      AssignmentReference,
      @ObjectModel.foreignKey.association: '_AccountingDocumentCategory'
      AccountingDocumentCategory,
      @ObjectModel.foreignKey.association: '_PostingKey'
      PostingKey,

      TransactionTypeDetermination,
      @ObjectModel.foreignKey.association: '_SubLedgerAccLineItemType'
      SubLedgerAcctLineItemType,
      AccountingDocCreatedByUser,
      LastChangeDateTime,
      CreationDateTime,
      CreationDate,
      @ObjectModel.foreignKey.association: '_EliminationProfitCenter'
      EliminationProfitCenter,
      OriginObjectType,
      @ObjectModel.foreignKey.association: '_GLAccountType'
      GLAccountType,
      @ObjectModel.foreignKey.association: '_AlternativeGLAccount'
      AlternativeGLAccount,
      @ObjectModel.foreignKey.association: '_CountryChartOfAccounts'
      CountryChartOfAccounts,
      InvoiceReference,
      InvoiceReferenceFiscalYear,
      FollowOnDocumentType,
      InvoiceItemReference,
      ReferencePurchaseOrderCategory,
//      @ObjectModel.foreignKey.association: '_PurchasingDocument'
      PurchasingDocument,
//      @ObjectModel.foreignKey.association: '_PurchasingDocumentItem'
      PurchasingDocumentItem,
      AccountAssignmentNumber,
      DocumentItemText,
      //      @ObjectModel.foreignKey.association: '_SalesOrder'
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:   'SalesDocument'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: 'SalesDocument'
      SalesOrder,
      //      @ObjectModel.foreignKey.association: '_SalesOrderItem'
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:   'SalesDocumentItem'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: 'SalesDocumentItem'
      SalesOrderItem,
      @ObjectModel.foreignKey.association: '_SalesDocument'
      SalesDocument,
      @ObjectModel.foreignKey.association: '_SalesDocumentItem'
      SalesDocumentItem,
      //      @ObjectModel.foreignKey.association: '_Material'
      //      Material,
      @ObjectModel.foreignKey.association: '_Product'
      Product,
      @ObjectModel.foreignKey.association: '_Plant'
      Plant,
      @ObjectModel.foreignKey.association: '_Supplier'
      Supplier,
      @ObjectModel.foreignKey.association: '_Customer'
      Customer,
      ServicesRenderedDate,
      @ObjectModel.foreignKey.association: '_ConditionContract'
      ConditionContract,
      @ObjectModel.foreignKey.association: '_FinancialAccountType'
      FinancialAccountType,
      @ObjectModel.foreignKey.association: '_SpecialGLCode'
      SpecialGLCode,
      TaxCode,
      @ObjectModel.foreignKey.association: '_HouseBank'
      HouseBank,
//      @ObjectModel.foreignKey.association: '_HouseBankAccount'
      HouseBankAccount,
      IsOpenItemManaged,
      ClearingDate,

//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:    'ClearingJournalEntry'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: 'ClearingJournalEntry'
//      @ObjectModel.foreignKey.association: '_ClearingAccountingDocument'
      ClearingAccountingDocument,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_ClearingJournalEntry'
      ClearingJournalEntry,

//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:    'ClearingJournalEntryFiscalYear'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: 'ClearingJournalEntryFiscalYear'
      ClearingDocFiscalYear,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_ClearingJrnlEntryFiscalYear'
      ClearingJournalEntryFiscalYear,

      AssetDepreciationArea,
      @ObjectModel.foreignKey.association: '_MasterFixedAsset'
      MasterFixedAsset,
      @ObjectModel.foreignKey.association: '_FixedAsset'
      FixedAsset,
      AssetValueDate,
      @ObjectModel.foreignKey.association: '_AssetTransactionType'
      AssetTransactionType,
      @ObjectModel.foreignKey.association: '_MovementCategory'
      AssetAcctTransClassfctn,
      DepreciationFiscalPeriod,
      @ObjectModel.foreignKey.association: '_GroupMasterFixedAsset'
      GroupMasterFixedAsset,
      @ObjectModel.foreignKey.association: '_GroupFixedAsset'
      GroupFixedAsset,
      CostEstimate,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:   'InvtrySpecialStockValnType_2'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: 'InvtrySpecialStockValnType_2'
      @ObjectModel.foreignKey.association: '_InventorySpecialStockValnType'
      InventorySpecialStockValnType,
      @ObjectModel.foreignKey.association: '_InventorySpclStockValnType'
      InvtrySpecialStockValnType_2,
      @ObjectModel.foreignKey.association: '_InventorySpecialStockType'
      InventorySpecialStockType,
      @ObjectModel.foreignKey.association: '_InventorySpclStkSalesDocument'
      InventorySpclStkSalesDocument,
      @ObjectModel.foreignKey.association: '_InventorySpclStkSalesDocItm'
      InventorySpclStkSalesDocItm,
//      @ObjectModel.foreignKey.association: '_InvtrySpclStkWBSElmntBscData'
      InvtrySpclStockWBSElmntIntID,
      //      @ObjectModel.foreignKey.association: '_InvtrySpclStkWBSElmntBscData'
      //      InventorySpclStockWBSElement,
      //      @ObjectModel.foreignKey.association: '_InventorySpecialStockSupplier'
      InventorySpecialStockSupplier,
//      cast( _InvtrySpclStkWBSElmntBscData.WBSElementExternalID  as fis_invspstock_wbsext_no_conv ) as InvtrySpclStockWBSElmntExtID,
      @ObjectModel.foreignKey.association: '_InventoryValuationType'
      InventoryValuationType,
//      @ObjectModel.foreignKey.association: '_Purreqvaluationarea'
      ValuationArea,
      @ObjectModel.foreignKey.association: '_ServiceDocumentType'
      ServiceDocumentType,
      @ObjectModel.foreignKey.association: '_ServiceDocument'
      ServiceDocument,
      @ObjectModel.foreignKey.association: '_ServiceDocumentItem'
      ServiceDocumentItem,
      @ObjectModel.foreignKey.association: '_ServiceContractType'
      ServiceContractType,
      @ObjectModel.foreignKey.association: '_ServiceContract'
      ServiceContract,
      @ObjectModel.foreignKey.association: '_ServiceContractItem'
      ServiceContractItem,
      TimeSheetOvertimeCategory,
      SenderGLAccount,
      SenderAccountAssignment,
      SenderAccountAssignmentType,
      CostOriginGroup,
      @ObjectModel.foreignKey.association: '_OriginSenderObject'
      OriginSenderObject,
      @ObjectModel.foreignKey.association: '_ControllingDebitCreditCode'
      ControllingDebitCreditCode,
      ControllingObjectDebitType,
      QuantityIsIncomplete,
      @ObjectModel.foreignKey.association: '_OffsettingAccountWithBP'
      OffsettingAccount,
      @ObjectModel.foreignKey.association: '_OffsettingAccountType'
      OffsettingAccountType,
      @ObjectModel.foreignKey.association: '_OffsettingChartOfAccounts'
      OffsettingChartOfAccounts,
      LineItemIsCompleted,
      PersonnelNumber,
      @ObjectModel.foreignKey.association: '_ControllingObjectClass'
      ControllingObjectClass,
      @ObjectModel.foreignKey.association: '_PartnerCompanyCode'
      PartnerCompanyCode,
      @ObjectModel.foreignKey.association: '_PartnerControllingObjectClass'
      PartnerControllingObjectClass,
      @ObjectModel.foreignKey.association: '_OriginCostCenter'
      OriginCostCenter,
      @ObjectModel.foreignKey.association: '_OriginProfitCenter'
      OriginProfitCenter,
      @ObjectModel.foreignKey.association: '_OriginCostCtrActivityType'
      OriginCostCtrActivityType,
      AccountAssignment,
      AccountAssignmentType,
      @ObjectModel.foreignKey.association: '_CostCtrActivityType'
      CostCtrActivityType,
      @ObjectModel.foreignKey.association: '_Order'
      OrderID,
      @ObjectModel.foreignKey.association: '_OrderCategory'
      OrderCategory,
//      @ObjectModel.foreignKey.association: '_WBSElementBasicData'
      WBSElementInternalID,
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'WBSElementExternalID'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'WBSElementExternalID'      
//      WBSElement,
//      cast( _WBSElementBasicData.WBSElementExternalID as fis_wbsext_no_conv )                      as WBSElementExternalID,
//      @ObjectModel.foreignKey.association: '_ProjectBasicData'
      ProjectInternalID,
//      cast( _ProjectBasicData.ProjectExternalID  as fis_projectext_no_conv )                       as ProjectExternalID,
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'ProjectExternalID'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'ProjectExternalID'  
//      Project,
      @ObjectModel.foreignKey.association: '_OperatingConcern'
      OperatingConcern,
//      @ObjectModel.foreignKey.association: '_ProjectNetwork'
      ProjectNetwork,
      RelatedNetworkActivity,
//      @ObjectModel.foreignKey.association: '_BusinessProcess'
      BusinessProcess,
      CostObject,
      @ObjectModel.foreignKey.association: '_BillableControl'
      BillableControl,
      @ObjectModel.foreignKey.association: '_CostAnalysisResource'
      CostAnalysisResource,
      CustomerServiceNotification,
      PartnerAccountAssignment,
      PartnerAccountAssignmentType,
      WorkPackage,
      WorkItem,
      @ObjectModel.foreignKey.association: '_PartnerCostCtrActivityType'
      PartnerCostCtrActivityType,
      @ObjectModel.foreignKey.association: '_PartnerOrder'
      PartnerOrder,
      PartnerOrder_2,
      @ObjectModel.foreignKey.association: '_PartnerOrderCategory'
      PartnerOrderCategory,
//      @ObjectModel.foreignKey.association: '_PartnerWBSElementBasicData'
      PartnerWBSElementInternalID,
//      cast( _PartnerWBSElementBasicData.WBSElementExternalID as fis_partner_wbsext_no_conv )       as PartnerWBSElementExternalID,
//@API.element.releaseState: #DEPRECATED
//@API.element.successor:   'PartnerWBSElementExternalID'
//@VDM.lifecycle.status:    #DEPRECATED
//@VDM.lifecycle.successor: 'PartnerWBSElementExternalID'
//      PartnerWBSElement,       
      
//      @ObjectModel.foreignKey.association: '_PartnerProjectBasicData'
      PartnerProjectInternalID,
//      cast( _PartnerProjectBasicData.ProjectExternalID as fis_part_projectext_no_conv )            as PartnerProjectExternalID,
//@API.element.releaseState: #DEPRECATED
//@API.element.successor:   'PartnerProjectExternalID'
//@VDM.lifecycle.status:    #DEPRECATED
//@VDM.lifecycle.successor: 'PartnerProjectExternalID'
//      PartnerProject,      
      
      @ObjectModel.foreignKey.association: '_PartnerSalesDocument'
      PartnerSalesDocument,
      @ObjectModel.foreignKey.association: '_PartnerSalesDocumentItem'
      PartnerSalesDocumentItem,
      PartnerProjectNetwork,
      PartnerProjectNetworkActivity,
//      @ObjectModel.foreignKey.association: '_PartnerBusinessProcess'
      PartnerBusinessProcess,
      PartnerCostObject,
      @ObjectModel.foreignKey.association: '_BillingDocumentType'
      BillingDocumentType,
      @ObjectModel.foreignKey.association: '_SalesOrganization'
      SalesOrganization,
      @ObjectModel.foreignKey.association: '_DistributionChannel'
      DistributionChannel,
      OrganizationDivision,
      @ObjectModel.foreignKey.association: '_SoldProduct'
      SoldProduct,
//      @ObjectModel.foreignKey.association: '_SoldProductGroup'
      SoldProductGroup,
      @ObjectModel.foreignKey.association: '_CustomerGroup'
      CustomerGroup,
      CustomerSupplierCountry,
      CustomerSupplierIndustry,
      SalesDistrict,
      BillToParty,
      ShipToParty,
      CustomerSupplierCorporateGroup,
      JointVenture,
      JointVentureEquityGroup,
      JointVentureCostRecoveryCode,
      JointVentureEquityType,
      SettlementReferenceDate,
      WorkCenterInternalID,
      OrderOperation,
      OrderItem,
      OrderSuboperation,
      @ObjectModel.foreignKey.association: '_Equipment'
      Equipment,
      @ObjectModel.foreignKey.association: '_FunctionalLocation'
      FunctionalLocation,
      @ObjectModel.foreignKey.association: '_Assembly'
      Assembly,
//      @ObjectModel.foreignKey.association: '_MaintenanceActivityType'
      MaintenanceActivityType,
      @ObjectModel.foreignKey.association: '_MaintOrdPlngDegreeCode'
      MaintenanceOrderPlanningCode,
      @ObjectModel.foreignKey.association: '_PMNotificationPriorityType'
      MaintPriorityType,
      @ObjectModel.foreignKey.association: '_PMNotificationPriority'
      MaintPriority,
//      @ObjectModel.foreignKey.association: '_SuperiorOrder'
      SuperiorOrder,
//      @ObjectModel.foreignKey.association: '_ProductGroup'
      ProductGroup,
      MaintenanceOrderIsPlanned,

      IsStatisticalOrder,
      IsStatisticalCostCenter,
      IsStatisticalSalesDocument,
      WBSIsStatisticalWBSElement,
      CalendarYear,
      CalendarQuarter,
      CalendarYearQuarter,
      CalendarMonth,
      CalendarYearMonth,
      CalendarWeek,
      CalendarYearWeek,
      _FiscalCalendarDate.CalendarDate                                                             as CalendarDate,
      _FiscalCalendarDate.FiscalQuarter                                                            as FiscalQuarter,
      _FiscalCalendarDate.FiscalWeek                                                               as FiscalWeek,
      _FiscalCalendarDate.FiscalYearQuarter                                                        as FiscalYearQuarter,
      _FiscalCalendarDate.FiscalYearWeek                                                           as FiscalYearWeek,
//       cast( '          ' as acr_logsys preserving type )                                           as AccrualObjectLogicalSystem,
      AccrualObjectType,
      AccrualObject,
      AccrualSubobject,
      AccrualItemType,

      @ObjectModel.foreignKey.association: '_CashLedgerCompanyCode'
      CashLedgerCompanyCode,

      @ObjectModel.foreignKey.association: '_CashLedgerAccount'
      CashLedgerAccount,

      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_FinMgmtAreaStdVH',
                     element: 'FinancialManagementArea' }
        }]
      @ObjectModel.foreignKey.association: '_FinancialManagementArea'
      FinancialManagementArea,

//      @Consumption.valueHelpDefinition: [
//        { entity:  { name:    'I_FundsCenterStdVH',
//                     element: 'FundsCenter' },
//          additionalBinding: [{ localElement: 'FinancialManagementArea',
//                                element: 'FinancialManagementArea' }]
//        }]
//      @ObjectModel.foreignKey.association: '_FundsCenter'
      FundsCenter,

//      @ObjectModel.foreignKey.association: '_FundedProgram'
      FundedProgram,

      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_FundStdVH',
                     element: 'Fund' },
          additionalBinding: [{ localElement: 'FinancialManagementArea',
                                element: 'FinancialManagementArea' }]
        }]
//      @ObjectModel.foreignKey.association: '_Fund'
      Fund,

      //      @ObjectModel.foreignKey.association: '_Grant'
      GrantID,

//      @Consumption.valueHelpDefinition: [
//        { entity:  { name:    'I_BudgetPeriodStdVH',
//                     element: 'BudgetPeriod' }
//        }]
//      @ObjectModel.foreignKey.association: '_BudgetPeriod'
      BudgetPeriod,

      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_FundStdVH',
                     element: 'Fund' },
          additionalBinding: [{ localElement: 'FinancialManagementArea',
                                element: 'FinancialManagementArea' }]
        }]
//      @ObjectModel.foreignKey.association: '_PartnerFund'
      PartnerFund,

      //      @ObjectModel.foreignKey.association: '_PartnerGrant'
      PartnerGrant,

//      @ObjectModel.foreignKey.association: '_PartnerBudgetPeriod'
      PartnerBudgetPeriod,

      @ObjectModel.foreignKey.association: '_PubSecBudgetAccount'
      PubSecBudgetAccount,

      @ObjectModel.foreignKey.association: '_PubSecBudgetAccountCoCode'
      PubSecBudgetAccountCoCode,

      @ObjectModel.foreignKey.association: '_PubSecBudgetCnsmpnDate'
      PubSecBudgetCnsmpnDate,

      @ObjectModel.foreignKey.association: '_PubSecBudgetCnsmpnFsclPeriod'
      PubSecBudgetCnsmpnFsclPeriod,

      @ObjectModel.foreignKey.association: '_PubSecBudgetCnsmpnFsclYear'
      PubSecBudgetCnsmpnFsclYear,

      PubSecBudgetIsRelevant,

      @ObjectModel.foreignKey.association: '_PubSecBudgetCnsmpnType'
      PubSecBudgetCnsmpnType,

      @ObjectModel.foreignKey.association: '_PubSecBudgetCnsmpnAmtType'
      PubSecBudgetCnsmpnAmtType,


      //      GLAccountAuthorizationGroup,
      //      SupplierBasicAuthorizationGrp,
      //      CustomerBasicAuthorizationGrp,
      //      AcctgDocTypeAuthorizationGroup,
      //      OrderType,
      //      SalesOrderType,
      AssetClass,


      /* Associations */
      _AccrualObjectType,
      _AccrualObject,
      _AccrualSubobject,
      _AccrualItemType,
      _AccountingDocumentCategory,
      _AccountingDocumentType,
      _AccountingDocumentTypeText,
      _AlternativeGLAccount,
      _Assembly,
      _AssetTransactionType,

      _BalanceTransactionCurrency,
      /*
      _BaseUnit,
      */
      _BillableControl,
      _BillingDocumentType,
      _BillToParty,
      _BusinessArea,
      _BusinessAreaText,
      _BusinessProcess,
      _BusinessTransactionType,
      _ChartOfAccounts,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:   '_ClearingJournalEntry'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: '_ClearingJournalEntry'
      _ClearingAccountingDocument,
      _ClearingJournalEntry,
      _ClearingJrnlEntryFiscalYear,
      _CompanyCode,
      _CompanyCodeText,
      _CompanyCodeCurrency,
      _ConditionContract,
      _ControllingArea,
      _ControllingAreaText,
      _ControllingDebitCreditCode,
      _ControllingObjectClass,
      _CostAnalysisResource,
      _CostCenter,
      _CostCtrActivityType,
      _CostOriginGroup,
      _CostSourceUnit,
      _CountryChartOfAccounts,
      _CurrentCostCenter,
      _CurrentProfitCenter,
      _Customer,
      _CustomerText,
      _CustomerGroup,
      _CustomerSupplierCountry,
      _DebitCreditCode,
      _DistributionChannel,
      _EliminationProfitCenter,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:    '_PersonWorkAgreement_1'
//      @VDM.lifecycle.status:     #DEPRECATED
//      @VDM.lifecycle.successor:  '_PersonWorkAgreement_1'
      _Employment,
      _PersonWorkAgreement_1,
      _Equipment,
      _FinancialAccountType,
      _FinancialTransactionType,
      _FiscalCalendarDate,
      _FiscalYear,
      _FiscalYearVariant,
      _FixedAsset,
      _FixedAssetText,
      _FreeDefinedCurrency1,
      _FreeDefinedCurrency2,
      _FreeDefinedCurrency3,
      _FreeDefinedCurrency4,
      _FreeDefinedCurrency5,
      _FreeDefinedCurrency6,
      _FreeDefinedCurrency7,
      _FreeDefinedCurrency8,
      _FunctionalArea,
      _FunctionalLocation,
      _GLAccountInChartOfAccounts,
      _GLAccountInCompanyCode,
      _GLAccountType,
      _GlobalCurrency,
      _GroupFixedAsset,
      _GroupFixedAssetText,
      _GroupMasterFixedAsset,
      _GroupMasterFixedAssetText,
      _HouseBank,
      _HouseBankAccount,
      _InternalOrder,
      _InventorySpclStkSalesDocItm,
      _InventorySpclStkSalesDocument,
      _InventorySpecialStockSupplier,
      _InvtrySpclStockSupplierText,
      _InventorySpecialStockType,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:   '_InventorySpclStockValnType'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: '_InventorySpclStockValnType'
      _InventorySpecialStockValnType,
      _InventorySpclStockValnType,
      _InventoryValuationType,
      _InvtrySpclStkWBSElmntBscData,
      _JournalEntry,
      _Ledger,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:   '_LedgerFiscalYearForVariant'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: '_LedgerFiscalYearForVariant'
      _LedgerFiscalYear,
      _LedgerFiscalYearForVariant,
      _LogicalSystem,
      _MaintenanceActivityType,
      _MaintenanceOrderSubOperation,
      _MaintOrdPlngDegreeCode,
      _MasterFixedAsset,
      _MasterFixedAssetText,
      _MovementCategory,
      _OffsettingAccount,
      _OffsettingAccountText,
      _OffsettingAccountType,
      _OffsettingAccountWithBP,
      _OffsettingChartOfAccounts,
      _OperatingConcern,
      _Order,
      _OrderCategory,
      _OriginCostCenter,
      _OriginCostCtrActivityType,
      _OriginProfitCenter,
      _OriginSenderObject,
      _PartnerBusinessArea,
      _PartnerBusinessAreaText,
      _PartnerBusinessProcess,
      _PartnerCompany,
      _PartnerCompanyCode,
      _PartnerCompanyCodeText,
      _PartnerControllingObjectClass,
      _PartnerCostCenter,
      _PartnerCostCtrActivityType,
      _PartnerFunctionalArea,
      _PartnerOrder,
      _PartnerOrder_2,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:    '_PartnerOrderText_2'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: '_PartnerOrderText_2'
      _PartnerOrderText,
      _PartnerOrderText_2,
      _PartnerOrderCategory,
      _PartnerProfitCenter,
      _PartnerProjectBasicData,
      _PartnerSalesDocument,
      _PartnerSalesDocumentItem,
      _PartnerSegment,
      _PartnerWBSElementBasicData,
      _Plant,
      _PMNotificationPriority,
      _PMNotificationPriorityType,
      _PostingKey,
      _PredecessorReferenceDocType,
      _Product,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:    '_ProductGroup_2'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: '_ProductGroup_2'
      _ProductGroup,
      _ProductGroup_2,
      _ProfitCenter,
      _ProjectBasicData,
      _ProjectNetwork,
      _PurchasingDocument,
      _PurchasingDocumentItem,
      _PurReqValuationArea,
      _ReferenceDocumentType,
      _SalesDistrict,
      _SalesDocument,
      _SalesDocumentItem,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:    '_SalesDocument'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: '_SalesDocument'
      _SalesOrder,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:    '_SalesDocumentItem'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: '_SalesDocumentItem'
      _SalesOrderItem,
      _SalesOrganization,
      _Segment,
      _ServiceDocument,
      _ServiceDocumentType,
      _ServiceDocumentItem,
      _ServiceContract,
      _ServiceContractType,
      _ServiceContractItem,
      _TimeSheetOvertimeCat,
      _ShipToParty,
      _SoldProduct,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:    '_SoldProductGroup_2'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: '_SoldProductGroup_2'
      _SoldProductGroup,
      _SoldProductGroup_2,
      _SourceLedger,
      _SpecialGLCode,
      _SubLedgerAccLineItemType,
      _SuperiorOrder,
      _Supplier,
      _SupplierText,
      _TaxCode,
      _TransactionCurrency,
      _User,
      _WBSElementBasicData,
      _WorkCenter,
      _WorkPackageText,
      _GLAccountFlowType,
      _GLAccountTypeFlowType,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:   '_FiscalYearPeriodForVariant'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: '_FiscalYearPeriodForVariant'
      _FiscalYearPeriod,
      _FiscalPeriodForVariant,
      _FiscalYearPeriodForVariant,
      _FiscalPeriod,
      _CashLedgerCompanyCode,
      _CashLedgerAccount,
      _FinancialManagementArea,
      _FundsCenter,
      _FundedProgram,
      _Fund,
      _BudgetPeriod,
      _BudgetPeriodText,
      _PartnerFund,
      _PartnerBudgetPeriod,
      _PubSecBudgetAccountCoCode,
      _PubSecBudgetAccount,
      _PubSecBudgetCnsmpnDate,
      _PubSecBudgetCnsmpnFsclPeriod,
      _PubSecBudgetCnsmpnFsclYear,
      _PubSecBudgetCnsmpnType,
      _PubSecBudgetCnsmpnAmtType,
      _CustomerCompany,
      _SupplierCompany
}
