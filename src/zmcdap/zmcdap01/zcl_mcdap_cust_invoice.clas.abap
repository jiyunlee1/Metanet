CLASS zcl_mcdap_cust_invoice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDAP_CUST_INVOICE IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Input Context
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    IF io_request->is_data_requested( ).

      TRY.


          DATA(lv_search) = io_request->get_search_expression( ).
          REPLACE ALL OCCURRENCES OF REGEX '[^[:alnum:]]' IN lv_search WITH ''.
          DATA(lt_params) = io_request->get_parameters( ).
          DATA(lt_ranges) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_root INTO DATA(lcx_exception).
*          DATA(lo_exception)          = cl_message_helper=>get_latest_t100_exception( lcx_exception ).
*          DATA(lo_exception_t100_key) = cl_message_helper=>get_latest_t100_exception( lcx_exception )->t100key.
*
*          RAISE EXCEPTION TYPE zfi_cl_exception01
*            EXPORTING
*              textid = VALUE scx_t100key(
*               msgid = lo_exception_t100_key-msgid
*               msgno = lo_exception_t100_key-msgno
*               attr1 = lo_exception_t100_key-attr1
*               attr2 = lo_exception_t100_key-attr2
*               attr3 = lo_exception_t100_key-attr3
*               attr4 = lo_exception_t100_key-attr4 ).
      ENDTRY.

      DATA(lv_top)    = io_request->get_paging( )->get_page_size( ).

      IF lv_top < 0.
        lv_top = 1.
      ENDIF.
      DATA(lv_skip)   = io_request->get_paging( )->get_offset( ).
      DATA(lt_fields) = io_request->get_requested_elements( ).
      DATA(lt_sort)   = io_request->get_sort_elements( ).

      DATA(lt_req_elements) = io_request->get_requested_elements( ).
      DATA(lt_aggr_elements) = io_request->get_aggregation( )->get_aggregated_elements( ).
      IF lt_aggr_elements IS NOT INITIAL.
        LOOP AT lt_aggr_elements ASSIGNING FIELD-SYMBOL(<fs_aggregation>).
          DELETE lt_req_elements WHERE table_line = <fs_aggregation>-result_element.
          DATA(lv_aggregation) = |{ <fs_aggregation>-aggregation_method }( { <fs_aggregation>-input_element } ) as { <fs_aggregation>-result_element }|.
          APPEND lv_aggregation TO lt_req_elements.
        ENDLOOP.
      ENDIF.

      DATA(lt_grouped_element) = io_request->get_aggregation( )->get_grouped_elements( ).
      DATA(lv_grouping) = concat_lines_of( table = lt_grouped_element sep = `, ` ).



      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " NTS Date Mode Check
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      READ TABLE lt_ranges WITH KEY name = 'DATEMODE' INTO DATA(ls_mode).
      IF ls_mode IS NOT INITIAL.
        DATA(lv_mode) = ls_mode-range[ 1 ]-low.
      ENDIF.
      DATA lv_req_elements TYPE string.

      LOOP AT lt_req_elements INTO DATA(lv_element).
        IF lv_element EQ 'NTSDT'.
          lv_element = |{ lv_mode } AS NTSDT|.
        ENDIF.
        IF lv_req_elements IS INITIAL.
          lv_req_elements = lv_element.
        ELSE.
          lv_req_elements = |{ lv_req_elements }, { lv_element }|.
        ENDIF.
      ENDLOOP.

      TYPES: BEGIN OF ts_range_set,
               id          TYPE RANGE OF string,
               bizplace    TYPE RANGE OF string,
               issueno     TYPE RANGE OF string,
               makedt      TYPE RANGE OF string,
               issuedt     TYPE RANGE OF string,
               senddt      TYPE RANGE OF string,
               byrbizno    TYPE RANGE OF string,
               clientkey   TYPE RANGE OF string,
               entkey      TYPE RANGE OF string,
               billtype    TYPE RANGE OF string,
               supbizno    TYPE RANGE OF string,
               supbizsubno TYPE RANGE OF string,
               supcorpnm   TYPE RANGE OF string,
               suprepnm    TYPE RANGE OF string,
               supaddress  TYPE RANGE OF string,
               byrbizsubno TYPE RANGE OF string,
               byrcorpnm   TYPE RANGE OF string,
               byrrepnm    TYPE RANGE OF string,
               byraddress  TYPE RANGE OF string,
               totamt      TYPE RANGE OF string,
               supamt      TYPE RANGE OF string,
               taxamt      TYPE RANGE OF string,
               taxclsf     TYPE RANGE OF string,
               taxknd      TYPE RANGE OF string,
               isntype     TYPE RANGE OF string,
               bigo        TYPE RANGE OF string,
               demandgb    TYPE RANGE OF string,
               supemail    TYPE RANGE OF string,
               byremail1   TYPE RANGE OF string,
               byremail2   TYPE RANGE OF string,
               itemdt      TYPE RANGE OF string,
               itemnm      TYPE RANGE OF string,
               itemstd     TYPE RANGE OF string,
               itemqty     TYPE RANGE OF string,
               itemunt     TYPE RANGE OF string,
               itemsupamt  TYPE RANGE OF string,
               itemtaxamt  TYPE RANGE OF string,
               itembigo    TYPE RANGE OF string,
               currency    TYPE RANGE OF string,
             END OF ts_range_set.

      DATA: ls_range_set TYPE ts_range_set.

      LOOP AT lt_ranges ASSIGNING FIELD-SYMBOL(<fs_ranges>).
        CHECK <fs_ranges>-range IS NOT INITIAL.
        IF <fs_ranges>-name = 'DATEMODE'.
          CONTINUE.
        ENDIF.

        IF <fs_ranges>-name = 'BYREMAIL1' AND <fs_ranges>-range IS NOT INITIAL.
          ASSIGN COMPONENT 'BYREMAIL1' OF STRUCTURE ls_range_set TO FIELD-SYMBOL(<fs_byremail>).
          <fs_byremail> = <fs_ranges>-range.
          UNASSIGN <fs_byremail>.
          ASSIGN COMPONENT 'BYREMAIL2' OF STRUCTURE ls_range_set TO <fs_byremail>.
          <fs_byremail> = <fs_ranges>-range.
          UNASSIGN <fs_byremail>.
          CONTINUE.
        ENDIF.

        IF <fs_ranges>-name = 'NTSDT'.
          <fs_ranges>-name = lv_mode.
        ELSEIF <fs_ranges>-name = lv_mode.
          CONTINUE.
        ENDIF.


        ASSIGN COMPONENT <fs_ranges>-name OF STRUCTURE ls_range_set TO FIELD-SYMBOL(<fs_data>).
        IF <fs_ranges>-range IS NOT INITIAL.
          <fs_data> = <fs_ranges>-range.
        ENDIF.

        UNASSIGN: <fs_data>.
      ENDLOOP.

