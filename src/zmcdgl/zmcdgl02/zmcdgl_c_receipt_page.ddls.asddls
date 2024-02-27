@EndUserText.label: '[GL] Bank Statement Auto - Posting _ Receipt Page'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZMCDGL_C_RECEIPT_PAGE
  as projection on ZMCDGL_R_AUTO_POST
  association [0..*] to ZMCDGL_C_RECEIPT_DETAIL as _ReceiptDetail on $projection.ID = _ReceiptDetail.HeaderID
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
      _PostingState,
      _ReceiptDetail
}
