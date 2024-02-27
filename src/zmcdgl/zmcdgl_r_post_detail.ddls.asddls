@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] Bank Statement Auto - Posting _ Detail'
define view entity ZMCDGL_R_POST_DETAIL
  as select from ZMCDGL_I_POST_DETAIL
  association to parent ZMCDGL_R_AUTO_POST as _AutoPost on $projection.HeaderID = _AutoPost.ID
{
  key ID,
      HeaderID,
      DocDateR,
      SendBank,
      Sender,
      DocDateS,
      DebitBank,
      DebitAccount,
      Fee,
      PostingDate,
      Description,
      Total,
      AmountInTransactionCurrency,
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
      HouseDebitNM,
      HouseBank,
      HouseBankAccount,
      /* Associations */
      _JEItem.IsReversed,
      _SweepAcct,
      _AutoPost,
      _HBAcct
}
