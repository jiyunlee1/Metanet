CLASS zcl_mcdhsif0001 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MCDHSIF0001 IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

**********************************************************************
*Journal Entry Type 선언
**********************************************************************
    TYPES : BEGIN OF ty_s_consignee.
    TYPES : external_ref_num TYPE string.
    TYPES : END OF ty_s_consignee.

    TYPES : BEGIN OF ty_s_payment_method.
    TYPES : name TYPE string.
    TYPES : END OF ty_s_payment_method.

    TYPES : BEGIN OF ty_s_custom_fields.
    TYPES : cf_integration_status  TYPE string,
            cf_sap_je_ref_number   TYPE string,
            requires_consignee     TYPE string,
            authorization_code_sap TYPE string,
            sap_payment_method     TYPE ty_s_payment_method,
            consignee              TYPE ty_s_consignee.
    TYPES : END OF ty_s_custom_fields.

    TYPES : BEGIN OF ty_s_tax_lines.
    TYPES : id     TYPE string,
            amount TYPE string,
            code   TYPE string.
    TYPES : END OF ty_s_tax_lines.

    TYPES : BEGIN OF ty_s_tax_code.
    TYPES : code   TYPE string.
    TYPES : END OF ty_s_tax_code.

    TYPES : BEGIN OF ty_s_account.
    TYPES : id        TYPE string,
            code      TYPE string,
            segment_1 TYPE string,
            segment_2 TYPE string.
    TYPES : END OF ty_s_account.

    TYPES : BEGIN OF ty_s_account_allocations.
    TYPES : id      TYPE string,
            amount  TYPE string,
            account TYPE ty_s_account.
    TYPES : END OF ty_s_account_allocations.
    TYPES : ty_t_account_allocations TYPE STANDARD TABLE OF ty_s_account_allocations WITH EMPTY KEY.

    TYPES : BEGIN OF ty_s_commodity.
    TYPES : name   TYPE string.
    TYPES : END OF ty_s_commodity.

    TYPES : BEGIN OF ty_s_invoice_lines.
    TYPES : id                  TYPE string,
            description         TYPE string,
            po_number           TYPE string,
            total               TYPE string,
            account             TYPE ty_s_account,
            account_allocations TYPE ty_t_account_allocations,
            tax_code            TYPE ty_s_tax_code,
            tax_lines           TYPE ty_s_tax_lines,
            commodity           TYPE ty_s_commodity.
    TYPES : END OF ty_s_invoice_lines.
    TYPES : ty_t_invoice_lines TYPE STANDARD TABLE OF ty_s_invoice_lines WITH EMPTY KEY.

    TYPES : BEGIN OF ty_s_crcustom_fields.
    TYPES : sap_user_id TYPE string.
    TYPES : END OF ty_s_crcustom_fields.

    TYPES : BEGIN OF ty_s_created_by.
    TYPES : id            TYPE string,
            custom_fields TYPE ty_s_crcustom_fields.
    TYPES : END OF ty_s_created_by.

    TYPES : BEGIN OF ty_s_requested_by.
    TYPES : firstname     TYPE string.
    TYPES : END OF ty_s_requested_by.

    TYPES : BEGIN OF ty_s_supplier.
    TYPES : id     TYPE string,
            number TYPE string.
    TYPES : END OF ty_s_supplier.

    TYPES : BEGIN OF ty_s_remit.
    TYPES:  remit_to_code  TYPE string.
    TYPES : END OF ty_s_remit.

    TYPES : BEGIN OF ty_s_payment.
    TYPES:  code  TYPE string.
    TYPES : END OF ty_s_payment.

    TYPES : BEGIN OF ty_s_currency.
    TYPES:  code  TYPE string.
    TYPES : END OF ty_s_currency.

    TYPES : BEGIN OF ty_s_account_type.
    TYPES : id   TYPE string,
            name TYPE string.
    TYPES : END OF ty_s_account_type.

    TYPES : BEGIN OF ty_s_request.
    TYPES : id               TYPE string,
            invoice_date     TYPE string,
            credit_reason    TYPE string,
            transaction_uuid TYPE string,
            total_with_taxes TYPE string,
            document_type    TYPE string,
            account_type     TYPE ty_s_account_type,
            currency         TYPE ty_s_currency,
            payment_term     TYPE ty_s_payment,
            remit_to_address TYPE ty_s_remit,
            supplier         TYPE ty_s_supplier,
            invoice_lines    TYPE ty_t_invoice_lines,
            requested_by     TYPE ty_s_requested_by,
            created_by       TYPE ty_s_created_by,
            custom_fields    TYPE ty_s_custom_fields.
    TYPES : END OF ty_s_request.
    TYPES : ty_t_request TYPE STANDARD TABLE OF ty_s_request WITH EMPTY KEY.

    DATA : lt_request TYPE ty_t_request,    "데이터가 배열안에 json이 들어오는 경우 - 전체
           ls_request TYPE ty_s_request.    "데이터가 배열 없이 json으로 들어오는 경우 - 단건

    DATA : ls_glitem TYPE ty_s_invoice_lines,
           ls_allo   TYPE ty_s_account_allocations.

    " 세금액 합산
    TYPES : BEGIN OF ty_s_tax_sum.
    TYPES : code       TYPE string,
            taxamount  TYPE string,
            baseamount TYPE string.
    TYPES : END OF ty_s_tax_sum.
    TYPES : ty_t_tax_sum TYPE STANDARD TABLE OF ty_s_tax_sum WITH EMPTY KEY.

    " 서로 다른 지점 체크
    TYPES : BEGIN OF ty_s_cc_check.
    TYPES : costcenter TYPE string.
    TYPES : END OF ty_s_cc_check.
    TYPES : ty_t_cc_check TYPE STANDARD TABLE OF ty_s_cc_check WITH EMPTY KEY.

    " 불공제 V4 세금액 변경 및 밸런싱 체크
    TYPES:BEGIN OF ty_s_balance.
    TYPES: id        TYPE string,
           seq       TYPE sy-tabix,
           percent   TYPE p LENGTH 16 DECIMALS 14,
           pertax    TYPE p LENGTH 16 DECIMALS 14,
           allototal TYPE i_journalentryitem-amountintransactioncurrency.
    TYPES:END OF ty_s_balance.
    TYPES: ty_t_balance TYPE STANDARD TABLE OF ty_s_balance WITH EMPTY KEY.

    DATA : lt_tax_sum TYPE ty_t_tax_sum,
           ls_tax_sum TYPE ty_s_tax_sum,
           ls_taxitem TYPE ty_s_tax_sum.

    DATA : lt_cc_check TYPE ty_t_cc_check,
           ls_cc_check TYPE ty_s_cc_check.

    DATA : lt_balance TYPE ty_t_balance,
           lv_sum     TYPE i_journalentryitem-amountintransactioncurrency,
           lv_balan   TYPE p LENGTH 5 DECIMALS 2.

    DATA : lv_factor TYPE p LENGTH 8 DECIMALS 12 VALUE 100.

    DATA : lt_name_mapping TYPE /ui2/cl_json=>name_mappings.

    lt_name_mapping = VALUE #(
        ( abap = 'ID' json = 'id' )
        ( abap = 'INVOICE_DATE' json = 'invoice-date' )
        ( abap = 'CREDIT_REASON' json = 'credit-reason' )
        ( abap = 'TRANSACTION_UUID' json = 'transaction-uuid' )
        ( abap = 'TOTAL_WITH_TAXES' json = 'total-with-taxes' )
        ( abap = 'DOCUMENT_TYPE' json = 'document-type' )
        ( abap = 'ACCOUNT_TYPE' json = 'account-type' )
        ( abap = 'NAME' json = 'name' )
        ( abap = 'CURRENCY' json = 'currency' )
        ( abap = 'CODE' json = 'code' )
        ( abap = 'PAYMENT_TERM' json = 'payment-term' )
        ( abap = 'REMIT_TO_ADDRESS' json = 'remit-to-address' )
        ( abap = 'REMIT_TO_CODE' json = 'remit-to-code' )
        ( abap = 'SUPPLIER' json = 'supplier' )
        ( abap = 'NUMBER' json = 'number' )
        ( abap = 'INVOICE_LINES' json = 'invoice-lines' )
        ( abap = 'DESCRIPTION' json = 'description' )
        ( abap = 'PO_NUMBER' json = 'po-number' )
        ( abap = 'TOTAL' json = 'total' )
        ( abap = 'ACCOUNT' json = 'account' )
        ( abap = 'SEGMENT_1' json = 'segment-1' )
        ( abap = 'SEGMENT_2' json = 'segment-2' )
        ( abap = 'ACCOUNT_ALLOCATIONS' json = 'account-allocations' )
        ( abap = 'TAX_CODE' json = 'tax-code' )
        ( abap = 'TAX_LINES' json = 'tax-lines' )
        ( abap = 'AMOUNT' json = 'amount' )
        ( abap = 'COMMODITY' json = 'commodity' )
        ( abap = 'CREATED_BY' json = 'created-by' )
        ( abap = 'LOGIN' json = 'login' )
        ( abap = 'REQUESTED_BY' json = 'requested-by' )
        ( abap = 'FIRSTNAME' json = 'firstname' )
        ( abap = 'CUSTOM_FIELDS' json = 'custom-fields' )
        ( abap = 'SAP_USER_ID' json = 'sap-user-id' )
        ( abap = 'CF_INTEGRATION_STATUS' json = 'cf-integration-status' )
        ( abap = 'CF_SAP_JE_REF_NUMBER' json = 'cf-sap-je-ref-number' )
        ( abap = 'SAP_PAYMENT_METHOD' json = 'sap-payment-method' )
        ( abap = 'REQUIRES_CONSIGNEE' json = 'requires-consignee' )
        ( abap = 'AUTHORIZATION_CODE_SAP' json = 'authorization-code-sap' ) ).

    DATA(lv_data) = request->get_text( ).

    /ui2/cl_json=>deserialize(
      EXPORTING
        json             = lv_data
        name_mappings    = lt_name_mapping
      CHANGING
        data             = lt_request ).

