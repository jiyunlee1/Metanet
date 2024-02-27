@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] Get Preivous Fiscal Year Period'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.presentationVariant: [{ sortOrder: [{ by: 'FiscalYearPeriod', direction: #DESC }] }]
define view entity ZMCDGL_I_FISCALYEARPERIOD_VH
  as select from I_FiscalYearPeriod
{
      @Consumption.valueHelpDefault.display: false
  key FiscalYearVariant,
      @Consumption.valueHelpDefault.display: false
  key FiscalYear,
      @Consumption.valueHelpDefault.display: false
  key FiscalPeriod,
      @Consumption.valueHelpDefault.display: true
      FiscalYearPeriod
}
where
      FiscalYearVariant     =       'K0'
  and FiscalPeriodStartDate between concat( substring( dats_add_months( $session.system_date, - 12, 'FAIL' ), 1, 6 ), '01' ) and concat( substring( $session.system_date, 1, 6 ), '01' )