*element_name  type string
* descending  type abap_bool
      DATA: lv_sort TYPE string,
            lv_desc TYPE string.

      LOOP AT lt_sort INTO DATA(ls_sort).
        CASE ls_sort-descending.
          WHEN 'X'.
            lv_desc = 'DESCENDING'.
          WHEN OTHERS.
            lv_desc = ''.
        ENDCASE.
        IF ls_sort-element_name EQ 'NTSDT'.
          ls_sort-element_name = lv_mode.
        ENDIF.

        IF lv_sort IS INITIAL.
          lv_sort = |{ ls_sort-element_name } { lv_desc }|.
*          CONCATENATE ls_sort-element_name lv_desc INTO lv_sort.
        ELSE.
          lv_sort = |{ lv_sort }, { ls_sort-element_name } { lv_desc }|.
*          CONCATENATE lv_sort ', ' ls_sort-element_name lv_desc INTO lv_sort.
        ENDIF.
      ENDLOOP.
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " MAKE RESULT
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      DATA : lt_result TYPE STANDARD TABLE OF zmcdap_u_invoice,
             ls_result TYPE zmcdap_u_invoice.

      CLEAR : lt_result[].

      IF lv_skip IS INITIAL.
        SELECT *
        FROM zmcdap_i_invoice
        WHERE id IN @ls_range_set-id
          AND bizplace    IN @ls_range_set-bizplace
          AND issueno     IN @ls_range_set-issueno
          AND makedt      IN @ls_range_set-makedt
          AND issuedt     IN @ls_range_set-issuedt
          AND senddt      IN @ls_range_set-senddt
          AND byrbizno    IN @ls_range_set-byrbizno
          AND clientkey   IN @ls_range_set-clientkey
          AND entkey      IN @ls_range_set-entkey
          AND billtype    IN @ls_range_set-billtype
          AND supbizno    IN @ls_range_set-supbizno
          AND supbizsubno IN @ls_range_set-supbizsubno
          AND supcorpnm   IN @ls_range_set-supcorpnm
          AND suprepnm    IN @ls_range_set-suprepnm
          AND supaddress  IN @ls_range_set-supaddress
          AND byrbizsubno IN @ls_range_set-byrbizsubno
          AND byrcorpnm   IN @ls_range_set-byrcorpnm
          AND byrrepnm    IN @ls_range_set-byrrepnm
          AND byraddress  IN @ls_range_set-byraddress
          AND totamt      IN @ls_range_set-totamt
          AND supamt      IN @ls_range_set-supamt
          AND taxamt      IN @ls_range_set-taxamt
          AND taxclsf     IN @ls_range_set-taxclsf
          AND taxknd      IN @ls_range_set-taxknd
          AND isntype     IN @ls_range_set-isntype
          AND demandgb    IN @ls_range_set-demandgb
          AND supemail    IN @ls_range_set-supemail
          AND ( byremail1   IN @ls_range_set-byremail1
          OR byremail2   IN @ls_range_set-byremail2 )
          AND itemdt      IN @ls_range_set-itemdt
          AND itemnm      IN @ls_range_set-itemnm
          AND itemstd     IN @ls_range_set-itemstd
          AND itemqty     IN @ls_range_set-itemqty
          AND itemunt     IN @ls_range_set-itemunt
          AND itemsupamt  IN @ls_range_set-itemsupamt
          AND itemtaxamt  IN @ls_range_set-itemtaxamt
          AND itembigo    IN @ls_range_set-itembigo
          AND currency    IN @ls_range_set-currency
