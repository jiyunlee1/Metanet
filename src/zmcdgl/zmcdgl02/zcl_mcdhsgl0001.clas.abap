CLASS zcl_mcdhsgl0001 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDHSGL0001 IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.
    TYPES: BEGIN OF ts_docseqno,
             docseqno TYPE zmcdgl_i_auto_post-docseqno,
           END OF ts_docseqno.
    DATA lt_docseqno TYPE TABLE OF ts_docseqno.
    DATA lr_docseqno TYPE RANGE OF zmcdgl_i_auto_post-docseqno.
    DATA: BEGIN OF ls_request,
            mode         TYPE string,
            docseqno_set TYPE TABLE OF ts_docseqno,
          END OF ls_request.

*    ENDLOOP.
    DATA(lv_json) = request->get_text( ).
    DATA: lv_uname_str TYPE string.

    request->get_header_field(
      EXPORTING
        i_name               = 'uname'
      RECEIVING
        r_value              = lv_uname_str
    ).


    /ui2/cl_json=>deserialize(
      EXPORTING
        json             = lv_json
      CHANGING
        data             = ls_request
    ).

    DATA lv_uname TYPE sy-uname.
    lv_uname = lv_uname_str.

    lt_docseqno = ls_request-docseqno_set.
    LOOP AT lt_docseqno INTO DATA(lv_docseq).
      APPEND INITIAL LINE TO lr_docseqno ASSIGNING FIELD-SYMBOL(<fs_docseqno>).
      <fs_docseqno>-option = 'EQ'.
      <fs_docseqno>-sign = 'I'.
      <fs_docseqno>-low = lv_docseq.
    ENDLOOP.

    SELECT * FROM zmcdgl_i_auto_post AS ap
            WHERE ap~docseqno IN @lr_docseqno
             INTO TABLE @DATA(lt_base).

    TYPES: BEGIN OF ts_detail_base,
             postingdate TYPE zmcdgl_i_post_detail-postingdate,
             headerid    TYPE zmcdgl_i_post_detail-headerid,
             sepcid      TYPE sysuuid_x16,
           END OF ts_detail_base.

    DATA : lt_je_deep    TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
           lv_cid        TYPE sysuuid_x16,
           lt_detailbase TYPE TABLE OF ts_detail_base.

    DATA : lt_cidtab TYPE TABLE OF ts_detail_base.

*   아이템의 base 데이터 수를 300 개로 제한 하기 위한 변수
    DATA: lv_det_lines TYPE i,
          lv_idx       TYPE i.

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
             housebank                   TYPE zmcdgl_i_post_detail-housebank,
             housebankaccount            TYPE zmcdgl_i_post_detail-housebankaccount,
             journalentry                TYPE zmcdgl_i_post_detail-journalentry,
             cid                         TYPE sysuuid_x16,
           END OF ts_detail.

    DATA: lt_detail TYPE TABLE OF ts_detail,
          BEGIN OF ls_rslt,
            response TYPE string,
            detail   TYPE TABLE OF ts_detail,
          END OF ls_rslt.

    LOOP AT lt_base INTO DATA(ls_base).

*******************************************************
*     Receipt
*******************************************************
      IF ls_base-doctype = 'R'.

        SELECT postingdate, headerid
        FROM zmcdgl_i_post_detail AS detail
        WHERE detail~headerid = @ls_base-id
        GROUP BY detail~postingdate, headerid
        INTO CORRESPONDING FIELDS OF TABLE @lt_detailbase.

        LOOP AT lt_detailbase ASSIGNING FIELD-SYMBOL(<fs_detailbase>).
          CLEAR lt_detail.
          SELECT * FROM zmcdgl_i_post_detail AS detail
            WHERE detail~headerid = @ls_base-id
              AND detail~postingdate = @<fs_detailbase>-postingdate
             INTO CORRESPONDING FIELDS OF TABLE @lt_detail.

          lv_idx = 0.

          LOOP AT lt_detail ASSIGNING FIELD-SYMBOL(<fs_detail_r>).
*           300 개의 base data 마다 새로운 전표를 생성
            IF lv_idx MOD 300 = 0.
              APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<fs_je_deepsa_r>).
              CLEAR lv_cid.
              lv_cid  = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).

              <fs_detailbase>-sepcid = lv_cid.
              <fs_je_deepsa_r>-%cid   = lv_cid.
              <fs_je_deepsa_r>-%param = VALUE #( companycode         = '1000'
                                               accountingdocumenttype = 'ZP'
                                               businesstransactiontype = 'RFBU'
                                               documentreferenceid = ls_base-account
                                               accountingdocumentheadertext = 'Bank Statement Receipt'
                                               documentdate            = <fs_detailbase>-postingdate
                                               postingdate            = <fs_detailbase>-postingdate
