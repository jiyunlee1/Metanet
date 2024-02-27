CLASS zcl_mcdhsar0001 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mcdhsar0001 IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    TYPES: BEGIN OF ts_data,
             fiscalperiod   TYPE zmcdar_u_mass_post-fiscalperiod,
             costtype       TYPE zmcdar_u_mass_post-costtype,
             profitcenter   TYPE zmcdar_u_mass_post-profitcenter,
             roletype       TYPE zmcdar_u_mass_post-roletype,
             validfrdate    TYPE zmcdar_u_mass_post-validfrdate,
             validtodate    TYPE zmcdar_u_mass_post-validtodate,
             profitcenternm TYPE zmcdar_u_mass_post-profitcenternm,
             costtypenm     TYPE zmcdar_u_mass_post-costtypenm,
             shutdowndate   TYPE zmcdar_u_mass_post-shutdowndate,
             postingdate    TYPE zmcdar_u_mass_post-postingdate,
             rate           TYPE zmcdar_u_mass_post-rate,
             salesamount    TYPE zmcdar_u_mass_post-salesamount,
             calcamount     TYPE zmcdar_u_mass_post-calcamount,
             currency       TYPE zmcdar_u_mass_post-currency,
             state          TYPE zmcdar_u_mass_post-state,
             journalentrysa TYPE zmcdar_u_mass_post-journalentrysa,
             journalentrydr TYPE zmcdar_u_mass_post-journalentrydr,
             cid_sa         TYPE sysuuid_x16,
             cid_dr         TYPE sysuuid_x16,
           END OF ts_data.

    DATA : BEGIN OF ls_return,
             error TYPE string,
             data  TYPE TABLE OF ts_data,
           END OF ls_return.

    DATA: BEGIN OF ls_massdata,
            method TYPE string,
            uname  TYPE sy-uname,
            data   TYPE TABLE OF ts_data,
          END OF ls_massdata.

    DATA(lv_json) = request->get_text( ).
*      CLEAR : lt_masspost.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json             = lv_json
      CHANGING
        data             = ls_massdata
    ).


**********************************************************************
* Post Data 가공                                                     *
**********************************************************************
    IF ls_massdata-method = 'POST'.
      DATA : lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
*    DATA : lt_je_deep TYPE TABLE FOR FUNCTION IMPORT i_journalentrytp~validate,
             lv_cid     TYPE abp_behv_cid.
      TYPES: BEGIN OF ts_account,
               postingkey TYPE zmcdar_i_doc_acct-postingkey,
               account    TYPE zmcdar_i_doc_acct-account,
             END OF ts_account.

      DATA : lt_accountsa TYPE TABLE OF ts_account,
             lt_accountdr TYPE TABLE OF ts_account.


      LOOP AT ls_massdata-data ASSIGNING FIELD-SYMBOL(<fs_masspost>).
        DATA: lv_profitcenter TYPE zmcdar_i_def_rate-profitcenter.

        DATA(lv_fiscal) = <fs_masspost>-fiscalperiod.

        lv_profitcenter = |{ <fs_masspost>-profitcenter ALPHA = IN }|.
        <fs_masspost>-salesamount = <fs_masspost>-salesamount * '0.01'.
        <fs_masspost>-calcamount = <fs_masspost>-calcamount * '0.01'.
        SELECT costcenter, businesspartner FROM zmcdar_i_def_rate
        WHERE profitcenter = @lv_profitcenter
          AND validfrdate  LE @<fs_masspost>-validtodate
          AND costtype     = @<fs_masspost>-costtype
        ORDER BY validfrdate DESCENDING
        INTO @DATA(ls_defrate)
        UP TO 1 ROWS.
        ENDSELECT.

        CLEAR lt_accountsa.
        SELECT postingkey, account FROM zmcdar_i_doc_acct
        WHERE costtype = @<fs_masspost>-costtype
          AND roletype = @<fs_masspost>-roletype
          AND doctype = 'SA'
        INTO TABLE @lt_accountsa.

        IF lines( lt_accountsa[] ) NE 0.
          "deep구조의 journal entry data값
          APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<fs_je_deepsa>).
          "cid없으면 에러로 종료
          CLEAR lv_cid.
          lv_cid  = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
          <fs_masspost>-cid_sa = lv_cid.
          <fs_je_deepsa>-%cid   = lv_cid.
          <fs_je_deepsa>-%param = VALUE #( documentdate                 = <fs_masspost>-postingdate " 문서 생성일인지 아니면 Posting Date 그대로 넣어주면 될지????
                                           postingdate                  = <fs_masspost>-postingdate
                                           accountingdocumentheadertext = |{ <fs_masspost>-fiscalperiod(4) }.{ <fs_masspost>-fiscalperiod+5(2) }.{ <fs_masspost>-costtypenm }|
                                           createdbyuser                = ls_massdata-uname
                                           accountingdocumenttype       = 'SA'
                                           companycode                  = '1000'
                                           documentreferenceid          = 'BKPFF'
                                           businesstransactiontype      = 'RFBU').

          DATA: ls_accountsa LIKE LINE OF lt_accountsa.
          DATA: lv_tenper    LIKE <fs_masspost>-calcamount.

          IF <fs_masspost>-roletype <> 'MC'.
            CLEAR lv_tenper.
            LOOP AT lt_accountsa INTO ls_accountsa.
              APPEND INITIAL LINE TO <fs_je_deepsa>-%param-_glitems ASSIGNING FIELD-SYMBOL(<fs_glitemsa>).
              <fs_glitemsa>-glaccount = ls_accountsa-account.
              <fs_glitemsa>-documentitemtext = <fs_je_deepsa>-%param-accountingdocumentheadertext.
              <fs_glitemsa>-assignmentreference = |{ <fs_masspost>-fiscalperiod+2(2) }.{ <fs_masspost>-fiscalperiod+5(2) }_{ <fs_masspost>-costtype }_{ <fs_masspost>-roletype }|.
              <fs_glitemsa>-profitcenter = <fs_masspost>-profitcenter.
              <fs_glitemsa>-costcenter  = ls_defrate-costcenter.
              lv_tenper = floor( <fs_masspost>-calcamount * '0.1' * 10 ) / 10.
              CASE ls_accountsa-postingkey.
                WHEN 'CA'.
                  <fs_glitemsa>-_currencyamount = VALUE #( ( journalentryitemamount = <fs_masspost>-calcamount
                                                             currency = <fs_masspost>-currency ) ).
                WHEN 'WT'.
                  <fs_glitemsa>-_currencyamount = VALUE #( ( journalentryitemamount = lv_tenper * -1
                                                             currency = <fs_masspost>-currency ) ).

                WHEN 'IC'.
