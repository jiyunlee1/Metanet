CLASS lhc_zmcdap_u_invoice DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmcdap_u_invoice RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zmcdap_u_invoice.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zmcdap_u_invoice.

*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE zmcdap_u_invoice.

    METHODS read FOR READ
      IMPORTING keys FOR READ zmcdap_u_invoice RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zmcdap_u_invoice.

    METHODS rba_invoiceitem FOR READ
      IMPORTING keys_rba FOR READ zmcdap_u_invoice\_invoiceitem FULL result_requested RESULT result LINK association_links.

    METHODS cba_invoiceitem FOR MODIFY
      IMPORTING entities_cba FOR CREATE zmcdap_u_invoice\_invoiceitem.
    METHODS callheaderdata FOR MODIFY
      IMPORTING keys FOR ACTION zmcdap_u_invoice~callheaderdata.
    METHODS callitemdata FOR MODIFY
      IMPORTING keys FOR ACTION zmcdap_u_invoice~callitemdata.
    METHODS setdefaultopt FOR READ
      IMPORTING keys FOR FUNCTION zmcdap_u_invoice~setdefaultopt RESULT result.

    METHODS precheck_callheaderdata FOR PRECHECK
      IMPORTING keys FOR ACTION zmcdap_u_invoice~callheaderdata.

ENDCLASS.

CLASS lhc_zmcdap_u_invoice IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

