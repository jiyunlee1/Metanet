@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 전표 사용 계정 관리'
define root view entity ZMCDAR_R_DOC_ACCT 
  as select from ZMCDAR_I_DOC_ACCT
{

  key ID,

      Company,

      CostType,

      RoleType,

      DocType,

      PostingKey,

      Account,

      AccountNM,

      CreatedBy,

      CreatedAt,

      LocalLastChangedBy,

      LocalLastChangedAt,

      LastChangedAt,

      LastChangedBy
}
