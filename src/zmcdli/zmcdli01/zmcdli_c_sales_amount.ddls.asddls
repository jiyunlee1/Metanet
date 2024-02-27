@EndUserText.label: '[LI] 매출 유형 별 매출액'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZMCDLI_C_SALES_AMOUNT
  provider contract transactional_query
  as projection on ZMCDLI_R_SALES_AMOUNT
{

  key Id,


      Company,


      @Semantics.calendar : {
          yearMonth: true
      }
      @Consumption.filter.selectionType: #INTERVAL
      FiscalYear,

      @Consumption.valueHelpDefinition: [
        {
          entity.name: 'ZMCDLI_V_PLATFORM_TYPE',
          entity.element: 'LowValue'
        }
      ]
      PlatformType,

      SalesAmount,

      Currency,

      CreatedBy,

      CreatedAt,

      LocalLastChangedBy,

      LocalLastChangedAt,

      LastChangedAt,

      LastChangedBy,

      /* Associations */

      _PlatformType

}