*  METHOD delete.
*  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_invoiceitem.
  ENDMETHOD.

  METHOD cba_invoiceitem.
  ENDMETHOD.

  METHOD callheaderdata.

    DATA : lt_update_invoice TYPE TABLE FOR UPDATE zmcdap_c_invoice.
    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).

      IF <fs_key>-%param-business_place IS INITIAL.

        APPEND VALUE #( %cid                = <fs_key>-%cid ) TO failed-zmcdap_u_invoice.

        APPEND VALUE #( %cid                = <fs_key>-%cid
                        %msg                = new_message_with_text(  text = 'Business Place is Required'
                                                                      severity = if_abap_behv_message=>severity-error ) ) TO reported-zmcdap_u_invoice.
      ENDIF.

      IF <fs_key>-%param-from_date IS INITIAL.

        APPEND VALUE #( %cid                = <fs_key>-%cid ) TO failed-zmcdap_u_invoice.

        APPEND VALUE #( %cid                = <fs_key>-%cid
                        %msg                = new_message_with_text(  text = 'NTS From Date is Required'
                                                                      severity = if_abap_behv_message=>severity-error ) ) TO reported-zmcdap_u_invoice.
      ENDIF.

      IF <fs_key>-%param-method IS INITIAL.

        APPEND VALUE #( %cid                = <fs_key>-%cid ) TO failed-zmcdap_u_invoice.

        APPEND VALUE #( %cid                = <fs_key>-%cid
                        %msg                = new_message_with_text(  text = 'Method is Required'
                                                                      severity = if_abap_behv_message=>severity-error ) ) TO reported-zmcdap_u_invoice.
      ENDIF.

      CHECK failed IS INITIAL.


      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " Custom Communication Scenario 이름으로 Communication Arrangement 찾기
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      DATA: lr_cscn TYPE if_com_scenario_factory=>ty_query-cscn_id_range.

      lr_cscn       = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZMCDCSIF0004' ) ).

      DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).

      lo_factory->query_ca(
        EXPORTING
          is_query           = VALUE #( cscn_id_range = lr_cscn )
        IMPORTING
          et_com_arrangement = DATA(lt_ca) ).

      IF lt_ca IS INITIAL.
        EXIT.
      ENDIF.

      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " Communication Arrangement의 Property 값을 Message의 Header로 할당 하기
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

      DATA: lt_header TYPE if_web_http_request=>name_value_pairs.

      READ TABLE lt_ca INTO DATA(lo_ca) INDEX 1.

      lo_ca->get_properties(
          RECEIVING
              rt_property = DATA(lt_property)
      ).

      LOOP AT lt_property INTO DATA(ls_property).
        IF ls_property-values[ 1 ] IS NOT INITIAL.
          APPEND INITIAL LINE TO lt_header ASSIGNING FIELD-SYMBOL(<fs_header>).
          <fs_header>-name  = ls_property-name.
          <fs_header>-value = ls_property-values[ 1 ].
        ENDIF.
      ENDLOOP.


      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " HTTP Client 생성
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      TRY.
          DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
           comm_scenario        = 'ZMCDCSIF0004'
           service_id           = 'ZMCDIF_OBS_01_REST'
           comm_system_id       = lo_ca->get_comm_system_id( ) ).

          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

          DATA(lo_request) = lo_http_client->get_http_request( ).

          lo_request->set_header_fields(
            EXPORTING
              i_fields =  lt_header
          ).
          DATA lv_mode TYPE string.
          CASE <fs_key>-%param-search_kind.
            WHEN 'MAKEDT'.
              lv_mode = 'make'.
            WHEN 'ISSUEDT'.
              lv_mode = 'issue'.
            WHEN 'SENDDT'.
              lv_mode = 'send'.
          ENDCASE.
          lo_request->set_header_fields(
           EXPORTING
             i_fields =  VALUE #( ( name ='bizno' value = <fs_key>-%param-business_place )
                                  ( name ='searchkind' value = lv_mode )
                                  ( name ='startdt' value = <fs_key>-%param-from_date )
                                  ( name ='enddt' value = <fs_key>-%param-to_date )   )
         ).



          "호출
          DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).
          DATA(lv_json_results) = lo_response->get_text(  ).

          DATA: BEGIN OF ls_response,
                  resultdata TYPE TABLE OF zmcdap_i_invoice,
                END OF ls_response.

          /ui2/cl_json=>deserialize(
            EXPORTING
              json             = lv_json_results
            CHANGING
              data             = ls_response
          ).

          DATA: lt_invoice TYPE TABLE OF zmcdap_c_invoice,
                lt_create  TYPE TABLE FOR CREATE zmcdap_c_invoice,
                ls_create  LIKE LINE OF lt_create,
                lt_update  TYPE TABLE FOR UPDATE zmcdap_c_invoice,
                ls_update  LIKE LINE OF lt_update.


          lt_invoice = CORRESPONDING #( ls_response-resultdata ).

          SELECT branch FROM zmcdap_v_businees_place
          WHERE vatregistration = @<fs_key>-%param-business_place
          ORDER BY branch
          INTO @DATA(lv_bizplace)
          UP TO 1 ROWS.
          ENDSELECT.

          LOOP AT lt_invoice ASSIGNING FIELD-SYMBOL(<fs_invoice>).
            <fs_invoice>-itemstate = '1'.
            <fs_invoice>-bizplace = lv_bizplace.
            <fs_invoice>-totamt =     <fs_invoice>-totamt     / 100.
            <fs_invoice>-supamt =     <fs_invoice>-supamt     / 100.
            <fs_invoice>-taxamt =     <fs_invoice>-taxamt     / 100.
            <fs_invoice>-itemunt =    <fs_invoice>-itemunt    / 100.
            <fs_invoice>-itemsupamt = <fs_invoice>-itemsupamt / 100.
            <fs_invoice>-itemtaxamt = <fs_invoice>-itemtaxamt / 100.
            <fs_invoice>-currency = 'KRW'.
            SELECT SINGLE id FROM zmcdap_i_invoice
            WHERE issueno = @<fs_invoice>-issueno
            INTO @DATA(lv_id).

            IF lv_id IS NOT INITIAL.
              <fs_invoice>-id = lv_id.
              ls_update = CORRESPONDING #( <fs_invoice> ).
*              ls_update-%cid_ref = <fs_key>-%cid.
              APPEND ls_update TO lt_update.
            ELSE.
              ls_create = CORRESPONDING #( <fs_invoice> ).
              ls_create-%cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
              APPEND ls_create TO lt_create.
            ENDIF.
            CLEAR: ls_update, ls_create, lv_id.

          ENDLOOP.

          IF <fs_key>-%param-method EQ 1.
            MODIFY ENTITIES OF zmcdap_c_invoice
            ENTITY zmcdap_c_invoice
            CREATE
            SET FIELDS WITH lt_create.
          ELSE.
            MODIFY ENTITIES OF zmcdap_c_invoice
            ENTITY zmcdap_c_invoice
            UPDATE
            SET FIELDS WITH lt_update
            CREATE
            SET FIELDS WITH lt_create.
          ENDIF.

        CATCH cx_http_dest_provider_error INTO DATA(lx_destexcept).

        CATCH cx_web_http_client_error INTO DATA(lx_clientexcept).

      ENDTRY.

    ENDLOOP.
