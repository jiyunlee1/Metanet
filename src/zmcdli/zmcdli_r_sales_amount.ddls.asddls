@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[LI] 매출 유형 별 매출액'
define root view entity ZMCDLI_R_SALES_AMOUNT
  as select from ZMCDLI_I_SALES_AMOUNT
{
  
  key Id,

      Company,

      FiscalYear,

      PlatformType,

      @Semantics.amount.currencyCode: 'Currency'
      SalesAmount,

      Currency,

      CreatedBy,

      CreatedAt,

      LocalLastChangedBy,

      LocalLastChangedAt,

      LastChangedAt,

      LastChangedBy,

      _PlatformType

}
