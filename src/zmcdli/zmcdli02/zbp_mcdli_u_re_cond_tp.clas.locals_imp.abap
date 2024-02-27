CLASS lhc_zmcdli_u_re_cond_tp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmcdli_u_re_cond_tp RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ zmcdli_u_re_cond_tp RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zmcdli_u_re_cond_tp.

    METHODS valid_check FOR READ
      IMPORTING keys FOR FUNCTION zmcdli_u_re_cond_tp~valid_check RESULT result.

    METHODS create_condition FOR MODIFY
      IMPORTING keys FOR ACTION zmcdli_u_re_cond_tp~create_condition RESULT result.

ENDCLASS.

CLASS lhc_zmcdli_u_re_cond_tp IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.



  METHOD valid_check.

    TYPES: BEGIN OF ts_condition,
             internalrealestatenumber  TYPE zmcdli_u_re_cond_tp-internalrealestatenumber,
             restatusobjectcalculation TYPE zmcdli_u_re_cond_tp-restatusobjectcalculation,
             reconditiontype           TYPE zmcdli_u_re_cond_tp-reconditiontype,
             reextconditionpurpose     TYPE zmcdli_u_re_cond_tp-reextconditionpurpose,
             validitystartdate         TYPE zmcdli_u_re_cond_tp-validitystartdate,
             repostingterm             TYPE zmcdli_u_re_cond_tp-repostingterm,
             rerhythmterm              TYPE zmcdli_u_re_cond_tp-rerhythmterm,
             reorglassignmentterm      TYPE zmcdli_u_re_cond_tp-reorglassignmentterm,
             recalculationrule         TYPE zmcdli_u_re_cond_tp-recalculationrule,
             reunitprice               TYPE zmcdli_u_re_cond_tp-reunitprice,
             reconditioncurrency       TYPE zmcdli_u_re_cond_tp-reconditioncurrency,
             localpath                 TYPE zmcdli_u_re_cond_tp-localpath,
           END OF ts_condition.
    DATA: lt_condition TYPE STANDARD TABLE OF ts_condition,
          ls_condition TYPE ts_condition.

    LOOP AT keys[] INTO DATA(ls_key).
      DATA(lv_json) = ls_key-%param-importparameter.
      CLEAR : lt_condition.

      /ui2/cl_json=>deserialize(
        EXPORTING
          json             = lv_json
        CHANGING
          data             = lt_condition
      ).
    ENDLOOP.

*   필수 입력 키 체크
    LOOP AT lt_condition INTO ls_condition.
      IF ls_condition-reunitprice IS INITIAL OR ls_condition-validitystartdate IS INITIAL.
        APPEND INITIAL LINE TO result[] ASSIGNING FIELD-SYMBOL(<fs_result1>).
        <fs_result1>-%param-localpath = ls_condition-localpath.
        <fs_result1>-%param-errmsg = '필수 입력값이 누락되었습니다.'.
      ENDIF.
    ENDLOOP.

    CHECK result IS INITIAL.

*   local 중 중복된 key
    DATA lv_count TYPE i.
    TYPES: BEGIN OF ts_filter_val,
             internalrealestatenumber TYPE zmcdli_u_re_cond_tp-internalrealestatenumber,
             reconditiontype          TYPE zmcdli_u_re_cond_tp-reconditiontype,
             validitystartdate        TYPE zmcdli_u_re_cond_tp-validitystartdate,
           END OF ts_filter_val.
    DATA lt_filter_val TYPE TABLE OF ts_filter_val.

    LOOP AT lt_condition INTO ls_condition.
      APPEND INITIAL LINE TO lt_filter_val ASSIGNING FIELD-SYMBOL(<fs_filter_val>).
      <fs_filter_val> = CORRESPONDING #( ls_condition ).
      CLEAR lv_count.
      SELECT COUNT( * ) FROM @lt_condition AS cond
             WHERE cond~internalrealestatenumber = @ls_condition-internalrealestatenumber
               AND cond~reconditiontype = @ls_condition-reconditiontype
               AND cond~validitystartdate = @ls_condition-validitystartdate
              INTO @lv_count.
      IF lv_count > 1.
        APPEND INITIAL LINE TO result[] ASSIGNING FIELD-SYMBOL(<fs_result2>).
        <fs_result2>-%param-localpath = ls_condition-localpath.
        <fs_result2>-%param-errmsg = '생성된 Local Data 에 중복된 key 값이 존재합니다.'.
      ENDIF.
    ENDLOOP.

    CHECK result IS INITIAL.


