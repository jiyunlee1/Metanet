CLASS lhc_autopost DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR autopost RESULT result.

    METHODS validation_check FOR MODIFY
      IMPORTING keys FOR ACTION autopost~validation_check RESULT result.

    METHODS post_doc FOR MODIFY
      IMPORTING keys FOR ACTION autopost~post_doc RESULT result.
    METHODS determinmodify FOR DETERMINE ON MODIFY
      IMPORTING keys FOR autopost~determinmodify.

ENDCLASS.

CLASS lhc_autopost IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD validation_check.
    LOOP AT keys[] INTO DATA(ls_keys).
      DATA(lv_json) = ls_keys-%param-importparameter.
    ENDLOOP.

    DATA: lr_cscn TYPE if_com_scenario_factory=>ty_query-cscn_id_range.

    lr_cscn = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZMCDCSGL0001' ) ).
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
            service_id     = 'ZMCDGL_OBS_01_REST'
            comm_system_id = lo_ca->get_comm_system_id( ) ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

        DATA(lo_request) = lo_http_client->get_http_request( ).
        lo_request->set_text(
          EXPORTING
            i_text = lv_json
        ).

        DATA: lv_uname TYPE string.

        lv_uname = sy-uname.

        lo_request->set_header_field(
          EXPORTING
            i_name  = 'uname'
            i_value = lv_uname
        ).

        lo_request->set_uri_path(
          EXPORTING
            i_uri_path = 'sap/bc/http/sap/zmcdhsgl0001'
*              multivalue = 0
*            RECEIVING
*              r_value    =
        ).
*          CATCH cx_web_message_error.

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).
        DATA(lv_json_results) = lo_response->get_text( ).


        TYPES: BEGIN OF ts_docseqno,
                 docseqno TYPE zmcdgl_i_auto_post-docseqno,
               END OF ts_docseqno.
        DATA: BEGIN OF ls_json,
                mode         TYPE string,
                docseqno_set TYPE TABLE OF ts_docseqno,
              END OF ls_json,
              BEGIN OF ls_return,
                result   TYPE string,
                errorid  TYPE TABLE OF sysuuid_x16,
                errormsg TYPE TABLE OF string,
              END OF ls_return..

        /ui2/cl_json=>deserialize(
          EXPORTING
            json             = lv_json
          CHANGING
            data             = ls_json
        ).


        DATA: lr_docseqno TYPE RANGE OF zmcdgl_i_auto_post-docseqno,
              lr_errorid  TYPE RANGE OF sysuuid_x16.
        DATA(lt_docseqno) = ls_json-docseqno_set.

        LOOP AT lt_docseqno INTO DATA(lv_docseq).
          APPEND INITIAL LINE TO lr_docseqno ASSIGNING FIELD-SYMBOL(<fs_docseqno>).
          <fs_docseqno>-option = 'EQ'.
          <fs_docseqno>-sign = 'I'.
          <fs_docseqno>-low = lv_docseq.
        ENDLOOP.
        /ui2/cl_json=>deserialize(
          EXPORTING
            json             = lv_json_results
          CHANGING
            data             = ls_return
        ).

        CHECK ls_return-result NE 'SKIP'.

        DATA lt_read_cond TYPE TABLE FOR READ IMPORT zmcdgl_r_auto_post.

        LOOP AT ls_return-errorid INTO DATA(lv_errorid).
          APPEND INITIAL LINE TO lr_errorid ASSIGNING FIELD-SYMBOL(<fs_errorid>).
          <fs_errorid>-option = 'EQ'.
          <fs_errorid>-sign = 'I'.
          <fs_errorid>-low = lv_errorid.
