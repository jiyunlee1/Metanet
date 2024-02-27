@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 비용 유형 별 대량 전표 처리'
define root view entity ZMCDAR_R_MASS_POST
  as select from ZMCDAR_I_MASS_POST
{
  key Fiscalperiod,
  key Costtype,
  key Profitcenter,
  key Roletype,
  key Validfrdate,
  key Validtodate,
      Shutdowndate,
      Postingdate,
      IsReversed,
      Rate,
      Salesamount,
      Calcamount,
      Currency,
      Journalentrysa,
      Journalentrydr
}