*                                           documentreferenceid   = ls_base-account
                                               createdbyuser = lv_uname ).
            ENDIF.
            <fs_detail_r>-cid = lv_cid.
            APPEND INITIAL LINE TO <fs_je_deepsa_r>-%param-_glitems ASSIGNING FIELD-SYMBOL(<fs_glitemd_r>).
            <fs_glitemd_r>-glaccount = ls_base-reconaccount.
            <fs_glitemd_r>-profitcenter = '99999'.
            <fs_glitemd_r>-documentitemtext = <fs_detail_r>-description.
            <fs_glitemd_r>-assignmentreference = <fs_detail_r>-docdater.
            <fs_glitemd_r>-housebank = ls_base-bank.
            <fs_glitemd_r>-housebankaccount = ls_base-bankacctid.
            <fs_glitemd_r>-valuedate = <fs_detailbase>-postingdate.
            <fs_glitemd_r>-_currencyamount = VALUE #( ( journalentryitemamount = <fs_detail_r>-amountintransactioncurrency
                                                       currency = <fs_detail_r>-currencycode ) ).
            APPEND INITIAL LINE TO <fs_je_deepsa_r>-%param-_glitems ASSIGNING FIELD-SYMBOL(<fs_glitemc_r>).
            <fs_glitemc_r>-glaccount = '1111090'.
            <fs_glitemc_r>-profitcenter = '99999'.
            <fs_glitemc_r>-documentitemtext = <fs_detail_r>-description.
            <fs_glitemc_r>-assignmentreference = <fs_detail_r>-docdater.
            <fs_glitemc_r>-_currencyamount = VALUE #( ( journalentryitemamount = <fs_detail_r>-amountintransactioncurrency * -1
                                                       currency = <fs_detail_r>-currencycode ) ).
            lv_idx += 1.
          ENDLOOP.
          ls_rslt-detail = CORRESPONDING #( BASE ( ls_rslt-detail ) lt_detail ).
        ENDLOOP.

        APPEND LINES OF lt_detailbase TO lt_cidtab.
*******************************************************
*     Sweeping
*******************************************************
      ELSE.
        SELECT postingdate, headerid
        FROM zmcdgl_i_post_detail AS detail
         WHERE detail~headerid = @ls_base-id
         GROUP BY detail~postingdate, headerid
          INTO CORRESPONDING FIELDS OF TABLE @lt_detailbase.

        LOOP AT lt_detailbase ASSIGNING FIELD-SYMBOL(<fs_detailbase_s>).
          CLEAR lt_detail.
          SELECT * FROM zmcdgl_i_post_detail AS detail
            WHERE detail~headerid = @ls_base-id
              AND detail~postingdate = @<fs_detailbase_s>-postingdate
              AND detail~amountintransactioncurrency IS NOT INITIAL
             INTO CORRESPONDING FIELDS OF TABLE @lt_detail.

          lv_idx = 0.

          LOOP AT lt_detail ASSIGNING FIELD-SYMBOL(<fs_detail_s>).
            IF lv_idx MOD 300 = 0.
              APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<fs_je_deepsa_s>).
              CLEAR lv_cid.
              lv_cid  = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
              <fs_detailbase_s>-sepcid = lv_cid.
              <fs_je_deepsa_s>-%cid   = lv_cid.
              <fs_je_deepsa_s>-%param = VALUE #( companycode         = '1000'
                                               accountingdocumenttype = 'ZP'
                                               businesstransactiontype = 'RFBU'
                                               documentreferenceid = ls_base-account
                                               accountingdocumentheadertext = 'BoA Sweeping'
                                               documentdate            = <fs_detailbase_s>-postingdate
                                               postingdate            = <fs_detailbase_s>-postingdate
                                               createdbyuser = lv_uname ).
            ENDIF.
            <fs_detail_s>-cid = lv_cid.
            APPEND INITIAL LINE TO <fs_je_deepsa_s>-%param-_glitems ASSIGNING FIELD-SYMBOL(<fs_glitem_sd>).
            <fs_glitem_sd>-glaccount = ls_base-reconaccount.
            <fs_glitem_sd>-profitcenter = '99999'.
            IF <fs_detail_s>-housedebitnm IS NOT INITIAL.
              <fs_glitem_sd>-documentitemtext = |SW_{ <fs_detail_s>-housedebitnm }|.
*              <fs_glitem_sd>-housebank = <fs_detail_s>-housebank.
*              <fs_glitem_sd>-housebankaccount = <fs_detail_s>-housebankaccount.
            ELSE.
              <fs_glitem_sd>-documentitemtext = |SW_{ <fs_detail_s>-debitnm }|.
