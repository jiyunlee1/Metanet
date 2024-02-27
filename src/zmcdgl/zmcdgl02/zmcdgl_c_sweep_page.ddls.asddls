@EndUserText.label: '[GL] Bank Statement Auto - Posting _ Sweeping Page'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZMCDGL_C_SWEEP_PAGE
  provider contract transactional_query
  as projection on ZMCDGL_R_AUTO_POST
  association [0..*] to ZMCDGL_C_SWEEP_DETAIL as _SweepDetail on $projection.ID = _SweepDetail.HeaderID
{
  key ID,
      DocSeqNo,
      Company,
      DocType,
      Bank,
      BankAcctID,
      Account,
      DocDate,
      PostingDate,
      TransactionCurrency,
      AmountInTransactionCurrency,
      RefDocHeader,
      State,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      LastChangedBy,
      _PostingState.StateText,
      _Linkage.BankAccountAlternative as ReconAcct,
      /* Associations */
      _Linkage,
      _PostDetail,
      _PostingState,
      _SweepDetail

}
