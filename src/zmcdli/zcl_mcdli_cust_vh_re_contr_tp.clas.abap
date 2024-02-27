CLASS zcl_mcdli_cust_vh_re_contr_tp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDLI_CUST_VH_RE_CONTR_TP IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA: lr_cscn TYPE if_com_scenario_factory=>ty_query-cscn_id_range.

    DATA(lo_paging)     = io_request->get_paging( ).
    DATA(lv_offset)     = lo_paging->get_offset( ).
    DATA(lv_page_size)  = lo_paging->get_page_size( ).
    DATA(lv_max_rows)   = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_page_size ).

    DATA(lt_sorting)        = io_request->get_sort_elements( ).
    DATA(lo_filter)         = io_request->get_filter( ).
    DATA(lt_req_elements)   = io_request->get_requested_elements( ).
    DATA(lt_aggr_elements)  = io_request->get_aggregation( )->get_aggregated_elements( ).

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

      CATCH cx_http_dest_provider_error.
        " handle exception here

      CATCH cx_web_http_client_error.
        " handle exception here
      CATCH /iwbep/cx_gateway.
    ENDTRY.


    DATA: lo_client_proxy         TYPE REF TO /iwbep/if_cp_client_proxy,
          lo_read_list_request    TYPE REF TO /iwbep/if_cp_request_read_list,
          lo_read_list_response   TYPE REF TO /iwbep/if_cp_response_read_lst,
          lo_entity_list_resource TYPE REF TO /iwbep/if_cp_resource_list,
          lo_filter_factory       TYPE REF TO /iwbep/if_cp_filter_factory,
          lo_filter_node_1        TYPE REF TO /iwbep/if_cp_filter_node,
          lt_range                TYPE RANGE OF string.

    DATA lt_result TYPE TABLE OF ZMCDLI_U_VH_RE_CONTRACT_TYPE.
    DATA   selected_properties  TYPE /iwbep/if_cp_runtime_types=>ty_t_property_path.
    APPEND 'RECONTRACTTYPE' TO  selected_properties .
    APPEND 'RECONTRACTTYPENAME' TO  selected_properties .
    TRY.
        lo_client_proxy = cl_web_odata_client_factory=>create_v4_remote_proxy(
                        iv_service_definition_name = 'API_RECONTRACTTYPE'
                        io_http_client             = lo_http_client
                        iv_relative_service_root   = '/sap/opu/odata4/sap/api_re_contracttype/srvd_a2x/sap/recontracttype/0001/').

        lo_entity_list_resource = lo_client_proxy->create_resource_for_entity_set( 'RECONTRACTTYPE' ).
        lo_read_list_request = lo_entity_list_resource->create_request_for_read( ).
        lo_read_list_request->set_select_properties( it_select_property = selected_properties ).

        lo_read_list_response = lo_read_list_request->execute( ).

        lo_read_list_response->get_business_data( IMPORTING et_business_data = lt_result ).
      CATCH cx_web_http_client_error INTO DATA(lx_http_client_error).
      CATCH /iwbep/cx_cp_remote INTO DATA(lx_cp_remote).
      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
    ENDTRY.

    io_response->set_data( lt_result ).
    io_response->set_total_number_of_records( lines( lt_result )  ).
  ENDMETHOD.
ENDCLASS.