*            <fs_glitem_sd>-housebank = ls_base-bank.
*            <fs_glitem_sd>-housebankaccount = ls_base-bankacctid.
            ENDIF.
            <fs_glitem_sd>-housebank = ls_base-bank.
            <fs_glitem_sd>-housebankaccount = ls_base-bankacctid.
            <fs_glitem_sd>-assignmentreference = <fs_detail_s>-debitaccount.
            <fs_glitem_sd>-valuedate = <fs_detailbase_s>-postingdate.
            <fs_glitem_sd>-_currencyamount = VALUE #( ( journalentryitemamount = <fs_detail_s>-amountintransactioncurrency
                                                       currency = <fs_detail_s>-currencycode ) ).

            IF <fs_detail_s>-fee IS NOT INITIAL.
              APPEND INITIAL LINE TO <fs_je_deepsa_s>-%param-_glitems ASSIGNING FIELD-SYMBOL(<fs_glitem_sdf>).
              <fs_glitem_sdf>-glaccount = '5245901'.
              <fs_glitem_sdf>-profitcenter = '99999'.
              <fs_glitem_sdf>-documentitemtext = 'BoA Sweeping FEE'.
              <fs_glitem_sdf>-assignmentreference = <fs_detail_s>-debitaccount.
              <fs_glitem_sdf>-costcenter = 'HQ9009'.
              <fs_glitem_sdf>-_currencyamount = VALUE #( ( journalentryitemamount = <fs_detail_s>-fee
                                                           currency = <fs_detail_s>-currencycode ) ).
            ENDIF.
            APPEND INITIAL LINE TO <fs_je_deepsa_s>-%param-_glitems ASSIGNING FIELD-SYMBOL(<fs_glitemc_sc>).
            IF <fs_detail_s>-debitgl IS NOT INITIAL.
              <fs_glitemc_sc>-glaccount = <fs_detail_s>-debitgl.
            ELSE.
              <fs_glitemc_sc>-glaccount = <fs_detail_s>-housedebitgl.
            ENDIF.
            <fs_glitemc_sc>-profitcenter = <fs_detail_s>-debitprofit.

*           비어있는 경우 안뜬다
            IF <fs_detail_s>-housedebitnm IS NOT INITIAL.
              <fs_glitemc_sc>-documentitemtext = |SW_{ <fs_detail_s>-housedebitnm }|.
            ELSE.
              <fs_glitemc_sc>-documentitemtext = <fs_detail_s>-debitdescription.
            ENDIF.

            <fs_glitemc_sc>-assignmentreference = <fs_detail_s>-debitaccount.
            <fs_glitemc_sc>-valuedate = <fs_detailbase_s>-postingdate.

            <fs_glitem_sd>-housebank = ls_base-bank.
            <fs_glitem_sd>-housebankaccount = ls_base-bankacctid.
            IF <fs_detail_s>-housedebitnm IS NOT INITIAL.
              <fs_glitemc_sc>-housebank = <fs_detail_s>-housebank.
              <fs_glitemc_sc>-housebankaccount = <fs_detail_s>-housebankaccount.
            ENDIF.

            <fs_glitemc_sc>-_currencyamount = VALUE #( ( journalentryitemamount = <fs_detail_s>-total * -1
                                                         currency = <fs_detail_s>-currencycode ) ).
            lv_idx += 1.
          ENDLOOP.
          ls_rslt-detail = CORRESPONDING #( BASE ( ls_rslt-detail ) lt_detail ).
        ENDLOOP.

        APPEND LINES OF lt_detailbase TO lt_cidtab.
      ENDIF.
    ENDLOOP.

    DATA lt_errorid TYPE TABLE OF sysuuid_x16.
    TYPES: BEGIN OF ts_cid,
             sepcid TYPE sysuuid_x16,
           END OF ts_cid.
    DATA lt_cid TYPE TABLE OF ts_cid.
    DATA lv_response TYPE string.
******************************************
*   DATA 구성 완료
******************************************