*          APPEND INITIAL LINE TO lt_read_cond ASSIGNING FIELD-SYMBOL(<fs_read_cond>).
*          <fs_read_cond>-%key-id = lv_errorid.
        ENDLOOP.



        SELECT * FROM zmcdtgl0020
         WHERE doc_seq_no IN @lr_docseqno
          INTO @DATA(ls_autopost).
          IF lr_errorid IS NOT INITIAL AND ls_autopost-id IN lr_errorid.
            ls_autopost-state = '1'.
            MODIFY ENTITIES OF zmcdgl_r_auto_post IN LOCAL MODE
                    ENTITY autopost UPDATE FIELDS ( state )
                    WITH VALUE #( ( %key-id = ls_autopost-id
                                    state = ls_autopost-state ) ).

          ELSE.
            ls_autopost-state = '3'.
            MODIFY ENTITIES OF zmcdgl_r_auto_post IN LOCAL MODE
                    ENTITY autopost UPDATE FIELDS ( state )
                    WITH VALUE #( ( %key-id = ls_autopost-id
                                    state = ls_autopost-state ) ).
          ENDIF.
        ENDSELECT.

        IF ls_return-errormsg IS NOT INITIAL.
          LOOP AT ls_return-errormsg INTO DATA(lv_errmsg).
            APPEND INITIAL LINE TO result[] ASSIGNING FIELD-SYMBOL(<fs_result>).
            <fs_result>-%cid = ls_keys-%cid.
            <fs_result>-%param-erridx = sy-tabix.
            <fs_result>-%param-errmsg = lv_errmsg.
          ENDLOOP.
        ENDIF.


      CATCH cx_http_dest_provider_error INTO DATA(lo_dest_provider_error).
        " handle exception here

      CATCH cx_web_http_client_error INTO DATA(lo_http_client_error).
        " handle exception here
      CATCH /iwbep/cx_gateway INTO DATA(lo_gateway_error).
    ENDTRY.
  ENDMETHOD.



  METHOD post_doc.
    "데이터 불러오기
    LOOP AT keys[] INTO DATA(ls_keys).
      DATA(lv_json) = ls_keys-%param-importparameter.
    ENDLOOP.

    DATA: lr_cscn TYPE if_com_scenario_factory=>ty_query-cscn_id_range.

    lr_cscn = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZMCDCSGL0001' ) ).
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
            service_id     = 'ZMCDGL_OBS_01_REST'
            comm_system_id = lo_ca->get_comm_system_id( ) ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

        DATA(lo_request) = lo_http_client->get_http_request( ).

        DATA: lv_uname TYPE string.

        lv_uname = sy-uname.

        lo_request->set_header_field(
          EXPORTING
            i_name  = 'uname'
            i_value = lv_uname
        ).

        lo_request->set_text(
          EXPORTING
            i_text = lv_json
        ).

        lo_request->set_uri_path(
          EXPORTING
            i_uri_path = 'sap/bc/http/sap/zmcdhsgl0001'
*              multivalue = 0
*            RECEIVING
*              r_value    =
        ).