**********************************************************************
*Journal Entry
**********************************************************************

    DATA : lv_error TYPE string.

    IF lv_data IS INITIAL.
      lv_error = 'Data is Empty'.

      response->set_text(
          EXPORTING
      i_text   = lv_error
      ).
      EXIT.
    ENDIF.

    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lv_cid     TYPE abp_behv_cid.

    DATA lv_docd TYPE bldat.

    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.

**********************************************************************
*Journal Entry 데이터 가공
**********************************************************************

    LOOP AT lt_request INTO ls_request.
      "Data 가공

      DATA(lv_bizp) = '1000'.

      DATA(lv_yyyy) = ls_request-invoice_date+0(4).
      DATA(lv_mm)   = ls_request-invoice_date+5(2).
      DATA(lv_dd)   = ls_request-invoice_date+8(2).

      CONCATENATE lv_yyyy lv_mm lv_dd INTO lv_docd.

      CLEAR : lv_yyyy, lv_mm, lv_dd.

      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      "UTC+9 YesterDay
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      GET TIME STAMP FIELD DATA(lv_tstp).
      CONVERT TIME STAMP lv_tstp TIME ZONE 'UTC+9' INTO DATE DATA(lv_date) TIME DATA(lv_time).

      IF ls_request-created_by-custom_fields-sap_user_id IS INITIAL.
        ls_request-created_by-custom_fields-sap_user_id = 'COUPA-CSP'.
      ENDIF.

      "미사용 맵핑
