@AbapCatalog.preserveKey: true
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.sqlViewName: 'ZPIFIGLACOUNTBL2'
@AccessControl.authorizationCheck: #CHECK
@ClientHandling.algorithm: #SESSION_VARIABLE
@AbapCatalog.buffering.status: #NOT_ALLOWED
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST, #UNION]
//@EndUserText.label: 'G/L Account B alance with Flow-Measure'
define view ZMCDGL_P_GLACCOUNTBALANCE2
  as select from           I_GLAccountLineItem
    left outer to one join I_FiscalCalendarDate as _FiscalCalendarDate on  I_GLAccountLineItem.FiscalYearVariant = _FiscalCalendarDate.FiscalYearVariant
                                                                       and I_GLAccountLineItem.PostingDate       = _FiscalCalendarDate.CalendarDate

  association [0..1] to I_GLAccountFlowType     as _GLAccountFlowType     on $projection.GLAccountFlowType = _GLAccountFlowType.GLAccountFlowType
  association [0..1] to I_GLAccountTypeFlowType as _GLAccountTypeFlowType on $projection.GLAccountTypeFlowType = _GLAccountTypeFlowType.GLAccountTypeFlowType
{
      //I_GLAccountLineItem
  key I_GLAccountLineItem.SourceLedger,
  key I_GLAccountLineItem.CompanyCode,
  key I_GLAccountLineItem.FiscalYear,
  key I_GLAccountLineItem.AccountingDocument,
  key I_GLAccountLineItem.LedgerGLLineItem,
  key I_GLAccountLineItem.Ledger,
      I_GLAccountLineItem.LedgerFiscalYear,
      I_GLAccountLineItem.GLRecordType,
      I_GLAccountLineItem.ChartOfAccounts,
      I_GLAccountLineItem.ControllingArea,
      I_GLAccountLineItem.FinancialTransactionType,
      I_GLAccountLineItem.BusinessTransactionType,
      I_GLAccountLineItem.ReferenceDocumentType,
      I_GLAccountLineItem.LogicalSystem,
      I_GLAccountLineItem.ReferenceDocumentContext,
      I_GLAccountLineItem.ReferenceDocument,
      I_GLAccountLineItem.ReferenceDocumentItem,
      I_GLAccountLineItem.ReferenceDocumentItemGroup,
      I_GLAccountLineItem.IsReversal,
      I_GLAccountLineItem.IsReversed,
      I_GLAccountLineItem.ReversalReferenceDocumentCntxt,
      I_GLAccountLineItem.ReversalReferenceDocument,
      I_GLAccountLineItem.IsSettlement,
      I_GLAccountLineItem.IsSettled,
      I_GLAccountLineItem.PredecessorReferenceDocType,
      I_GLAccountLineItem.PredecessorReferenceDocCntxt,
      I_GLAccountLineItem.PredecessorReferenceDocument,
      I_GLAccountLineItem.PredecessorReferenceDocItem,
      I_GLAccountLineItem.SourceReferenceDocumentType,
      I_GLAccountLineItem.SourceLogicalSystem,
      I_GLAccountLineItem.SourceReferenceDocumentCntxt,
      I_GLAccountLineItem.SourceReferenceDocument,
      I_GLAccountLineItem.SourceReferenceDocumentItem,
      I_GLAccountLineItem.SourceReferenceDocSubitem,
      I_GLAccountLineItem.IsCommitment,
      I_GLAccountLineItem.JrnlEntryItemObsoleteReason,
      I_GLAccountLineItem.GLAccount,
      I_GLAccountLineItem.CostCenter,
      I_GLAccountLineItem.ProfitCenter,
      I_GLAccountLineItem.FunctionalArea,
      I_GLAccountLineItem.BusinessArea,
      I_GLAccountLineItem.Segment,
      I_GLAccountLineItem.PartnerCostCenter,
      I_GLAccountLineItem.PartnerProfitCenter,
      I_GLAccountLineItem.PartnerFunctionalArea,
      I_GLAccountLineItem.PartnerBusinessArea,
      I_GLAccountLineItem.PartnerCompany,
      I_GLAccountLineItem.PartnerSegment,
      I_GLAccountLineItem.BalanceTransactionCurrency,
      I_GLAccountLineItem.AmountInBalanceTransacCrcy,
//      cast( I_GLAccountLineItem.AmountInBalanceTransacCrcy as abap.curr( 23, 2 ) preserving type )   as FlowAmountInBalanceTransCrcy,
      I_GLAccountLineItem.DebitAmountInBalanceTransCrcy,
      I_GLAccountLineItem.CreditAmountInBalanceTransCrcy,
      I_GLAccountLineItem.TransactionCurrency,
      I_GLAccountLineItem.AmountInTransactionCurrency,
//      cast( I_GLAccountLineItem.AmountInTransactionCurrency as abap.curr( 23, 2 ) preserving type )  as FlowAmountInTransCrcy,
      I_GLAccountLineItem.DebitAmountInTransCrcy,
      I_GLAccountLineItem.CreditAmountInTransCrcy,
      I_GLAccountLineItem.CompanyCodeCurrency,
      I_GLAccountLineItem.AmountInCompanyCodeCurrency,
//      cast( I_GLAccountLineItem.AmountInCompanyCodeCurrency as abap.curr( 23, 2 ) preserving type )  as FlowAmountInCoCodeCrcy,
      I_GLAccountLineItem.DebitAmountInCoCodeCrcy,
      I_GLAccountLineItem.CreditAmountInCoCodeCrcy,
      I_GLAccountLineItem.GlobalCurrency,
      I_GLAccountLineItem.AmountInGlobalCurrency,
//      cast( I_GLAccountLineItem.AmountInGlobalCurrency as abap.curr( 23, 2 ) preserving type )       as FlowAmountInGlobalCrcy,
      I_GLAccountLineItem.DebitAmountInGlobalCrcy,
      I_GLAccountLineItem.CreditAmountInGlobalCrcy,
      I_GLAccountLineItem.FixedAmountInGlobalCrcy,
      I_GLAccountLineItem.FreeDefinedCurrency1,
      I_GLAccountLineItem.AmountInFreeDefinedCurrency1,
//      cast( I_GLAccountLineItem.AmountInFreeDefinedCurrency1 as abap.curr( 23, 2 ) preserving type ) as FlowAmountInFreeDfndCrcy1,
      I_GLAccountLineItem.DebitAmountInFreeDefinedCrcy1                                              as DebitAmountInFreeDfndCrcy1,
      I_GLAccountLineItem.CreditAmountInFreeDefinedCrcy1                                             as CreditAmountInFreeDfndCrcy1,
      I_GLAccountLineItem.FreeDefinedCurrency2,
      I_GLAccountLineItem.AmountInFreeDefinedCurrency2,
//      cast( I_GLAccountLineItem.AmountInFreeDefinedCurrency2 as abap.curr( 23, 2 ) preserving type ) as FlowAmountInFreeDfndCrcy2,
      I_GLAccountLineItem.DebitAmountInFreeDefinedCrcy2                                              as DebitAmountInFreeDfndCrcy2,
      I_GLAccountLineItem.CreditAmountInFreeDefinedCrcy2                                             as CreditAmountInFreeDfndCrcy2,
      I_GLAccountLineItem.FreeDefinedCurrency3,
      I_GLAccountLineItem.AmountInFreeDefinedCurrency3,
//      cast( I_GLAccountLineItem.AmountInFreeDefinedCurrency3 as abap.curr( 23, 2 ) preserving type ) as FlowAmountInFreeDfndCrcy3,
      I_GLAccountLineItem.DebitAmountInFreeDefinedCrcy3                                              as DebitAmountInFreeDfndCrcy3,
      I_GLAccountLineItem.CreditAmountInFreeDefinedCrcy3                                             as CreditAmountInFreeDfndCrcy3,
      I_GLAccountLineItem.FreeDefinedCurrency4,
      I_GLAccountLineItem.AmountInFreeDefinedCurrency4,
//      cast( I_GLAccountLineItem.AmountInFreeDefinedCurrency4 as abap.curr( 23, 2 ) preserving type ) as FlowAmountInFreeDfndCrcy4,
      I_GLAccountLineItem.DebitAmountInFreeDefinedCrcy4                                              as DebitAmountInFreeDfndCrcy4,
      I_GLAccountLineItem.CreditAmountInFreeDefinedCrcy4                                             as CreditAmountInFreeDfndCrcy4,
      I_GLAccountLineItem.FreeDefinedCurrency5,
      I_GLAccountLineItem.AmountInFreeDefinedCurrency5,
//      cast( I_GLAccountLineItem.AmountInFreeDefinedCurrency5 as abap.curr( 23, 2 ) preserving type ) as FlowAmountInFreeDfndCrcy5,
      I_GLAccountLineItem.DebitAmountInFreeDefinedCrcy5                                              as DebitAmountInFreeDfndCrcy5,
      I_GLAccountLineItem.CreditAmountInFreeDefinedCrcy5                                             as CreditAmountInFreeDfndCrcy5,
      I_GLAccountLineItem.FreeDefinedCurrency6,
      I_GLAccountLineItem.AmountInFreeDefinedCurrency6,
//      cast( I_GLAccountLineItem.AmountInFreeDefinedCurrency6 as abap.curr( 23, 2 ) preserving type ) as FlowAmountInFreeDfndCrcy6,
      I_GLAccountLineItem.DebitAmountInFreeDefinedCrcy6                                              as DebitAmountInFreeDfndCrcy6,
      I_GLAccountLineItem.CreditAmountInFreeDefinedCrcy6                                             as CreditAmountInFreeDfndCrcy6,
      I_GLAccountLineItem.FreeDefinedCurrency7,
      I_GLAccountLineItem.AmountInFreeDefinedCurrency7,
//      cast( I_GLAccountLineItem.AmountInFreeDefinedCurrency7 as abap.curr( 23, 2 ) preserving type ) as FlowAmountInFreeDfndCrcy7,
      I_GLAccountLineItem.DebitAmountInFreeDefinedCrcy7                                              as DebitAmountInFreeDfndCrcy7,
      I_GLAccountLineItem.CreditAmountInFreeDefinedCrcy7                                             as CreditAmountInFreeDfndCrcy7,
      I_GLAccountLineItem.FreeDefinedCurrency8,
      I_GLAccountLineItem.AmountInFreeDefinedCurrency8,
//      cast( I_GLAccountLineItem.AmountInFreeDefinedCurrency8 as abap.curr( 23, 2 ) preserving type ) as FlowAmountInFreeDfndCrcy8,
      I_GLAccountLineItem.DebitAmountInFreeDefinedCrcy8                                              as DebitAmountInFreeDfndCrcy8,
      I_GLAccountLineItem.CreditAmountInFreeDefinedCrcy8                                             as CreditAmountInFreeDfndCrcy8,

      I_GLAccountLineItem.CostSourceUnit,
      I_GLAccountLineItem.ValuationQuantity,


      cast( '' as abap.char( 10 ) )                                                                  as GLAccountFlowType,




      cast( '' as abap.char( 12 ) )                                                                  as GLAccountTypeFlowType,

      I_GLAccountLineItem._GLAccountInChartOfAccounts.IsBalanceSheetAccount,


      I_GLAccountLineItem.DebitCreditCode,

      case when I_GLAccountLineItem.PostingDate is initial then I_GLAccountLineItem.FiscalPeriod
      when I_GLAccountLineItem.FiscalPeriod > _FiscalCalendarDate.FiscalPeriod then _FiscalCalendarDate.FiscalPeriod
      when I_GLAccountLineItem.FiscalPeriod = '000' then I_GLAccountLineItem.FiscalPeriod
      when I_GLAccountLineItem.FiscalPeriod = _FiscalCalendarDate.FiscalPeriod then I_GLAccountLineItem.FiscalPeriod
      end                                                                                            as FiscalPeriod,
      case when I_GLAccountLineItem.PostingDate is initial then I_GLAccountLineItem.FiscalYearPeriod
      when I_GLAccountLineItem.FiscalYearPeriod > _FiscalCalendarDate.FiscalYearPeriod then _FiscalCalendarDate.FiscalYearPeriod
      when I_GLAccountLineItem.FiscalPeriod = '000' then I_GLAccountLineItem.FiscalYearPeriod
      when I_GLAccountLineItem.FiscalPeriod = _FiscalCalendarDate.FiscalPeriod then I_GLAccountLineItem.FiscalYearPeriod
      end                                                                                            as FiscalYearPeriod,


      I_GLAccountLineItem.FiscalYearVariant,

      //FiscalYearPeriod,
      I_GLAccountLineItem.PostingDate                                                                as PostingDate,
      I_GLAccountLineItem.DocumentDate,

      I_GLAccountLineItem.AccountingDocumentType,
      I_GLAccountLineItem.AccountingDocumentItem,
      I_GLAccountLineItem.AssignmentReference,

      I_GLAccountLineItem.AccountingDocumentCategory,

      I_GLAccountLineItem.PostingKey,

      I_GLAccountLineItem.TransactionTypeDetermination,

      I_GLAccountLineItem.SubLedgerAcctLineItemType,
      I_GLAccountLineItem.AccountingDocCreatedByUser,
      I_GLAccountLineItem.LastChangeDateTime,
      I_GLAccountLineItem.CreationDateTime,
      I_GLAccountLineItem.CreationDate,

      I_GLAccountLineItem.EliminationProfitCenter,
      I_GLAccountLineItem.OriginObjectType,

      I_GLAccountLineItem.GLAccountType,

      I_GLAccountLineItem.AlternativeGLAccount,

      I_GLAccountLineItem.CountryChartOfAccounts,
      I_GLAccountLineItem.InvoiceReference,
      I_GLAccountLineItem.InvoiceReferenceFiscalYear,
      I_GLAccountLineItem.FollowOnDocumentType,
      I_GLAccountLineItem.InvoiceItemReference,
      I_GLAccountLineItem.ReferencePurchaseOrderCategory,

      I_GLAccountLineItem.PurchasingDocument,

      I_GLAccountLineItem.PurchasingDocumentItem,
      I_GLAccountLineItem.AccountAssignmentNumber,
      I_GLAccountLineItem.DocumentItemText,
      I_GLAccountLineItem.SalesOrder,
      I_GLAccountLineItem.SalesOrderItem,

      I_GLAccountLineItem.SalesDocument,

      I_GLAccountLineItem.SalesDocumentItem,

      //      Material,

      I_GLAccountLineItem.Product,

      I_GLAccountLineItem.Plant,

      I_GLAccountLineItem.Supplier,

      I_GLAccountLineItem.Customer,
      I_GLAccountLineItem.ServicesRenderedDate,

      I_GLAccountLineItem.ConditionContract,

      I_GLAccountLineItem.FinancialAccountType,

      I_GLAccountLineItem.SpecialGLCode,
      I_GLAccountLineItem.TaxCode,

      I_GLAccountLineItem.HouseBank,

      I_GLAccountLineItem.HouseBankAccount,
      I_GLAccountLineItem.IsOpenItemManaged,
      I_GLAccountLineItem.ClearingDate,

      I_GLAccountLineItem.ClearingAccountingDocument,
      I_GLAccountLineItem.ClearingDocFiscalYear,

      I_GLAccountLineItem.ClearingJournalEntry,
      I_GLAccountLineItem.ClearingJournalEntryFiscalYear,

      I_GLAccountLineItem.AssetDepreciationArea,
      I_GLAccountLineItem.MasterFixedAsset,
      I_GLAccountLineItem.FixedAsset,
      I_GLAccountLineItem.AssetValueDate,
      I_GLAccountLineItem.AssetTransactionType,
      I_GLAccountLineItem.AssetAcctTransClassfctn,
      I_GLAccountLineItem.DepreciationFiscalPeriod,
      I_GLAccountLineItem.GroupMasterFixedAsset,
      I_GLAccountLineItem.GroupFixedAsset,

      I_GLAccountLineItem.CostEstimate,
      I_GLAccountLineItem.InventorySpecialStockValnType,
      I_GLAccountLineItem.InvtrySpecialStockValnType_2,

      I_GLAccountLineItem.InventorySpecialStockType,

      I_GLAccountLineItem.InventorySpclStkSalesDocument,

      I_GLAccountLineItem.InventorySpclStkSalesDocItm,

      I_GLAccountLineItem.InvtrySpclStockWBSElmntIntID,

      //      InventorySpclStockWBSElement,

      I_GLAccountLineItem.InventorySpecialStockSupplier,

      I_GLAccountLineItem.InventoryValuationType,

      I_GLAccountLineItem.ValuationArea,
      I_GLAccountLineItem.SenderGLAccount,
      I_GLAccountLineItem.SenderAccountAssignment,
      I_GLAccountLineItem.SenderAccountAssignmentType,
      I_GLAccountLineItem.CostOriginGroup,

      I_GLAccountLineItem.OriginSenderObject,

      I_GLAccountLineItem.ControllingDebitCreditCode,
      I_GLAccountLineItem.ControllingObjectDebitType,
      I_GLAccountLineItem.QuantityIsIncomplete,

      I_GLAccountLineItem.OffsettingAccount,

      I_GLAccountLineItem.OffsettingAccountType,

      I_GLAccountLineItem.OffsettingChartOfAccounts,
      I_GLAccountLineItem.LineItemIsCompleted,
      I_GLAccountLineItem.PersonnelNumber,

      I_GLAccountLineItem.ControllingObjectClass,

      I_GLAccountLineItem.PartnerCompanyCode,

      I_GLAccountLineItem.PartnerControllingObjectClass,

      I_GLAccountLineItem.OriginCostCenter,

      I_GLAccountLineItem.OriginProfitCenter,

      I_GLAccountLineItem.OriginCostCtrActivityType,
      I_GLAccountLineItem.AccountAssignment,
      I_GLAccountLineItem.AccountAssignmentType,

      I_GLAccountLineItem.CostCtrActivityType,

      I_GLAccountLineItem.OrderID,

      I_GLAccountLineItem.OrderCategory,

      I_GLAccountLineItem.ServiceDocument,
      I_GLAccountLineItem.ServiceDocumentType,
      I_GLAccountLineItem.ServiceDocumentItem,
      I_GLAccountLineItem.ServiceContract,
      I_GLAccountLineItem.ServiceContractItem,
      I_GLAccountLineItem.ServiceContractType,
      I_GLAccountLineItem.TimeSheetOvertimeCategory,
      I_GLAccountLineItem.WBSElementInternalID,

//      cast( I_GLAccountLineItem.WBSElement as abap.char( 24 ) preserving type )                      as WBSElement,

      I_GLAccountLineItem.ProjectInternalID,

//      cast( I_GLAccountLineItem.Project as abap.char( 24 ) preserving type )                         as Project,

      I_GLAccountLineItem.OperatingConcern,

      I_GLAccountLineItem.ProjectNetwork,
      I_GLAccountLineItem.RelatedNetworkActivity,

      I_GLAccountLineItem.BusinessProcess,
      I_GLAccountLineItem.CostObject,

      I_GLAccountLineItem.BillableControl,

      I_GLAccountLineItem.CostAnalysisResource,
      I_GLAccountLineItem.CustomerServiceNotification,
      I_GLAccountLineItem.PartnerAccountAssignment,
      I_GLAccountLineItem.PartnerAccountAssignmentType,
      I_GLAccountLineItem.WorkPackage,
      I_GLAccountLineItem.WorkItem,

      I_GLAccountLineItem.PartnerCostCtrActivityType,

      I_GLAccountLineItem.PartnerOrder,
      I_GLAccountLineItem.PartnerOrder_2,

      I_GLAccountLineItem.PartnerOrderCategory,

      I_GLAccountLineItem.PartnerWBSElementInternalID,
//      cast( I_GLAccountLineItem.PartnerWBSElement as abap.char( 24 ) preserving type )               as PartnerWBSElement,

      I_GLAccountLineItem.PartnerProjectInternalID,
//      cast( I_GLAccountLineItem.PartnerProject as abap.char( 24 ) preserving type )                  as PartnerProject,

      I_GLAccountLineItem.PartnerSalesDocument,
      I_GLAccountLineItem.PartnerSalesDocumentItem,

      I_GLAccountLineItem.PartnerProjectNetwork,
      I_GLAccountLineItem.PartnerProjectNetworkActivity,

      I_GLAccountLineItem.PartnerBusinessProcess,
      I_GLAccountLineItem.PartnerCostObject,

      I_GLAccountLineItem.BillingDocumentType,

      I_GLAccountLineItem.SalesOrganization,

      I_GLAccountLineItem.DistributionChannel,
      I_GLAccountLineItem.OrganizationDivision,

      //      SoldMaterial,

      I_GLAccountLineItem.SoldProduct,

      //      MaterialGroup,

      I_GLAccountLineItem.SoldProductGroup,

      I_GLAccountLineItem.CustomerGroup,
      I_GLAccountLineItem.CustomerSupplierCountry,
      I_GLAccountLineItem.CustomerSupplierIndustry,
      I_GLAccountLineItem.SalesDistrict,
      I_GLAccountLineItem.BillToParty,
      I_GLAccountLineItem.ShipToParty,
      I_GLAccountLineItem.CustomerSupplierCorporateGroup,

      I_GLAccountLineItem.JointVenture,
      I_GLAccountLineItem.JointVentureEquityGroup,
      I_GLAccountLineItem.JointVentureCostRecoveryCode,
      I_GLAccountLineItem.JointVentureEquityType,
      I_GLAccountLineItem.SettlementReferenceDate,
      I_GLAccountLineItem.WorkCenterInternalID,
      I_GLAccountLineItem.OrderOperation,
      I_GLAccountLineItem.OrderItem,
      I_GLAccountLineItem.OrderSuboperation,

      I_GLAccountLineItem.Equipment,

      I_GLAccountLineItem.FunctionalLocation,

      I_GLAccountLineItem.Assembly,

      I_GLAccountLineItem.MaintenanceActivityType,

      I_GLAccountLineItem.MaintenanceOrderPlanningCode,

      I_GLAccountLineItem.MaintPriorityType,

      I_GLAccountLineItem.MaintPriority,

      I_GLAccountLineItem.SuperiorOrder,
      I_GLAccountLineItem.ProductGroup,
      I_GLAccountLineItem.MaintenanceOrderIsPlanned,

      I_GLAccountLineItem.IsStatisticalOrder,
      I_GLAccountLineItem.IsStatisticalCostCenter,
      I_GLAccountLineItem.IsStatisticalSalesDocument,
      I_GLAccountLineItem.WBSIsStatisticalWBSElement,
      I_GLAccountLineItem.CalendarYear, // hier
      I_GLAccountLineItem.CalendarQuarter,
      I_GLAccountLineItem.CalendarYearQuarter,
      I_GLAccountLineItem.CalendarMonth,
      I_GLAccountLineItem.CalendarYearMonth,
      I_GLAccountLineItem.CalendarWeek,
      I_GLAccountLineItem.CalendarYearWeek,
      I_GLAccountLineItem.AccrualObjectType,
      I_GLAccountLineItem.AccrualObject,
      I_GLAccountLineItem.AccrualSubobject,
      I_GLAccountLineItem.AccrualItemType,

      I_GLAccountLineItem.CashLedgerCompanyCode,
      I_GLAccountLineItem.CashLedgerAccount,
      I_GLAccountLineItem.FinancialManagementArea,
      I_GLAccountLineItem.FundsCenter,
      I_GLAccountLineItem.FundedProgram,
      I_GLAccountLineItem.Fund,
      I_GLAccountLineItem.GrantID,
      I_GLAccountLineItem.BudgetPeriod,
      I_GLAccountLineItem.PartnerFund,
      I_GLAccountLineItem.PartnerGrant,
      I_GLAccountLineItem.PartnerBudgetPeriod,
      I_GLAccountLineItem.PubSecBudgetAccount,
      I_GLAccountLineItem.PubSecBudgetAccountCoCode,
      I_GLAccountLineItem.PubSecBudgetCnsmpnDate,
      I_GLAccountLineItem.PubSecBudgetCnsmpnFsclPeriod,
      I_GLAccountLineItem.PubSecBudgetCnsmpnFsclYear,
      I_GLAccountLineItem.PubSecBudgetIsRelevant,
      I_GLAccountLineItem.PubSecBudgetCnsmpnType,
      I_GLAccountLineItem.PubSecBudgetCnsmpnAmtType,

      //      GLAccountAuthorizationGroup,
      //      SupplierBasicAuthorizationGrp,
      //      CustomerBasicAuthorizationGrp,
      //      AcctgDocTypeAuthorizationGroup,
      //      OrderType,
      //      SalesOrderType,
      I_GLAccountLineItem.AssetClass,
      I_GLAccountLineItem._AccrualObjectType,
      I_GLAccountLineItem._AccrualObject,
      I_GLAccountLineItem._AccrualSubobject,
      I_GLAccountLineItem._AccrualItemType,

      /* Associations */
      I_GLAccountLineItem._AccountingDocumentCategory,
      I_GLAccountLineItem._AccountingDocumentType,
      I_GLAccountLineItem._AccountingDocumentTypeText,
      /*
      _AdditionalQuantity1Unit,
      _AdditionalQuantity2Unit,
      _AdditionalQuantity3Unit,
      */
      I_GLAccountLineItem._AlternativeGLAccount,
      //      _AlternativeGLAccountText,
      I_GLAccountLineItem._Assembly,
      I_GLAccountLineItem._AssemblyText,
      I_GLAccountLineItem._AssetTransactionType,

      I_GLAccountLineItem._BalanceTransactionCurrency,
      /*
      _BaseUnit,
      */
      I_GLAccountLineItem._BillableControl,
      I_GLAccountLineItem._BillingDocumentType,
      I_GLAccountLineItem._BillToParty,
      I_GLAccountLineItem._BudgetPeriodText,
      I_GLAccountLineItem._BusinessArea,
      I_GLAccountLineItem._BusinessAreaText,
      I_GLAccountLineItem._BusinessProcess,
      //      _BusinessProcessText,
      I_GLAccountLineItem._BusinessTransactionType,
      //      _BusinessTransactionTypeText,
      //      P_FsclCalenderLedgerWithCC._CalendarDate,
      I_GLAccountLineItem._ChartOfAccounts,
      I_GLAccountLineItem._ChartOfAccountsText,

      I_GLAccountLineItem._ClearingJrnlEntryFiscalYear,
      I_GLAccountLineItem._ClearingJournalEntry,
      I_GLAccountLineItem._ClearingAccountingDocument,

      I_GLAccountLineItem._CompanyCode,
      I_GLAccountLineItem._CompanyCodeCurrency,
      I_GLAccountLineItem._CompanyCodeText,
      I_GLAccountLineItem._ConditionContract,
      I_GLAccountLineItem._ControllingArea,
      I_GLAccountLineItem._ControllingAreaText,
      I_GLAccountLineItem._ControllingDebitCreditCode,
      I_GLAccountLineItem._ControllingObjectClass,
      I_GLAccountLineItem._CostAnalysisResource,
      //      _CostAnalysisResourceText,
      I_GLAccountLineItem._CostCenter,
      //      _CostCenterText,
      I_GLAccountLineItem._CostCtrActivityType,
      I_GLAccountLineItem._CostOriginGroup,
      I_GLAccountLineItem._CostSourceUnit,
      I_GLAccountLineItem._CountryChartOfAccounts,
      //      _CountryChartOfAccountsText,
      I_GLAccountLineItem._CurrentCostCenter,
      I_GLAccountLineItem._CurrentProfitCenter,
      I_GLAccountLineItem._Customer,
      I_GLAccountLineItem._CustomerGroup,
      I_GLAccountLineItem._CustomerSupplierCountry,
      I_GLAccountLineItem._CustomerText,
      I_GLAccountLineItem._DebitCreditCode,
      //      _DebitCreditCodeText,
      I_GLAccountLineItem._DistributionChannel,
      I_GLAccountLineItem._EliminationProfitCenter,
      I_GLAccountLineItem._Employment,
      I_GLAccountLineItem._PersonWorkAgreement_1,
      I_GLAccountLineItem._Equipment,
      //      _EquipmentText,
      I_GLAccountLineItem._FinancialAccountType,
      //      _FinancialAccountTypeText,
      //      _FinancialManagementAreaText,
      I_GLAccountLineItem._FinancialTransactionType,
      I_GLAccountLineItem._FiscalCalendarDate,
      //      _FiscalPeriod,
      //      _FiscalPeriodForVariant,
      I_GLAccountLineItem._FiscalYear,
      //      _FiscalYearPeriod,
      //      _FiscalYearPeriodForVariant,
      I_GLAccountLineItem._FiscalYearVariant,
      I_GLAccountLineItem._FixedAsset,
      I_GLAccountLineItem._FixedAssetText,
      I_GLAccountLineItem._FreeDefinedCurrency1,
      I_GLAccountLineItem._FreeDefinedCurrency2,
      I_GLAccountLineItem._FreeDefinedCurrency3,
      I_GLAccountLineItem._FreeDefinedCurrency4,
      I_GLAccountLineItem._FreeDefinedCurrency5,
      I_GLAccountLineItem._FreeDefinedCurrency6,
      I_GLAccountLineItem._FreeDefinedCurrency7,
      I_GLAccountLineItem._FreeDefinedCurrency8,
      I_GLAccountLineItem._FunctionalArea,
      //      _FunctionalAreaText,
      I_GLAccountLineItem._FunctionalLocation,
      //      _FunctionalLocationText,
      //      _FundText,
      I_GLAccountLineItem._GLAccountInChartOfAccounts,
      I_GLAccountLineItem._GLAccountInCompanyCode,
      //      _GLAccountText,
      I_GLAccountLineItem._GLAccountType,
      //      _GLAcctInChartOfAccountsText,
      I_GLAccountLineItem._GlobalCurrency,
      I_GLAccountLineItem._GroupFixedAsset,
      I_GLAccountLineItem._GroupFixedAssetText,
      I_GLAccountLineItem._GroupMasterFixedAsset,
      I_GLAccountLineItem._GroupMasterFixedAssetText,
      I_GLAccountLineItem._HouseBank,
      I_GLAccountLineItem._HouseBankAccount,
      //      _HouseBankAccountText,
      I_GLAccountLineItem._InternalOrder,
      I_GLAccountLineItem._InventorySpclStkSalesDocItm,
      I_GLAccountLineItem._InventorySpclStkSalesDocument,
      //      _InventorySpclStockWBSElement,
      I_GLAccountLineItem._InventorySpecialStockSupplier,
      I_GLAccountLineItem._InventorySpecialStockType,
      I_GLAccountLineItem._InventorySpecialStockValnType,
      I_GLAccountLineItem._InventorySpclStockValnType,
      I_GLAccountLineItem._InventoryValuationType,
      I_GLAccountLineItem._InvtrySpclStockSupplierText,
      //      _InvtrySpclStockWBSElmntText,
      I_GLAccountLineItem._InvtrySpclStkWBSElmntBscData,
      I_GLAccountLineItem._JournalEntry,
      I_GLAccountLineItem._Ledger,
      I_GLAccountLineItem._LedgerFiscalYear,
      I_GLAccountLineItem._LedgerFiscalYearForVariant,
      //      I_GLAccountLineItem._LedgerText,
      I_GLAccountLineItem._LogicalSystem,
      I_GLAccountLineItem._MaintenanceActivityType,
      //      _MaintenanceActivityTypeText,
      I_GLAccountLineItem._MaintenanceOrderSubOperation,
      I_GLAccountLineItem._MaintOrdPlngDegreeCode,
      I_GLAccountLineItem._MasterFixedAsset,
      I_GLAccountLineItem._MasterFixedAssetText,
      //      _Material,
      //      _MaterialGroup,
      I_GLAccountLineItem._MovementCategory,
      I_GLAccountLineItem._OffsettingAccount,
      I_GLAccountLineItem._OffsettingAccountText,
      I_GLAccountLineItem._OffsettingAccountType,
      //      _OffsettingAccountTypeText,
      I_GLAccountLineItem._OffsettingAccountWithBP,
      I_GLAccountLineItem._OffsettingChartOfAccounts,
      //      _OffsettingChartOfAccountsText,
      I_GLAccountLineItem._OperatingConcern,
      //      _OperatingConcernText,
      I_GLAccountLineItem._Order,
      I_GLAccountLineItem._OrderCategory,
      I_GLAccountLineItem._OriginCostCenter,
      I_GLAccountLineItem._OriginCostCtrActivityType,
      I_GLAccountLineItem._OriginProfitCenter,
      I_GLAccountLineItem._OriginSenderObject,
      I_GLAccountLineItem._PartnerBusinessArea,
      I_GLAccountLineItem._PartnerBusinessAreaText,
      I_GLAccountLineItem._PartnerBusinessProcess,
      //      _PartnerBusinessProcessText,
      I_GLAccountLineItem._PartnerCompany,
      I_GLAccountLineItem._PartnerCompanyCode,
      I_GLAccountLineItem._PartnerCompanyCodeText,
      I_GLAccountLineItem._PartnerControllingObjectClass,
      I_GLAccountLineItem._PartnerCostCenter,
      I_GLAccountLineItem._PartnerCostCtrActivityType,
      I_GLAccountLineItem._PartnerFunctionalArea,
      //      _PartnerFundText,
      I_GLAccountLineItem._PartnerOrder,
      I_GLAccountLineItem._PartnerOrder_2,
      I_GLAccountLineItem._PartnerOrderCategory,
      I_GLAccountLineItem._PartnerOrderText,
      I_GLAccountLineItem._PartnerOrderText_2,
      I_GLAccountLineItem._PartnerProfitCenter,
      I_GLAccountLineItem._PartnerProjectBasicData,
      //      _PartnerProjectText,
      I_GLAccountLineItem._PartnerSalesDocument,
      I_GLAccountLineItem._PartnerSalesDocumentItem,
      I_GLAccountLineItem._PartnerSegment,
      //      _PartnerSegmentText,
      I_GLAccountLineItem._PartnerWBSElementBasicData,
      //      _PartnerWBSElement,
      //      _PartnerWBSElementText,
      I_GLAccountLineItem._Plant,
      I_GLAccountLineItem._PMNotificationPriority,
      I_GLAccountLineItem._PMNotificationPriorityType,
      I_GLAccountLineItem._PostingKey,
      I_GLAccountLineItem._PredecessorReferenceDocType,
      I_GLAccountLineItem._Product,
      I_GLAccountLineItem._ProductGroup,
      I_GLAccountLineItem._ProductGroup_2,
      //      _ProductText,
      I_GLAccountLineItem._ProfitCenter,
      //      _ProfitCenterText,
      //      _Project,
      I_GLAccountLineItem._ProjectBasicData,
      //      _ProjectInternalIDText,
      I_GLAccountLineItem._ProjectNetwork,
      //      _ProjectNetworkText,
      //      _ProjectText,
      I_GLAccountLineItem._PurchasingDocument,
      I_GLAccountLineItem._PurchasingDocumentItem,
      I_GLAccountLineItem._PurReqValuationArea,
      I_GLAccountLineItem._ReferenceDocumentType,
      I_GLAccountLineItem._SalesDistrict,
      I_GLAccountLineItem._SalesDocument,
      I_GLAccountLineItem._SalesDocumentItem,
      I_GLAccountLineItem._SalesOrder,
      I_GLAccountLineItem._SalesOrderItem,
      I_GLAccountLineItem._SalesOrganization,
      I_GLAccountLineItem._Segment,
      //      _SegmentText,
      I_GLAccountLineItem._ServiceDocument,
      I_GLAccountLineItem._ServiceDocumentType,
      I_GLAccountLineItem._ServiceDocumentItem,
      I_GLAccountLineItem._ServiceContract,
      I_GLAccountLineItem._ServiceContractType,
      I_GLAccountLineItem._ServiceContractItem,
      I_GLAccountLineItem._TimeSheetOvertimeCat,
      I_GLAccountLineItem._ShipToParty,
      //      _SoldMaterial,
      I_GLAccountLineItem._SoldProduct,
      I_GLAccountLineItem._SoldProductGroup,
      I_GLAccountLineItem._SoldProductGroup_2,
      //      _SoldProductText,
      I_GLAccountLineItem._SourceLedger,
      //      _SourceLedgerText,
      I_GLAccountLineItem._SpecialGLCode,
      I_GLAccountLineItem._SubLedgerAccLineItemType,
      I_GLAccountLineItem._SuperiorOrder,
      I_GLAccountLineItem._Supplier,
      I_GLAccountLineItem._SupplierText,
      I_GLAccountLineItem._TaxCode,
      I_GLAccountLineItem._TransactionCurrency,
      I_GLAccountLineItem._User,
      //      _WBSElement,
      //      _WBSElementInternalID,
      I_GLAccountLineItem._WBSElementBasicData,
      //      _WBSElementInternalIDText,
      //      _WBSElementText,
      I_GLAccountLineItem._WorkCenter,
      I_GLAccountLineItem._WorkPackageText,

      _GLAccountFlowType,
      //      _GLAccountFlowTypeText,
      _GLAccountTypeFlowType,
      //      _GLAccountTypeFlowTypeTxt,

      I_GLAccountLineItem._CashLedgerCompanyCode,
      I_GLAccountLineItem._CashLedgerAccount,
      I_GLAccountLineItem._FinancialManagementArea,
      I_GLAccountLineItem._FundsCenter,
      I_GLAccountLineItem._FundedProgram,
      I_GLAccountLineItem._Fund,
      //      _Grant,
      I_GLAccountLineItem._BudgetPeriod,
      I_GLAccountLineItem._PartnerFund,
      //      _PartnerGrant,
      I_GLAccountLineItem._PartnerBudgetPeriod,
      I_GLAccountLineItem._PubSecBudgetAccountCoCode,
      I_GLAccountLineItem._PubSecBudgetAccount,
      I_GLAccountLineItem._PubSecBudgetCnsmpnDate,
      I_GLAccountLineItem._PubSecBudgetCnsmpnFsclPeriod,
      I_GLAccountLineItem._PubSecBudgetCnsmpnFsclYear,
      I_GLAccountLineItem._PubSecBudgetCnsmpnType,
      I_GLAccountLineItem._PubSecBudgetCnsmpnAmtType,
      I_GLAccountLineItem._CustomerCompany,
      I_GLAccountLineItem._SupplierCompany

}
where
  I_GLAccountLineItem.GLRecordType != '5'
