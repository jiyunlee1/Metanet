CLASS zmcdap_cl_get_item DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMCDAP_CL_GET_ITEM IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
    "파라미터 정의
    et_parameter_def = VALUE #( ).

    "파라미터 기본 값
    et_parameter_val = VALUE #( ).

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "log message Type
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    TYPES : BEGIN OF ty_s_log.
    TYPES : msg(200) TYPE c,
            msgt(1)  TYPE c.
    TYPES : END OF ty_s_log.

    DATA : lt_log TYPE TABLE OF ty_s_log,
           ls_log TYPE ty_s_log.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "UTC+9 YesterDay
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    GET TIME STAMP FIELD DATA(lv_tstp).
    CONVERT TIME STAMP lv_tstp TIME ZONE 'UTC+9' INTO DATE DATA(lv_date) TIME DATA(lv_time).
    SELECT SINGLE datefunctionstartdate
          FROM i_datefunctionvalue
          WHERE datefunction             = 'YESTERDAY'
            AND datefunctionvaliditydate = @lv_date
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
         service_id           = 'ZMCDIF_OBS_02_REST'
         comm_system_id       = lo_ca->get_comm_system_id( ) ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

        DATA(lo_request) = lo_http_client->get_http_request( ).

        "Property 값을 Header로 할당
        lo_request->set_header_fields(
          EXPORTING
            i_fields =  lt_header
        ).

        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        "Item Batch Call
        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

        DATA: BEGIN OF ls_response,
                resultdata        TYPE TABLE OF zmcdap_i_invoice_item,
                resultcode        TYPE string,
                resultfailmessage TYPE string,
              END OF ls_response.

        DATA: lt_item          TYPE TABLE OF zmcdap_c_invoice_item,
