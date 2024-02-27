CLASS zcl_mcdap_cust_comp_invoice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDAP_CUST_COMP_INVOICE IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Input Context
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    IF io_request->is_data_requested( ).

      TRY.


*          DATA(lv_search) = io_request->get_search_expression( ).
*          REPLACE ALL OCCURRENCES OF REGEX '[^[:alnum:]]' IN lv_search WITH ''.
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

      data(lv_name) = lt_ranges[ 1 ]-name.
      data(lv_low) = lt_ranges[ 1 ]-range[ 1 ]-low.
      data(lv_sign) = lt_ranges[ 1 ]-range[ 1 ]-option.

      IF lv_name EQ 'ACCOUNTINGDOCUMENT' AND lv_low IS INITIAL AND lv_sign = 'EQ'.
        DATA(lv_check) = abap_true.
      ENDIF.

      DATA(lv_top)    = io_request->get_paging( )->get_page_size( ).

*      IF lv_top < 0.
*        lv_top = 1.
*      ENDIF.
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

*      DATA(lt_grouped_element) = io_request->get_aggregation( )->get_grouped_elements( ).
*      DATA(lv_grouping) = concat_lines_of( table = lt_grouped_element sep = `, ` ).

      TYPES: BEGIN OF ts_range_set,
               accountingdocument         TYPE RANGE OF string,
               issueno                    TYPE RANGE OF string,
               bizplace                   TYPE RANGE OF string,
               jesupcorpnm                TYPE RANGE OF string,
               ntssupcorpnm               TYPE RANGE OF string,
               supcorpnm                  TYPE RANGE OF string,
               jesupbizno                 TYPE RANGE OF string,
               ntssupbizno                TYPE RANGE OF string,
               supbizno                   TYPE RANGE OF string,
               mainissueno                TYPE RANGE OF string,
               profitcenter               TYPE RANGE OF string,
               documentdate               TYPE RANGE OF string,
               companycodecurrency        TYPE RANGE OF string,
               jesupamt                   TYPE RANGE OF string,
               transactioncurrency        TYPE RANGE OF string,
               jetaxamt                   TYPE RANGE OF string,
               jetotamt                   TYPE RANGE OF string,
               makedt                     TYPE RANGE OF string,
               currency                   TYPE RANGE OF string,
               supamt                     TYPE RANGE OF string,
               taxamt                     TYPE RANGE OF string,
               totamt                     TYPE RANGE OF string,
               isdifdate                  TYPE RANGE OF string,
               isdifdatecol               TYPE RANGE OF string,
               difsupamt                  TYPE RANGE OF string,
               diftaxamt                  TYPE RANGE OF string,
               diftotamt                  TYPE RANGE OF string,
               defcurrency                TYPE RANGE OF string,
               isdiff                     TYPE RANGE OF string,
               isdifftext                 TYPE RANGE OF string,
               exptstat                   TYPE RANGE OF string,
               isexceptedtext             TYPE RANGE OF string,
               isreversed                 TYPE RANGE OF string,
               isreversal                 TYPE RANGE OF string,
               reversalreferencedocument  TYPE RANGE OF string,
               ismain                     TYPE RANGE OF string,
               sourceledger               TYPE RANGE OF string,
               companycode                TYPE RANGE OF string,
               fiscalyear                 TYPE RANGE OF string,
               ledgergllineitem           TYPE RANGE OF string,
               ledger                     TYPE RANGE OF string,
               ledgergroup                TYPE RANGE OF string,
               postingdate                TYPE RANGE OF string,
               accountingdoccreatedbyuser TYPE RANGE OF string,
               accountingdocumenttype     TYPE RANGE OF string,
               businessplacename          TYPE RANGE OF string,
               supbizsubno                TYPE RANGE OF string,
               byrbizno                   TYPE RANGE OF string,
               billtype                   TYPE RANGE OF string,
               issuedt                    TYPE RANGE OF string,
               senddt                     TYPE RANGE OF string,
               suprepnm                   TYPE RANGE OF string,
               supaddress                 TYPE RANGE OF string,
               byrbizsubno                TYPE RANGE OF string,
               byrcorpnm                  TYPE RANGE OF string,
               byrrepnm                   TYPE RANGE OF string,
               byraddress                 TYPE RANGE OF string,
               taxclsf                    TYPE RANGE OF string,
               taxknd                     TYPE RANGE OF string,
               isntype                    TYPE RANGE OF string,
               bigo                       TYPE RANGE OF string,
               demandgb                   TYPE RANGE OF string,
               supemail                   TYPE RANGE OF string,
               byremail1                  TYPE RANGE OF string,
               byremail2                  TYPE RANGE OF string,
               itemdt                     TYPE RANGE OF string,
               itemnm                     TYPE RANGE OF string,
               itemstd                    TYPE RANGE OF string,
               itemqty                    TYPE RANGE OF string,
               itemunt                    TYPE RANGE OF string,
               itemsupamt                 TYPE RANGE OF string,
               itemtaxamt                 TYPE RANGE OF string,
               itembigo                   TYPE RANGE OF string,
               itemstate                  TYPE RANGE OF string,
               billtypetext               TYPE RANGE OF string,
               itemstatetext              TYPE RANGE OF string,
               profitcenternm             TYPE RANGE OF string,
               excludingstat              TYPE RANGE OF string,
               cstnbizno                  TYPE RANGE OF string,
               cstncorpnm                 TYPE RANGE OF string,
               createdat                  TYPE RANGE OF string,
               createdby                  TYPE RANGE OF string,
               lastchangedat              TYPE RANGE OF string,
               lastchangedby              TYPE RANGE OF string,
               locallastchangedat         TYPE RANGE OF string,
               locallastchangedby         TYPE RANGE OF string,
             END OF ts_range_set.


      DATA: ls_range_set TYPE ts_range_set.

      LOOP AT lt_ranges ASSIGNING FIELD-SYMBOL(<fs_ranges>).
