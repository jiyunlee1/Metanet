@EndUserText.label: '[AR] 계산 비율 정의 - Error Return'
define abstract entity ZMCDAR_A_EXP_ERR_01
{
  key ErrKey    : abap.char(256);
  key LocalPath : abap.char(256); 
      ErrMsg    : abap.char(256);
}
 