*      IF ls_request-custom_fields-requires_consignee = 'true'.
*        ls_request-custom_fields-requires_consignee = 'Consignment'.
*      ELSE.
*        CLEAR ls_request-custom_fields-requires_consignee.
*      ENDIF.

      IF ls_request-invoice_lines[ 1 ]-description IS NOT INITIAL.
        DATA(lv_desc) = ls_request-invoice_lines[ 1 ]-description.
      ENDIF.

      IF ls_request-invoice_lines[ 1 ]-commodity-name IS NOT INITIAL.
        DATA(lv_comm) = ls_request-invoice_lines[ 1 ]-commodity-name.
      ENDIF.

      IF ls_request-invoice_lines[ 1 ]-po_number IS NOT INITIAL.
        DATA(lv_ponum) = ls_request-invoice_lines[ 1 ]-po_number.
      ENDIF.

      IF ls_request-transaction_uuid IS INITIAL.
        ls_request-transaction_uuid = ls_request-custom_fields-authorization_code_sap.
      ENDIF.

      "11/29 일회성 벤더 프로세스 제거
*      DATA : lv_lifnr TYPE lifnr.
*
*      lv_lifnr = |{ ls_request-supplier-number ALPHA = IN }|.
*
*      SELECT SINGLE supplier, supplieraccountgroup, suppliername, bpaddrcityname  FROM i_supplier
*            WHERE supplier = @lv_lifnr
*            INTO @DATA(ls_supplier).

      "위수탁 계좌
