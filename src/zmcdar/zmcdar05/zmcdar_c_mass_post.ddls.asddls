@EndUserText.label: '[AR] 비용 유형 별 대량 전표 처리'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZMCDAR_C_MASS_POST
  provider contract transactional_query
  as projection on ZMCDAR_R_MASS_POST
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
