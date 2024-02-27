@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] Bank Statement Auto - Posting'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDGL_I_AUTO_POST
  as select from zmcdtgl0020
  association [1]    to ZMCDGL_V_POSTING_STATE    as _PostingState on  $projection.State = _PostingState.State
  association [1]    to I_HouseBankAccountLinkage as _Linkage      on  $projection.Company    = _Linkage.CompanyCode
                                                                   and $projection.Bank       = _Linkage.HouseBank
                                                                   and $projection.BankAcctID = _Linkage.HouseBankAccount
  association [0..*] to ZMCDGL_i_REVERSE_CHECK    as _ReverseCheck on  $projection.ID = _ReverseCheck.HeaderID
  association [0..*] to ZMCDGL_I_DISTINCT_CHECK   as _DistCheck    on  $projection.ID = _DistCheck.HeaderID
{
      @EndUserText.label: 'ID'
  key id                                                 as ID,

      @EndUserText.label: 'Document Sequence No.'
      doc_seq_no                                         as DocSeqNo,

      cast(substring( doc_seq_no , 3 , 8 ) as abap.dats) as CreatedDate,


      @EndUserText.label: 'Company Code'
      company                                            as Company,

      @EndUserText.label: '문서 Type'
      doc_type                                           as DocType,


      @EndUserText.label: '은행'
      bank                                               as Bank,

      @EndUserText.label: 'Bank Account ID'
      bank_acct_id                                       as BankAcctID,

      @EndUserText.label: '계좌'
      account                                            as Account,

      @EndUserText.label: 'Document Date'
      doc_date                                           as DocDate,

      @EndUserText.label: 'Posting Date'
      posting_date                                       as PostingDate,

      @EndUserText.label: '통화'
      transaction_currency                               as TransactionCurrency,

      @EndUserText.label: 'Total Amount'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      amount_in_transaction_currency                     as AmountInTransactionCurrency,

      @EndUserText.label: 'Reference Document Number'
      ref_doc_header                                     as RefDocHeader,

      @EndUserText.label: 'Status'
      state                                              as State,

      @EndUserText.label: 'Created By'
      @Semantics.user.createdBy: true
      created_by                                         as CreatedBy,

      @EndUserText.label: 'Created At'
      @Semantics.systemDateTime.createdAt: true
      created_at                                         as CreatedAt,

      @EndUserText.label: 'Local Last Changed By'
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by                              as LocalLastChangedBy,


      @EndUserText.label: 'Local Last Changed At'
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                                    as LastChangedAt,

      @EndUserText.label: 'Last Changed At'
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                              as LocalLastChangedAt,

      @EndUserText.label: 'Last Changed By'
      @Semantics.user.lastChangedBy: true
      last_changed_by                                    as LastChangedBy,

      _Linkage.BankAccountAlternative                    as ReconAccount,

//      @EndUserText.label: 'Reversal Check'
//      case state
//        when '0'
//        then
//          case _DistCheck.DistCount
//            when 1
//            then
//              case _ReverseCheck.IsReversed
//                when ''
//                then '0'
//                else '5'
//              end
//            else '2'
//          end
//        else ''
//      end                                                as RevState,
//
//      @EndUserText.label: 'Reversal Check'
//      case state
//        when '0'
//        then
//          case _DistCheck.DistCount
//            when 1
//            then
//              case _ReverseCheck.IsReversed
//                when ''
//                then ''
//                else 'Reversed'
//              end
//            else 'Reversal in progress'
//          end
//        else ''
//      end                                                as RevStateText,

      _ReverseCheck,

      _Linkage,

      _PostingState
}