*      SELECT SINGLE businesspartner, bankidentification, bankaccount FROM i_businesspartnerbank
*            WHERE businesspartner    = @lv_lifnr
*              AND bankidentification = @ls_request-remit_to_address-remit_to_code
*              INTO @DATA(ls_remit).

      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " Invoice Line 가공
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      LOOP AT ls_request-invoice_lines[] INTO DATA(ls_involine).

        IF ls_involine-account_allocations[ 1 ]-id IS INITIAL.

          """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          "2개 이상 지점의 Cost Center Check
          """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

          DATA(lv_cc_check) = substring( val = ls_involine-account-segment_1 off = 2 len = strlen( ls_involine-account-segment_1 ) - 2 ).

          READ TABLE lt_cc_check WITH KEY costcenter = lv_cc_check
                                 INTO ls_cc_check.

          IF  sy-subrc = 0. " 기존에 동일한 code가 있는 경우

          ELSE. " 기존 동일한 code가 없는 경우
            APPEND INITIAL LINE TO lt_cc_check ASSIGNING FIELD-SYMBOL(<fs_cc>).
            <fs_cc>-costcenter   = lv_cc_check.
          ENDIF.
          CLEAR : lv_cc_check, ls_cc_check.
        ELSE.
          DATA(lv_allseq) = 1.
          LOOP AT ls_involine-account_allocations[] INTO DATA(ls_split).

            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            "2개 이상 지점의 Cost Center Check
            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

            lv_cc_check = substring( val = ls_split-account-segment_1 off = 2 len = strlen( ls_split-account-segment_1 ) - 2 ).
            READ TABLE lt_cc_check WITH KEY costcenter = lv_cc_check
                                    INTO ls_cc_check.

            IF  sy-subrc = 0. " 기존에 동일한 code가 있는 경우

            ELSE. " 기존 동일한 code가 없는 경우
              APPEND INITIAL LINE TO lt_cc_check ASSIGNING <fs_cc>.
              <fs_cc>-costcenter   = lv_cc_check.
            ENDIF.
            CLEAR : lv_cc_check, ls_cc_check.

            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            "V4인 경우 비율 별 공급가액 합산 및 밸런싱 로직
            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            IF ls_involine-tax_code-code = 'V4' AND ( ls_involine-total IS NOT INITIAL OR ls_involine-total <> '0' ).

              APPEND INITIAL LINE TO lt_balance[] ASSIGNING FIELD-SYMBOL(<fs_bala>).
              <fs_bala>-id        = ls_involine-id.
              <fs_bala>-seq       = lv_allseq.
              <fs_bala>-percent   = ls_split-amount / ls_involine-total.
              <fs_bala>-pertax    = <fs_bala>-percent * ls_involine-tax_lines-amount.
              <fs_bala>-allototal = ( ls_split-amount + <fs_bala>-pertax ) / 100.

              lv_sum += <fs_bala>-allototal.
              lv_allseq += 1.
            ENDIF.
          ENDLOOP.
          IF ( ls_involine-total + ls_involine-tax_lines-amount ) / 100 <> lv_sum.
            lv_balan = ( ls_involine-total + ls_involine-tax_lines-amount ) / 100 - lv_sum.

            READ TABLE lt_balance WITH KEY id  = ls_involine-id seq = 1
                                  INTO DATA(ls_balance).

            ls_balance-allototal = ls_balance-allototal + lv_balan.

            MODIFY lt_balance FROM ls_balance
                              TRANSPORTING allototal
                              WHERE id  = ls_balance-id
                                AND seq = 1.
          ENDIF.
          CLEAR : lv_sum, lv_balan, ls_balance, lv_allseq.
        ENDIF.
      ENDLOOP.

      "서로 다른 지점의 갯수
      DATA(lv_cc_count) = lines( lt_cc_check ).

**********************************************************************
*Journal Entry Post
**********************************************************************

*      IF ls_request-document_type = 'Invoice'.
**********************************************************************
*Journal Entry Header
**********************************************************************

      APPEND INITIAL LINE TO lt_je_deep[] ASSIGNING FIELD-SYMBOL(<je_deep_head>).
      <je_deep_head>-%cid = lv_cid.
      <je_deep_head>-%param-businesstransactiontype 		 = 'RFBU'.
      <je_deep_head>-%param-accountingdocumenttype  		 = 'CT'.
      <je_deep_head>-%param-createdbyuser           		 =  ls_request-created_by-custom_fields-sap_user_id.
      <je_deep_head>-%param-companycode             		 =  ls_request-account_type-name.
      <je_deep_head>-%param-documentdate            		 =  lv_docd.
      <je_deep_head>-%param-postingdate             		 =  lv_date.     " 2차 통합테스트 지정 원복 시 sy-datum 지정
      <je_deep_head>-%param-taxdeterminationdate    		 =  lv_date.
      <je_deep_head>-%param-taxreportingdate    		     =  lv_docd.
      <je_deep_head>-%param-documentreferenceid     		 =  |COUPA{ ls_request-id }|.
      <je_deep_head>-%param-accountingdocumentheadertext     =  lv_comm.
      <je_deep_head>-%param-jrnlentrycntryspecificref1       =  ls_request-transaction_uuid.

