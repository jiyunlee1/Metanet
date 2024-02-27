@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 비용 유형 별 대량 전표 처리'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_MASS_POST
  as select from zmcdtar0050
{
  key fiscalperiod   as Fiscalperiod,
  key costtype       as Costtype,
  key profitcenter   as Profitcenter,
  key roletype       as Roletype,
  key validfrdate    as Validfrdate,
  key validtodate    as Validtodate,
      shutdowndate   as Shutdowndate,
      postingdate    as Postingdate,
      isreversed     as IsReversed,
      rate           as Rate,
      @Semantics.amount.currencyCode: 'Currency'
      salesamount    as Salesamount,
      @Semantics.amount.currencyCode: 'Currency'
      calcamount     as Calcamount,
      currency       as Currency,
      journalentrysa as Journalentrysa,
      journalentrydr as Journalentrydr
}
