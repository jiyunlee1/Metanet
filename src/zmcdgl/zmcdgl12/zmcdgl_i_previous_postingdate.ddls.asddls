@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] Get Preivous Fiscal Year Period'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDGL_I_PREVIOUS_POSTINGDATE
  as select from I_FiscalYearPeriod
{
  @ObjectModel.text.element: [ 'fiscalyearvariant' ]
  FiscalYearVariant,
  @ObjectModel.text.element: [ 'fiscalyearperiod' ]
  FiscalYearPeriod
}
where FiscalPeriodStartDate <= dats_add_months($session.system_date, -1, 'FAIL' )
  and FiscalPeriodEndDate   >= dats_add_months($session.system_date, -1, 'FAIL' )