*                    <fs_glitemsa>-_currencyamount = VALUE #( ( journalentryitemamount = <fs_masspost>-calcamount * '0.9' * -1
*                                                               currency = <fs_masspost>-currency ) ).

                  <fs_glitemsa>-_currencyamount = VALUE #( ( journalentryitemamount = ( <fs_masspost>-calcamount - lv_tenper ) * -1
                                                             currency = <fs_masspost>-currency ) ).
              ENDCASE.
            ENDLOOP.
          ELSE.
            LOOP AT lt_accountsa INTO ls_accountsa.
              APPEND INITIAL LINE TO <fs_je_deepsa>-%param-_glitems ASSIGNING FIELD-SYMBOL(<fs_glitemsa_mc>).
              <fs_glitemsa_mc>-glaccount = ls_accountsa-account.
              <fs_glitemsa_mc>-documentitemtext = <fs_je_deepsa>-%param-accountingdocumentheadertext.
              <fs_glitemsa_mc>-assignmentreference = |{ <fs_masspost>-fiscalperiod+2(2) }.{ <fs_masspost>-fiscalperiod+5(2) }_{ <fs_masspost>-costtype }_{ <fs_masspost>-roletype }|.
              <fs_glitemsa_mc>-profitcenter = <fs_masspost>-profitcenter.
              <fs_glitemsa_mc>-costcenter  = ls_defrate-costcenter.
              CASE ls_accountsa-postingkey.
                WHEN 'CA'.
                  <fs_glitemsa_mc>-_currencyamount = VALUE #( ( journalentryitemamount = <fs_masspost>-calcamount
                                                             currency = <fs_masspost>-currency ) ).
                WHEN 'IC'.

                  <fs_glitemsa_mc>-_currencyamount = VALUE #( ( journalentryitemamount = <fs_masspost>-calcamount * -1
                                                             currency = <fs_masspost>-currency ) ).
              ENDCASE.
            ENDLOOP.
          ENDIF.
        ENDIF.

        CLEAR lt_accountdr.
        SELECT postingkey, account FROM zmcdar_i_doc_acct
        WHERE costtype = @<fs_masspost>-costtype
          AND roletype = @<fs_masspost>-roletype
          AND doctype  = 'DR'
        INTO TABLE @lt_accountdr.

        IF lines( lt_accountdr[] ) NE 0.
          "deep구조의 journal entry data값
          APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<fs_je_deepdr>).
          "cid없으면 에러로 종료
          CLEAR lv_cid.
          DATA: BEGIN OF ls_date,
                  lv_frst TYPE sy-datum,
                  lv_last TYPE sy-datum,
                END OF ls_date.
          zcl_mcdcm_calc_date=>period_of_month(
            EXPORTING
              iv_yyyymmm = <fs_masspost>-fiscalperiod
            RECEIVING
              is_period  = ls_date
          ).
          lv_cid  = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
          <fs_masspost>-cid_dr = lv_cid.
          <fs_je_deepdr>-%cid   = lv_cid.
          <fs_je_deepdr>-%param = VALUE #( documentdate             = <fs_masspost>-postingdate " 문서 생성일인지 아니면 Posting Date 그대로 넣어주면 될지????
                                      postingdate                   = <fs_masspost>-postingdate
                                      accountingdocumentheadertext  = |{ <fs_masspost>-fiscalperiod(4) }.{ <fs_masspost>-fiscalperiod+5(2) }.{ <fs_masspost>-costtypenm }|
                                      createdbyuser                 = ls_massdata-uname
                                      accountingdocumenttype        = 'DR'
                                      companycode                   = '1000'
                                      documentreferenceid           = 'BKPFF'
                                      businesstransactiontype       = 'RFBU'
                                      taxdeterminationdate          = ls_date-lv_last ).
          CLEAR lv_tenper.
          lv_tenper = <fs_masspost>-calcamount * '0.1'.
          LOOP AT lt_accountdr INTO DATA(ls_accountdr).
            APPEND INITIAL LINE TO <fs_je_deepdr>-%param-_aritems ASSIGNING FIELD-SYMBOL(<fs_aritemdr>).
            <fs_aritemdr>-customer = ls_defrate-businesspartner.
            <fs_aritemdr>-_currencyamount = VALUE #( ( journalentryitemamount = <fs_masspost>-calcamount * '1.1'
                                                     currency = <fs_masspost>-currency  ) ).
            APPEND INITIAL LINE TO <fs_je_deepdr>-%param-_glitems ASSIGNING FIELD-SYMBOL(<fs_glitemdr>).
            <fs_glitemdr>-glaccount = ls_accountdr-account.
            <fs_glitemdr>-documentitemtext = <fs_je_deepdr>-%param-accountingdocumentheadertext.
            <fs_glitemdr>-assignmentreference = |{ <fs_masspost>-fiscalperiod+2(2) }.{ <fs_masspost>-fiscalperiod+5(2) }_{ <fs_masspost>-costtype }_{ <fs_masspost>-roletype }|.
            <fs_glitemdr>-profitcenter = <fs_masspost>-profitcenter.
            <fs_glitemdr>-costcenter  = ls_defrate-costcenter.
            <fs_glitemdr>-taxcode = 'AA'.
            <fs_glitemdr>-_currencyamount = VALUE #( ( journalentryitemamount = <fs_masspost>-calcamount * -1
                                                       currency = <fs_masspost>-currency  ) ).
            APPEND INITIAL LINE TO <fs_je_deepdr>-%param-_taxitems ASSIGNING FIELD-SYMBOL(<fs_taxitemdr>).
            <fs_taxitemdr>-taxcode = 'AA'.
            <fs_taxitemdr>-taxitemclassification = 'MWS'.
            <fs_taxitemdr>-conditiontype = 'MWAS'.
            <fs_taxitemdr>-_currencyamount = VALUE #( ( journalentryitemamount = <fs_masspost>-calcamount * '0.1' * -1
                                                       taxamount = <fs_masspost>-calcamount * '0.1' * -1
                                                       taxbaseamount = <fs_masspost>-calcamount * -1
                                                       currency = <fs_masspost>-currency  ) ).
          ENDLOOP.
        ENDIF.

      ENDLOOP.

