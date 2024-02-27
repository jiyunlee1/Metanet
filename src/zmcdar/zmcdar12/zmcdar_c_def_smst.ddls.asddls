@EndUserText.label: '[AR] Smart Store 정의'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZMCDAR_C_DEF_SMST
  provider contract transactional_query
  as projection on ZMCDAR_R_DEF_SMST
{
  key     SmartStore,

          SmartStoreName,

          Indent,

          IsComb,

          Formula,

          CreatedBy,

          CreatedAt,

          LocalLastChangedBy,

          LocalLastChangedAt,

          LastChangedAt,

          LastChangedBy
}