*      GROUP BY (lv_grouping)
        ORDER BY (lv_sort)
        INTO CORRESPONDING FIELDS OF TABLE @lt_result.
*        UP TO @lv_top ROWS.
*      OFFSET @lv_skip

      ELSE.
        SELECT *
        FROM zmcdap_i_invoice
        WHERE id IN @ls_range_set-id
          AND bizplace    IN @ls_range_set-bizplace
          AND issueno     IN @ls_range_set-issueno
          AND makedt      IN @ls_range_set-makedt
          AND issuedt     IN @ls_range_set-issuedt
          AND senddt      IN @ls_range_set-senddt
          AND byrbizno    IN @ls_range_set-byrbizno
          AND clientkey   IN @ls_range_set-clientkey
          AND entkey      IN @ls_range_set-entkey
          AND billtype    IN @ls_range_set-billtype
          AND supbizno    IN @ls_range_set-supbizno
          AND supbizsubno IN @ls_range_set-supbizsubno
          AND supcorpnm   IN @ls_range_set-supcorpnm
          AND suprepnm    IN @ls_range_set-suprepnm
          AND supaddress  IN @ls_range_set-supaddress
          AND byrbizsubno IN @ls_range_set-byrbizsubno
          AND byrcorpnm   IN @ls_range_set-byrcorpnm
          AND byrrepnm    IN @ls_range_set-byrrepnm
          AND byraddress  IN @ls_range_set-byraddress
          AND totamt      IN @ls_range_set-totamt
          AND supamt      IN @ls_range_set-supamt
          AND taxamt      IN @ls_range_set-taxamt
          AND taxclsf     IN @ls_range_set-taxclsf
          AND taxknd      IN @ls_range_set-taxknd
          AND isntype     IN @ls_range_set-isntype
          AND demandgb    IN @ls_range_set-demandgb
          AND supemail    IN @ls_range_set-supemail
          AND byremail1   IN @ls_range_set-byremail1
          AND byremail2   IN @ls_range_set-byremail2
          AND itemdt      IN @ls_range_set-itemdt
          AND itemnm      IN @ls_range_set-itemnm
          AND itemstd     IN @ls_range_set-itemstd
          AND itemqty     IN @ls_range_set-itemqty
          AND itemunt     IN @ls_range_set-itemunt
          AND itemsupamt  IN @ls_range_set-itemsupamt
          AND itemtaxamt  IN @ls_range_set-itemtaxamt
          AND itembigo    IN @ls_range_set-itembigo
          AND currency    IN @ls_range_set-currency
