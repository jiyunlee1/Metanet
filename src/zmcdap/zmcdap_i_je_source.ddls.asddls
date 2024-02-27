@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier ETax Invoice Comparison List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAP_I_JE_SOURCE
  as select from ZMCDAP_I_JE_ITEM
  association [0..1] to ZMCDAP_I_JE_MAIN_ITEM as _MainJE      on $projection.AccountingDocument = _MainJE.MainDoc

  association [0..1] to ZMCDAP_I_INVOICE      as _Invoice     on $projection.IssueNo = _Invoice.IssueNo
  association [0..1] to ZMCDAP_I_INVOICE      as _MainInvoice on $projection.MainIssueNo = _MainInvoice.IssueNo
{
  key SourceLedger,

  key CompanyCode,

  key FiscalYear,

      @EndUserText.label: 'Journal Entry'
  key AccountingDocument,

  key LedgerGLLineItem,

  key Ledger,

      @EndUserText.label: 'Business Place'
      BizPlace,

      @EndUserText.label: '종사업장'
      Supplier,

      JESupCorpNm,
      @EndUserText.label: 'Supplier'
      case
        when _Invoice.SupBizNo is null
          then JESupCorpNm
        else
            case
              when JESupBizNo <> _Invoice.SupBizNo
                then ''
              else JESupCorpNm
            end
      end                                               as SupCorpNm,

      JESupBizNo,
      @EndUserText.label: 'Business No'
      case
        when _Invoice.SupBizNo is null
          then JESupBizNo
        else
            case
              when JESupBizNo <> _Invoice.SupBizNo
                then ''
              else JESupBizNo
            end
      end                                               as SupBizNo,

      @EndUserText.label: 'Approval No'
      JrnlEntryCntrySpecificRef1                        as IssueNo,
      _MainJE.IssueNo                                   as MainIssueNo,

      @EndUserText.label: 'Profit Center'
      ProfitCenter,

      @EndUserText.label: 'Journal Entry Date'
      DocumentDate,

      CompanyCodeCurrency,
      @EndUserText.label: 'Net Amount (SAP)'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      JESupAmt,

      TransactionCurrency,
      @EndUserText.label: 'Tax Amount (SAP)'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      JETaxAmt,

      @EndUserText.label: 'Gross Amount (SAP)'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast((JESupAmt + JETaxAmt) as abap.curr( 23, 2 )) as JETotAmt,

      IsReversed,

      IsReversal,

      case
        when _MainJE.IssueNo is not null
        then cast('X' as abap_boolean)
        else cast(' ' as abap_boolean)
      end                                               as IsMain,

      @EndUserText.label: 'Ledger Group'
      LedgerGroup,

      @EndUserText.label: 'Posting Date'
      PostingDate,

      @EndUserText.label: 'Journal Entry Created By'
      AccountingDocCreatedByUser,

      @EndUserText.label: 'Journal Entry Type'
      AccountingDocumentType,

      ReversalReferenceDocument,

      _Invoice,

      _MainInvoice,

      _MainJE,

      _JournalEntry
      //      case JrnlEntryCntrySpecificRef1
      //        when _MainJE.IssueNo
      //        then _Invoice.MakeDt
      //        else cast('' as abap.dats)
      //      end                                               as MakeDt,

      //  @Semantics.amount.currencyCode: 'Currency'
      //  @EndUserText.label: 'Gross Amount (NTS)'
      //  case JrnlEntryCntrySpecificRef1
      //    when _MainJE.IssueNo
      //    then _Invoice.SupAmt
      //    else cast(0 as abap.curr(23, 2))
      //  end                                               as SupAmt,
      //
      //  @Semantics.amount.currencyCode: 'Currency'
      //  @EndUserText.label: 'Gross Amount (NTS)'
      //  case JrnlEntryCntrySpecificRef1
      //    when _MainJE.IssueNo
      //    then _Invoice.TaxAmt
      //    else cast(0 as abap.curr(23, 2))
      //  end                                               as TaxAmt,
      //
      //  @Semantics.amount.currencyCode: 'Currency'
      //  @EndUserText.label: 'Gross Amount (NTS)'
      //  case JrnlEntryCntrySpecificRef1
      //    when _MainJE.IssueNo
      //    then _Invoice.TotAmt
      //    else cast(0 as abap.curr(23, 2))
      //  end                                               as TotAmt,

      //  _Invoicemain.MakeDt,
      //
      //  _InvoiceMain.SupAmt,
      //
      //  _InvoiceMain.TaxAmt,
      //
      //  _invoicemain.TotAmt,



      //      ChartOfAccounts,
      //
      //      FiscalPeriod,
      //
      //      GLAccount,
      //
      //      CostCenter,
      //
      //      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      //      AmountInTransactionCurrency,
      //
      //      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      //      AmountInCompanyCodeCurrency,
      //
      //      DebitCreditCode,
      //
      //      PostingDate,
      //
      //      AccountingDocumentType,
      //
      //      AccountingDocumentItem,
      //
      //      PostingKey,
      //
      //      TaxCode,
      //
      //      TaxCountry,
      //
      //      StoreCode,
      //
      //      DocumentItemText,
      //
      //      IsReversed,
      //
      //      /* Associations */
      //      _AccountingDocumentType,
      //      _AccountingDocumentTypeText,
      //      _CalendarDate,
      //      _ChartOfAccounts,
      //      _ChartOfAccountsText,
      //      _CompanyCode,
      //      _CompanyCodeText,
      //      _CostCenterText,
      //      _DebitCreditCode,
      //      _DebitCreditCodeText,
      //      _FiscalYear,
      //      _GLAccountInChartOfAccounts,
      //      _GLAccountInCompanyCode,
      //      _GLAccountText,
      //      _GLAccountTxt,
      //      _GLAcctInChartOfAccountsText,
      //      _JournalEntry,
      //      _Ledger,
      //      _LedgerCompanyCodeCrcyRoles,
      //      _LedgerText,
      //      _PostingKey,
      //      _ProfitCenterText,
      //      _SemTagGLAccount,
      //      _SourceLedger,
      //      _SourceLedgerText,
      //      _TaxCode,
      //      _TaxCountry,
      //      _TransactionCurrency
}
//where JrnlEntryCntrySpecificRef1 is not null
//  and JrnlEntryCntrySpecificRef1 is not initial
