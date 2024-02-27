@EndUserText.label: '[GL] Bank Statement Auto - Posting _ Sweeping Detail'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZMCDGL_C_SWEEP_DETAIL
  provider contract transactional_query
  as projection on ZMCDGL_R_POST_DETAIL
{
  key     ID,
          HeaderID,
          DocDateS,
          DebitBank,
          DebitAccount,
          Fee,
          PostingDate,
          Description,
          AmountInTransactionCurrency,
          Total,
          CurrencyCode,
          CreatedBy,
          CreatedAt,
          LocalLastChangedBy,
          LocalLastChangedAt,
          LastChangedAt,
          LastChangedBy,
          DebitGL,
          HouseDebitGL,
          JournalEntry,
          HouseBank,
          HouseBankAccount,
          HouseDebitNM,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MCDGL_VE_SWJOURNALURL'
  virtual JournalUrl : abap.string,
          IsReversed,
          /* Associations */
          _AutoPost,
          _SweepAcct,
          _HBAcct
}
