CLASS zcl_mcdar_cust_doc_proc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDAR_CUST_DOC_PROC IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA(lt_filter_cond) = io_request->get_parameters( ).
    DATA(lo_paging)     = io_request->get_paging( ).
    DATA(lv_offset)     = lo_paging->get_offset( ).
    DATA(lv_page_size)  = lo_paging->get_page_size( ).
    DATA(lv_max_rows)   = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_page_size ).

    DATA(lt_sorting)        = io_request->get_sort_elements( ).
    DATA(lt_req_elements)   = io_request->get_requested_elements( ).
    DATA(lt_aggr_elements)  = io_request->get_aggregation( )->get_aggregated_elements( ).


    TRY.
        DATA(lt_filter)         = io_request->get_filter( )->get_as_ranges( ).
        DATA: lv_fiscal    TYPE zmcdde_fiscal_ym_type.
        DATA: lr_costtype     TYPE RANGE OF string,
              lr_profitcenter TYPE RANGE OF string,
              lr_state        TYPE RANGE OF string,
              lr_roletype     TYPE RANGE OF string.
        READ TABLE lt_filter_cond WITH KEY parameter_name = 'FISCALPARAM' INTO DATA(ls_fiscal).
        lv_fiscal = ls_fiscal-value.
        LOOP AT lt_filter INTO DATA(ls_filter).
          CASE ls_filter-name.
            WHEN 'COSTTYPE'.
              lr_costtype = ls_filter-range.
            WHEN 'PROFITCENTER'.
              lr_profitcenter = ls_filter-range.
              LOOP AT lr_profitcenter ASSIGNING FIELD-SYMBOL(<fs_profitcenter>).
                <fs_profitcenter>-low = |{ <fs_profitcenter>-low ALPHA = IN }|.
              ENDLOOP.
            WHEN 'STATE'.
              lr_state = ls_filter-range.
            WHEN 'ROLETYPE'.
              lr_roletype = ls_filter-range.
          ENDCASE.
        ENDLOOP.
*        READ TABLE lt_filter WITH KEY name = 'FISCALPERIOD' INTO DATA(lr_fiscal).
*        LOOP AT lr_fiscal-range INTO DATA(ls_fiscal).
*          lv_fiscal = ls_fiscal-low.
*        ENDLOOP.
        DATA: lr_base_date TYPE RANGE OF string,
              lr_bt_date   TYPE RANGE OF string,
              lr_top_one   TYPE RANGE OF string.

        DATA(ls_period) = zcl_mcdcm_calc_date=>period_of_month( iv_yyyymmm = lv_fiscal ).

        TYPES: BEGIN OF ts_ratedef,
                 costtype     TYPE zmcdar_u_mass_post-costtype,
                 profitcenter TYPE zmcdar_u_mass_post-profitcenter,
                 roletype     TYPE zmcdar_u_mass_post-roletype,
                 rate         TYPE zmcdar_u_mass_post-rate,
                 validfrdate  TYPE zmcdar_u_mass_post-validfrdate,
                 costcenter   TYPE zmcdar_i_def_rate-costcenter,
               END OF ts_ratedef.

        DATA: lt_ratedef TYPE TABLE OF ts_ratedef,
              ls_ratedef TYPE ts_ratedef.


        " Base Itab for Grouping
        TYPES: BEGIN OF ts_base,
                 costtype     TYPE zmcdar_u_mass_post-costtype,
                 profitcenter TYPE zmcdar_u_mass_post-profitcenter,
*                 roletype     TYPE zmcdar_u_mass_post-roletype,
               END OF ts_base.
        DATA lt_base TYPE TABLE OF ts_base.

        lr_base_date = VALUE #( ( sign = 'I' option = 'GT' low = ls_period-frst_date ) ).

        SELECT dr~costtype, dr~profitcenter
*        , dr~roletype
             FROM zmcdar_i_def_rate AS dr
            WHERE costtype IN @lr_costtype
              AND ( shutdowndate    IS INITIAL
               OR shutdowndate    IN @lr_base_date )
            GROUP BY dr~costtype, dr~profitcenter
