@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Export Smartstore PL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zmcdar_i_debit_credit
  as select from ZMCDAR_I_JE_ITEM
{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key LedgerGLLineItem,
  key Ledger,
      FiscalPeriod,
      CostCenterType,
      GLAccount,
      CostCenter,
      ProfitCenter,
      TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case DebitCreditCode
        when 'S'
        then AmountInTransactionCurrency
        when 'H'
        then cast('0.00' as abap.curr( 23, 2 ))
      end as DebitAmt,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case DebitCreditCode
        when 'S'
        then cast('0.00' as abap.curr( 23, 2 ))
        when 'H'
        then
          case substring( GLAccount, 4, 1 )
            when '2'
            then AmountInTransactionCurrency * -1
            when '4'
            then AmountInTransactionCurrency * -1
            else AmountInTransactionCurrency
          end
      end as CreditAmt,
      DebitCreditCode,
      PostingDate,
      DocumentDate,
      AccountingDocumentType,
      AccountingDocumentItem,
      PostingKey,
      TaxCode,
      TaxCountry,
      StoreCode,
      /* Associations */
      _AccountTxt,
      _CostCetnerType,
      _SmstCode,
      _SubSite
}
where IsReversal <> 'X'
  and IsReversed <> 'X'
