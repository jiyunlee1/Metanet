@EndUserText.label: '[AR] 비용 유형 별 대량 전표 처리'
define root custom entity ZMCDAR_U_MASS_POST
{
      @UI.lineItem   : [{ position: 30 }]
  key FiscalPeriod   : zmcdde_fiscal_ym_type;

  key CostType       : zmcdde_cost_type;

  key ProfitCenter   : prctr;

      @UI.lineItem   : [{ position: 90 }]
  key RoleType       : zmcdde_role_type;

  key ValidFrDate    : abap.dats(8);

  key ValidToDate    : abap.dats(8);

      @UI.lineItem   : [{ position: 70 }]
      ProfitCenterNM : abap.char(40);

      @UI.lineItem   : [{ position: 50 }]
      CostTypeNM     : abap.char(20);

      ShutDownDate   : abap.dats(8);

      PostingDate    : abap.dats(8);

      @UI.lineItem   : [{ position: 110 }]
      Rate           : abap.dec(6,4);

      @UI.lineItem   : [{ position: 150 }]
      @Semantics.amount.currencyCode: 'Currency'
      SalesAmount    : abap.curr( 23, 2 );

      @UI.lineItem   : [{ position: 190 }]
      @Semantics.amount.currencyCode: 'Currency'
      CalcAmount     : abap.curr(23, 2);

      @UI.hidden     : true
      Currency       : abap.cuky;

      @UI.lineItem   : [{ position: 170 }]
      State          : zmcdde_doc_state_type;
      
      JournalEntrySA : abap.char(10);
      
      JournalEntryDR : abap.char(10);

}