*            , dr~roletype
             INTO CORRESPONDING FIELDS OF TABLE @lt_base.




        DATA: lt_glaccount TYPE TABLE OF zmcdar_i_sales_acct.
        DATA: BEGIN OF ls_processing,
                fiscalperiod TYPE zmcdar_u_mass_post-fiscalperiod,
                costtype     TYPE zmcdar_u_mass_post-costtype,
                profitcenter TYPE zmcdar_u_mass_post-profitcenter,
                roletype     TYPE zmcdar_u_mass_post-roletype,
                validfrdate  TYPE zmcdar_u_mass_post-validfrdate,
                validtodate  TYPE zmcdar_u_mass_post-validtodate,
                shutdowndate TYPE zmcdar_u_mass_post-shutdowndate,
                postingdate  TYPE zmcdar_u_mass_post-postingdate,
                rate         TYPE zmcdar_u_mass_post-rate,
                salesamount  TYPE zmcdar_u_mass_post-salesamount,
                calcamount   TYPE zmcdar_u_mass_post-calcamount,
                currency     TYPE zmcdar_u_mass_post-currency,
                state        TYPE zmcdar_u_mass_post-state,
*                glaccount    TYPE TABLE OF zmcdar_i_sales_acct,
              END OF ls_processing.


        DATA: lt_grouping   LIKE TABLE OF ls_processing,
              lt_processing LIKE TABLE OF ls_processing,
              lt_last       TYPE TABLE OF zmcdar_u_mass_post,
              lt_result     TYPE TABLE OF zmcdar_u_mass_post,
              ls_result     TYPE zmcdar_u_mass_post.


        lr_bt_date = VALUE #( ( sign = 'I' option = 'BT' low = ls_period-frst_date high = ls_period-last_date ) ).
        lr_top_one = VALUE #( ( sign = 'I' option = 'LE' low = ls_period-frst_date ) ).

        DATA: lv_validtodate TYPE zmcdar_u_mass_post-validtodate,
              lv_count       TYPE i.

        LOOP AT lt_base INTO DATA(ls_base).
          CLEAR: lt_grouping,
                 lv_validtodate,
                 lv_count.

          SELECT * FROM zmcdar_i_def_rate
          WHERE costtype     = @ls_base-costtype
            AND profitcenter = @ls_base-profitcenter
            AND validfrdate IN @lr_bt_date
            AND validfrdate <> @ls_period-frst_date
          INTO CORRESPONDING FIELDS OF TABLE @lt_grouping.

          SELECT * FROM zmcdar_i_def_rate
          WHERE validfrdate IN @lr_top_one
            AND profitcenter = @ls_base-profitcenter
            AND costtype     = @ls_base-costtype
          ORDER BY validfrdate DESCENDING
          APPENDING CORRESPONDING FIELDS OF TABLE @lt_grouping
          UP TO 1 ROWS.

          SORT lt_grouping BY validfrdate  DESCENDING.

          lv_count = lines( lt_grouping ).

          LOOP AT lt_grouping INTO DATA(ls_grouping).
            IF sy-tabix = 1.
              IF ls_grouping-shutdowndate IS NOT INITIAL AND ls_grouping-shutdowndate IN lr_bt_date.
                ls_grouping-validtodate = ls_grouping-shutdowndate.
              ELSE.
                ls_grouping-validtodate = ls_period-last_date.
              ENDIF.
            ELSE.
              ls_grouping-validtodate = lv_validtodate.
            ENDIF.

            lv_validtodate = ls_grouping-validfrdate - 1.

            IF sy-tabix = lv_count.
              ls_grouping-validfrdate = ls_period-frst_date.
            ENDIF.
            ls_grouping-fiscalperiod = lv_fiscal.
            APPEND ls_grouping TO lt_processing.
          ENDLOOP.
        ENDLOOP.


**********************************************************************
        DATA: lr_costcentertp TYPE RANGE OF string,
              lr_account      TYPE RANGE OF string.

*       GLAccount
        SELECT * FROM zmcdar_i_sales_acct
        WHERE costtype IN @lr_costtype
        ORDER BY costcentertype, account
        INTO CORRESPONDING FIELDS OF TABLE @lt_glaccount.

        LOOP AT lt_glaccount INTO DATA(ls_account).
          APPEND INITIAL LINE TO lr_costcentertp ASSIGNING FIELD-SYMBOL(<fs_costcentertp>).
          APPEND INITIAL LINE TO lr_account ASSIGNING FIELD-SYMBOL(<fs_account>).
          <fs_costcentertp>-low = ls_account-costcentertype.
          <fs_costcentertp>-option = 'EQ'.
          <fs_costcentertp>-sign = 'I'.
          <fs_account>-low = ls_account-account.
          <fs_account>-option = 'EQ'.
          <fs_account>-sign = 'I'.
        ENDLOOP.
