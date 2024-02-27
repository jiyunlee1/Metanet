CLASS lhc_zmcdar_u_mass_post DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmcdar_u_mass_post RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ zmcdar_u_mass_post RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zmcdar_u_mass_post.
    METHODS mass_post FOR MODIFY
      IMPORTING keys FOR ACTION zmcdar_u_mass_post~mass_post RESULT result.

ENDCLASS.

CLASS lhc_zmcdar_u_mass_post IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD mass_post.

    LOOP AT keys[] INTO DATA(ls_key).
      DATA(lv_json) = ls_key-%param-importparameter.

      DATA: lr_cscn TYPE if_com_scenario_factory=>ty_query-cscn_id_range.

      lr_cscn = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZMCDCSAR0001' ) ).
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

      DATA(lv_scenario) =  lo_ca->get_comm_scenario_id( ).
      DATA(lv_systemid) = lo_ca->get_comm_system_id( ).

      TRY.
          DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
              comm_scenario  = lo_ca->get_comm_scenario_id( )
              service_id     = 'ZMCDAR_OBS_01_REST'
              comm_system_id = lo_ca->get_comm_system_id( ) ).

          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).



**********************************************************************
*  Request                                                           *
**********************************************************************
          DATA(lo_request) = lo_http_client->get_http_request( ).

          DATA: BEGIN OF ls_massdata,
                  method TYPE string,
                  uname  TYPE sy-uname,
                  data   TYPE TABLE OF zmcdar_u_mass_post,
                END OF ls_massdata.

          /ui2/cl_json=>deserialize(
            EXPORTING
              json             = lv_json
            CHANGING
              data             = ls_massdata
          ).

          ls_massdata-uname = sy-uname.

          /ui2/cl_json=>serialize(
            EXPORTING
              data             = ls_massdata
            RECEIVING
              r_json           = lv_json
          ).

          lo_request->set_text(
            EXPORTING
              i_text = lv_json
          ).

          lo_request->set_uri_path(
            EXPORTING
              i_uri_path = 'sap/bc/http/sap/zmcdhsar0001'
          ).
*          CATCH cx_web_message_error.



**********************************************************************
*  Response                                                          *
**********************************************************************
          DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).
          DATA(lv_json_results) = lo_response->get_text( ).

          DATA lt_response TYPE TABLE OF string.


          /ui2/cl_json=>deserialize(
            EXPORTING
              json             = lv_json_results
            CHANGING
              data             = lt_response
          ).

          IF lt_response IS NOT INITIAL.
            LOOP AT lt_response INTO DATA(lv_errmsg).
              APPEND INITIAL LINE TO result[] ASSIGNING FIELD-SYMBOL(<fs_result>).
              <fs_result>-%cid = ls_key-%cid.
              <fs_result>-%param-msg = lv_errmsg.
            ENDLOOP.
          ENDIF.
        CATCH cx_http_dest_provider_error INTO DATA(lo_dest_provider_error).
          " handle exception here

        CATCH cx_web_http_client_error INTO DATA(lo_http_client_error).
          " handle exception here
        CATCH /iwbep/cx_gateway INTO DATA(lo_gateway_error).
      ENDTRY.
    ENDLOOP.
*    "input data
*    DATA : lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
*           lv_cid     TYPE abp_behv_cid.
*
*    "   cid없으면 에러로 종료
*    CLEAR lv_cid.
*    lv_cid  = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
*
*    LOOP AT lt_masspost INTO DATA(ls_masspost).
*      APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
*      <je_deep>-%cid   = lv_cid.
*      <je_deep>-%param = VALUE #(
*      ).
*
*      "POST
**    MODIFY ENTITIES OF i_journalentrytp
**             ENTITY JournalEntry
**            EXECUTE post FROM lt_masspst
**    FAILED DATA(failed)
**    REPORTED DATA(reported)
**    MAPPED DATA(mapped).
*    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmcdar_u_mass_post DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmcdar_u_mass_post IMPLEMENTATION.

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
