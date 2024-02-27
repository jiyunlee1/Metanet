CLASS zmcdap_cl_get_ih DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMCDAP_CL_GET_IH IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
    "파라미터 정의
    et_parameter_def = VALUE #( ).

    "파라미터 기본 값
    et_parameter_val = VALUE #( ).

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "log message
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    TYPES : BEGIN OF ty_s_log.
    TYPES : msg(200) TYPE C,
            msgt(1)  TYPE C.
    TYPES : END OF ty_s_log.

    DATA : lt_log TYPE TABLE OF ty_s_log,
           ls_log TYPE ty_s_log.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "UTC+9 YesterDay
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    GET TIME STAMP FIELD DATA(lv_tstp).
    CONVERT TIME STAMP lv_tstp TIME ZONE 'UTC+9' INTO DATE DATA(lv_date) TIME DATA(lv_time).
    SELECT SINGLE datefunctionstartdate
          FROM I_DateFunctionValue
          WHERE datefunction             = 'YESTERDAY'
            and DateFunctionValidityDate = @lv_date
          INTO @DATA(lv_yday).

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
        CASE ls_property-name.
          WHEN 'BIZNO'.
            DATA(lv_bizno) = ls_property-values[ 1 ].
        ENDCASE.
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

        "Property 값을 Header로 할당
        lo_request->set_header_fields(
          EXPORTING
            i_fields =  lt_header
        ).

        "Property에서 설정하지 않은 값을 Header로 할당
        lo_request->set_header_fields(
         EXPORTING
           i_fields =  VALUE #(
                                ( name ='searchkind' value = 'send' )
                                ( name ='startdt'    value = lv_yday )
                                ( name ='enddt'      value = lv_yday )   )
       ).

        ls_log-msg  = |SendDate: { lv_yday }|.
        ls_log-msgt = 'I'.
        APPEND ls_log TO lt_log.
        clear: ls_log.

        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        "호출
        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).
        DATA(lv_json_results) = lo_response->get_text(  ).


        DATA: BEGIN OF ls_response,
                resultdata        TYPE TABLE OF zmcdap_i_invoice,
                resultcode        TYPE string,
                resultfailmessage TYPE string,
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

        IF ls_response-resultcode = '0000'.
          ls_log-msg  = |ResultCode : { ls_response-resultcode }, ResultMessage : { ls_response-resultfailmessage }|.
          ls_log-msgt = 'S'.
        ELSE.
          ls_log-msg  = |ResultCode : { ls_response-resultcode }, ResultMessage : { ls_response-resultfailmessage }|.
          ls_log-msgt = 'W'.
        ENDIF.
        APPEND ls_log TO lt_log.
        clear: ls_log.

        SELECT branch
          FROM zmcdap_v_businees_place
          WHERE vatregistration = @lv_bizno
          ORDER BY branch
          INTO @DATA(lv_bizplace)
          UP TO 1 ROWS.
        ENDSELECT.

          LOOP AT lt_invoice ASSIGNING FIELD-SYMBOL(<fs_invoice>).
            <fs_invoice>-itemstate  = '1'.
            <fs_invoice>-bizplace   = lv_bizplace.
            <fs_invoice>-totamt     = <fs_invoice>-totamt     / 100.
            <fs_invoice>-supamt     = <fs_invoice>-supamt     / 100.
            <fs_invoice>-taxamt     = <fs_invoice>-taxamt     / 100.
            <fs_invoice>-itemunt    = <fs_invoice>-itemunt    / 100.
            <fs_invoice>-itemsupamt = <fs_invoice>-itemsupamt / 100.
            <fs_invoice>-itemtaxamt = <fs_invoice>-itemtaxamt / 100.
            <fs_invoice>-currency   = 'KRW'.

            SELECT SINGLE id
              FROM zmcdap_i_invoice
              WHERE issueno = @<fs_invoice>-issueno
              INTO @DATA(lv_id).

            IF lv_id IS NOT INITIAL.
              <fs_invoice>-id = lv_id.
              ls_update = CORRESPONDING #( <fs_invoice> ).
              APPEND ls_update TO lt_update.
            ELSE.
              ls_create = CORRESPONDING #( <fs_invoice> ).
              ls_create-%cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
              APPEND ls_create TO lt_create.
            ENDIF.
          ENDLOOP.

          "덮어쓰기

            MODIFY ENTITIES OF zmcdap_c_invoice
              ENTITY zmcdap_c_invoice
            UPDATE
              SET FIELDS WITH lt_update
            CREATE
              SET FIELDS WITH lt_create
              FAILED DATA(lt_failed)
              REPORTED DATA(lt_reported).

           IF lt_failed IS NOT INITIAL.
             LOOP AT lt_reported-zmcdap_c_invoice ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
                DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
              APPEND INITIAL LINE TO lt_log ASSIGNING FIELD-SYMBOL(<fs_fail>).
                <fs_fail>-msg  = |DB Failed: { lv_result }|.
                <fs_fail>-msgt = 'E'.
            ENDLOOP.
           ELSE.
            COMMIT ENTITIES.
              DATA(lv_total) = lines( lt_invoice ).
              DATA(lv_upcnt) = lines( lt_update ).
              DATA(lv_crcnt) = lines( lt_create ).
              ls_log-msg  = |Total : { lv_total }, Update : { lv_upcnt }, Create : { lv_crcnt }|.
              ls_log-msgt = 'S'.
              APPEND ls_log TO lt_log.
              clear: ls_log.
           ENDIF.

        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        "Application Log TO Application Jobs
        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
         DATA(lo_ajlog) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create(
                                                           object      = 'ZMCDAPJL0001'
                                                           subobject   = 'ZMCDAPJL0001_01'
                                                         ) ).

         LOOP AT lt_log ASSIGNING FIELD-SYMBOL(<fs_log>).
          CASE <fs_log>-msgt.
            WHEN 'S'.
             DATA(lo_free_text) = cl_bali_free_text_setter=>create(
                    severity = if_bali_constants=>c_severity_status
                    text     = <fs_log>-msg
                  ).
            WHEN 'I'.
                  lo_free_text = cl_bali_free_text_setter=>create(
                    severity = if_bali_constants=>c_severity_information
                    text     = <fs_log>-msg
                  ).
            WHEN 'W'.
                  lo_free_text = cl_bali_free_text_setter=>create(
                    severity = if_bali_constants=>c_severity_warning
                    text     = <fs_log>-msg
                  ).
            WHEN 'E'.
                  lo_free_text = cl_bali_free_text_setter=>create(
                    severity = if_bali_constants=>c_severity_error
                    text     = <fs_log>-msg
                  ).
          ENDCASE.
            lo_ajlog->add_item( item = lo_free_text ).
         ENDLOOP.

         cl_bali_log_db=>get_instance( )->save_log( log = lo_ajlog assign_to_current_appl_job = abap_true ).
         COMMIT WORK.

      CATCH cx_http_dest_provider_error INTO DATA(lx_destexcept).

      CATCH cx_web_http_client_error INTO DATA(lx_clientexcept).

      CATCH cx_uuid_error INTO DATA(lx_uuidexcept).

      CATCH cx_bali_runtime.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
