@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Journal Entry Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_JE_ITEM
  as select from I_JournalEntryItem
  association [1] to ZMCDAR_I_COST_CENTER as _CostCetnerType on $projection.CostCenter = _CostCetnerType.CostCenter
  association [1] to ZMCDAR_I_SMST_CODE   as _SmstCode       on $projection.GLAccount = _SmstCode.Account
  association [1] to ZMCDAR_I_SUB_SITE    as _SubSite        on $projection.costcentertype = _SubSite.CostcenterType
  association [1] to ZMCDAR_V_GL_ACCOUNT  as _AccountTxt     on $projection.GLAccount = _AccountTxt.GLAccount
{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key LedgerGLLineItem,
  key Ledger,
      ChartOfAccounts,
      FiscalPeriod,
      _CostCetnerType.CostCenterType,
      //      _SmstCode.SmartStore,
      //      _SubSite.Subsite,
      GLAccount,
      I_JournalEntryItem.CostCenter,
      ProfitCenter,
      TransactionCurrency,
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      AmountInTransactionCurrency,
      DebitCreditCode,
      PostingDate,
      DocumentDate,
      AccountingDocumentType,
      AccountingDocumentItem,
      PostingKey,
      TaxCode,
      TaxCountry,
      substring( ProfitCenter, 7 , 4 ) as StoreCode,
      DocumentItemText,
      IsReversed,
      IsReversal,
      cast(1 as abap.int8)             as Cnt,
      _AccountTxt.GLAccountName,
      _CostCetnerType,
      _SmstCode,
      _SubSite,
      _AccountTxt,
      _SmstCode.Lineuse
}
where
  SourceLedger = '0L'
