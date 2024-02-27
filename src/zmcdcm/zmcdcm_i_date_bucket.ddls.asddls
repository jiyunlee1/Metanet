@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[CM] Date Bucket'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDCM_I_DATE_BUCKET as select from I_CalendarDate
{
    key CalendarDate,
    CalendarYear,
    CalendarQuarter,
    CalendarMonth,
    CalendarWeek,
    CalendarDay,
    YearMonth,
    YearQuarter,
    YearWeek,
    WeekDay,
    FirstDayOfWeekDate,
    FirstDayOfMonthDate,
    dats_add_days(dats_add_months(FirstDayOfMonthDate, 1, 'UNCHANGED'), -1, 'UNCHANGED') as LastDayOfMonthDate,
    CalendarDayOfYear,
    YearDay
    /* Associations */
//    _CalendarMonth,
//    _CalendarQuarter,
//    _CalendarYear,
//    _WeekDay,
//    _YearMonth
}
where CalendarDate = $session.system_date