*      "12/11 수정세금계산서 차대변 변환 및 음수 값 입력
*      IF ls_request-document_type = 'Credit Note'.
*        <je_deep_head>-%param-IsNegativePosting                =  'X'.
*      ENDIF.

      "11/29 일회성벤더 프로세스 제거
*        IF ls_supplier-supplieraccountgroup = 'CPD'.
*          <je_deep_head>-%param-_onetimecustomersupplier-cityname = ls_supplier-bpaddrcityname.
*          <je_deep_head>-%param-_onetimecustomersupplier-name     = ls_supplier-suppliername.
*        ENDIF.

**********************************************************************
*Journal Entry APItem
**********************************************************************

      APPEND INITIAL LINE TO <je_deep_head>-%param-_apitems[] ASSIGNING FIELD-SYMBOL(<je_deep_ap>).
      "가격 부분에 -를 곱한다.
      <je_deep_ap>-glaccountlineitem                   = 1.
      <je_deep_ap>-supplier                            = ls_request-supplier-number.
      <je_deep_ap>-documentitemtext                    = lv_desc.
      <je_deep_ap>-reference1idbybusinesspartner       = ls_request-id.
      <je_deep_ap>-reference2idbybusinesspartner       = lv_ponum.
      <je_deep_ap>-reference3idbybusinesspartner       = ls_request-requested_by-firstname.           "신규 수정 맵핑
      <je_deep_ap>-businessplace                       = lv_bizp.           "business place test
      <je_deep_ap>-paymentmethod                       = ls_request-custom_fields-sap_payment_method-name.
      <je_deep_ap>-paymentterms                        = ls_request-payment_term-code.


*        IF ls_request-custom_fields-requires_consignee IS NOT INITIAL.
*            <je_deep_ap>-alternativepayee                    = ls_request-payment_term-code.
*            <je_deep_ap>-bpbankaccountinternalid             = ls_request-remit_to_address-remit_to_code.   "신규 맵핑
*        ENDIF.

      " 서로다른 지점 전표
      IF lv_cc_count > 1.
        <je_deep_ap>-profitcenter                      = '99999'.
      ENDIF.

      APPEND INITIAL LINE TO <je_deep_ap>-_currencyamount[] ASSIGNING FIELD-SYMBOL(<je_deep_ap_cu>).
      <je_deep_ap_cu>-journalentryitemamount      = ls_request-total_with_taxes * -1 / lv_factor.
      <je_deep_ap_cu>-currency                    = ls_request-currency-code.



