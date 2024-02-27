@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[CM] MIME Repository'
define root view entity ZMCDCM_R_MIME_REPOSITORY
  as select from ZMCDCM_I_MIME_REPOSITORY
{
  key ID,

  ProgPackage,

  Purpose,

  Attachment,

  MimeType,

  FileName,

  Description,

  CreatedBy,

  CreatedAt,

  LocalLastChangedBy,

  LocalLastChangedAt,

  LastChangedAt,

  LastChangedBy

}
