@EndUserText.label: '[CM] MIME Repository'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZMCDCM_C_MIME_REPOSITORY
  provider contract transactional_query
  as projection on ZMCDCM_R_MIME_REPOSITORY
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