**********************************************************************
*Journal Entry GLItem
**********************************************************************
      "Invoice lines 별 allocation 있는 경우와 없는 경우로 나눈다.

      DATA(lv_count) = 2.
      LOOP AT ls_request-invoice_lines[] INTO ls_glitem.

        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        "공제 또는 세금액이 0%인 경우
        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        IF ls_glitem-tax_code-code <> 'V4'.

          "split이 안 되어있는 invoice lines의 경우
          IF ls_glitem-account_allocations[ 1 ]-id IS INITIAL.

            APPEND INITIAL LINE TO <je_deep_head>-%param-_glitems[] ASSIGNING FIELD-SYMBOL(<je_deep_gl>).
            <je_deep_gl>-glaccountlineitem                          = lv_count.
            <je_deep_gl>-glaccount                                  = ls_glitem-account-segment_2.
            <je_deep_gl>-costcenter                                 = ls_glitem-account-segment_1.
            <je_deep_gl>-businessplace                              = lv_bizp.
            <je_deep_gl>-documentitemtext                           = ls_glitem-description.
            <je_deep_gl>-taxcode                                    = ls_glitem-tax_code-code.
            <je_deep_gl>-reference1idbybusinesspartner              = ls_request-id.
            <je_deep_gl>-reference2idbybusinesspartner              = lv_ponum.
            <je_deep_gl>-reference3idbybusinesspartner              = ls_request-requested_by-firstname.        "신규 수정 맵핑

            APPEND INITIAL LINE TO <je_deep_gl>-_currencyamount[] ASSIGNING FIELD-SYMBOL(<je_deep_gl_cu>).
            <je_deep_gl_cu>-journalentryitemamount   = ls_glitem-total / lv_factor.
            <je_deep_gl_cu>-currency                 = ls_request-currency-code.

            lv_count = lv_count + 1.

            "split이 있는 경우
          ELSE.
            LOOP AT ls_glitem-account_allocations[] INTO ls_allo.
              APPEND INITIAL LINE TO <je_deep_head>-%param-_glitems[] ASSIGNING <je_deep_gl>.
              <je_deep_gl>-glaccountlineitem                           = lv_count.
              <je_deep_gl>-glaccount                                   = ls_allo-account-segment_2.
              <je_deep_gl>-costcenter                                  = ls_allo-account-segment_1.
              <je_deep_gl>-businessplace                               = lv_bizp.
              <je_deep_gl>-documentitemtext                            = ls_glitem-description.
              <je_deep_gl>-taxcode                                     = ls_glitem-tax_code-code.
              <je_deep_gl>-reference1idbybusinesspartner               = ls_request-id.
              <je_deep_gl>-reference2idbybusinesspartner               = lv_ponum.
              <je_deep_gl>-reference3idbybusinesspartner               = ls_request-requested_by-firstname.     "신규 수정 맵핑

              APPEND INITIAL LINE TO <je_deep_gl>-_currencyamount[] ASSIGNING <je_deep_gl_cu>.
              <je_deep_gl_cu>-journalentryitemamount   = ls_allo-amount / lv_factor.
              <je_deep_gl_cu>-currency                 = ls_request-currency-code.

              lv_count = lv_count + 1.
            ENDLOOP.
          ENDIF.

          """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          "V4 - 불공제 10%인 경우
          """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

        ELSEIF ls_glitem-tax_code-code = 'V4'.

          "split이 안 되어있는 invoice lines의 경우
          IF ls_glitem-account_allocations[ 1 ]-id IS INITIAL.

            APPEND INITIAL LINE TO <je_deep_head>-%param-_glitems[] ASSIGNING <je_deep_gl>.
            <je_deep_gl>-glaccountlineitem                          = lv_count.
            <je_deep_gl>-glaccount                                  = ls_glitem-account-segment_2.
            <je_deep_gl>-costcenter                                 = ls_glitem-account-segment_1.
            <je_deep_gl>-businessplace                              = lv_bizp.
            <je_deep_gl>-documentitemtext                           = ls_glitem-description.
            <je_deep_gl>-taxcode                                    = ls_glitem-tax_code-code.
            <je_deep_gl>-reference1idbybusinesspartner              = ls_request-id.
            <je_deep_gl>-reference2idbybusinesspartner              = lv_ponum.
            <je_deep_gl>-reference3idbybusinesspartner              = ls_request-requested_by-firstname.        "신규 수정 맵핑

            APPEND INITIAL LINE TO <je_deep_gl>-_currencyamount[] ASSIGNING <je_deep_gl_cu>.
            <je_deep_gl_cu>-journalentryitemamount   = ( ls_glitem-total + ls_glitem-tax_lines-amount ) / lv_factor.
            <je_deep_gl_cu>-currency                 = ls_request-currency-code.

            lv_count = lv_count + 1.

            "split이 있는 경우
          ELSE.
            DATA(lv_balaseq) = 1.
            LOOP AT ls_glitem-account_allocations[] INTO ls_allo.
              APPEND INITIAL LINE TO <je_deep_head>-%param-_glitems[] ASSIGNING <je_deep_gl>.
              <je_deep_gl>-glaccountlineitem                           = lv_count.
              <je_deep_gl>-glaccount                                   = ls_allo-account-segment_2.
              <je_deep_gl>-costcenter                                  = ls_allo-account-segment_1.
              <je_deep_gl>-businessplace                               = lv_bizp.
              <je_deep_gl>-documentitemtext                            = ls_glitem-description.
              <je_deep_gl>-taxcode                                     = ls_glitem-tax_code-code.
              <je_deep_gl>-reference1idbybusinesspartner               = ls_request-id.
              <je_deep_gl>-reference2idbybusinesspartner               = lv_ponum.
              <je_deep_gl>-reference3idbybusinesspartner               = ls_request-requested_by-firstname.     "신규 수정 맵핑

              READ TABLE lt_balance WITH KEY id = ls_glitem-id seq = lv_balaseq
                                    INTO DATA(ls_balance_amount).

              APPEND INITIAL LINE TO <je_deep_gl>-_currencyamount[] ASSIGNING <je_deep_gl_cu>.
              <je_deep_gl_cu>-journalentryitemamount   = ls_balance_amount-allototal.
              <je_deep_gl_cu>-currency                 = ls_request-currency-code.

              lv_count   = lv_count + 1.
              lv_balaseq += 1.
              CLEAR: ls_balance_amount.
            ENDLOOP.
            CLEAR : lv_balaseq.
          ENDIF.
        ENDIF.

        "모든 invoice lines의 tax code를 확인하고 동일한 값 끼리 합을 더한다.
        READ TABLE lt_tax_sum WITH KEY code = ls_glitem-tax_lines-code
                              INTO ls_tax_sum.
        IF  sy-subrc = 0. " 기존에 동일한 code가 있는 경우
          ls_tax_sum-taxamount  = ls_tax_sum-taxamount + ls_glitem-tax_lines-amount.
          ls_tax_sum-baseamount = ls_tax_sum-baseamount + ls_glitem-total.

          MODIFY lt_tax_sum FROM ls_tax_sum
                            TRANSPORTING taxamount
                                         baseamount
                            WHERE code = ls_tax_sum-code.


        ELSE. " 기존 동일한 code가 없는 경우
          APPEND INITIAL LINE TO lt_tax_sum ASSIGNING FIELD-SYMBOL(<fs_sum>).
          <fs_sum>-code       = ls_glitem-tax_lines-code.
          <fs_sum>-taxamount  = ls_glitem-tax_lines-amount.
          <fs_sum>-baseamount = ls_glitem-total.
        ENDIF.

        CLEAR : ls_tax_sum.

      ENDLOOP.


