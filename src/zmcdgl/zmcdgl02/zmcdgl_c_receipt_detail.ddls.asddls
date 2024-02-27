@EndUserText.label: '[GL] Bank Statement Auto - Posting _ Receipt Detail'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZMCDGL_C_RECEIPT_DETAIL
  provider contract transactional_query
  as projection on ZMCDGL_R_POST_DETAIL
{
  key     ID,
          HeaderID,
          DocDateR,
          SendBank,
          Sender,
          PostingDate,
          Description,
          AmountInTransactionCurrency,
          CurrencyCode,
          JournalEntry,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MCDGL_VE_JOURNALURL'
  virtual JournalUrl : abap.string,
          IsReversed,
          CreatedBy,
          CreatedAt,
          LocalLastChangedBy,
          LocalLastChangedAt,
          LastChangedAt,
          LastChangedBy
}
