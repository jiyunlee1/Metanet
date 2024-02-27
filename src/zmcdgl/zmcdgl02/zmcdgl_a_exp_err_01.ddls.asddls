@EndUserText.label: '[AR] 계산 비율 정의 - Error Return'
define abstract entity ZMCDGL_A_EXP_ERR_01
{
  key ErrKey    : abap.char(256); 
  key ErrIdx    : abap.int4;
      ErrMsg    : abap.char(256);
}