**********************************************************************
*  POST                                                              *
**********************************************************************
      MODIFY ENTITIES OF i_journalentrytp
          ENTITY journalentry
          EXECUTE post FROM lt_je_deep
          FAILED DATA(fail)
          REPORTED DATA(report)
          MAPPED DATA(map).


**********************************************************************
*  Error Response / COMMIT                                           *
**********************************************************************
      IF fail IS NOT INITIAL.
        DATA lt_result_p TYPE TABLE OF string.
        LOOP AT report-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep_p>).
          DATA(lv_result_p) = <ls_reported_deep_p>-%msg->if_message~get_text( ).
          APPEND lv_result_p TO lt_result_p.
        ENDLOOP.

        ls_return-data = ls_massdata-data.
        /ui2/cl_json=>serialize(
          EXPORTING
            data             = lt_result_p
          RECEIVING
            r_json           = lv_json
        ).

        response->set_text(
          EXPORTING
            i_text   = lv_json
        ).


      ELSE.
        COMMIT ENTITIES BEGIN
         RESPONSE OF i_journalentrytp
         FAILED DATA(lt_commit_failed)
         REPORTED DATA(lt_commit_reported).
        COMMIT ENTITIES END.

        DATA lt_process_sa TYPE TABLE OF ts_data.

