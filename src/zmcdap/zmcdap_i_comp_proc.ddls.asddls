@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier ETax Invoice Comparison List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAP_I_COMP_PROC
  as select from ZMCDAP_I_COMP_SOURCE
{
      @EndUserText.label: 'Journal Entry'
  key AccountingDocument,

  key FiscalYear,

      @EndUserText.label: 'Approval No'
  key IssueNo,

      @EndUserText.label: 'Business Place'
      BizPlace,

      @EndUserText.label: 'Supplier (Jaurnal Entry)'
      JESupCorpNm,

      @EndUserText.label: 'Supplier (NTS)'
      NTSSupCorpNm,

      @EndUserText.label: 'Supplier'
      SupCorpNm,

      @EndUserText.label: 'Business No (Jaurnal Entry)'
      JESupBizNo,

      @EndUserText.label: 'Business No (NTS)'
      NTSSupBizNo,

      @EndUserText.label: 'Business No'
      SupBizNo,

      MainIssueNo,

      @EndUserText.label: 'Profit Center'
      ProfitCenter,

      @EndUserText.label: 'Journal Entry Date'
      DocumentDate,

      CompanyCodeCurrency,

      @EndUserText.label: 'Net Amount (SAP)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      JESupAmt,

      TransactionCurrency,

      @EndUserText.label: 'Tax Amount (SAP)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      JETaxAmt,

      @EndUserText.label: 'Gross Amount (SAP)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      JETotAmt,

      @EndUserText.label    : 'Start Date'
      MakeDt,

      Currency,

      @EndUserText.label: 'Net Amount (NTS)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      SupAmt,

      @EndUserText.label: 'Tax Amount (NTS)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      TaxAmt,

      @EndUserText.label: 'Gross Amount (NTS)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      TotAmt,

      @EndUserText.label: 'Date (Difference)'
      isDifDate,

      @EndUserText.label: 'Date (Difference)'
      isDifDateCol,

      @EndUserText.label: 'Net Amount (Difference)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      DifSupAmt,

      @EndUserText.label: 'Tax Amount (Difference)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      DifTaxAmt,

      @EndUserText.label: 'Gross Amount (Difference)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      DifTotAmt,

      DefCurrency,

      @EndUserText.label: 'Difference Type'
      case
        when DifSupAmt is not initial
          or DifTaxAmt is not initial
          or DifTotAmt is not initial
        then cast('1' as zmcdde_diff_stat_type)
        else cast(' ' as zmcdde_diff_stat_type)
      end as IsDiffAmt,

      @EndUserText.label: 'Difference Type'
      case
        when isDifDate is not initial
          or DifSupAmt is not initial
          or DifTaxAmt is not initial
          or DifTotAmt is not initial
        then cast('1' as zmcdde_diff_stat_type)
        else cast(' ' as zmcdde_diff_stat_type)
      end as IsDiff,

      @EndUserText.label: 'Excluding Status'
      ExptStat,

      //    Journal Entry Hidden data
      IsReversed,

      IsReversal,

      ReversalReferenceDocument,

      IsMain,

      SourceLedger,

      CompanyCode,

      LedgerGLLineItem,

      Ledger,

      LedgerGroup,

      PostingDate,

      AccountingDocCreatedByUser,

      AccountingDocumentType,


      @EndUserText.label    : 'Supplier Business Sub Number'
      SupBizSubNo,

      @EndUserText.label    : 'Buyer Business No'
      ByrBizNo,

      @EndUserText.label    : 'Tax Classification 1'
      BillType,

      @EndUserText.label    : 'Issue Date'
      IssueDt,

      @EndUserText.label    : 'Send Date'
      SendDt,

      @EndUserText.label    : 'Supplier CEO'
      SupRepNm,

      @EndUserText.label    : 'Supplier Address'
      SupAddress,

      @EndUserText.label    : 'Buyer Business Sub Number'
      ByrBizSubNo,

      @EndUserText.label    : 'Buyer Business Name'
      ByrCorpNm,

      @EndUserText.label    : 'Buyer CEO'
      ByrRepNm,

      @EndUserText.label    : 'Buyer Address'
      ByrAddress,

      @EndUserText.label    : 'Tax Classification 2'
      TaxClsf,

      @EndUserText.label    : 'Issue Type1'
      TaxKnd,

      @EndUserText.label    : 'Issue Type2'
      IsnType,

      @EndUserText.label    : 'Note'
      Bigo,

      @EndUserText.label    : 'Demand Type'
      DemandGb,

      @EndUserText.label    : 'Supplier Email'
      SupEmail,

      @EndUserText.label    : 'Buyer Email1'
      ByrEmail1,

      @EndUserText.label    : 'Buyer Email2'
      ByrEmail2,

      @EndUserText.label    : 'Item Date'
      ItemDt,

      @EndUserText.label    : 'Item Name'
      ItemNm,

      @EndUserText.label    : 'Item Standard'
      ItemStd,

      @EndUserText.label    : 'Item Quantity'
      ItemQty,

      @EndUserText.label    : 'Item Unit Price'
      @Semantics.amount.currencyCode: 'DefCurrency'
      ItemUnt,

      @EndUserText.label    : 'Item Net Amount'
      @Semantics.amount.currencyCode: 'DefCurrency'
      ItemSupAmt,

      @EndUserText.label    : 'Item Tax Amount'
      @Semantics.amount.currencyCode: 'DefCurrency'
      ItemTaxAmt,

      @EndUserText.label    : 'Item Note'
      ItemBigo,

      @EndUserText.label    : 'Item State'
      ItemState,

      @EndUserText.label    : 'Tax Classification 1'
      BillTypeText,

      @EndUserText.label    : 'Item State'
      ItemStateText,

      CstnBizNO,
      CstnCorpNm,
      CreatedAt,
      CreatedBy,
      LastChangedAt,
      LastChangedBy,
      LocalLastChangedAt,
      LocalLastChangedBy
}
