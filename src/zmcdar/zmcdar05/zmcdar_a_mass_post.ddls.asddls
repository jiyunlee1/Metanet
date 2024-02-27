@EndUserText.label: '[AR] 비용 유형 별 대량 전표 처리 - Mass Post Param'
//@VDM.usage.type: [#ACTION_PARAMETER_STRUCTURE] 
define root abstract entity ZMCDAR_A_MASS_POST
{
  key DummyKey : abap.char(1); 
    _DocData : composition [0..*] of ZMCDAR_A_DOC_DATA; 
} 