**********************************************************************

        DATA: lr_salesamt TYPE RANGE OF dats.


        TYPES: BEGIN OF ts_journalentryitem,
                 debitcreditcode             TYPE zmcdar_i_je_item-debitcreditcode,
                 postingdate                 TYPE zmcdar_i_je_item-postingdate,
                 glaccount                   TYPE zmcdar_i_je_item-glaccount,
                 profitcenter                TYPE zmcdar_i_je_item-profitcenter,
                 amountintransactioncurrency TYPE zmcdar_i_je_item-amountintransactioncurrency,
                 costcentertype              TYPE zmcdar_i_je_item-costcentertype,
                 transactioncurrency         TYPE zmcdar_i_je_item-transactioncurrency,
               END OF ts_journalentryitem.

        DATA: lt_journalentryitem TYPE TABLE OF ts_journalentryitem,
              lr_now_month        TYPE RANGE OF dats.

        lr_now_month = VALUE #( ( sign = 'I' option = 'BT' low = ls_period-frst_date high = ls_period-last_date ) ).

        SELECT * FROM zmcdar_i_je_item
        WHERE postingdate    IN @lr_now_month
          AND glaccount      IN @lr_account
        INTO CORRESPONDING FIELDS OF TABLE @lt_journalentryitem.

        LOOP AT lt_processing ASSIGNING FIELD-SYMBOL(<fs_processing>).
          CLEAR: lr_salesamt.
          lr_salesamt = VALUE #( ( sign = 'I' option = 'BT' low = <fs_processing>-validfrdate high = <fs_processing>-validtodate ) ).

          SELECT je~amountintransactioncurrency,  gl~account, gl~costcentertype
          FROM @lt_glaccount AS gl
          INNER JOIN @lt_journalentryitem AS je
             ON gl~costcentertype = je~costcentertype
            AND gl~account        = je~glaccount
          WHERE je~postingdate      IN @lr_salesamt
            AND je~profitcenter      = @<fs_processing>-profitcenter
          INTO table @DATA(lt_add).


          loop at lt_add into data(ls_add).
            <fs_processing>-salesamount -= ls_add-amountintransactioncurrency.
          ENDLOOP.
*          SELECT je~amountintransactioncurrency,  gl~account, gl~costcentertype
*          FROM @lt_glaccount AS gl
*          INNER JOIN @lt_journalentryitem AS je
*             ON gl~costcentertype = je~costcentertype
*            AND gl~account        = je~glaccount
*          WHERE je~postingdate      IN @lr_salesamt
*            AND je~profitcenter      = @<fs_processing>-profitcenter
*          INTO @DATA(lv_add).
*            <fs_processing>-salesamount -= lv_add-amountintransactioncurrency.
*            CLEAR lv_add.
*          ENDSELECT.
*          LOOP AT <fs_processing>-glaccount INTO DATA(ls_glaccount).
*            SELECT SUM( amountintransactioncurrency )  FROM @lt_journalentryitem AS je
*                    WHERE postingdate IN @lr_salesamt
*                      AND costcentertype = @ls_glaccount-costcentertype
*                      AND glaccount      = @ls_glaccount-account
*                      AND profitcenter   = @<fs_processing>-profitcenter
*                     INTO @DATA(lv_add).
*            <fs_processing>-salesamount -= lv_add.
*          ENDLOOP.
          <fs_processing>-calcamount = <fs_processing>-salesamount * <fs_processing>-rate / 100.
          <fs_processing>-currency = 'KRW'.
          CLEAR lt_add.
        ENDLOOP.

        SELECT  proc~fiscalperiod  AS   fiscalperiod,
                proc~costtype  AS       costtype,
                proc~profitcenter  AS   profitcenter,
                proc~roletype  AS       roletype,
                proc~validfrdate  AS    validfrdate,
                proc~validtodate  AS    validtodate,
                proc~shutdowndate  AS   shutdowndate,
                proc~postingdate  AS    postingdate,
                proc~rate  AS           rate,
                proc~salesamount  AS    salesamount,
                proc~calcamount  AS     calcamount,
                proc~currency  AS       currency,
                prof~profitcenternm  AS profitcenternm,
                cost~costtypenm  AS     costtypenm
                FROM @lt_processing AS proc
                INNER JOIN zmcdar_i_cost_type AS cost
                   ON cost~costtype = proc~costtype
                INNER JOIN zmcdar_v_profit_center AS prof
                   ON prof~profitcenter = proc~profitcenter