*   기존 데이터와 비교
    " OData Proxy
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

    TYPES: BEGIN OF ts_existing,
             reconditionuuid           TYPE sysuuid_x16,
             internalrealestatenumber  TYPE zmcdli_u_re_cond_tp-internalrealestatenumber,
             restatusobjectcalculation TYPE zmcdli_u_re_cond_tp-restatusobjectcalculation,
             reconditiontype           TYPE zmcdli_u_re_cond_tp-reconditiontype,
             reextconditionpurpose     TYPE zmcdli_u_re_cond_tp-reextconditionpurpose,
             validitystartdate         TYPE zmcdli_u_re_cond_tp-validitystartdate,
             validityenddate           TYPE zmcdli_u_re_cond_tp-validitystartdate,
             repostingterm             TYPE zmcdli_u_re_cond_tp-repostingterm,
             rerhythmterm              TYPE zmcdli_u_re_cond_tp-rerhythmterm,
             reorglassignmentterm      TYPE zmcdli_u_re_cond_tp-reorglassignmentterm,
             recalculationrule         TYPE zmcdli_u_re_cond_tp-recalculationrule,
             reunitprice               TYPE zmcdli_u_re_cond_tp-reunitprice,
             reconditioncurrency       TYPE zmcdli_u_re_cond_tp-reconditioncurrency,
           END OF ts_existing.

    DATA: lt_existing TYPE TABLE OF ts_existing,
          ls_existing TYPE ts_existing.

    DATA: lo_client_proxy         TYPE REF TO /iwbep/if_cp_client_proxy,
          lo_read_list_request    TYPE REF TO /iwbep/if_cp_request_read_list,
          lo_read_list_response   TYPE REF TO /iwbep/if_cp_response_read_lst,
          lo_entity_list_resource TYPE REF TO /iwbep/if_cp_resource_list,
          lo_filter_factory       TYPE REF TO /iwbep/if_cp_filter_factory,
          lo_filter_node1         TYPE REF TO /iwbep/if_cp_filter_node,
          lo_filter_node2         TYPE REF TO /iwbep/if_cp_filter_node,
          lo_filter_combi         TYPE REF TO /iwbep/if_cp_filter_node,
          lo_root_filter_node     TYPE REF TO /iwbep/if_cp_filter_node,
          lr_range                TYPE RANGE OF string.

    TRY.
        lo_client_proxy = cl_web_odata_client_factory=>create_v4_remote_proxy(
                        iv_service_definition_name = 'API_RECONTRACT'
                        io_http_client             = lo_http_client
                        iv_relative_service_root   = '/sap/opu/odata4/sap/api_real_estate_contract/srvd_a2x/sap/api_recontract/0001/').

        lo_entity_list_resource = lo_client_proxy->create_resource_for_entity_set( 'A_RECONTRCONDITION' ).
        lo_read_list_request = lo_entity_list_resource->create_request_for_read( ).
        lo_read_list_request->set_select_properties( VALUE #( ( CONV #('RECONDITIONUUID' ) )
                                                              ( CONV #('INTERNALREALESTATENUMBER' ) )
                                                              ( CONV #('RESTATUSOBJECTCALCULATION' ) )
                                                              ( CONV #('RECONDITIONTYPE' ) )
                                                              ( CONV #('REEXTCONDITIONPURPOSE' ) )
                                                              ( CONV #('VALIDITYSTARTDATE' ) )
                                                              ( CONV #('VALIDITYENDDATE' ) )
                                                              ( CONV #('REPOSTINGTERM' ) )
                                                              ( CONV #('RERHYTHMTERM' ) )
                                                              ( CONV #('REORGLASSIGNMENTTERM' ) )
                                                              ( CONV #('RECALCULATIONRULE' ) )
                                                              ( CONV #('REUNITPRICE' ) )
                                                              ( CONV #('RECONDITIONCURRENCY' ) ) ) ).

        lo_filter_factory = lo_read_list_request->create_filter_factory( ).
        LOOP AT lt_filter_val INTO DATA(wa_filter_val).
          CLEAR lo_filter_node1.
          CLEAR lr_range.
          lr_range = VALUE #( ( option = 'EQ' sign = 'I' low = wa_filter_val-reconditiontype ) ).
          lo_filter_node1 = lo_filter_factory->create_by_range(
              iv_property_path = 'RECONDITIONTYPE'
              it_range = lr_range
          ).

          CLEAR lo_filter_node2.
          CLEAR lr_range.
          lr_range = VALUE #( ( option = 'EQ' sign = 'I' low = wa_filter_val-internalrealestatenumber ) ).
          lo_filter_node2 = lo_filter_factory->create_by_range(
              iv_property_path = 'INTERNALREALESTATENUMBER'
              it_range = lr_range
          ).

          lo_filter_combi = lo_filter_node1->and( lo_filter_node2 ).

          IF lo_root_filter_node IS INITIAL.
            lo_root_filter_node = lo_filter_combi.
          ELSE.
            lo_root_filter_node = lo_root_filter_node->or( lo_filter_combi ).
          ENDIF.
        ENDLOOP.

        IF lo_root_filter_node IS NOT INITIAL.
          lo_read_list_request->set_filter( lo_root_filter_node ).
        ENDIF.

        lo_read_list_response = lo_read_list_request->execute( ).
        lo_read_list_response->get_business_data( IMPORTING et_business_data = lt_existing ).
      CATCH cx_web_http_client_error INTO DATA(lx_http_client_error).
      CATCH /iwbep/cx_cp_remote INTO DATA(lx_cp_remote).
      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
    ENDTRY.


    LOOP AT lt_condition INTO ls_condition.
*     One Time
      CLEAR ls_existing.
      SELECT SINGLE * FROM @lt_existing AS cond
       WHERE cond~internalrealestatenumber = @ls_condition-internalrealestatenumber
         AND cond~reconditiontype = @ls_condition-reconditiontype
         AND cond~validitystartdate = @ls_condition-validitystartdate
         AND cond~reextconditionpurpose = 'YB'
          OR cond~reextconditionpurpose = 'YK'
        INTO @ls_existing.
      IF sy-subrc = 0.
        APPEND INITIAL LINE TO result[] ASSIGNING FIELD-SYMBOL(<fs_result3>).
        <fs_result3>-%param-localpath = ls_condition-localpath.
        <fs_result3>-%param-errmsg = '기존 Data 에 중복된 key 값이 존재합니다.'.
        CONTINUE.
      ENDIF.
*     ELSE
      CLEAR ls_existing.
      SELECT * FROM @lt_existing AS cond
       WHERE cond~internalrealestatenumber = @ls_condition-internalrealestatenumber
         AND cond~reconditiontype = @ls_condition-reconditiontype
         AND cond~reextconditionpurpose <> 'YB'
         AND cond~reextconditionpurpose <> 'YK'
         INTO @ls_existing.
        CLEAR lr_range.
        lr_range = VALUE #( ( sign = 'I' option = 'EQ' high = ls_existing-validityenddate low = ls_existing-validitystartdate ) ).
        IF ls_condition-validitystartdate IN lr_range.
          APPEND INITIAL LINE TO result[] ASSIGNING FIELD-SYMBOL(<fs_result4>).
          <fs_result4>-%param-localpath = ls_condition-localpath.
          <fs_result4>-%param-errmsg = '기존 Data 에 중복된 key 값이 존재합니다.'.
          EXIT.
        ENDIF.
      ENDSELECT.
    ENDLOOP.
  ENDMETHOD.


  METHOD create_condition.

    TYPES: BEGIN OF ts_condition,
             internalrealestatenumber  TYPE zmcdli_u_re_cond_tp-internalrealestatenumber,
             restatusobjectcalculation TYPE zmcdli_u_re_cond_tp-restatusobjectcalculation,
             reconditiontype           TYPE zmcdli_u_re_cond_tp-reconditiontype,
             reextconditionpurpose     TYPE zmcdli_u_re_cond_tp-reextconditionpurpose,
             validitystartdate         TYPE zmcdli_u_re_cond_tp-validitystartdate,
             repostingterm             TYPE zmcdli_u_re_cond_tp-repostingterm,
             rerhythmterm              TYPE zmcdli_u_re_cond_tp-rerhythmterm,
             reorglassignmentterm      TYPE zmcdli_u_re_cond_tp-reorglassignmentterm,
             recalculationrule         TYPE zmcdli_u_re_cond_tp-recalculationrule,
             reunitprice               TYPE zmcdli_u_re_cond_tp-reunitprice,
             reconditioncurrency       TYPE zmcdli_u_re_cond_tp-reconditioncurrency,
           END OF ts_condition.
    DATA: lt_condition TYPE TABLE OF ts_condition.

    LOOP AT keys[] INTO DATA(ls_key).
      DATA(lv_json) = ls_key-%param-importparameter.
      CLEAR : lt_condition.

      /ui2/cl_json=>deserialize(
        EXPORTING
          json             = lv_json
        CHANGING
          data             = lt_condition
      ).
    ENDLOOP.

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



    DATA: lo_client_proxy         TYPE REF TO /iwbep/if_cp_client_proxy,
          lo_read_request         TYPE REF TO /iwbep/if_cp_request_read_list,
          lo_read_response        TYPE REF TO /iwbep/if_cp_response_read_lst,
          lo_create_request       TYPE REF TO /iwbep/if_cp_request_create,
          lo_create_response      TYPE REF TO /iwbep/if_cp_response_create,
          lo_batch_request        TYPE REF TO /iwbep/if_cp_request_batch,
          ro_request              TYPE REF TO /iwbep/if_cp_request_batch,
          lo_changeset_request    TYPE REF TO /iwbep/if_cp_request_changeset,
          lo_entity_list_resource TYPE REF TO /iwbep/if_cp_resource_list,
          ls_condition            TYPE ts_condition.




    TRY.
        lo_client_proxy = cl_web_odata_client_factory=>create_v4_remote_proxy(
                        iv_service_definition_name = 'API_RECONTRACT'
                        io_http_client             = lo_http_client
                        iv_relative_service_root   = '/sap/opu/odata4/sap/api_real_estate_contract/srvd_a2x/sap/api_recontract/0001/').


        lo_batch_request = lo_client_proxy->create_request_for_batch( ).
        lo_changeset_request = lo_batch_request->create_request_for_changeset( ).
        lo_entity_list_resource = lo_client_proxy->create_resource_for_entity_set( 'A_RECONTRCONDITION' ).

        LOOP AT lt_condition INTO ls_condition.
          lo_create_request = lo_entity_list_resource->create_request_for_create( ).
          lo_create_request->set_business_data( is_business_data = ls_condition
                                                it_provided_property = VALUE #( ( |INTERNALREALESTATENUMBER| )
                                                                                ( |RESTATUSOBJECTCALCULATION| )
                                                                                ( |RECONDITIONTYPE| )
                                                                                ( |REEXTCONDITIONPURPOSE| )
                                                                                ( |VALIDITYSTARTDATE| )
                                                                                ( |REPOSTINGTERM| )
                                                                                ( |RERHYTHMTERM| )
                                                                                ( |RECALCULATIONRULE| )
                                                                                ( |REUNITPRICE| )
                                                                                ( |RECONDITIONCURRENCY| )
                                                                                ( |REORGLASSIGNMENTTERM| ) ) ).

          lo_changeset_request->add_request( lo_create_request ).
*          lo_batch_request->add_request( lo_create_request ).
        ENDLOOP.
        lo_batch_request->add_request( lo_changeset_request ).
        lo_batch_request->execute( ).
        ro_request = lo_batch_request->check_execution( ).
        lo_changeset_request->check_execution( ).
        lo_create_request->check_execution( ).
        lo_create_response = lo_create_request->get_response( ).
*        lo_create_response->get_business_data(
*          IMPORTING
*            es_business_data =
*        ).


      CATCH cx_web_http_client_error INTO DATA(lv_http_client_error).

      CATCH  /iwbep/cx_cp_remote INTO DATA(lv_cp_remote).
        TYPES: BEGIN OF ty_details,
                 message TYPE c LENGTH 256,
               END OF ty_details.
        data: BEGIN OF lv_error,
                message TYPE c LENGTH 256,
                details TYPE TABLE OF ty_details,
              END OF lv_error.
        DATA: BEGIN OF ls_error,
                error LIKE lv_error,
              END OF ls_error.
        /ui2/cl_json=>deserialize(
            EXPORTING
              json             = lv_cp_remote->http_error_body
            CHANGING
              data             = ls_error
        ).
        APPEND INITIAL LINE TO result[] ASSIGNING FIELD-SYMBOL(<fs_result1>).
        <fs_result1>-%param-errmsg = ls_error-error-message.
        <fs_result1>-%cid = ls_key-%cid.
        LOOP AT ls_error-error-details INTO DATA(wa_error).
          APPEND INITIAL LINE TO result[] ASSIGNING FIELD-SYMBOL(<fs_result2>).
          <fs_result2>-%cid = ls_key-%cid.
          <fs_result2>-%param-errmsg = wa_error-message.
        ENDLOOP.
      CATCH /iwbep/cx_gateway INTO DATA(lv_cx_gateway).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmcdli_u_re_cond_tp DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmcdli_u_re_cond_tp IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
