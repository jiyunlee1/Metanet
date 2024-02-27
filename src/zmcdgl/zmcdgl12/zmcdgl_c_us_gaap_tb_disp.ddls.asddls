@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] US-GAAP 시산 조회'
@Metadata.allowExtensions: true
define root view entity ZMCDGL_C_US_GAAP_TB_DISP
  as select from ZMCDGL_R_US_GAAP_TB_DISP
{
      @Consumption.filter : {  selectionType: #SINGLE,
                               multipleSelections: false,
                               defaultValue: '3L',
                               mandatory: true }
      @Consumption.valueHelpDefinition: [
      {
        entity.name: 'I_Ledger',
        entity.element: 'Ledger'
      }
      ]
  key Ledger,
      @Consumption.filter : {  selectionType: #SINGLE,
                               multipleSelections: false,
                               defaultValue: '1000',
                               mandatory: true }
      @Consumption.valueHelpDefinition: [
      {
        entity.name: 'I_CompanyCode',
        entity.element: 'CompanyCode'
      }
      ]
  key CompanyCode,
      @Consumption.filter : {  selectionType: #SINGLE,
                               multipleSelections: false,
                               defaultValue: 'YGR1',
                               mandatory: true }
      @Consumption.valueHelpDefinition: [
      {
        entity.name: 'I_ChartOfAccountsStdVH',
        entity.element: 'ChartOfAccounts'
      }
      ]
  key CorporateGroupChartOfAccounts,
      @Consumption.derivation:{ lookupEntity: 'ZMCDGL_I_PREVIOUS_POSTINGDATE',
                                resultElement: 'FiscalYearPeriod',
                                binding: [{ targetElement: 'fiscalyearvariant',
                                            type: #CONSTANT,
                                            value: 'K0' }] }
      @Consumption.valueHelpDefinition: [
      {
        entity.name: 'ZMCDGL_I_FISCALYEARPERIOD_VH',
        entity.element: 'FiscalYearPeriod'
      }
      ]
  key FiscalYearPeriod,
      FiscalYear,
      Period,
      Scenario,
      TB_Submission_Entity,
      CorporateGroupAccount,
      BalanceTransactionCurrency,
      @DefaultAggregation: #SUM
      cast(Amount * 100 as abap.dec( 20, 0 )) as Amount,
      Src_Sys_Identifier
}
