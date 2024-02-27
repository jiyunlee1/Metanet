@EndUserText.label: '[AP] Supplier ETax Invoice Comparison List'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZMCDAP_C_COMP_EXCPT
  provider contract transactional_query
  as projection on ZMCDAP_R_COMP_EXCPT
{
  key Id,
      IssueNo,
      ExptStat,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      LastChangedBy
}
