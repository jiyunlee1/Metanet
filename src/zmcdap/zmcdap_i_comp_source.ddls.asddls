@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier ETax Invoice Comparison List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAP_I_COMP_SOURCE
  as select from ZMCDAP_I_JE_SOURCE
  association [0..1] to ZMCDAP_I_EXCPT_STATUS as _ExcptStat on $projection.IssueNo = _ExcptStat.IssueNo
{
      @EndUserText.label: 'Journal Entry'
  key AccountingDocument,

      @EndUserText.label: 'Approval No'
  key IssueNo,

  key FiscalYear,

      SourceLedger,

      CompanyCode,

      //  AccountingDocument,

      LedgerGLLineItem,

      Ledger,

      @EndUserText.label: 'Business Place'
      BizPlace,

      //      @EndUserText.label: '종사업장'
      //      Supplier,

      @EndUserText.label: 'Supplier (Jaurnal Entry)'
      JESupCorpNm,
      @EndUserText.label: 'Supplier (NTS)'
      _Invoice.SupCorpNm            as NTSSupCorpNm,
      @EndUserText.label: 'Supplier'
      SupCorpNm,

      @EndUserText.label: 'Business No (Jaurnal Entry)'
      JESupBizNo,
      @EndUserText.label: 'Business No (NTS)'
      _Invoice.SupBizNo             as NTSSupBizNo,
      @EndUserText.label: 'Business No'
      SupBizNo,

      //  IssueNo,
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
    
    
      case
        when _MainInvoice.IssueNo is null then cast('00000000' as abap.dats(8))
        else _MainInvoice.MakeDt
      end                           as MakeDt,
      
      case
        when _MainInvoice.IssueNo is null then cast('' as abap.cuky(5))
        else _MainInvoice.Currency
      end                           as Currency,

      @Semantics.amount.currencyCode: 'DefCurrency'
      case
        when _MainInvoice.SupAmt is null
          then cast(0 as abap.curr(23, 2))
        else
          _MainInvoice.SupAmt
      end                           as SupAmt,

      @Semantics.amount.currencyCode: 'DefCurrency'
      case
        when _MainInvoice.TaxAmt is null
          then cast(0 as abap.curr(23, 2))
        else
          _MainInvoice.TaxAmt
      end                           as TaxAmt,

      @Semantics.amount.currencyCode: 'DefCurrency'
      case
        when _MainInvoice.TotAmt is null
          then cast(0 as abap.curr(23, 2))
        else
          _MainInvoice.TotAmt
      end                           as TotAmt,

      @EndUserText.label: 'Date (Difference)'
      case
        when _MainInvoice.MakeDt is null
          then cast('1' as abap.char(1))
        else
          case
            when substring(DocumentDate, 1, 6) <> substring(_MainInvoice.MakeDt, 1, 6)
              then cast('1' as abap.char(1))
            else cast('' as abap.char(1))
          end
      end                           as isDifDate,

      cast('' as abap.char(1))      as isDifDateCol,

      @EndUserText.label: 'Net Amount (Difference)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      case
        when JESupAmt is null
          then cast((- _MainInvoice.SupAmt) as abap.curr(23,2))
        when _MainInvoice.SupAmt is null
          then cast((JESupAmt) as abap.curr(23,2))
        else cast((JESupAmt - _MainInvoice.SupAmt) as abap.curr(23,2))
      end                           as DifSupAmt,

      @EndUserText.label: 'Tax Amount (Difference)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      case
        when JETaxAmt is null
          then cast((- _MainInvoice.TaxAmt) as abap.curr(23,2))
        when _MainInvoice.TaxAmt is null
          then cast((JETaxAmt) as abap.curr(23,2))
        else cast((JETaxAmt - _MainInvoice.TaxAmt) as abap.curr(23,2))
      end                           as DifTaxAmt,

      @EndUserText.label: 'Gross Amount (Difference)'
      @Semantics.amount.currencyCode: 'DefCurrency'
      case
        when _MainInvoice.BillType = '4' or _MainInvoice.BillType = '3'
          then
            case
              when JESupAmt is null
                then cast((- _MainInvoice.SupAmt) as abap.curr(23,2))
              when _MainInvoice.TotAmt is null
                then cast((JESupAmt) as abap.curr(23,2))
              else cast((JESupAmt - _MainInvoice.SupAmt) as abap.curr(23,2))
            end
        else
          case
            when JETotAmt is null
              then cast((- _MainInvoice.TotAmt) as abap.curr(23,2))
            when _MainInvoice.TotAmt is null
              then cast((JETotAmt) as abap.curr(23,2))
            else cast((JETotAmt - _MainInvoice.TotAmt) as abap.curr(23,2))
          end
        end                         as DifTotAmt,

      cast( 'KRW' as abap.cuky(5) ) as DefCurrency,
      //      _MainInvoice.SupAmt,
      //
      //      _maininvoice.TaxAmt,
      //
      //      _maininvoice.TotAmt,

      case
        when _ExcptStat.ExptStat is null
          then cast(' ' as zmcdde_expt_status_type)
        else _ExcptStat.ExptStat
      end                           as ExptStat,

      IsReversed,

      IsReversal,

      ReversalReferenceDocument,

      IsMain,

      LedgerGroup,

      PostingDate,

      AccountingDocCreatedByUser,

      AccountingDocumentType,

      //  @EndUserText.label: 'Business Place'
      //  _MainInvoice.BusinessPlaceName,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.SupBizSubNo
      end                           as SupBizSubNo,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.ByrBizNo
      end                           as ByrBizNo,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.BillType
      end                           as BillType,

      case
        when _MainInvoice.IssueNo is null then '00000000'
        else _MainInvoice.IssueDt
      end                           as IssueDt,

      case
        when _MainInvoice.IssueNo is null then '00000000'
        else _MainInvoice.SendDt
      end                           as SendDt,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.SupRepNm
      end                           as SupRepNm,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.SupAddress
      end                           as SupAddress,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.ByrBizSubNo
      end                           as ByrBizSubNo,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.ByrCorpNm
      end                           as ByrCorpNm,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.ByrRepNm
      end                           as ByrRepNm,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.ByrAddress
      end                           as ByrAddress,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.TaxClsf
      end                           as TaxClsf,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.TaxKnd
      end                           as TaxKnd,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.IsnType
      end                           as IsnType,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.Bigo
      end                           as Bigo,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.DemandGb
      end                           as DemandGb,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.SupEmail
      end                           as SupEmail,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.ByrEmail1
      end                           as ByrEmail1,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.ByrEmail2
      end                           as ByrEmail2,

      case
        when _MainInvoice.IssueNo is null then cast('00000000' as abap.dats(8))
        else _MainInvoice.ItemDt
      end                           as ItemDt,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.ItemNm
      end                           as ItemNm,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.ItemStd
      end                           as ItemStd,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.ItemQty
      end                           as ItemQty,

      @Semantics.amount.currencyCode: 'Currency'
      case
        when _MainInvoice.IssueNo is null then cast(0 as abap.curr(30,2))
        else _MainInvoice.ItemUnt
      end                           as ItemUnt,
      
      @Semantics.amount.currencyCode: 'Currency'
      case
        when _MainInvoice.ItemSupAmt is null then cast(0 as abap.curr(23,2))
        else _MainInvoice.ItemSupAmt
      end                           as ItemSupAmt,

      @Semantics.amount.currencyCode: 'Currency'
      case
        when _MainInvoice.IssueNo is null then cast(0 as abap.curr(23,2))
        else _MainInvoice.ItemTaxAmt
      end                           as ItemTaxAmt,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.ItemBigo
      end                           as ItemBigo,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.ItemState
      end                           as ItemState,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.CstnBizNO
      end                           as CstnBizNO,
      
      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.CstnCorpNm
      end                           as CstnCorpNm,

      case
        when _MainInvoice.IssueNo is null then cast('000000000000000000000' as abp_creation_tstmpl)
        else _MainInvoice.CreatedAt
      end                           as CreatedAt,
      
      case
        when _MainInvoice.IssueNo is null then cast('' as abp_creation_user)
        else _MainInvoice.CreatedBy
      end                           as CreatedBy,
      
      case
        when _MainInvoice.IssueNo is null then cast('000000000000000000000' as abp_lastchange_tstmpl)
        else _MainInvoice.LastChangedAt
      end                           as LastChangedAt,
      
      case
        when _MainInvoice.IssueNo is null then cast('' as abp_lastchange_user)
        else _MainInvoice.LastChangedBy
      end                           as LastChangedBy,
      
      case
        when _MainInvoice.IssueNo is null then cast('000000000000000000000' as abp_locinst_lastchange_tstmpl)
        else _MainInvoice.LocalLastChangedAt
      end                           as LocalLastChangedAt,
      
      case
        when _MainInvoice.IssueNo is null then cast('' as abp_locinst_lastchange_user  )
        else _MainInvoice.LocalLastChangedBy
      end                           as LocalLastChangedBy,

      //      _MainInvoice.CreatedBy,
      //
      //      _MainInvoice.CreatedAt,
      //
      //      _MainInvoice.LocalLastChangedBy,
      //
      //      _MainInvoice.LocalLastChangedAt,
      //
      //      _MainInvoice.LastChangedAt,
      //
      //      _MainInvoice.LastChangedBy,


      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.BillTypeText
      end                           as BillTypeText,

      case
        when _MainInvoice.IssueNo is null then ''
        else _MainInvoice.ItemStateText
      end                           as ItemStateText


      /* Associations */
      //      _Invoice,
      //
      //      _MainInvoice,
      //
      //      _MainJE,
      //
      //      _JournalEntry
}
union select from ZMCDAP_I_INVOICE_SOURCE
association [0..1] to ZMCDAP_I_EXCPT_STATUS as _ExcptStat on $projection.IssueNo = _ExcptStat.IssueNo
{
  key cast('' as abap.char(10))           as AccountingDocument,
  key IssueNo,
  key cast('0000' as abap.numc(4))            as FiscalYear,

      cast('' as abap.char(2))            as SourceLedger,

      cast('' as abap.char(4))            as CompanyCode,

      cast('' as abap.char(6))            as LedgerGLLineItem,

      cast('' as abap.char(2))            as Ledger,

      BizPlace,

      //      @EndUserText.label: '종사업장'
      //      Supplier,

      cast('' as abap.char(80))           as JESupCorpNm,
      SupCorpNm                           as NTSSupCorpNm,
      SupCorpNm,

      cast('' as abap.char(13))           as JESupBizNo,
      SupBizNo                            as NTSSupBizNo,
      SupBizNo,

      cast('' as abap.char(24))           as MainIssueNo,

      cast('' as abap.char(10))           as ProfitCenter,

      cast('00000000' as abap.dats(8))    as DocumentDate,

      cast('KRW' as abap.cuky(5))         as CompanyCodeCurrency,
      cast(0 as abap.curr(23, 2))         as JESupAmt,

      cast('KRW' as abap.cuky(5))         as TransactionCurrency,
      cast(0 as abap.curr(23, 2))         as JETaxAmt,

      cast(0 as abap.curr(23, 2))         as JETotAmt,

      MakeDt,

      Currency,

      SupAmt,

      TaxAmt,

      TotAmt,


      //      case
      //        when _MainItem.DocumentDate is null
      //          then cast('1' as abap.char(1))
      //        else
      //          case
      //            when substring(_MainItem.DocumentDate, 1, 6) <> substring(MakeDt, 1, 6)
      //              then cast('1' as abap.char(1))
      //            else cast('' as abap.char(1))
      //          end
      //      end                           as isDifDate,

      cast ('1' as abap.char(1))          as isDifDate,

      cast('' as abap.char(1))            as isDifDateCol,

      //      case
      //        when _MainItem.JESupAmt is null
      //          then cast((- SupAmt) as abap.curr(23,2))
      //        when SupAmt is null
      //          then cast((_MainItem.JESupAmt) as abap.curr(23,2))
      //        else cast((_MainItem.JESupAmt - SupAmt) as abap.curr(23,2))
      //      end                           as DifSupAmt,
      //      case
      //        when _MainItem.JETaxAmt is null
      //          then cast((- TaxAmt) as abap.curr(23,2))
      //        when TaxAmt is null
      //          then cast((_MainItem.JETaxAmt) as abap.curr(23,2))
      //        else cast((_MainItem.JETaxAmt - TaxAmt) as abap.curr(23,2))
      //      end                           as DifTaxAmt,
      //      case
      //        when BillType = '4' or BillType = '3'
      //          then
      //            case
      //              when _MainItem.JESupAmt is null
      //                then cast((- SupAmt) as abap.curr(23,2))
      //              when TotAmt is null
      //                then cast((_MainItem.JESupAmt) as abap.curr(23,2))
      //              else cast((_MainItem.JESupAmt - SupAmt) as abap.curr(23,2))
      //            end
      //        else
      //          case
      //            when _MainItem.JETotAmt is null
      //              then cast((- TotAmt) as abap.curr(23,2))
      //            when TotAmt is null
      //              then cast((_MainItem.JETotAmt) as abap.curr(23,2))
      //            else cast((_MainItem.JETotAmt - TotAmt) as abap.curr(23,2))
      //          end
      //      end                           as DifTotAmt,
      cast((- SupAmt) as abap.curr(23,2)) as DifSupAmt,

      cast((- TaxAmt) as abap.curr(23,2)) as DifTaxAmt,

      cast((- TotAmt) as abap.curr(23,2)) as DifTotAmt,

      cast( 'KRW' as abap.cuky(5) )       as DefCurrency,

      //      _MainInvoice.SupAmt,
      //
      //      _maininvoice.TaxAmt,
      //
      //      _maininvoice.TotAmt,

      case
        when _ExcptStat.ExptStat is null
          then cast(' ' as zmcdde_expt_status_type)
        else _ExcptStat.ExptStat
      end                                 as ExptStat,

      //    Journal Entry Hidden
      cast('' as xfeld)                   as IsReversed,

      cast('' as xfeld)                   as IsReversal,

      cast('' as abap.char(10))           as ReversalReferenceDocument,

      cast('' as abap_boolean)            as IsMain,

      cast('' as abap.char(4))            as LedgerGroup,

      cast('00000000' as abap.dats(8))    as PostingDate,

      cast('' as abap.char(12))           as AccountingDocCreatedByUser,

      cast('' as abap.char(2))            as AccountingDocumentType,

      //  BusinessPlaceName,

      //    NTS Hidden
      SupBizSubNo,

      ByrBizNo,

      BillType,

      IssueDt,

      SendDt,

      SupRepNm,

      SupAddress,

      ByrBizSubNo,

      ByrCorpNm,

      ByrRepNm,

      ByrAddress,

      TaxClsf,

      TaxKnd,

      IsnType,

      Bigo,

      DemandGb,

      SupEmail,

      ByrEmail1,

      ByrEmail2,

      ItemDt,

      ItemNm,

      ItemStd,

      ItemQty,

      ItemUnt,

      ItemSupAmt,

      ItemTaxAmt,

      ItemBigo,

      ItemState,

      //      _MainInvoice.CreatedBy,
      //
      //      _MainInvoice.CreatedAt,
      //
      //      _MainInvoice.LocalLastChangedBy,
      //
      //      _MainInvoice.LocalLastChangedAt,
      //
      //      _MainInvoice.LastChangedAt,
      //
      //      _MainInvoice.LastChangedBy,


      CstnBizNO,
      CstnCorpNm,
      CreatedAt,
      CreatedBy,
      LastChangedAt,
      LastChangedBy,
      LocalLastChangedAt,
      LocalLastChangedBy,

      BillTypeText,

      ItemStateText


      //  /* Associations */
      //  _JESource._Invoice,
      //
      //  _JESource._MainInvoice,
      //
      //  _JESource._MainJE,
      //
      //  _JESource._JournalEntry
}
where
     MainDoc is initial
  or MainDoc is null
