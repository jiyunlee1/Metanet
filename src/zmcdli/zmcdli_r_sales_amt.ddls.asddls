@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[LI] 매출 유형 별 매출액'
define root view entity ZMCDLI_R_SALES_AMT
  as select from ZMCDLI_I_SALES_AMT
{

  key Id,

      Company,

      FiscalYear,

      PlatformType,

      @Semantics.amount.currencyCode: 'Currency'
      SalesAmount,

      Currency,

      Ratio,

      @Semantics.user.createdBy: true
      CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,

      @Semantics.user.lastChangedBy: true
      LastChangedBy,

      /* Associations */
      _PlatformType
}
