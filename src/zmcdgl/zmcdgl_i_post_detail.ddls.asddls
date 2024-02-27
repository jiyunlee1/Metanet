@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] Bank Statement Auto - Posting _ Detail'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDGL_I_POST_DETAIL
  as select from zmcdtgl0030
  association [1]    to ZMCDGL_I_AUTO_POST        as _Header    on  $projection.HeaderID = _Header.ID
  association [0..1] to ZMCDGL_I_SWP_ACCT         as _SweepAcct on  $projection.DebitAccount = _SweepAcct.Account
  association [0..1] to I_HouseBankAccountLinkage as _HBAcct    on  $projection.DebitAccount = _HBAcct.BankAccount
  association [0..1] to ZMCDGL_I_JOURNAL          as _JEItem    on  $projection.JournalEntry = _JEItem.AccountingDocument
                                                                and $projection.FiscalYear   = _JEItem.FiscalYear
                                                                and _JEItem.CompanyCode      = '1000'
{
      @EndUserText.label: 'ID'
  key id                                                            as ID,

      @EndUserText.label: 'HeaderID'
      header_id                                                     as HeaderID,

      @EndUserText.label: 'Document Date'
      doc_date_r                                                    as DocDateR,

      @EndUserText.label: 'Send Bank'
      send_bank                                                     as SendBank,

      @EndUserText.label: 'Sender'
      sender                                                        as Sender,

      @EndUserText.label: 'Document Date'
      doc_date_s                                                    as DocDateS,

      @EndUserText.label: 'Debit Bank'
      debit_bank                                                    as DebitBank,

      @EndUserText.label: 'Debit Account'
      debit_account                                                 as DebitAccount,

      @EndUserText.label: 'Fee'
      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'CurrencyCode'
      fee                                                           as Fee,

      @EndUserText.label: 'Posting Date'
      posting_date                                                  as PostingDate,

      substring( posting_date, 1, 4 )                               as FiscalYear,

      @EndUserText.label: '적요'
      description                                                   as Description,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      @EndUserText.label: 'Amount'
      @Aggregation.default: #SUM
      amount_in_transaction_currency                                as AmountInTransactionCurrency,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      @EndUserText.label: 'Total'
      @Aggregation.default: #SUM
      cast(fee + amount_in_transaction_currency as abap.curr(23,2)) as Total,

      currency_code                                                 as CurrencyCode,

      @EndUserText.label: '전표 번호'
      journalentry                                                  as JournalEntry,

      @EndUserText.label: 'Created By'
      created_by                                                    as CreatedBy,

      @EndUserText.label: 'Created At'
      created_at                                                    as CreatedAt,

      @EndUserText.label: 'Local Last Changed By'
      local_last_changed_by                                         as LocalLastChangedBy,

      @EndUserText.label: 'Local Last Changed At'
      local_last_changed_at                                         as LocalLastChangedAt,

      @EndUserText.label: 'Last Changed At'
      last_changed_at                                               as LastChangedAt,

      @EndUserText.label: 'Last Changed By'
      last_changed_by                                               as LastChangedBy,

      @EndUserText.label: 'Debit G/L Account'
      _SweepAcct.GLAccount                                          as DebitGL,

      _SweepAcct._Bank.BankName                                     as DebitNM,

      @EndUserText.label: 'Debit Description'
      _SweepAcct.Description                                        as DebitDescription,

      @EndUserText.label: 'Debit Profit Center'
      _SweepAcct.ProfitCenter                                       as DebitProfit,

      @EndUserText.label: 'Debit G/L Account (on House Bank)'
      cast(_HBAcct.BankAccountAlternative as hkont)                 as HouseDebitGL,

      _JEItem,

      _HBAcct.BankName                                              as HouseDebitNM,

      _HBAcct.HouseBank,
      
      _HBAcct.HouseBankAccount,

      _SweepAcct,

      _HBAcct
}
