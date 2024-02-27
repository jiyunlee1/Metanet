@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier ETax Invoice Comparison List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAP_I_DOC_TAX_ITEM
  as select from I_OperationalAcctgDocTaxItem
{
  key CompanyCode,
  key AccountingDocument,
  key FiscalYear,
  key TaxItem,
  key TaxItemUUID,
      TaxCode,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      TaxBaseAmountInCoCodeCrcy,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxBaseAmountInTransCrcy,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      TaxAmountInCoCodeCrcy,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxAmountInTransCrcy,
      TransactionTypeDetermination,
      @Semantics.amount.currencyCode: 'ReportingCurrency'
      TaxAmountInRptgCrcy,
      @Semantics.amount.currencyCode: 'ReportingCurrency'
      TaxBaseAmountInRptgCrcy,
      ReportingCountry,
      ReportingCurrency,
      CompanyCodeCurrency,
      TransactionCurrency,
      TaxDataSource,
      DebitCreditCode,
      /* Associations */
      _CompanyCode,
      _CompanyCodeCurrency,
      _JournalEntry,
      _OperationalAcctgDocItem
}
where
     TaxCode = 'VA'
  or TaxCode = 'V1'
  or TaxCode = 'V4'