******************************************
*   VALIDATION CHECK _ post 와 동일한 DATA 사용
******************************************
    IF ls_request-mode = 'validation'.
      DATA: BEGIN OF ls_return,
              result   TYPE string,
              errorid  TYPE TABLE OF sysuuid_x16,
              errormsg TYPE TABLE OF string,
            END OF ls_return.

      SELECT SINGLE @abap_true FROM @lt_base AS base
      WHERE state = '3'
         OR state = '0'
      INTO @DATA(lv_check).

      IF lv_check IS NOT INITIAL.
        ls_return-result = 'SKIP'.

        /ui2/cl_json=>serialize(
           EXPORTING
               data = ls_return
           RECEIVING
               r_json = lv_response ).
        response->set_text(
          EXPORTING
            i_text   = lv_response
        ).

      ELSE.

        DATA:lt_je_val TYPE TABLE FOR FUNCTION IMPORT i_journalentrytp~validate.
        lt_je_val = CORRESPONDING #( lt_je_deep ).
        READ ENTITIES OF i_journalentrytp
        ENTITY journalentry
        EXECUTE validate FROM lt_je_val
          RESULT DATA(lt_check_result)
          FAILED DATA(ls_failed_deep)
          REPORTED DATA(ls_reported_deep).

        DATA lt_result_v TYPE TABLE OF string.
        LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep_v>).
          DATA(lv_result_v) = <ls_reported_deep_v>-%msg->if_message~get_text( ).
          APPEND lv_result_v TO lt_result_v.
        ENDLOOP.



        IF ls_failed_deep IS NOT INITIAL.
          ls_return-result = 'ERROR'.
          lt_cid = CORRESPONDING #( ls_failed_deep-journalentry MAPPING sepcid = %cid ).
          SELECT d~headerid FROM @lt_cid AS f
           INNER JOIN @lt_cidtab AS d
              ON f~sepcid = d~sepcid
            INTO TABLE @ls_return-errorid.

          ls_return-errormsg = lt_result_v.

          /ui2/cl_json=>serialize(
             EXPORTING
                 data = ls_return
             RECEIVING
                 r_json = lv_response ).
          response->set_text(
            EXPORTING
              i_text   = lv_response
          ).
        ELSE.
          ls_return-result = 'SUCCESS'.
          /ui2/cl_json=>serialize(
             EXPORTING
                 data = ls_return
             RECEIVING
                 r_json = lv_response ).
          response->set_text(
            EXPORTING
              i_text   = lv_response
          ).
        ENDIF.
      ENDIF.
******************************************
*   POST 수행 _ validation 과 동일한 DATA 사용
******************************************
    ELSE.
      SELECT SINGLE @abap_true FROM @lt_base AS base
      WHERE state = '2'
         OR state = '0'
         OR state = '1'
      INTO @DATA(lv_check_post).

      IF lv_check_post IS NOT INITIAL.
        ls_rslt-response = 'SKIP'.
        /ui2/cl_json=>serialize(
           EXPORTING
               data = ls_rslt
           RECEIVING
               r_json = lv_response ).
        response->set_text(
          EXPORTING
            i_text   = lv_response
        ).
      ELSE.
        CHECK lv_check_post NE abap_true.
        MODIFY ENTITIES OF i_journalentrytp
            ENTITY journalentry
            EXECUTE post FROM lt_je_deep
            FAILED DATA(fail)
            REPORTED DATA(report)
            MAPPED DATA(map).
        IF fail IS NOT INITIAL.
*          out->write( fail-journalentry[ 1 ]-%fail-cause ).
          LOOP AT report-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
            DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
          ENDLOOP.
        ELSE.
          COMMIT ENTITIES BEGIN
          RESPONSE OF i_journalentrytp
            FAILED DATA(commit_fail)
            REPORTED DATA(commit_report).
          COMMIT ENTITIES END.
        ENDIF.

        IF commit_fail IS NOT INITIAL.
          ls_rslt-response = 'error'.

          /ui2/cl_json=>serialize(
             EXPORTING
                 data = ls_rslt
             RECEIVING
                 r_json = lv_response ).
          response->set_text(
            EXPORTING
              i_text   = lv_response
          ).
        ELSEIF fail IS NOT INITIAL.
          ls_rslt-response = 'error'.

          /ui2/cl_json=>serialize(
             EXPORTING
                 data = ls_rslt
             RECEIVING
                 r_json = lv_response ).
          response->set_text(
            EXPORTING
              i_text   = lv_response
          ).
        ELSE.
          ls_rslt-response = 'success'.
          LOOP AT ls_rslt-detail ASSIGNING FIELD-SYMBOL(<fs_detail>).
            READ TABLE map-journalentry INTO DATA(ls_map_sa) WITH KEY %cid = <fs_detail>-cid.

            SELECT SINGLE accountingdocument FROM @commit_report-journalentry AS commit
            WHERE commit~%pid = @ls_map_sa-%pid
             INTO @<fs_detail>-journalentry.
          ENDLOOP.

          /ui2/cl_json=>serialize(
             EXPORTING
                 data = ls_rslt
             RECEIVING
                 r_json = lv_response ).
          response->set_text(
            EXPORTING
              i_text   = lv_response
          ).
        ENDIF.

      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