*    result = VALUE #( FOR <fs_doc_head> IN lt_doc_head ( %tky = <fs_doc_head>-%tky
*    %param = <fs_doc_head> ) ).

  ENDMETHOD.




  METHOD callitemdata.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).

      SELECT SINGLE senddt, bizplace, issueno
      FROM zmcdap_i_invoice
      WHERE id = @<fs_key>-%param-id
      INTO @DATA(ls_param).


      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " Custom Communication Scenario 이름으로 Communication Arrangement 찾기
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      DATA: lr_cscn TYPE if_com_scenario_factory=>ty_query-cscn_id_range.

      lr_cscn       = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZMCDCSIF0004' ) ).

      DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).

      lo_factory->query_ca(
        EXPORTING
          is_query           = VALUE #( cscn_id_range = lr_cscn )
        IMPORTING
          et_com_arrangement = DATA(lt_ca) ).

      IF lt_ca IS INITIAL.
        EXIT.
      ENDIF.

      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " Communication Arrangement의 Property 값을 Message의 Header로 할당 하기
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

      DATA: lt_header TYPE if_web_http_request=>name_value_pairs.

      READ TABLE lt_ca INTO DATA(lo_ca) INDEX 1.

      lo_ca->get_properties(
          RECEIVING
              rt_property = DATA(lt_property)
      ).

      LOOP AT lt_property INTO DATA(ls_property).
        IF ls_property-values[ 1 ] IS NOT INITIAL.
          APPEND INITIAL LINE TO lt_header ASSIGNING FIELD-SYMBOL(<fs_header>).
          <fs_header>-name  = ls_property-name.
          <fs_header>-value = ls_property-values[ 1 ].
        ENDIF.
      ENDLOOP.


      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " HTTP Client 생성
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      TRY.
          DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
           comm_scenario        = 'ZMCDCSIF0004'
           service_id           = 'ZMCDIF_OBS_02_REST'
           comm_system_id       = lo_ca->get_comm_system_id( ) ).

          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

          DATA(lo_request) = lo_http_client->get_http_request( ).

          lo_request->set_header_fields(
            EXPORTING
              i_fields =  lt_header
          ).

          lo_request->set_header_fields(
           EXPORTING
             i_fields =  VALUE #( ( name ='startdt' value = ls_param-senddt )
                                  ( name ='enddt' value = ls_param-senddt )
                                  ( name ='issueno' value = ls_param-issueno )   )
         ).



          "호출
          DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).
          DATA(lv_json_results) = lo_response->get_text(  ).
          DATA: BEGIN OF ls_response,
                  resultdata TYPE TABLE OF zmcdap_i_invoice_item,
                END OF ls_response.

          /ui2/cl_json=>deserialize(
            EXPORTING
              json             = lv_json_results
            CHANGING
              data             = ls_response
          ).

          DATA: lt_item          TYPE TABLE OF zmcdap_c_invoice_item,
                lt_header_update TYPE TABLE FOR UPDATE zmcdap_c_invoice,
                lt_create        TYPE TABLE FOR CREATE zmcdap_c_invoice\_items,
                ls_create        LIKE LINE OF lt_create,
                lt_update        TYPE TABLE FOR UPDATE zmcdap_c_invoice\\zmcdap_c_invoice_item,
                ls_update        LIKE LINE OF lt_update,
                ls_target        LIKE LINE OF ls_create-%target.

          READ ENTITIES OF zmcdap_c_invoice
          ENTITY zmcdap_c_invoice
          ALL FIELDS WITH
          VALUE #( ( id = <fs_key>-%param-id ) )
          RESULT DATA(result)
          FAILED DATA(f)
          REPORTED DATA(r).

          lt_header_update = CORRESPONDING #( result ).

          LOOP AT lt_header_update ASSIGNING FIELD-SYMBOL(<fs_header_update>).
