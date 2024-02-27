CLASS zcl_mcdli_cust_re_contract DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDLI_CUST_RE_CONTRACT IMPLEMENTATION.


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

      CATCH cx_http_dest_provider_error.
        " handle exception here

      CATCH cx_web_http_client_error.
        " handle exception here
      CATCH /iwbep/cx_gateway.
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




**********************************************************************
*   Contract Main Data 호출                                          *
**********************************************************************
    DATA: lo_client_proxy         TYPE REF TO /iwbep/if_cp_client_proxy,
          lo_read_list_request    TYPE REF TO /iwbep/if_cp_request_read_list,
          lo_read_list_response   TYPE REF TO /iwbep/if_cp_response_read_lst,
          lo_entity_list_resource TYPE REF TO /iwbep/if_cp_resource_list,
          lo_filter_factory       TYPE REF TO /iwbep/if_cp_filter_factory,
          lo_filter_node          TYPE REF TO /iwbep/if_cp_filter_node,
          lo_root_filter_node     TYPE REF TO /iwbep/if_cp_filter_node,
          lt_range                TYPE RANGE OF string.

*    TYPES : BEGIN OF ts_repartnerassgmttp,
*              repartnerrelationuuid    TYPE sysuuid_x16,
*              internalrealestatenumber TYPE zmcdli_u_re_contract-internalrealestatenumber,
*              businesspartner          TYPE i_businesspartner-businesspartner,
*            END OF ts_repartnerassgmttp.
    TYPES : BEGIN OF ts_repostingtermtp,
              internalrealestatenumber  TYPE zmcdli_u_re_contract-internalrealestatenumber,
              retermtype                TYPE c LENGTH 4,
              retermnumber              TYPE c LENGTH 4,
              validitystartenddatevalue TYPE c LENGTH 16,
              businesspartner           TYPE zmcdli_u_re_contract-businesspartner,
            END OF ts_repostingtermtp.

    DATA : BEGIN OF ls_contract,
             internalrealestatenumber TYPE zmcdli_u_re_contract-internalrealestatenumber,
             companycode              TYPE zmcdli_u_re_contract-companycode,
             realestatecontract       TYPE zmcdli_u_re_contract-realestatecontract,
             recontractname           TYPE zmcdli_u_re_contract-recontractname,
             recontracttype           TYPE zmcdli_u_re_contract-recontracttype,
             recontractcurrency       TYPE zmcdli_u_re_contract-recontractcurrency,