*                LEFT OUTER JOIN zmcdtar0050 AS exst
                 INTO CORRESPONDING FIELDS OF TABLE @lt_result.

        DATA lv_reversed LIKE abap_true.

        LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<fs_result>).
          CLEAR lv_reversed.
          DATA(lv_profit) = |{ <fs_result>-profitcenter ALPHA = OUT }|.
          SELECT SINGLE * FROM zmcdar_i_mass_post
          WHERE fiscalperiod = @<fs_result>-fiscalperiod
            AND costtype    = @<fs_result>-costtype
            AND profitcenter = @lv_profit
            AND roletype    = @<fs_result>-roletype
            AND validfrdate = @<fs_result>-validfrdate
            AND validtodate = @<fs_result>-validtodate
            AND isreversed <> 'X'
          INTO @DATA(ls_dbtab).

          IF sy-subrc = 0.
            IF ls_dbtab-postingdate IS NOT INITIAL AND <fs_result>-calcamount <> ls_dbtab-calcamount.
              <fs_result>-state = 'E'.
            ELSE.
*              SELECT SINGLE @abap_true FROM zmcdar_i_je_item
*              WHERE accountingdocument = @ls_dbtab-journalentrydr
*                 OR accountingdocument = @ls_dbtab-journalentrysa
*                AND isreversed = 'X'
*               INTO @lv_reversed.
              SELECT isreversed FROM zmcdar_i_je_item
              WHERE accountingdocument = @ls_dbtab-journalentrydr
                 OR accountingdocument = @ls_dbtab-journalentrysa
               INTO @DATA(lv_reversed_check).
                IF lv_reversed_check = 'X'.
                  lv_reversed = abap_true.
                ENDIF.
              ENDSELECT.
              IF lv_reversed = abap_true.
                <fs_result>-state = 'E'.
*              ELSEIF ls_dbtab-journalentrydr IS NOT INITIAL.
*                SELECT SINGLE * FROM zmcdar_i_je_item
*                WHERE accountingdocument = @ls_dbtab-journalentrydr
*                INTO @DATA(ls_drcheck).
*
*                IF ls_drcheck IS INITIAL.
*                  <fs_result>-state = 'E'.
*                ENDIF.
*              ELSEIF ls_dbtab-journalentrysa IS NOT INITIAL.
*                SELECT SINGLE * FROM zmcdar_i_je_item
*                WHERE accountingdocument = @ls_dbtab-journalentrysa
*                INTO @DATA(ls_sacheck).
*
*                IF ls_sacheck IS INITIAL.
*                  <fs_result>-state = 'E'.
*                ENDIF.

              ELSEIF ls_dbtab-postingdate IS NOT INITIAL AND <fs_result>-calcamount = ls_dbtab-calcamount.
                <fs_result>-state = 'C'.
              ENDIF.

            ENDIF.
            <fs_result>-postingdate = ls_dbtab-postingdate.
            <fs_result>-journalentrydr = ls_dbtab-journalentrydr.
            <fs_result>-journalentrysa = ls_dbtab-journalentrysa.
          ELSEIF <fs_result>-calcamount IS INITIAL.
            <fs_result>-state = 'N'.
          ELSE.
            <fs_result>-state = 'I'.
          ENDIF.
          CLEAR: ls_dbtab.
        ENDLOOP.


        DATA: lv_orderby_string TYPE string,
              lv_elementnm      TYPE string.

        IF lt_sorting IS NOT INITIAL.
          CLEAR lv_orderby_string.
          lv_orderby_string = 'r~ProfitCenter'.
          LOOP AT lt_sorting INTO DATA(ls_sorting).
            CLEAR lv_elementnm.
            CONCATENATE 'r~' ls_sorting-element_name INTO lv_elementnm.
            IF ls_sorting-descending = abap_true.
              CONCATENATE lv_elementnm 'DESCENDING' INTO lv_elementnm SEPARATED BY space.
            ELSE.
              CONCATENATE lv_elementnm 'ASCENDING' INTO lv_elementnm SEPARATED BY space.
            ENDIF.
            IF lv_orderby_string IS INITIAL.
              lv_orderby_string = lv_elementnm.
            ELSE.
              CONCATENATE lv_orderby_string lv_elementnm INTO lv_orderby_string SEPARATED BY ', '.
            ENDIF.
          ENDLOOP.
        ELSE.
          " lv_orderby_string must not be empty.
          lv_orderby_string = 'r~ProfitCenter, r~ValidFrDate'.
        ENDIF.


        SELECT * FROM @lt_result AS r
         WHERE r~state IN @lr_state
           AND r~profitcenter IN @lr_profitcenter
           AND r~costtype     IN @lr_costtype
           AND r~roletype     IN @lr_roletype
         ORDER BY (lv_orderby_string)
          INTO TABLE @DATA(lt_filtered)
          OFFSET @lv_offset
          UP TO @lv_max_rows ROWS.
        io_response->set_data( lt_filtered ).
        io_response->set_total_number_of_records( lines( lt_filtered )  ).

      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    ENDTRY.


  ENDMETHOD.
ENDCLASS.