**********************************************************************
*  Commit 된 SA / DR 전표 번호 / Posting Date Modify                 *
**********************************************************************
        DATA ls_result TYPE zmcdtar0050.
        LOOP AT ls_massdata-data ASSIGNING FIELD-SYMBOL(<fs_result>).
          IF <fs_result>-cid_sa IS NOT INITIAL OR <fs_result>-cid_dr IS NOT INITIAL.
            <fs_result>-state = 'C'.
            IF <fs_result>-cid_sa IS NOT INITIAL.
              READ TABLE map-journalentry INTO DATA(ls_map_sa) WITH KEY %cid = <fs_result>-cid_sa.

              SELECT SINGLE accountingdocument FROM @lt_commit_reported-journalentry AS commit
              WHERE commit~%pid = @ls_map_sa-%pid
               INTO @<fs_result>-journalentrysa.
            ENDIF.

            IF <fs_result>-cid_dr IS NOT INITIAL.
              READ TABLE map-journalentry INTO DATA(ls_map_dr) WITH KEY %cid = <fs_result>-cid_dr.

              SELECT SINGLE accountingdocument FROM @lt_commit_reported-journalentry AS commit
              WHERE commit~%pid = @ls_map_dr-%pid
               INTO @<fs_result>-journalentrydr.
            ENDIF.
            CLEAR ls_result.
            ls_result = CORRESPONDING #( <fs_result> ).
            MODIFY zmcdtar0050 FROM @ls_result.
          ELSE.
            APPEND |Check : \| { <fs_result>-fiscalperiod } \| { <fs_result>-validfrdate }~{ <fs_result>-validtodate } \| { <fs_result>-costtype } \| { <fs_result>-profitcenter } \| { <fs_result>-roletype } \| was not POSTED| TO lt_result_p.
          ENDIF.
        ENDLOOP.
      ENDIF.

      IF lt_result_p IS NOT INITIAL.
        /ui2/cl_json=>serialize(
          EXPORTING
            data             = lt_result_p
          RECEIVING
            r_json           = lv_json
        ).

        response->set_text(
          EXPORTING
            i_text   = lv_json
        ).
      ENDIF..
**********************************************************************
* Reverse 데이터 가공
**********************************************************************
    ELSE.
      DATA : lt_jr TYPE TABLE FOR ACTION IMPORT i_journalentrytp~reverse.
      LOOP AT ls_massdata-data ASSIGNING FIELD-SYMBOL(<fs_massreverse>).
        IF <fs_massreverse>-journalentrydr IS NOT INITIAL.
          " 이미 역분개 된 전표 번호인지 확인
          SELECT SINGLE @abap_true FROM zmcdar_i_je_item
          WHERE accountingdocument = @<fs_massreverse>-journalentrydr
            AND isreversed = 'X'
           INTO @DATA(lv_drreversed).
          IF lv_drreversed <> abap_true AND sy-subrc = 0.
            APPEND INITIAL LINE TO lt_jr[] ASSIGNING FIELD-SYMBOL(<jr_dr>).
            <jr_dr>-companycode                  = '1000'.
            <jr_dr>-fiscalyear                   = <fs_massreverse>-fiscalperiod+0(4).
            <jr_dr>-accountingdocument           = <fs_massreverse>-journalentrydr.
            <jr_dr>-%param-postingdate           = <fs_massreverse>-postingdate.
            <jr_dr>-%param-reversalreason        = '01'.
            <jr_dr>-%param-createdbyuser         = ls_massdata-uname.
          ENDIF.
          CLEAR lv_drreversed.
        ENDIF.

        IF <fs_massreverse>-journalentrysa IS NOT INITIAL.
          " 이미 역분개 된 전표 번호인지 확인
          SELECT SINGLE @abap_true FROM zmcdar_i_je_item
          WHERE accountingdocument = @<fs_massreverse>-journalentrysa
            AND isreversed = 'X'
           INTO @DATA(lv_sareversed).
          IF lv_sareversed <> abap_true AND sy-subrc = 0.
            APPEND INITIAL LINE TO lt_jr[] ASSIGNING FIELD-SYMBOL(<jr_sa>).
            <jr_sa>-companycode                  = '1000'.
            <jr_sa>-fiscalyear                   = <fs_massreverse>-fiscalperiod+0(4).
            <jr_sa>-accountingdocument           = <fs_massreverse>-journalentrysa.
            <jr_sa>-%param-postingdate           = <fs_massreverse>-postingdate.
            <jr_sa>-%param-reversalreason        = '01'.
            <jr_sa>-%param-createdbyuser         = ls_massdata-uname.
          ENDIF.
          CLEAR lv_sareversed.
        ENDIF.
      ENDLOOP.

