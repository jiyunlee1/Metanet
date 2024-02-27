@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] Export Smartstore PL - Act Dtl Acct'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_I_DTL_ACCT
  as select from ZMCDAR_I_JE_ITEM
{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key LedgerGLLineItem,
  key Ledger,
      FiscalPeriod,
      CostCenterType,
      GLAccount,
      CostCenter,
      ProfitCenter,
      TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case DebitCreditCode
        when 'S'
        then AmountInTransactionCurrency 
        when 'H'
        then cast('0.00' as abap.curr( 23, 2 ))
      end                  as DebitAmt,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case DebitCreditCode
        when 'S'
        then cast('0.00' as abap.curr( 23, 2 ))
        when 'H'
        then
          case substring( GLAccount, 4, 1 )
            when '2'
            then AmountInTransactionCurrency * -1
            when '4'
            then AmountInTransactionCurrency * -1
            else AmountInTransactionCurrency
          end
      end                  as CreditAmt,
      DebitCreditCode,
      PostingDate,
      DocumentDate,
      GLAccountName,
      AccountingDocumentType,
      AccountingDocumentItem,
      PostingKey,
      TaxCode,
      TaxCountry,  
      DocumentItemText     as Description,
      cast(_SmstCode.SmartStore as abap.numc(3)) as SmartStore,
      _SubSite.Subsite     as SubSite,
      StoreCode,
      /* Associations */
      _AccountTxt,
      _CostCetnerType,
      _SmstCode,
      _SubSite
}
where Lineuse = 'Y'
  and IsReversal <> 'X'
  and IsReversed <> 'X'
  and _SubSite.Subsite is not null
  and _SmstCode.SmartStore is not null
