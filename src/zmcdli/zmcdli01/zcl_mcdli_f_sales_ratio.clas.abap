CLASS zcl_mcdli_f_sales_ratio DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS calc_ratio FOR TABLE FUNCTION zmcdli_f_sales_ratio.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDLI_F_SALES_RATIO IMPLEMENTATION.


  METHOD calc_ratio
    BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING zmcdtli0010.

    declare lv_idx int;
    declare lv_len int;

    lt_ratio =
      select
        tab1.client,
        tab1.id,
        tab1.company,
        tab1.fiscal_year,
        tab1.platform_type,
        tab1.sales_amount,
        cast( round( tab1.sales_amount / tab2.total_amount * 100, 2 ) as dec(10, 2) ) as ratio,
        ROW_NUMBER( ) over ( partition by tab1.fiscal_year order by tab1.sales_amount desc ) as rank,
        tab2.total_amount
        from zmcdtli0010 as tab1
       inner join ( select fiscal_year, company, sum( sales_amount ) as total_amount from zmcdtli0010 where client = :client group by fiscal_year, company ) as tab2
          on tab1.fiscal_year = tab2.fiscal_year and tab1.company = tab2.company
        where tab1.client = :client;

    RETURN
      select
        client,
        id,
        case
          WHEN tab2.total_ratio <> 100 then
            case
              when tab1.rank = 1
               then tab1.ratio + 100 - tab2.total_ratio
               else tab1.ratio
            end
          else tab1.ratio
        end as ratio
        from :lt_ratio as tab1
       inner join ( select fiscal_year, company, sum( ratio  ) as total_ratio from :lt_ratio group by fiscal_year, company ) tab2
          on tab1.fiscal_year = tab2.fiscal_year and tab1.company = tab2.company;

  endmethod.
ENDCLASS.