**********************************************************************
* Reverse
**********************************************************************
      MODIFY ENTITIES OF i_journalentrytp PRIVILEGED
      ENTITY journalentry
      EXECUTE reverse  FROM lt_jr
        FAILED DATA(ls_failed)
        REPORTED DATA(ls_reported)
        MAPPED DATA(ls_mapped).

*      LOOP AT ls_failed-journalentry ASSIGNING FIELD-SYMBOL(<ls_failed>).
*        lv_result = <ls_failed>-%fail-cause.
*      ENDLOOP.

**********************************************************************
* Error Handling / COMMIT
**********************************************************************
      DATA lt_result_r TYPE TABLE OF string.
      IF ls_failed-journalentry IS NOT INITIAL.
        LOOP AT ls_failed-journalentry ASSIGNING FIELD-SYMBOL(<ls_failed_deep_r>).
          DATA(lv_result_r) = <ls_failed_deep_r>-%fail-cause.
          APPEND lv_result_r TO lt_result_r.
        ENDLOOP.

        ls_return-data = ls_massdata-data.
        /ui2/cl_json=>serialize(
          EXPORTING
            data             = lt_result_r
          RECEIVING
            r_json           = lv_json
        ).
        response->set_text(
          EXPORTING
            i_text   = lv_json
        ).


      ELSE.
        COMMIT ENTITIES BEGIN
          RESPONSE OF i_journalentrytp
            FAILED DATA(lt_jr_commit_failed)
            REPORTED DATA(lt_jr_commit_reported).
        COMMIT ENTITIES END.

        IF lt_jr_commit_failed-journalentry IS NOT INITIAL.
          LOOP AT lt_jr_commit_failed-journalentry ASSIGNING FIELD-SYMBOL(<fs_failed_deep_r>).
            DATA(lv_result_commit_r) = <fs_failed_deep_r>-%fail-cause.
            APPEND lv_result_commit_r TO lt_result_r.
          ENDLOOP.

          ls_return-data = ls_massdata-data.
          /ui2/cl_json=>serialize(
            EXPORTING
              data             = lt_result_r
            RECEIVING
              r_json           = lv_json
          ).
          response->set_text(
            EXPORTING
              i_text   = lv_json
          ).
        ELSE.
**********************************************************************
* CBO 에서 역분개 전표 DELETE
**********************************************************************
          DATA lt_delete TYPE TABLE OF zmcdtar0050.
          DATA: lv_journalentrysa TYPE zmcdtar0050-journalentrysa,
                lv_journalentrydr TYPE zmcdtar0050-journalentrydr.
          lt_delete = CORRESPONDING #( ls_massdata-data ).
          LOOP AT lt_delete INTO DATA(ls_delete).
            CLEAR: lv_journalentrysa,
                   lv_journalentrydr.
            SELECT SINGLE accountingdocument FROM zmcdar_i_je_item
            WHERE accountingdocument = @ls_delete-journalentrysa
              AND isreversed = ''
             INTO @lv_journalentrysa.
            SELECT SINGLE accountingdocument FROM zmcdar_i_je_item
            WHERE accountingdocument = @ls_delete-journalentrydr
              AND isreversed = ''
             INTO @lv_journalentrydr.
            IF lv_journalentrysa IS NOT INITIAL.
              APPEND |AccountingDocument: { lv_journalentrysa } was not Reversed. Check Standard Application Link.| TO lt_result_r.
            ELSEIF lv_journalentrydr IS NOT INITIAL.
              APPEND |AccountingDocument: { lv_journalentrydr } was not Reversed. Check Standard Application Link.| TO lt_result_r.
            ELSE.
              DELETE zmcdtar0050 FROM @ls_delete.
            ENDIF.
          ENDLOOP.

          IF lt_result_r IS NOT INITIAL.
            ls_return-data = ls_massdata-data.
            /ui2/cl_json=>serialize(
              EXPORTING
                data             = lt_result_r
              RECEIVING
                r_json           = lv_json
            ).
            response->set_text(
              EXPORTING
                i_text   = lv_json
            ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
