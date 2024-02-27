@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[CM] MIME Repository'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDCM_I_MIME_REPOSITORY
  as select from zmcdtcm0010
{
      @EndUserText.label: 'ID'
  key id                    as ID,

      @EndUserText.label: 'Package'
      prog_package          as ProgPackage,

      @EndUserText.label: '파일 용도'
      purpose               as Purpose,

      @Semantics.largeObject:{
          mimeType: 'MimeType',
          fileName: 'FileName',
          contentDispositionPreference: #INLINE
      }
      @EndUserText.label: '첨부파일'
      attachment            as Attachment,

      @Semantics.mimeType: true
      @EndUserText.label: 'MimeType'
      mimetype              as MimeType,

      @EndUserText.label: '파일명'
      filename              as FileName,

      @EndUserText.label: '설명'
      description           as Description,

      @EndUserText.label: '생성자'
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,

      @EndUserText.label: '생성 위치'
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,

      @EndUserText.label: '최종 생성자'
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,

      @EndUserText.label: '최종 생성위치'
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      @EndUserText.label: '최종 생성 위치'
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      @EndUserText.label: '최종 생성자'
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy

}