*      GROUP BY (lv_grouping)
        ORDER BY (lv_sort)
        INTO CORRESPONDING FIELDS OF TABLE @lt_result
        OFFSET @lv_skip.
*        UP TO @lv_top ROWS.
      ENDIF.

      LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<fs_result>).
        IF lv_mode IS NOT INITIAL.
          ASSIGN COMPONENT lv_mode OF STRUCTURE <fs_result> TO FIELD-SYMBOL(<fv_ntsdt>).
          <fs_result>-ntsdt = <fv_ntsdt>.
          UNASSIGN <fv_ntsdt>.
        ENDIF.
      ENDLOOP.

*      DATA lr_dft_search TYPE RANGE OF string.
*      lr_dft_search = VALUE #( ( sign = 'I' option = 'CS' low = lv_search ) ).
      DATA(lv_dft_search) = |%{ lv_search }%|.
      SELECT * FROM @lt_result AS rslt
      WHERE rslt~businessplacename LIKE @lv_dft_search
         OR rslt~bizplace          LIKE @lv_dft_search
         OR rslt~issueno           LIKE @lv_dft_search
         OR rslt~byrbizno          LIKE @lv_dft_search
         OR rslt~supbizno          LIKE @lv_dft_search
         OR rslt~supcorpnm         LIKE @lv_dft_search
         OR rslt~suprepnm          LIKE @lv_dft_search
         OR rslt~supaddress        LIKE @lv_dft_search
         OR rslt~byrcorpnm         LIKE @lv_dft_search
         OR rslt~byrrepnm          LIKE @lv_dft_search
         OR rslt~byraddress        LIKE @lv_dft_search
         OR rslt~taxclsf           LIKE @lv_dft_search
         OR rslt~taxknd            LIKE @lv_dft_search
         OR rslt~isntype           LIKE @lv_dft_search
         OR rslt~bigo              LIKE @lv_dft_search
         OR rslt~demandgb          LIKE @lv_dft_search
         OR rslt~supemail          LIKE @lv_dft_search
         OR rslt~byremail1         LIKE @lv_dft_search
         OR rslt~byremail2         LIKE @lv_dft_search
         OR rslt~itemnm            LIKE @lv_dft_search
         OR rslt~itembigo          LIKE @lv_dft_search
         OR rslt~businessplacename LIKE @lv_dft_search
         OR rslt~billtypetext      LIKE @lv_dft_search
      INTO TABLE @lt_result.


      IF lv_top > 0.
        IF lv_skip IS NOT INITIAL.
          SELECT * FROM @lt_result AS rslt
          ORDER BY (lv_sort)
          INTO TABLE @lt_result
          OFFSET @lv_skip
          UP TO @lv_top ROWS.
        ELSE.
          SELECT * FROM @lt_result AS rslt
          ORDER BY (lv_sort)
          INTO TABLE @lt_result
          UP TO @lv_top ROWS.
        ENDIF.
      ELSE.
        SELECT * FROM @lt_result AS rslt
        ORDER BY (lv_sort)
        INTO TABLE @lt_result.
      ENDIF.

      io_response->set_total_number_of_records( lines( lt_result ) ).
      io_response->set_data( lt_result ).

    ENDIF.
  ENDMETHOD.
ENDCLASS.