*          CATCH cx_web_message_error.

        TYPES: BEGIN OF ts_detail,
                 id                          TYPE zmcdgl_i_post_detail-id,
                 headerid                    TYPE zmcdgl_i_post_detail-headerid,
                 docdater                    TYPE zmcdgl_i_post_detail-docdater,
                 sendbank                    TYPE zmcdgl_i_post_detail-sendbank,
                 sender                      TYPE zmcdgl_i_post_detail-sender,
                 docdates                    TYPE zmcdgl_i_post_detail-docdates,
                 debitbank                   TYPE zmcdgl_i_post_detail-debitbank,
                 debitaccount                TYPE zmcdgl_i_post_detail-debitaccount,
                 fee                         TYPE zmcdgl_i_post_detail-fee,
                 postingdate                 TYPE zmcdgl_i_post_detail-postingdate,
                 description                 TYPE zmcdgl_i_post_detail-description,
                 amountintransactioncurrency TYPE zmcdgl_i_post_detail-amountintransactioncurrency,
                 total                       TYPE zmcdgl_i_post_detail-total,
                 currencycode                TYPE zmcdgl_i_post_detail-currencycode,
                 createdby                   TYPE zmcdgl_i_post_detail-createdby,
                 createdat                   TYPE zmcdgl_i_post_detail-createdat,
                 locallastchangedby          TYPE zmcdgl_i_post_detail-locallastchangedby,
                 locallastchangedat          TYPE zmcdgl_i_post_detail-locallastchangedat,
                 lastchangedat               TYPE zmcdgl_i_post_detail-lastchangedat,
                 lastchangedby               TYPE zmcdgl_i_post_detail-lastchangedby,
                 debitgl                     TYPE zmcdgl_i_post_detail-debitgl,
                 debitnm                     TYPE zmcdgl_i_post_detail-debitnm,
                 debitdescription            TYPE zmcdgl_i_post_detail-debitdescription,
                 debitprofit                 TYPE zmcdgl_i_post_detail-debitprofit,
                 housedebitgl                TYPE zmcdgl_i_post_detail-housedebitgl,
                 housedebitnm                TYPE zmcdgl_i_post_detail-housedebitnm,
                 journalentry                TYPE zmcdgl_i_post_detail-journalentry,
                 cid                         TYPE sysuuid_x16,
               END OF ts_detail.

        DATA: BEGIN OF ls_rslt,
                response TYPE string,
                detail   TYPE TABLE OF ts_detail,
              END OF ls_rslt.

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).
        DATA(lv_results) = lo_response->get_text( ).


        TYPES: BEGIN OF ts_docseqno,
                 docseqno TYPE zmcdgl_i_auto_post-docseqno,
               END OF ts_docseqno.
        DATA: BEGIN OF ls_json,
                mode         TYPE string,
                docseqno_set TYPE TABLE OF ts_docseqno,
              END OF ls_json,
              lt_errorid TYPE TABLE OF sysuuid_x16.

        /ui2/cl_json=>deserialize(
          EXPORTING
            json             = lv_json
          CHANGING
            data             = ls_json
        ).

        /ui2/cl_json=>deserialize(
          EXPORTING
            json             = lv_results
          CHANGING
            data             = ls_rslt
        ).


        CHECK ls_rslt-response NE 'SKIP'.

        DATA: lr_docseqno TYPE RANGE OF zmcdgl_i_auto_post-docseqno,
              lr_errorid  TYPE RANGE OF sysuuid_x16.
        DATA(lt_docseqno) = ls_json-docseqno_set.


        LOOP AT lt_docseqno INTO DATA(lv_docseq).
          APPEND INITIAL LINE TO lr_docseqno ASSIGNING FIELD-SYMBOL(<fs_docseqno>).
          <fs_docseqno>-option = 'EQ'.
          <fs_docseqno>-sign = 'I'.
          <fs_docseqno>-low = lv_docseq.
        ENDLOOP.

        IF ls_rslt-response = 'success'.
          DATA: lt_autopost   TYPE TABLE FOR UPDATE zmcdgl_r_auto_post,
                lt_postdetail TYPE TABLE FOR UPDATE zmcdgl_r_post_detail.

          SELECT * FROM zmcdgl_r_auto_post
          WHERE docseqno IN @lr_docseqno
          INTO @DATA(ls_autopost).
            ls_autopost-state = '0'.
            APPEND INITIAL LINE TO lt_autopost ASSIGNING FIELD-SYMBOL(<fs_autopost>).
            <fs_autopost>-%key-id = ls_autopost-id.
            <fs_autopost>-state = ls_autopost-state.
          ENDSELECT.
          LOOP AT ls_rslt-detail INTO DATA(ls_detail).
            APPEND INITIAL LINE TO lt_postdetail ASSIGNING FIELD-SYMBOL(<fs_postdetail>).
            <fs_postdetail>-%key-id = ls_detail-id.
            <fs_postdetail>-journalentry = ls_detail-journalentry.
          ENDLOOP.
          MODIFY ENTITIES OF zmcdgl_r_auto_post IN LOCAL MODE
                  ENTITY autopost UPDATE FIELDS ( state )
                  WITH lt_autopost
                  ENTITY to_postdetail UPDATE FIELDS ( journalentry )
                  WITH lt_postdetail.
        ENDIF.
      CATCH cx_http_dest_provider_error INTO DATA(lo_dest_provider_error).
        " handle exception here

      CATCH cx_web_http_client_error INTO DATA(lo_http_client_error).
        " handle exception here
      CATCH /iwbep/cx_gateway INTO DATA(lo_gateway_error).
    ENDTRY.
  ENDMETHOD.

  METHOD determinmodify.

    READ ENTITIES OF zmcdgl_r_auto_post IN LOCAL MODE
         ENTITY autopost
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_draft).
    DATA: lv_today    TYPE sy-datum,
          lv_docseqno TYPE zmcdgl_i_auto_post-docseqno.
    lv_today = sy-datum.
    LOOP AT lt_draft INTO DATA(ls_draft).
      CHECK ls_draft-docseqno IS INITIAL.
      SELECT  docseqno, doctype FROM zmcdgl_i_auto_post AS ap
              WHERE ap~doctype = @ls_draft-doctype
                AND ap~createddate = @lv_today
              ORDER BY docseqno DESCENDING
               INTO TABLE @DATA(lt_docseqno)
                 UP TO 1 ROWS.
      IF sy-subrc = 0.
        DATA lv_seq TYPE n LENGTH 2.
        LOOP AT lt_docseqno INTO DATA(wa_docseqno).
          SPLIT wa_docseqno-docseqno AT '_' INTO DATA(lv_doctype) DATA(lv_date) lv_seq.
          lv_seq += 1.
          CONCATENATE lv_doctype '_' lv_date '_' lv_seq INTO lv_docseqno.
          MODIFY ENTITIES OF zmcdgl_r_auto_post IN LOCAL MODE
              ENTITY autopost UPDATE FIELDS ( docseqno )
              WITH VALUE #( ( %tky = ls_draft-%tky
                              docseqno = lv_docseqno ) ).
        ENDLOOP.
      ELSE.
        CONCATENATE ls_draft-doctype '_' lv_today '_01' INTO lv_docseqno.
        MODIFY ENTITIES OF zmcdgl_r_auto_post IN LOCAL MODE
            ENTITY autopost UPDATE FIELDS ( docseqno )
            WITH VALUE #( ( %tky = ls_draft-%tky
                            docseqno = lv_docseqno ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