*             _repartnerassgmttp       TYPE TABLE OF ts_repartnerassgmttp,
             _repostingtermtp         TYPE TABLE OF ts_repostingtermtp,
           END OF ls_contract.


    DATA lt_contract LIKE TABLE OF ls_contract.

    TRY.
        lo_client_proxy = cl_web_odata_client_factory=>create_v4_remote_proxy(
                        iv_service_definition_name = 'API_RECONTRACT'
                        io_http_client             = lo_http_client
                        iv_relative_service_root   = '/sap/opu/odata4/sap/api_real_estate_contract/srvd_a2x/sap/api_recontract/0001/').

        lo_entity_list_resource = lo_client_proxy->create_resource_for_entity_set( 'A_RECONTRACT' ).
        lo_read_list_request = lo_entity_list_resource->create_request_for_read( ).
        lo_read_list_request->set_select_properties( VALUE #( ( CONV #('INTERNALREALESTATENUMBER') )
                                                              ( CONV #('COMPANYCODE') )
                                                              ( CONV #('REALESTATECONTRACT') )
                                                              ( CONV #('RECONTRACTNAME') )
                                                              ( CONV #('RECONTRACTTYPE') )
                                                              ( CONV #('RECONTRACTCURRENCY') ) ) ).

*        lo_read_list_request->create_expand_node(  )->add_expand( '_REPARTNERASSGMTTP' )->set_select_properties( VALUE #( ( CONV #( 'REPARTNERRELATIONUUID' ) )
*                                                                                                                          ( CONV #( 'INTERNALREALESTATENUMBER' ) )
*                                                                                                                          ( CONV #( 'BUSINESSPARTNER' ) ) ) ).
        lo_read_list_request->create_expand_node(  )->add_expand( '_REPOSTINGTERMTP' )->set_select_properties( VALUE #( ( CONV #( 'INTERNALREALESTATENUMBER' ) )
                                                                                                                        ( CONV #( 'BUSINESSPARTNER' ) )
                                                                                                                        ( CONV #( 'RETERMTYPE' ) )
                                                                                                                        ( CONV #( 'RETERMNUMBER' ) )
                                                                                                                        ( CONV #( 'VALIDITYSTARTENDDATEVALUE' ) ) ) ).

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


**********************************************************************
*   Contract Type Text Data 호출                                     *
**********************************************************************
    DATA : BEGIN OF ls_contract_type,
             recontracttype     TYPE zmcdli_u_re_contract-recontracttype,
             recontracttypename TYPE zmcdli_u_re_contract-recontracttypename,
           END OF ls_contract_type.
    DATA : BEGIN OF ls_contract_type_text,
             recontracttype     TYPE zmcdli_u_re_contract-recontracttype,
             language           TYPE c LENGTH 2,
             recontracttypename TYPE zmcdli_u_re_contract-recontracttypename,
           END OF ls_contract_type_text.

    DATA lt_contract_type LIKE TABLE OF ls_contract_type.
    DATA lt_contract_type_text LIKE TABLE OF ls_contract_type_text.

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


**********************************************************************
*   Data 가공                                                        *
**********************************************************************
    DATA: lt_result  TYPE TABLE OF zmcdli_u_re_contract,
          ls_result  TYPE zmcdli_u_re_contract,
          lt_recontr TYPE TABLE OF zmcdli_u_re_contract.


**********************************************************************
*   Business Partner 데이터 Select                                   *
**********************************************************************
    TYPES: BEGIN OF ts_partner,
             businesspartner     TYPE i_businesspartner-businesspartner,
             businesspartnername TYPE i_businesspartner-businesspartnername,
           END OF ts_partner.
    DATA: lt_partner TYPE TABLE OF ts_partner,
          lr_partner TYPE RANGE OF zmcdli_u_re_contract-businesspartner,
          lv_partner TYPE i_businesspartner-businesspartner.
    DATA: lv_orderby_string TYPE string,
          lv_elementnm      TYPE string.
    DATA lv_select_string TYPE string.

    LOOP AT lt_contract INTO DATA(wa_contract).
      SELECT SINGLE businesspartner FROM @wa_contract-_repostingtermtp AS posting
       WHERE posting~retermnumber = ''
        INTO @lv_partner.
      IF lv_partner IS NOT INITIAL.
        APPEND INITIAL LINE TO lr_partner[] ASSIGNING FIELD-SYMBOL(<fs_range>).
        <fs_range>-sign = 'I'.
        <fs_range>-option = 'EQ'.
        <fs_range>-low = lv_partner.
      ENDIF.
      APPEND INITIAL LINE TO lt_recontr ASSIGNING FIELD-SYMBOL(<fs_recontr>).
      <fs_recontr> = CORRESPONDING #( wa_contract ).
      <fs_recontr>-businesspartner = lv_partner.
    ENDLOOP.

    SELECT * FROM i_businesspartner
        WHERE businesspartner IN @lr_partner
        INTO CORRESPONDING FIELDS OF TABLE @lt_partner.

    TYPES: BEGIN OF ts_col,
             col TYPE c LENGTH 256,
           END OF ts_col.
    DATA: lt_contr_col TYPE TABLE OF ts_col,
          lt_part_col  TYPE TABLE OF ts_col,
          lt_text_col  TYPE TABLE OF ts_col.

    lt_contr_col = VALUE #( ( col = 'InternalRealEstateNumber' )
                            ( col = 'CompanyCode' )
                            ( col = 'RealEstateContract' )
                            ( col = 'REContractName' )
                            ( col = 'REContractType' )
                            ( col = 'REContractCurrency' )
                            ( col = 'BusinessPartner' ) ).
    lt_text_col = VALUE #( ( col = 'REContractTypeName' ) ).
    lt_part_col = VALUE #( ( col = 'BusinessPartnerName') ).

    IF lt_sorting IS NOT INITIAL.
      CLEAR lv_orderby_string.
      LOOP AT lt_sorting INTO DATA(ls_sorting).
        CLEAR lv_elementnm.
        IF ls_sorting-element_name = 'RECONTRACTTYPENAME'.
          CONCATENATE 'ct~' ls_sorting-element_name INTO lv_elementnm.
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

        ELSEIF ls_sorting-element_name = 'BUSINESSPARTNERNAME'.
          CONCATENATE 'bp~' ls_sorting-element_name INTO lv_elementnm.
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
          CONCATENATE 'cntr~' ls_sorting-element_name INTO lv_elementnm.
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
      lv_orderby_string = 'cntr~REALESTATECONTRACT'.
    ENDIF.


    SELECT * FROM @lt_recontr AS cntr
            INNER JOIN @lt_contract_type AS ct
               ON cntr~recontracttype = ct~recontracttype
            INNER JOIN @lt_partner AS bp
               ON cntr~businesspartner = bp~businesspartner
            ORDER BY (lv_orderby_string)
             INTO CORRESPONDING FIELDS OF TABLE @lt_result.

    io_response->set_data( lt_result ).
    io_response->set_total_number_of_records( lines( lt_result )  ).
  ENDMETHOD.
ENDCLASS.
