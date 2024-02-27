@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Supplier ETax Invoice Comparison List'
define root view entity ZMCDAP_R_COMP_EXCPT
  as select from ZMCDAP_I_COMP_EXCPT
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
