@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 전표 사용 계정'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_DOC_ACCT
  as select from zmcdtar0030
  association [1..1] to I_CompanyCode            as _CompanyCode on  $projection.Company    = _CompanyCode.CompanyCode
  association [1..1] to ZMCDAR_I_COST_TYPE       as _CostType    on  $projection.CostType   = _CostType.CostType
  association [1..1] to ZMCDAR_V_ROLE_TYPE       as _RoleType    on  $projection.RoleType   = _RoleType.LowValue
                                                                 and _RoleType.Language     = $session.system_language
  association [1..1] to I_AccountingDocumentType as _DocType     on  $projection.DocType    = _DocType.AccountingDocumentType
  association [1..1] to I_PostingKey             as _PostingKey  on  $projection.PostingKey = _PostingKey.PostingKey
  association [1..1] to I_GLAccount              as _GLAccount   on  $projection.Account    = _GLAccount.GLAccount
                                                                 and $projection.Company    = _GLAccount.CompanyCode
{
      @EndUserText.label: 'ID'
  key id                    as ID,

      @EndUserText.label: '회사 코드'
      company               as Company,

      @EndUserText.label: '비용 유형'
      cost_type             as CostType,

      @EndUserText.label: 'Role 유형'
      role_type             as RoleType,

      @EndUserText.label: '문서 유형'
      doc_type              as DocType,

      @EndUserText.label: 'Account Type Code'
      posting_key           as PostingKey,

      @EndUserText.label: '계정'
      account               as Account,

      @EndUserText.label: '계정 명'
      account_name          as AccountNM,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      
      _CompanyCode,
      
      _CostType,
      
      _RoleType,
      
      _DocType,
      
      _PostingKey,
      
      _GLAccount
}
