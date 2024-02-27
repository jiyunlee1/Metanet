@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Export Smartstore PNL - Base View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_PNL_BASE
  as select from ZMCDAR_I_JE_ITEM
{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key Ledger,
      FiscalPeriod,
      StoreCode,
      ProfitCenter,
      TransactionCurrency as Currency,
      GLAccount,
      DebitCreditCode,
      @Semantics.amount.currencyCode: 'Currency'
      case DebitCreditCode
        when 'S'
        then sum(AmountInTransactionCurrency)
        when 'H'
        then
          case substring( GLAccount, 4, 1 )
            when '2'
            then sum(AmountInTransactionCurrency) * -1
            when '4'
            then sum(AmountInTransactionCurrency) * -1
            else sum(AmountInTransactionCurrency)
          end
      end                 as BaseSumAmt,
      _AccountTxt.GLAccountName,
      _SmstCode.SmartStore,
      _SmstCode.Lineuse,
      _SubSite.Subsite    as SubSite,
      cast(1 as abap.int8) as Cnt
}
where 
      CompanyCode     = '1000'
  and ChartOfAccounts = 'YCOA'
  and _SmstCode.Lineuse = 'Y'
  and _SubSite.Subsite is not null
  and _SmstCode.SmartStore is not null
  and IsReversal <> 'X'
  and IsReversed <> 'X'
group by
  CompanyCode,
  SourceLedger,
  Ledger,
  FiscalYear,
  FiscalPeriod,
  ProfitCenter,
  StoreCode,
  _SubSite.Subsite,
  _SmstCode.SmartStore,
  _SmstCode.Lineuse,
  GLAccount,
  _AccountTxt.GLAccountName,
  TransactionCurrency,
  DebitCreditCode