*        if <fs_ranges>-name = 'ACCOUNTINGDOCUMENT'.
*          LOOP AT <fs_ranges>-range ASSIGNING FIELD-SYMBOL(<FS_RANGE>).
*            IF <FS_RANGE>-low IS INITIAL.
*
*            ENDIF.
*          ENDLOOP.
*        ENDIF.
        ASSIGN COMPONENT <fs_ranges>-name OF STRUCTURE ls_range_set TO FIELD-SYMBOL(<fs_data>).
        IF <fs_ranges>-range IS NOT INITIAL.
          <fs_data> = <fs_ranges>-range.
        ENDIF.

        UNASSIGN: <fs_data>.
      ENDLOOP.


      DATA: lv_sort TYPE string,
            lv_desc TYPE string.

      LOOP AT lt_sort INTO DATA(ls_sort).
        CASE ls_sort-descending.
          WHEN 'X'.
            lv_desc = 'DESCENDING'.
          WHEN OTHERS.
            lv_desc = ''.
        ENDCASE.

        IF lv_sort IS INITIAL.
          lv_sort = |{ ls_sort-element_name } { lv_desc }|.
        ELSE.
          lv_sort = |{ lv_sort }, { ls_sort-element_name } { lv_desc }|.
        ENDIF.
      ENDLOOP.


      SELECT * FROM zmcdap_i_comp_invoice
      WHERE
        ( ( documentdate IN @ls_range_set-documentdate
            AND makedt   IN @ls_range_set-makedt ) OR
          ( documentdate IN @ls_range_set-documentdate
            AND ( makedt IS NULL OR makedt IS INITIAL ) ) OR
          ( makedt   IN @ls_range_set-makedt
            AND ( documentdate IS NULL OR documentdate IS INITIAL ) ) )

        AND accountingdocument         IN @ls_range_set-accountingdocument
        AND issueno                    IN @ls_range_set-issueno
        AND bizplace                   IN @ls_range_set-bizplace
        AND jesupcorpnm                IN @ls_range_set-jesupcorpnm
        AND ntssupcorpnm               IN @ls_range_set-ntssupcorpnm
        AND supcorpnm                  IN @ls_range_set-supcorpnm
        AND jesupbizno                 IN @ls_range_set-jesupbizno
        AND ntssupbizno                IN @ls_range_set-ntssupbizno
        AND supbizno                   IN @ls_range_set-supbizno
        AND mainissueno                IN @ls_range_set-mainissueno
        AND profitcenter               IN @ls_range_set-profitcenter
        AND companycodecurrency        IN @ls_range_set-companycodecurrency
        AND jesupamt                   IN @ls_range_set-jesupamt
        AND transactioncurrency        IN @ls_range_set-transactioncurrency
        AND jetaxamt                   IN @ls_range_set-jetaxamt
        AND jetotamt                   IN @ls_range_set-jetotamt
        AND currency                   IN @ls_range_set-currency
        AND supamt                     IN @ls_range_set-supamt
        AND taxamt                     IN @ls_range_set-taxamt
        AND totamt                     IN @ls_range_set-totamt
        AND isdifdate                  IN @ls_range_set-isdifdate
        AND isdifdatecol               IN @ls_range_set-isdifdatecol
        AND difsupamt                  IN @ls_range_set-difsupamt
        AND diftaxamt                  IN @ls_range_set-diftaxamt
        AND diftotamt                  IN @ls_range_set-diftotamt
        AND defcurrency                IN @ls_range_set-defcurrency
        AND isdiff                     IN @ls_range_set-isdiff
        AND isdifftext                 IN @ls_range_set-isdifftext
        AND exptstat                   IN @ls_range_set-exptstat
        AND isexceptedtext             IN @ls_range_set-isexceptedtext
        AND isreversed                 IN @ls_range_set-isreversed
        AND isreversal                 IN @ls_range_set-isreversal
        AND reversalreferencedocument  IN @ls_range_set-reversalreferencedocument
        AND ismain                     IN @ls_range_set-ismain
        AND sourceledger               IN @ls_range_set-sourceledger
        AND companycode                IN @ls_range_set-companycode
        AND fiscalyear                 IN @ls_range_set-fiscalyear
        AND ledgergllineitem           IN @ls_range_set-ledgergllineitem
        AND ledger                     IN @ls_range_set-ledger
        AND ledgergroup                IN @ls_range_set-ledgergroup
        AND postingdate                IN @ls_range_set-postingdate
        AND accountingdoccreatedbyuser IN @ls_range_set-accountingdoccreatedbyuser
        AND accountingdocumenttype     IN @ls_range_set-accountingdocumenttype
        AND businessplacename          IN @ls_range_set-businessplacename
        AND supbizsubno                IN @ls_range_set-supbizsubno
        AND byrbizno                   IN @ls_range_set-byrbizno
        AND billtype                   IN @ls_range_set-billtype
        AND issuedt                    IN @ls_range_set-issuedt
        AND senddt                     IN @ls_range_set-senddt
        AND suprepnm                   IN @ls_range_set-suprepnm
        AND supaddress                 IN @ls_range_set-supaddress
        AND byrbizsubno                IN @ls_range_set-byrbizsubno
        AND byrcorpnm                  IN @ls_range_set-byrcorpnm
        AND byrrepnm                   IN @ls_range_set-byrrepnm
        AND byraddress                 IN @ls_range_set-byraddress
        AND taxclsf                    IN @ls_range_set-taxclsf
        AND taxknd                     IN @ls_range_set-taxknd
        AND isntype                    IN @ls_range_set-isntype
        AND bigo                       IN @ls_range_set-bigo
        AND demandgb                   IN @ls_range_set-demandgb
        AND supemail                   IN @ls_range_set-supemail
        AND byremail1                  IN @ls_range_set-byremail1
        AND byremail2                  IN @ls_range_set-byremail2
        AND itemdt                     IN @ls_range_set-itemdt
        AND itemnm                     IN @ls_range_set-itemnm
        AND itemstd                    IN @ls_range_set-itemstd
        AND itemqty                    IN @ls_range_set-itemqty
        AND itemunt                    IN @ls_range_set-itemunt
        AND itemsupamt                 IN @ls_range_set-itemsupamt
        AND itemtaxamt                 IN @ls_range_set-itemtaxamt
        AND itembigo                   IN @ls_range_set-itembigo
        AND itemstate                  IN @ls_range_set-itemstate
        AND billtypetext               IN @ls_range_set-billtypetext
        AND itemstatetext              IN @ls_range_set-itemstatetext
        AND profitcenternm             IN @ls_range_set-profitcenternm
        AND excludingstat              IN @ls_range_set-excludingstat
        AND cstnbizno                  IN @ls_range_set-cstnbizno
        AND cstncorpnm                 IN @ls_range_set-cstncorpnm
        AND createdat                  IN @ls_range_set-createdat
        AND createdby                  IN @ls_range_set-createdby
        AND lastchangedat              IN @ls_range_set-lastchangedat
        AND lastchangedby              IN @ls_range_set-lastchangedby
        AND locallastchangedat         IN @ls_range_set-locallastchangedat
        AND locallastchangedby         IN @ls_range_set-locallastchangedby
      INTO TABLE @DATA(lt_result).

      LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<fs_result>).
        <fs_result>-profitcenter = |{ <fs_result>-profitcenter ALPHA = OUT }|.
      ENDLOOP.


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
