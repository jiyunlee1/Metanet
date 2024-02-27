@AbapCatalog.preserveKey: true
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.sqlViewName: 'ZIFIGLACCTBAL'
@EndUserText.label: 'G/L Account Balance with Flow-Measure'

@Analytics: { dataCategory: #CUBE} //, dataExtraction.enabled: true }

@AccessControl.authorizationCheck: #CHECK

@ObjectModel.representativeKey: 'LedgerGLLineItem'

@ObjectModel.usageType.sizeCategory: #XXL
@ObjectModel.usageType.dataClass:  #MIXED
@ObjectModel.usageType.serviceQuality: #D

@ClientHandling.algorithm: #SESSION_VARIABLE

@AbapCatalog.buffering.status: #NOT_ALLOWED

@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions:true
define view ZMCDGL_I_GLACCOUNTBALANCE
as select from ZMCDGL_P_GLACCOUNTBALANCE 
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
      //      @Semantics.booleanIndicator
      IsReversal,
      //      @Semantics.booleanIndicator
      IsReversed,
      ReversalReferenceDocumentCntxt,
      ReversalReferenceDocument,
      //      @Semantics.booleanIndicator
      IsSettlement,
      //      @Semantics.booleanIndicator
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
      //      @Semantics.booleanIndicator
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

      //      @Consumption.valueHelp: '_GLAccountFlowType'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_GLAccountFlowType' , element: 'GLAccountFlowType' } }]
      @ObjectModel.foreignKey.association: '_GLAccountFlowType'
      GLAccountFlowType,

      //      @Consumption.valueHelp: '_GLAccountTypeFlowType'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_GLAccountTypeFlowType' , element: 'GLAccountTypeFlowType' } }]
      @ObjectModel.foreignKey.association: '_GLAccountTypeFlowType'
      GLAccountTypeFlowType,
      //      @Semantics.booleanIndicator
      IsBalanceSheetAccount,
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
      */

      @ObjectModel.foreignKey.association: '_DebitCreditCode'
      DebitCreditCode,
      @ObjectModel.foreignKey.association: '_FiscalPeriodForVariant'
      //      @Semantics.fiscal.period: true
      FiscalPeriod,
      @ObjectModel.foreignKey.association: '_FiscalYearVariant'
      @Semantics.fiscal.yearVariant: true
      FiscalYearVariant,
      @ObjectModel.foreignKey.association: '_FiscalYearPeriodForVariant'
      @Semantics.fiscal.yearPeriod: true
      FiscalYearPeriod,
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
      @ObjectModel.foreignKey.association: '_SalesDocument'
      SalesDocument,
      @ObjectModel.foreignKey.association: '_SalesDocumentItem'
      SalesDocumentItem,
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
      //      @Semantics.booleanIndicator
      IsOpenItemManaged,
      ClearingDate,

//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:    'ClearingJournalEntry'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: 'ClearingJournalEntry'
//      @ObjectModel.foreignKey.association: '_ClearingAccountingDocument'
      ClearingAccountingDocument,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:    'ClearingJournalEntryFiscalYear'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: 'ClearingJournalEntryFiscalYear'
      ClearingDocFiscalYear,

      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_ClearingJournalEntry'
      ClearingJournalEntry,
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
//      InvtrySpclStockWBSElmntExtID,
      @ObjectModel.foreignKey.association: '_InventorySpecialStockSupplier'
      InventorySpecialStockSupplier,
      @ObjectModel.foreignKey.association: '_InventoryValuationType'
      InventoryValuationType,
//      @ObjectModel.foreignKey.association: '_Purreqvaluationarea'
      ValuationArea,
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
      @ObjectModel.foreignKey.association: '_TimeSheetOvertimeCat'
      TimeSheetOvertimeCategory,
//      @ObjectModel.foreignKey.association: '_WBSElementBasicData'
      WBSElementInternalID,
//      WBSElementExternalID,
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'WBSElementExternalID'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'WBSElementExternalID'      
//      WBSElement,
//      @ObjectModel.foreignKey.association: '_ProjectBasicData'
      ProjectInternalID,
//      ProjectExternalID,
//  @API.element.releaseState: #DEPRECATED
//  @API.element.successor:   'ProjectExternalID'
//  @VDM.lifecycle.status:    #DEPRECATED
//  @VDM.lifecycle.successor: 'ProjectExternalID'  
//      Project,      
      //      @ObjectModel.foreignKey.association: '_OperatingConcern'
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
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:    'PartnerOrder_2'
//      @VDM.lifecycle.status:     #DEPRECATED
//      @VDM.lifecycle.successor:  'PartnerOrder_2'
      @ObjectModel.foreignKey.association: '_PartnerOrder'
      PartnerOrder,
      @ObjectModel.foreignKey.association: '_PartnerOrder_2'
      PartnerOrder_2,
      @ObjectModel.foreignKey.association: '_PartnerOrderCategory'
      PartnerOrderCategory,
//      @ObjectModel.foreignKey.association: '_PartnerWBSElementBasicData'
      PartnerWBSElementInternalID,
//      PartnerWBSElementExternalID,
//@API.element.releaseState: #DEPRECATED
//@API.element.successor:   'PartnerWBSElementExternalID'
//@VDM.lifecycle.status:    #DEPRECATED
//@VDM.lifecycle.successor: 'PartnerWBSElementExternalID'
//      PartnerWBSElement, 
            
//      @ObjectModel.foreignKey.association: '_PartnerProjectBasicData'
      PartnerProjectInternalID,
//      PartnerProjectExternalID,
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
      _FiscalCalendarDate.FiscalQuarter     as FiscalQuarter,
      _FiscalCalendarDate.FiscalWeek        as FiscalWeek,
      _FiscalCalendarDate.FiscalYearQuarter as FiscalYearQuarter,
      _FiscalCalendarDate.FiscalYearWeek    as FiscalYearWeek,
//      AccrualObjectLogicalSystem,
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
      @Analytics.internalName: #LOCAL
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
      @Analytics.internalName: #LOCAL
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

      /* for compatibility */
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:   'SalesDocument'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: 'SalesDocument'
      SalesOrder,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:   'SalesDocumentItem'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: 'SalesDocumentItem'
      SalesOrderItem,

      /* Associations */
      _AccrualObjectType,
      _AccrualObject,
      _AccrualSubobject,
      _AccrualItemType,
      _AccountingDocumentCategory,
      _AccountingDocumentType,
      _AccountingDocumentTypeText,
      /*
      _AdditionalQuantity1Unit,
      _AdditionalQuantity2Unit,
      _AdditionalQuantity3Unit,
      */
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

      _ClearingJrnlEntryFiscalYear,
      _ClearingJournalEntry,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:    '_ClearingJournalEntry'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: '_ClearingJournalEntry'
      _ClearingAccountingDocument,

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
      /*
      _CostSourceUnit,
      */
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
      _FiscalPeriod,
      _FiscalPeriodForVariant,
      _FiscalYear,
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:   '_FiscalYearPeriodForVariant'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: '_FiscalYearPeriodForVariant'
      _FiscalYearPeriod,
      _FiscalYearPeriodForVariant,
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
      _InvtrySpclStkWBSElmntBscData,
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
//      @API.element.releaseState: #DEPRECATED
//      @API.element.successor:    '_PartnerOrder_2'
//      @VDM.lifecycle.status:    #DEPRECATED
//      @VDM.lifecycle.successor: '_PartnerOrder_2'
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
      _CashLedgerCompanyCode,
      _CashLedgerAccount,
      _FinancialManagementArea,
      _FundsCenter,
      _FundedProgram,
      _Fund,
//      _Grant,
      _BudgetPeriod,
      _BudgetPeriodText,
      _PartnerFund,
//      _PartnerGrant,
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
///////////////////////////////////////////////////////////////////////////////
// This is a virtual cube and serves only as metadata for the OLAP Engine.
// A SQL request shall never return any data.
//where
//  Ledger = ''
