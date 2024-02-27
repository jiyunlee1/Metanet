@EndUserText.label: 'Table Function for Ratio'
define table function ZMCDLI_F_SALES_RATIO
  with parameters
    @Environment.systemField : #CLIENT
    client : abap.clnt
returns
{
  key client : abap.clnt;
      id     : sysuuid_x16;
      ratio  : abap.dec(10,2);
}
implemented by method
  zcl_mcdli_f_sales_ratio=>CALC_RATIO;