*              lt_header_update TYPE TABLE FOR UPDATE zmcdap_c_invoice,
              lt_create        TYPE TABLE FOR CREATE zmcdap_c_invoice\_items,
              ls_create        LIKE LINE OF lt_create,
              lt_update        TYPE TABLE FOR UPDATE zmcdap_c_invoice\\zmcdap_c_invoice_item,
              ls_update        LIKE LINE OF lt_update,
              ls_target        LIKE LINE OF ls_create-%target.

        DATA: BEGIN OF ls_head_update.
        DATA: id        TYPE sysuuid_x16,
              itemstate TYPE zmcdde_item_state_type.
        DATA: END OF ls_head_update.

        DATA: lt_head_update LIKE TABLE OF ls_head_update.


        "기준 어제 날짜 데이터 중 item state가 1이 아닌 경우
        SELECT id, senddt, bizplace, issueno, itemstate
          FROM zmcdap_i_invoice
         WHERE senddt = @lv_yday
           AND itemstate = 1
          INTO TABLE @DATA(lt_head).

        IF lt_head IS NOT INITIAL.
          ls_log-msg  = |SendDate: { lv_yday }, Line: { lines( lt_head ) }|.
          ls_log-msgt = 'I'.
          APPEND ls_log TO lt_log.
          CLEAR: ls_log.
        ELSE.
          ls_log-msg  = 'No Data Select'.
          ls_log-msgt = 'I'.
          APPEND ls_log TO lt_log.
          CLEAR: ls_log.
        ENDIF.

        """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        "Item Loop
        """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        LOOP AT lt_head INTO DATA(ls_head).
          APPEND INITIAL LINE TO lt_head_update ASSIGNING FIELD-SYMBOL(<fs_head_update>).
          <fs_head_update>-id        = ls_head-id.
          <fs_head_update>-itemstate = 3.

          "Property에서 설정하지 않은 값을 Header로 할당
          lo_request->set_header_fields(
           EXPORTING
             i_fields =  VALUE #(
                                  ( name ='issueno'    value = ls_head-issueno )
                                  ( name ='startdt'    value = ls_head-senddt  )
                                  ( name ='enddt'      value = ls_head-senddt  ) )
             ).

          """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          "Request
          """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).


          """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          "Response
          """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          DATA(lv_json_results) = lo_response->get_text(  ).

          /ui2/cl_json=>deserialize(
            EXPORTING
              json             = lv_json_results
            CHANGING
              data             = ls_response
          ).

          "Response 할당
          lt_item = CORRESPONDING #( ls_response-resultdata EXCEPT createdby createdat lastchangedby lastchangedat locallastchangedby locallastchangedat ).

          IF ls_response-resultcode = '0000'.
            ls_log-msg  = |IssueNo: { ls_head-issueno }, ResultCode : { ls_response-resultcode }, ResultMessage : { ls_response-resultfailmessage }|.
            ls_log-msgt = 'S'.
          ELSE.
            ls_log-msg  = |IssueNo: { ls_head-issueno }, ResultCode : { ls_response-resultcode }, ResultMessage : { ls_response-resultfailmessage }|.
            ls_log-msgt = 'W'.
          ENDIF.
          APPEND ls_log TO lt_log.
          CLEAR: ls_log.

          SELECT
            gv~id, gv~headerid,
            lc~bizplace, lc~issueno, lc~clientkey, lc~entkey,
            lc~itemno, lc~supbizno, lc~byrbizno, lc~itemdt, lc~itemnm, lc~itemstd,
            lc~itemqty, lc~itemunt, lc~itemsupamt, lc~itemtaxamt, lc~itembigo, lc~currency,
            lc~createdby, lc~createdat, lc~locallastchangedby, lc~locallastchangedat, lc~lastchangedat, lc~lastchangedby
          FROM @lt_item AS lc
          LEFT OUTER JOIN zmcdap_i_invoice_item AS gv
          ON lc~issueno = gv~issueno
          AND lc~itemno = gv~itemno
          INTO TABLE @lt_item.

          LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
            <fs_item>-itemunt    = <fs_item>-itemunt    / 100.
            <fs_item>-itemsupamt = <fs_item>-itemsupamt / 100.
            <fs_item>-itemtaxamt = <fs_item>-itemtaxamt / 100.
            <fs_item>-currency   = 'KRW'.

            "기존 item이 있는 경우
            IF <fs_item>-id IS NOT INITIAL.
              <fs_item>-headerid = ''.
              ls_update = CORRESPONDING #( <fs_item> ).
              APPEND ls_update TO lt_update.
            ELSE.
              "기존 item이 없는 경우
              ls_target = CORRESPONDING #( <fs_item> ).
              ls_target-%cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
              ls_target-bizplace = ls_head-bizplace.
              APPEND ls_target TO ls_create-%target.
            ENDIF.
            CLEAR: ls_update, ls_target.
          ENDLOOP.

          IF ls_create-%target[] IS NOT INITIAL.
            ls_create-id = ls_head-id.
            APPEND ls_create TO lt_create.
          ENDIF.

          clear:ls_create, lt_item.

        ENDLOOP.

        MODIFY ENTITIES OF zmcdap_c_invoice
        ENTITY zmcdap_c_invoice
        UPDATE
        FIELDS ( itemstate ) WITH CORRESPONDING #( lt_head_update )
        CREATE BY \_items
        SET FIELDS WITH lt_create
        ENTITY zmcdap_c_invoice_item
        UPDATE
        SET FIELDS WITH lt_update
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).

        IF lt_failed IS NOT INITIAL.
          LOOP AT lt_reported-zmcdap_c_invoice ASSIGNING FIELD-SYMBOL(<ls_reported_head>).
            DATA(lv_result) = <ls_reported_head>-%msg->if_message~get_text( ).
            APPEND INITIAL LINE TO lt_log ASSIGNING FIELD-SYMBOL(<fs_fail>).
            <fs_fail>-msg  = |Head DB Failed: { lv_result }|.
            <fs_fail>-msgt = 'E'.
          ENDLOOP.
          LOOP AT lt_reported-zmcdap_c_invoice_item ASSIGNING FIELD-SYMBOL(<ls_reported_item>).
            lv_result = <ls_reported_head>-%msg->if_message~get_text( ).
            APPEND INITIAL LINE TO lt_log ASSIGNING <fs_fail>.
            <fs_fail>-msg  = |Item DB Failed: { lv_result }|.
            <fs_fail>-msgt = 'E'.
          ENDLOOP.
        ELSE.
          COMMIT ENTITIES.
          DATA(lv_upcnt) = lines( lt_update ).
          DATA(lv_crcnt) = lines( lt_create ).
          ls_log-msg  = |Total: { lv_upcnt + lv_crcnt },Update: { lv_upcnt }, Create: { lv_crcnt }|.
          ls_log-msgt = 'S'.
          APPEND ls_log TO lt_log.
          CLEAR: ls_log.
        ENDIF.



        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        "Application Log TO Application Jobs
        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        DATA(lo_ajlog) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create(
                                                          object      = 'ZMCDAPJL0001'
                                                          subobject   = 'ZMCDAPJL0001_02'
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
