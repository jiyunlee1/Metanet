@EndUserText.label: '[AR] 비용 유형 별 대량 전표 처리 - Mass Post'
//@VDM.usage.type: [#ACTION_PARAMETER_STRUCTURE] 
define abstract entity ZMCDAR_A_DOC_DATA
{
  key DummyKey       : abap.char(1);
  
      FiscalPeriod   : zmcdde_fiscal_ym_type;

      CostType       : zmcdde_cost_type;

      ProfitCenter   : prctr;

      RoleType       : zmcdde_role_type;

      ValidFrDate    : abap.dats(8);

      ValidToDate    : abap.dats(8);

      ProfitCenterNM : abap.char(40);

      CostTypeNM     : abap.char(20);

      ShutDownDate   : abap.dats(8);

      PostingDate    : abap.dats(8);

      Rate           : abap.dec(6,2);

      @Semantics.amount.currencyCode: 'Currency'
      SalesAmount    : abap.curr( 23, 4 );

      @Semantics.amount.currencyCode: 'Currency'
      CalcAmount     : abap.curr(23, 2);

      Currency       : abap.cuky;

      State          : zmcdde_doc_state_type;

      JournalEntrySA : abap.char(10);

      JournalEntryDR : abap.char(10); 
      
      _DummyAssociation : association to parent ZMCDAR_A_MASS_POST on $projection.DummyKey = _DummyAssociation.DummyKey;
}