*            DATA(lv_cid) = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
            <fs_header_update>-itemstate = '3'.
          ENDLOOP.

          lt_item = CORRESPONDING #( ls_response-resultdata EXCEPT createdby createdat lastchangedby lastchangedat locallastchangedby locallastchangedat ).


          SELECT
            gv~id,
            gv~headerid,
            lc~bizplace  ,
            lc~issueno   ,
            lc~clientkey ,
            lc~entkey   ,
            lc~itemno   ,
            lc~supbizno  ,
            lc~byrbizno  ,
            lc~itemdt   ,
            lc~itemnm   ,
            lc~itemstd   ,
            lc~itemqty   ,
            lc~itemunt   ,
            lc~itemsupamt,
            lc~itemtaxamt,
            lc~itembigo  ,
            lc~currency  ,
            lc~createdby ,
            lc~createdat ,
            lc~locallastchangedby,
            lc~locallastchangedat,
            lc~lastchangedat  ,
            lc~lastchangedby
          FROM @lt_item AS lc
          LEFT OUTER JOIN zmcdap_i_invoice_item AS gv
          ON lc~issueno = gv~issueno
          AND lc~itemno = gv~itemno
          INTO TABLE @lt_item.

          LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
*            SELECT SINGLE id FROM zmcdap_i_invoice_item
*            WHERE issueno = @<fs_item>-issueno
*            AND itemno = @<fs_item>-itemno
*            INTO @DATA(lv_id).
            <fs_item>-itemunt = <fs_item>-itemunt / 100.
            <fs_item>-itemsupamt = <fs_item>-itemsupamt / 100.
            <fs_item>-itemtaxamt = <fs_item>-itemtaxamt / 100.
            <fs_item>-currency = 'KRW'.
            IF <fs_item>-id IS NOT INITIAL.
*              <fs_item>-id = lv_id.
              <fs_item>-headerid = ''.
              ls_update = CORRESPONDING #( <fs_item> ).
              APPEND ls_update TO lt_update.
            ELSE.
              ls_target = CORRESPONDING #( <fs_item> ).
*              ls_target-headerid = <fs_key>-%param-id.
              ls_target-%cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
              ls_target-bizplace = ls_param-bizplace.
              APPEND ls_target TO ls_create-%target.
            ENDIF.
            CLEAR: ls_update.
          ENDLOOP.
          ls_create-id = <fs_key>-%param-id.
          APPEND ls_create TO lt_create.

*          MODIFY ENTITIES OF zmcdap_c_invoice
*          ENTITY zmcdap_c_invoice
*          UPDATE
*          SET FIELDS WITH VALUE #( ( %cid_ref = lv_cid %key-id = <fs_item>-id  itemstate = '3') ).
*
*          MODIFY ENTITIES OF zmcdap_c_invoice
*          ENTITY zmcdap_c_invoice
*          CREATE BY \_items
*          SET FIELDS WITH lt_create.

          MODIFY ENTITIES OF zmcdap_c_invoice
          ENTITY zmcdap_c_invoice
          UPDATE
          FIELDS ( itemstate ) WITH lt_header_update
          CREATE BY \_items
          SET FIELDS WITH lt_create
          ENTITY zmcdap_c_invoice_item
          UPDATE
          SET FIELDS WITH lt_update.

        CATCH cx_http_dest_provider_error INTO DATA(lx_destexcept).

        CATCH cx_web_http_client_error INTO DATA(lx_clientexcept).

      ENDTRY.

    ENDLOOP.
  ENDMETHOD.

  METHOD setdefaultopt.
    APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).
    DATA(lv_this_month) = zcl_mcdcm_calc_date=>get_start_end_date( iv_date = sy-datum ).

    <fs_result>-%param-search_kind = 'MAKEDT'.
    <fs_result>-%param-from_date = lv_this_month-frst_date.
    <fs_result>-%param-to_date = lv_this_month-last_date.
    <fs_result>-%param-method = '1'.
  ENDMETHOD.

  METHOD precheck_callheaderdata.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zmcdap_r_cust_item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zmcdap_r_cust_item.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zmcdap_r_cust_item.

    METHODS read FOR READ
      IMPORTING keys FOR READ zmcdap_r_cust_item RESULT result.

    METHODS rba_header FOR READ
      IMPORTING keys_rba FOR READ zmcdap_r_cust_item\_header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zmcdap_r_cust_item IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_header.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmcdap_u_invoice DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmcdap_u_invoice IMPLEMENTATION.

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
