CLASS lhc_zmcdar_r_rate_bo DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmcdar_r_rate_bo RESULT result.

    METHODS mass_post FOR MODIFY
      IMPORTING keys FOR ACTION zmcdar_r_rate_bo~mass_post.
    METHODS mass_post2 FOR MODIFY
      IMPORTING keys FOR ACTION zmcdar_r_rate_bo~mass_post2.

ENDCLASS.

CLASS lhc_zmcdar_r_rate_bo IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD mass_post.
    DATA lt_masspost TYPE TABLE OF zmcdar_u_mass_post.
    LOOP AT keys[] INTO DATA(ls_key).
      DATA(lv_json) = ls_key-%param-importparameter.
*      CLEAR : lt_masspost.

      /ui2/cl_json=>deserialize(
        EXPORTING
          json             = lv_json
        CHANGING
          data             = lt_masspost
      ).


      DATA : lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
             lv_cid     TYPE abp_behv_cid.

      LOOP AT lt_masspost INTO DATA(ls_masspost).

        SELECT SINGLE costcenter, businesspartner FROM zmcdar_i_def_rate
            WHERE profitcenter = @ls_masspost-profitcenter
              AND validfrdate  = @ls_masspost-validfrdate
              AND costtype     = @ls_masspost-costtype
             INTO @DATA(ls_defrate).

        SELECT postingkey, account FROM zmcdar_i_doc_acct
                WHERE costtype = @ls_masspost-costtype
                  AND roletype = @ls_masspost-roletype
                  AND doctype  = 'SA'
                 INTO TABLE @DATA(lt_accountsa).
        IF sy-subrc = 0.
          "deep구조의 journal entry data값
          APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<fs_je_deepsa>).
          "cid없으면 에러로 종료
          CLEAR lv_cid.
          lv_cid  = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
          <fs_je_deepsa>-%cid   = lv_cid.
          <fs_je_deepsa>-%param = VALUE #( companycode         = '1000'
                                           documentreferenceid = 'BKPFF'
                                           createdbyuser        = sy-uname
                                           businesstransactiontype = 'RFBU'
                                           accountingdocumenttype  = 'SA'
                                           documentdate            = ls_masspost-postingdate " 문서 생성일인지 아니면 Posting Date 그대로 넣어주면 될지????
                                           postingdate             = ls_masspost-postingdate
                                           accountingdocumentheadertext = 'RAP Post Test' ).

          LOOP AT lt_accountsa INTO DATA(ls_accountsa).
            APPEND INITIAL LINE TO <fs_je_deepsa>-%param-_glitems ASSIGNING FIELD-SYMBOL(<fs_glitemsa>).
            <fs_glitemsa>-glaccount = ls_accountsa-account.
            <fs_glitemsa>-profitcenter = ls_masspost-profitcenter.
            <fs_glitemsa>-costcenter  = ls_defrate-costcenter.
            <fs_glitemsa>-documentitemtext = 'Post Test'.
            <fs_glitemsa>-_currencyamount = VALUE #( ( journalentryitemamount = ls_masspost-calcamount
                                                       currency = ls_masspost-currency ) ).
          ENDLOOP.
        ENDIF.

        SELECT postingkey, account FROM zmcdar_i_doc_acct
         WHERE costtype = @ls_masspost-costtype
           AND roletype = @ls_masspost-roletype
           AND doctype  = 'DR'
          INTO TABLE @DATA(lt_accountdr).

        IF sy-subrc = 0.
          "deep구조의 journal entry data값
          APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
          "cid없으면 에러로 종료
          CLEAR lv_cid.
          lv_cid  = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
          <je_deep>-%cid   = lv_cid.
          <je_deep>-%param = VALUE #( companycode         = '1000'
                                      documentreferenceid = 'BKPFF'
                                      createdbyuser        = sy-uname
                                      businesstransactiontype = 'RFBU'
                                      accountingdocumenttype  = 'DR'
                                      documentdate            = ls_masspost-postingdate
                                      postingdate             = ls_masspost-postingdate
                                      accountingdocumentheadertext = 'RAP Post Test' ).

          LOOP AT lt_accountsa INTO DATA(ls_accountdr).
            APPEND INITIAL LINE TO <je_deep>-%param-_aritems ASSIGNING FIELD-SYMBOL(<fs_aritemdr>).
            <fs_aritemdr>-glaccount = ls_accountsa-account.
            <fs_aritemdr>-glaccount = ls_accountsa-account.
            <fs_aritemdr>-customer  = ls_defrate-businesspartner.
            <fs_aritemdr>-documentitemtext = 'Post Test'.
*            if ls_accountdr-PostingKey
            <fs_aritemdr>-_currencyamount = VALUE #( ( journalentryitemamount = ls_masspost-calcamount
                                                       currency = ls_masspost-currency  ) ).
          ENDLOOP.
        ENDIF.

      ENDLOOP.
      "post : 회계 및 재고관리에서 발생한 거래나 이벤트 기록 업데이트
      MODIFY ENTITIES OF i_journalentrytp
      ENTITY journalentry
      EXECUTE post FROM lt_je_deep
      FAILED DATA(fail)
      REPORTED DATA(report)
      MAPPED DATA(map).
      IF fail IS NOT INITIAL.
*          out->write( fail-journalentry[ 1 ]-%fail-cause ).
      ELSE.
*          COMMIT ENTITIES BEGIN
*           RESPONSE OF i_journalentrytp
*           FAILED DATA(commit_fail)
*           REPORTED DATA(commit_report).
*          COMMIT ENTITIES END.
*
*          out->write( commit_report-journalentry[ 1 ]-%msg ).
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD MASS_POST2.
  ENDMETHOD.

ENDCLASS.
