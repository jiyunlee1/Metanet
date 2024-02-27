@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 매출액 합산 계정'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_SALES_ACCT
  as select from zmcdtar0020
  association [1..1] to I_CompanyCode            as _CompanyCode on $projection.Company        = _CompanyCode.CompanyCode
  association [1..1] to ZMCDAR_I_COST_TYPE       as _CostType    on $projection.CostType       = _CostType.CostType
  association [1..1] to ZMCDAR_V_COSTCENTER_TYPE as _Costcenter  on $projection.CostcenterType = _Costcenter.LowValue
                                                                and _Costcenter.Language       = $session.system_language
  association [1..1] to I_GLAccount              as _GLAccount   on $projection.Account        = _GLAccount.GLAccount
                                                                and $projection.Company        = _GLAccount.CompanyCode
  association[1] to ZMCDAR_V_GL_ACCOUNT          as _GLAcctNM   on $projection.AccountNM       = _GLAcctNM.GLAccountName
                                                               
                                                                                                                                      
{
      @EndUserText.label: 'ID' 
      key id                    as ID,
    
      @EndUserText.label: '회사 코드'
      company               as Company,

      @EndUserText.label: '비용 유형'
      cost_type             as CostType,

      @EndUserText.label: 'Costceter 유형'
      costcenter_type       as CostcenterType,

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

      _Costcenter,

      _GLAccount,
      
      _GLAcctNM
}