**********************************************************************
*Journal Entry TaxItem
**********************************************************************
      "가공된 tax table에서 데이터를 가져온다.

      LOOP AT lt_tax_sum INTO ls_taxitem.

        IF ls_taxitem-code = 'VZ' OR ls_taxitem-code = 'V4'.
          DATA(lv_tclas) = 'NVV'.
          DATA(lv_tcond) = 'MWVZ'.
        ELSE.
          lv_tclas = 'VST'.
          lv_tcond = 'MWVS'.
        ENDIF.

        APPEND INITIAL LINE TO <je_deep_head>-%param-_taxitems[] ASSIGNING FIELD-SYMBOL(<je_deep_tax>).
        <je_deep_tax>-glaccountlineitem           = lv_count.
        <je_deep_tax>-taxcode                     = ls_taxitem-code.
        <je_deep_tax>-taxitemclassification       = lv_tclas.
        <je_deep_tax>-conditiontype               = lv_tcond.


        APPEND INITIAL LINE TO <je_deep_tax>-_currencyamount[] ASSIGNING FIELD-SYMBOL(<je_deep_tax_cu>).
        <je_deep_tax_cu>-journalentryitemamount   = ls_taxitem-taxamount / lv_factor.
        <je_deep_tax_cu>-currency                 = ls_request-currency-code.
        <je_deep_tax_cu>-taxamount                = ls_taxitem-taxamount / lv_factor.
        <je_deep_tax_cu>-taxbaseamount            = ls_taxitem-baseamount / lv_factor.

        lv_count = lv_count + 1.
      ENDLOOP.

**********************************************************************
*Journal Entry Post Check 로직
**********************************************************************

      MODIFY ENTITIES OF i_journalentrytp
       ENTITY journalentry
       EXECUTE post FROM lt_je_deep
         FAILED DATA(ls_failed_deep)
         REPORTED DATA(ls_reported_deep)
         MAPPED DATA(ls_mapped_deep).

      IF ls_failed_deep IS NOT INITIAL.

        LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
          DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).

        ENDLOOP.
      ELSE.

**********************************************************************
*Journal Entry Post 로직
**********************************************************************

        COMMIT ENTITIES BEGIN
          RESPONSE OF i_journalentrytp
            FAILED DATA(lt_commit_failed)
            REPORTED DATA(lt_commit_reported).

        COMMIT ENTITIES END.

        LOOP AT lt_commit_reported-journalentry ASSIGNING FIELD-SYMBOL(<ls_commit_reported_deep>).
          lv_result       = <ls_commit_reported_deep>-%msg->if_message~get_text( ).
          DATA(lv_docnum) = <ls_commit_reported_deep>-%msg->if_t100_dyn_msg~msgv2.
        ENDLOOP.
      ENDIF.

      DATA(lv_response) = |\{ "custom-fields" : \{ "cf-integration-status" : "{ lv_result }", "cf-sap-je-ref-number" : "{ lv_docnum }" \}  \}|.

