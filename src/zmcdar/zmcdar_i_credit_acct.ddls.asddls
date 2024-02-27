@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Export Smartstore PL - Act Dtl Acct Credit'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_CREDIT_ACCT as select from ZMCDAR_I_JE_ITEM
{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key LedgerGLLineItem,
  key Ledger,
      FiscalPeriod,
      //    CostCenterType,
      StoreCode,
      ProfitCenter,
      TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum(AmountInTransactionCurrency) as CreditAmt,
      _SmstCode.SmartStore,
      _SubSite.Subsite                 as SubSite
}
where DebitCreditCode = 'H'
  and IsReversal <> 'X'
  and IsReversed <> 'X'
group by
  CompanyCode,
  SourceLedger,
  Ledger,
  FiscalYear,
  FiscalPeriod,
  AccountingDocument,
  LedgerGLLineItem,
  ProfitCenter,
  StoreCode,
  _SubSite.Subsite,
  _SmstCode.SmartStore,
  TransactionCurrency,
  DebitCreditCode
