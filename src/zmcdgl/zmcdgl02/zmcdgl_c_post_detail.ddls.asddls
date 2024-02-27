@EndUserText.label: '[GL] Bank Statement Auto - Posting _ Detail'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZMCDGL_C_POST_DETAIL
  as projection on ZMCDGL_R_POST_DETAIL
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
      AmountInTransactionCurrency,
      CurrencyCode,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      LastChangedBy,
      /* Associations */
      _SweepAcct,
      _AutoPost : redirected to parent ZMCDGL_C_AUTO_POST
}
