CLASS zcl_mcdli_cust_vh_re_contract DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDLI_CUST_VH_RE_CONTRACT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA: lr_cscn TYPE if_com_scenario_factory=>ty_query-cscn_id_range.

    lr_cscn = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZMCDCSLI0001' ) ).
    DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).
    lo_factory->query_ca(
      EXPORTING
        is_query           = VALUE #( cscn_id_range = lr_cscn )
      IMPORTING
        et_com_arrangement = DATA(lt_ca) ).

    IF lt_ca IS INITIAL.
      EXIT.
    ENDIF.

    READ TABLE lt_ca INTO DATA(lo_ca) INDEX 1.




    TRY.


        DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
            comm_scenario  = 'ZMCDCSLI0001'
            service_id     = 'ZMCDLI_OBS_01_REST'
            comm_system_id = lo_ca->get_comm_system_id( ) ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

      CATCH cx_http_dest_provider_error into data(lv_dest_provider_error).
        " handle exception here

      CATCH cx_web_http_client_error into data(lv_client_error).
        " handle exception here
      CATCH /iwbep/cx_gateway into data(lv_gateway).
    ENDTRY.



    DATA(lo_paging)     = io_request->get_paging( ).
    DATA(lv_offset)     = lo_paging->get_offset( ).
    DATA(lv_page_size)  = lo_paging->get_page_size( ).
    DATA(lv_max_rows)   = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_page_size ).
    DATA(lt_sorting)        = io_request->get_sort_elements( ).
    DATA(lt_req_elements)   = io_request->get_requested_elements( ).
    DATA(lt_aggr_elements)  = io_request->get_aggregation( )->get_aggregated_elements( ).

    TRY.
        DATA(lt_filter)         = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    ENDTRY.


    DATA: lo_client_proxy         TYPE REF TO /iwbep/if_cp_client_proxy,
          lo_read_list_request    TYPE REF TO /iwbep/if_cp_request_read_list,
          lo_read_list_response   TYPE REF TO /iwbep/if_cp_response_read_lst,
          lo_entity_list_resource TYPE REF TO /iwbep/if_cp_resource_list,
          lo_filter_factory       TYPE REF TO /iwbep/if_cp_filter_factory,
          lo_filter_node          TYPE REF TO /iwbep/if_cp_filter_node,
          lo_root_filter_node     TYPE REF TO /iwbep/if_cp_filter_node,
          lt_range                TYPE RANGE OF string.
    TYPES : BEGIN OF ts_contract,
              internalrealestatenumber TYPE c LENGTH 13,
              realestatecontract       TYPE zmcdli_u_vh_re_contract-realestatecontract,
              recontractname           TYPE zmcdli_u_vh_re_contract-recontractname,
              recontracttype           TYPE zmcdli_u_vh_re_contract-recontracttype,
            END OF ts_contract.

    DATA lt_contract TYPE TABLE OF ts_contract.

    TRY.
        lo_client_proxy = cl_web_odata_client_factory=>create_v4_remote_proxy(
                        iv_service_definition_name = 'API_RECONTRACT'
                        io_http_client             = lo_http_client
                        iv_relative_service_root   = '/sap/opu/odata4/sap/api_real_estate_contract/srvd_a2x/sap/api_recontract/0001/').

        lo_entity_list_resource = lo_client_proxy->create_resource_for_entity_set( 'A_RECONTRACT' ).
        lo_read_list_request = lo_entity_list_resource->create_request_for_read( ).
        lo_read_list_request->set_select_properties( VALUE #( ( CONV #('INTERNALREALESTATENUMBER') )
                                                              ( CONV #('REALESTATECONTRACT') )
                                                              ( CONV #('RECONTRACTNAME') )
                                                              ( CONV #('RECONTRACTTYPE') ) ) ).

        lo_filter_factory = lo_read_list_request->create_filter_factory( ).
        LOOP AT lt_filter INTO DATA(wa_filter).
          lo_filter_node = lo_filter_factory->create_by_range(
              iv_property_path = wa_filter-name
              it_range = wa_filter-range
          ).

          IF lo_root_filter_node IS INITIAL.
            lo_root_filter_node = lo_filter_node.
          ELSE.
            lo_root_filter_node = lo_root_filter_node->and( lo_filter_node ).
          ENDIF.
        ENDLOOP.

        IF lo_root_filter_node IS NOT INITIAL.
          lo_read_list_request->set_filter( lo_root_filter_node ).
        ENDIF.
        lo_read_list_response = lo_read_list_request->execute( ).

        lo_read_list_response->get_business_data( IMPORTING et_business_data = lt_contract ).
      CATCH cx_web_http_client_error INTO DATA(lx_http_client_error).
      CATCH /iwbep/cx_cp_remote INTO DATA(lx_cp_remote).
      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
    ENDTRY.


    TYPES : BEGIN OF ts_contract_type,
              recontracttype     TYPE zmcdli_u_vh_re_contract_type-recontracttype,
              recontracttypename TYPE zmcdli_u_vh_re_contract_type-recontracttypename,
            END OF ts_contract_type.
    TYPES : BEGIN OF ts_contract_type_text,
              recontracttype     TYPE zmcdli_u_vh_re_contract_type-recontracttype,
              language           TYPE c LENGTH 2,
              recontracttypename TYPE zmcdli_u_vh_re_contract_type-recontracttypename,
            END OF ts_contract_type_text.

    DATA lt_contract_type TYPE TABLE OF ts_contract_type.
    DATA lt_contract_type_text TYPE TABLE OF ts_contract_type_text.

    DATA: lo_client_proxy_2         TYPE REF TO /iwbep/if_cp_client_proxy,
          lo_read_list_request_2    TYPE REF TO /iwbep/if_cp_request_read_list,
          lo_read_list_response_2   TYPE REF TO /iwbep/if_cp_response_read_lst,
          lo_entity_list_resource_2 TYPE REF TO /iwbep/if_cp_resource_list.
    DATA   selected_properties  TYPE /iwbep/if_cp_runtime_types=>ty_t_property_path.
    APPEND 'RECONTRACTTYPE' TO  selected_properties .
    APPEND 'RECONTRACTTYPENAME' TO  selected_properties .
    TRY.
        lo_client_proxy_2 = cl_web_odata_client_factory=>create_v4_remote_proxy(
                        iv_service_definition_name = 'API_RECONTRACTTYPE'
                        io_http_client             = lo_http_client
                        iv_relative_service_root   = '/sap/opu/odata4/sap/api_re_contracttype/srvd_a2x/sap/recontracttype/0001/').

        lo_entity_list_resource_2 = lo_client_proxy_2->create_resource_for_entity_set( 'RECONTRACTTYPE' ).
        lo_read_list_request_2 = lo_entity_list_resource_2->create_request_for_read( ).
        lo_read_list_request_2->set_select_properties( it_select_property = selected_properties ).

        lo_read_list_response_2 = lo_read_list_request_2->execute( ).

        lo_read_list_response_2->get_business_data( IMPORTING et_business_data = lt_contract_type ).

*        lo_entity_list_resource_2 = lo_client_proxy_2->create_resource_for_entity_set( 'RECONTRACTTYPETEXT' ).
*        lo_read_list_request_2 = lo_entity_list_resource_2->create_request_for_read( ).
*        lo_read_list_request_2->set_select_properties( it_select_property = selected_properties ).
*
*        lo_filter_factory = lo_read_list_request_2->create_filter_factory( ).
*        lt_range = VALUE #( ( option = 'EQ' sign = 'I' low = sy-langu ) ).
*        lo_filter_node_1 = lo_filter_factory->create_by_range( iv_property_path = 'LANGUAGE'
*                                                               it_range = lt_range ).
*
*        lo_read_list_request_2->set_filter( lo_filter_node_1 ).
*
*        lo_read_list_response_2 = lo_read_list_request_2->execute( ).
*
*        lo_read_list_response_2->get_business_data( IMPORTING et_business_data = lt_contract_type_text ).
      CATCH cx_web_http_client_error INTO lx_http_client_error.
      CATCH /iwbep/cx_cp_remote INTO lx_cp_remote.
      CATCH /iwbep/cx_gateway INTO lx_gateway.
    ENDTRY.

    DATA lt_result TYPE TABLE OF zmcdli_u_vh_re_contract.
    DATA: lv_select_string  TYPE string,
          lv_orderby_string TYPE string,
          lv_elementnm      TYPE string.

    IF lt_sorting IS NOT INITIAL.
      CLEAR lv_orderby_string.
      LOOP AT lt_sorting INTO DATA(ls_sorting).
        CLEAR lv_elementnm.
        IF ls_sorting-element_name = 'RECONTRACTTYPENAME'.
          CONCATENATE 'text~' ls_sorting-element_name INTO lv_elementnm.
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
        ELSE.
          CONCATENATE 'contract~' ls_sorting-element_name INTO lv_elementnm.
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
        ENDIF.
      ENDLOOP.
    ELSE.
      " lv_orderby_string must not be empty.
      lv_orderby_string = 'contract~REALESTATECONTRACT'.
    ENDIF.


    SELECT * FROM @lt_contract AS contract
            INNER JOIN @lt_contract_type AS text
               ON contract~recontracttype = text~recontracttype
            ORDER BY (lv_orderby_string)
             INTO CORRESPONDING FIELDS OF TABLE @lt_result.

    io_response->set_data( lt_result ).
    io_response->set_total_number_of_records( lines( lt_result )  ).
  ENDMETHOD.
ENDCLASS.