**********************************************************************
*Journal Entry Change
**********************************************************************

      IF ls_request-remit_to_address-remit_to_code IS NOT INITIAL.
        DATA : lt_jc TYPE TABLE FOR ACTION IMPORT i_journalentrytp~change.

        APPEND INITIAL LINE TO lt_jc[] ASSIGNING FIELD-SYMBOL(<jc>).
        <jc>-companycode         =  lv_docnum+10(4).
        <jc>-fiscalyear          =  lv_docnum+14(4).
        <jc>-accountingdocument  =  lv_docnum+0(10).

        APPEND INITIAL LINE TO <jc>-%param-_aparitems[] ASSIGNING FIELD-SYMBOL(<jc_arap>).
        <jc_arap>-glaccountlineitem                = 1.
        <jc_arap>-bpbankaccountinternalid          = ls_request-remit_to_address-remit_to_code.
        <jc_arap>-%control-bpbankaccountinternalid = if_abap_behv=>mk-on.


        MODIFY ENTITIES OF i_journalentrytp PRIVILEGED
         ENTITY journalentry
         EXECUTE change FROM lt_jc
           FAILED DATA(ls_failed_jc)
           REPORTED DATA(ls_reported_jc)
           MAPPED DATA(ls_mapped_jc).

        IF ls_failed_jc IS NOT INITIAL.
          LOOP AT ls_reported_jc-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_jc>).
            DATA(lv_resultjc) = <ls_reported_jc>-%msg->if_message~get_text( ).
          ENDLOOP.
        ELSE.

          COMMIT ENTITIES BEGIN
                RESPONSE OF i_journalentrytp
                  FAILED DATA(lt_jc_commit_failed)
                  REPORTED DATA(lt_jc_commit_reported).

          COMMIT ENTITIES END.

          LOOP AT lt_jc_commit_reported-journalentry ASSIGNING FIELD-SYMBOL(<ls_commit_reported_jc>).
            lv_result       = <ls_commit_reported_jc>-%msg->if_message~get_text( ).
            DATA(lv_docjc)      = <ls_commit_reported_jc>-%msg->if_t100_dyn_msg~msgv2.
          ENDLOOP.

        ENDIF.
      ENDIF.

**********************************************************************
*Journal Entry Reverse
**********************************************************************
      "11/28 역분개 프로세스 제거
*      ELSEIF ls_request-document_type = 'Credit Note'.

*        IF ls_request-credit_reason IS INITIAL.
*          ls_request-credit_reason = '01'.
*        ENDIF.

*        IF ls_request-custom_fields-cf_sap_je_ref_number IS NOT INITIAL.

*          DATA : lt_jr TYPE TABLE FOR ACTION IMPORT i_journalentrytp~reverse.
*
*          APPEND INITIAL LINE TO lt_jr[] ASSIGNING FIELD-SYMBOL(<jr>).
*          <jr>-companycode                  = ls_request-custom_fields-cf_sap_je_ref_number+10(4).
*          <jr>-fiscalyear                   = ls_request-custom_fields-cf_sap_je_ref_number+14(4).
*          <jr>-accountingdocument           = ls_request-custom_fields-cf_sap_je_ref_number+0(10).
*          <jr>-%param-postingdate           = '20231031'.     " 2차 통합테스트 지정 원복 시 sy-datum 지정
*          <jr>-%param-reversalreason        = ls_request-credit_reason.
*          <jr>-%param-createdbyuser         = ls_request-created_by-custom_fields-sap_user_id.
*
*          MODIFY ENTITIES OF i_journalentrytp PRIVILEGED
*            ENTITY journalentry
*            EXECUTE reverse  FROM lt_jr
*              FAILED DATA(ls_failed)
*              REPORTED DATA(ls_reported)
*              MAPPED DATA(ls_mapped).
*
*          LOOP AT ls_failed-journalentry ASSIGNING FIELD-SYMBOL(<ls_failed>).
*            lv_result = <ls_failed>-%fail-cause.
*          ENDLOOP.
*
*          IF ls_failed-journalentry IS INITIAL.
*
*            COMMIT ENTITIES BEGIN
*              RESPONSE OF i_journalentrytp
*                FAILED DATA(lt_jr_commit_failed)
*                REPORTED DATA(lt_jr_commit_reported).
*
*            COMMIT ENTITIES END.
*            LOOP AT lt_jr_commit_reported-journalentry ASSIGNING FIELD-SYMBOL(<ls_jr_commit_reported>).
*              lv_result       = <ls_jr_commit_reported>-%msg->if_message~get_text( ).
*              lv_docnum       = <ls_jr_commit_reported>-%msg->if_t100_dyn_msg~msgv2.
*            ENDLOOP.
*          ENDIF.
*
*          lv_response = |\{ "custom-fields" : \{ "cf-integration-status" : "{ lv_result }", "cf-sap-je-ref-number" : "{ lv_docnum }" \}  \}|.

*        ELSE.
*          lv_response = |\{ "custom-fields" : \{ "cf-integration-status" : "Reverse Error - Document Number Empty" \}  \}|.

*        ENDIF.


*      ELSE.

*      ENDIF.

    ENDLOOP.    " lt_request를 돌리는 LOOP


**********************************************************************
*http response
**********************************************************************

    response->set_text(
      EXPORTING
        i_text   = lv_response
    ).

    response->set_header_field(
      EXPORTING
        i_name  = 'Content-Type'
        i_value = 'application/json'
    ).

  ENDMETHOD.
ENDCLASS.
