@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] US-GAAP 시산 조회'
@Metadata.allowExtensions: true
define root view entity ZMCDGL_R_US_GAAP_TB_DISP
  as select from ZMCDGL_I_GLACCOUNTBALANCE
{
  key Ledger,
  key CompanyCode,
  key _GLAccountInChartOfAccounts.CorporateGroupChartOfAccounts             as CorporateGroupChartOfAccounts,
  key FiscalYearPeriod,
      FiscalYear,
      case when FiscalPeriod = '000' then '####'
           when FiscalPeriod = '001' then 'Jan'
           when FiscalPeriod = '002' then 'Feb'
           when FiscalPeriod = '003' then 'Mar'
           when FiscalPeriod = '004' then 'Apr'
           when FiscalPeriod = '005' then 'May'
           when FiscalPeriod = '006' then 'Jun'
           when FiscalPeriod = '007' then 'Jul'
           when FiscalPeriod = '008' then 'Aug'
           when FiscalPeriod = '009' then 'Sep'
           when FiscalPeriod = '010' then 'Oct'
           when FiscalPeriod = '011' then 'Nov'
           when FiscalPeriod = '012' then 'Dec' else '#### 'end             as Period,
      'Actuals'                                                             as Scenario,
      'KRC'                                                                 as TB_Submission_Entity,
      _GLAccountInChartOfAccounts.CorporateGroupAccount                     as CorporateGroupAccount,
      BalanceTransactionCurrency,
      @Semantics.amount.currencyCode: 'BalanceTransactionCurrency'
      sum( DebitAmountInBalanceTransCrcy + CreditAmountInBalanceTransCrcy ) as Amount,
      'TB Extract'                                                          as Src_Sys_Identifier
}
where
      Ledger                                                    =  '3L'
  and CompanyCode                                               =  '1000'
  and _GLAccountInChartOfAccounts.CorporateGroupChartOfAccounts =  'YGR1'
  and _GLAccountInChartOfAccounts.CorporateGroupAccount         <> 'A99999999'
group by
  Ledger,
  CompanyCode,
  _GLAccountInChartOfAccounts.CorporateGroupChartOfAccounts,
  FiscalYearPeriod,
  FiscalYear,
  FiscalPeriod,
  _GLAccountInChartOfAccounts.CorporateGroupAccount,
  BalanceTransactionCurrency
having
  sum( DebitAmountInBalanceTransCrcy + CreditAmountInBalanceTransCrcy ) <> 0
