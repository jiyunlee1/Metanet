CLASS lhc_defsmartstore DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR defsmartstore RESULT result.

    METHODS determinonmodify FOR DETERMINE ON MODIFY
      IMPORTING keys FOR defsmartstore~determinonmodify.

    METHODS validatedata FOR VALIDATE ON SAVE
      IMPORTING keys FOR defsmartstore~validatedata.
ENDCLASS.

CLASS lhc_defsmartstore IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD determinonmodify.
    READ ENTITIES OF zmcdar_r_def_smst IN LOCAL MODE
        ENTITY defsmartstore
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_defsmst).
    LOOP AT lt_defsmst[] INTO DATA(ls_defsmst).
      IF ls_defsmst-formula IS NOT INITIAL.
        CONDENSE ls_defsmst-formula NO-GAPS.
        MODIFY ENTITIES OF zmcdar_r_def_smst IN LOCAL MODE
            ENTITY defsmartstore UPDATE FIELDS ( iscomb )
            WITH VALUE #( ( %tky = ls_defsmst-%tky
                            iscomb = abap_true
                            formula = ls_defsmst-formula
                            %control-iscomb = if_abap_behv=>mk-on ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validatedata.
    READ ENTITIES OF zmcdar_r_def_smst IN LOCAL MODE
        ENTITY defsmartstore
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_smst).

    TYPES: BEGIN OF ts_formula,
             symbol     TYPE c LENGTH 1,
             smartstore TYPE n LENGTH 3,
           END OF ts_formula.

    FIELD-SYMBOLS <fv_smst> TYPE zmcdar_i_def_smst-smartstore.
    DATA: lv_smst TYPE zmcdar_i_def_smst-smartstore,
          lv_idx  TYPE i,
          lv_code TYPE i.

    DATA: lt_formula TYPE TABLE OF ts_formula,
          ls_formula TYPE ts_formula.

    IF lt_smst IS NOT INITIAL.
      LOOP AT lt_smst REFERENCE INTO DATA(lr_smst).
        IF lr_smst->smartstore CO '1234567890 '.
          DATA(lv_nogap) = lr_smst->smartstore.

          CONDENSE lv_nogap NO-GAPS.

          IF lv_nogap <> lr_smst->smartstore.
            DATA(lv_error) = 'X'.
          ENDIF.

        ELSE.
          lv_error = 'X'.
        ENDIF.

        IF lv_error IS NOT INITIAL.
          APPEND VALUE #( %is_draft               = lr_smst->%is_draft
                            %tky                    = lr_smst->%tky
                            %element-smartstore = if_abap_behv=>mk-on
                            %state_area             = 'validation01'
                            %msg                    = new_message_with_text(
                                                      severity  = if_abap_behv_message=>severity-error
                                                      text      = |Smart Store is not number.| ) ) TO reported-defsmartstore.
        ELSE.
          APPEND VALUE #( %is_draft   = lr_smst->%is_draft
                          %tky        = lr_smst->%tky
                          %state_area = 'validation01' ) TO reported-defsmartstore.

          IF lr_smst->smartstorename IS INITIAL.
            APPEND VALUE #( %is_draft               = lr_smst->%is_draft
                            %tky                    = lr_smst->%tky
                            %element-smartstorename = if_abap_behv=>mk-on
                            %state_area             = 'validation01'
                            %msg                    = new_message_with_text(
                                                      severity  = if_abap_behv_message=>severity-error
                                                      text      = |Cost Type Name is required| ) ) TO reported-defsmartstore.
          ENDIF.

          IF lr_smst->indent IS INITIAL.
            APPEND VALUE #( %is_draft       = lr_smst->%is_draft
                            %tky            = lr_smst->%tky
                            %element-indent = if_abap_behv=>mk-on
                            %state_area     = 'validation01'
                            %msg            = new_message_with_text(
                                              severity  = if_abap_behv_message=>severity-error
                                              text      = |Indent is required| ) ) TO reported-defsmartstore.
          ENDIF.
        ENDIF.

        IF lr_smst->iscomb EQ abap_true.
          IF lr_smst->formula IS INITIAL.
            APPEND VALUE #( %is_draft       = lr_smst->%is_draft
                  %tky            = lr_smst->%tky
                  %element-formula = if_abap_behv=>mk-on
                  %state_area     = 'validation01'
                  %msg            = new_message_with_text(
                                    severity  = if_abap_behv_message=>severity-error
                                    text      = |For combination smartstore, Formula is required.| ) ) TO reported-defsmartstore.
          ENDIF.
        ENDIF.

        DATA: lv_valid_formula TYPE abap_boolean.

        IF lr_smst->formula IS NOT INITIAL.
          IF lr_smst->formula CO '+-1234567890 '.
            lv_valid_formula = abap_true.
            WHILE lv_idx < strlen( lr_smst->formula ).
              IF lv_code > 3.
                lv_valid_formula = abap_false.
                EXIT.
              ENDIF.
              DATA(lv_now) = lr_smst->formula+lv_idx(1).
              IF lv_now EQ ' '.
                lv_valid_formula = abap_false.
                EXIT.
              ELSEIF lv_now EQ '+' OR lv_now EQ '-'.
                IF lv_code EQ 0.
                  lv_valid_formula = abap_false.
                  EXIT.
                ELSE.
                  lv_code = 0.
                ENDIF.
              ELSE.
                lv_code += 1.
              ENDIF.
              lv_idx += 1.
            ENDWHILE.
          ELSE.
            lv_valid_formula = abap_false.
          ENDIF.
        ENDIF.

        IF lv_valid_formula EQ abap_true.
          zcl_mcdar_calc_comb_smst=>comp_formula(
            EXPORTING
              iv_formula = lr_smst->formula
            RECEIVING
              it_formula = lt_formula
          ).

          LOOP AT lt_formula INTO ls_formula.
            ASSIGN ls_formula-smartstore TO <fv_smst> CASTING.
            CLEAR lv_idx.

            IF <fv_smst> EQ '000'.
              APPEND VALUE #( %is_draft       = lr_smst->%is_draft
                    %tky            = lr_smst->%tky
                    %element-formula = if_abap_behv=>mk-on
                    %state_area     = 'validation01'
                    %msg            = new_message_with_text(
                                      severity  = if_abap_behv_message=>severity-error
                                      text      = |{ <fv_smst> } is wrong smart store code.| ) ) TO reported-defsmartstore.
              CONTINUE.
            ENDIF.
            WHILE lv_idx < strlen( <fv_smst> ).
              IF <fv_smst>+lv_idx(1) = '0'.
                lv_idx += 1.
              ELSE.
                EXIT.
              ENDIF.
            ENDWHILE.
            <fv_smst> = <fv_smst>+lv_idx.

            SELECT SINGLE @abap_true FROM zmcdar_i_def_smst
            WHERE smartstore = @<fv_smst>
            INTO @DATA(lv_exist).

            IF lv_exist NE abap_true.
              APPEND VALUE #( %is_draft       = lr_smst->%is_draft
                    %tky            = lr_smst->%tky
                    %element-formula = if_abap_behv=>mk-on
                    %state_area     = 'validation01'
                    %msg            = new_message_with_text(
                                      severity  = if_abap_behv_message=>severity-error
                                      text      = |{ <fv_smst> } is wrong smart store code.| ) ) TO reported-defsmartstore.
            ENDIF.

            CLEAR lv_exist.
            UNASSIGN <fv_smst>.
          ENDLOOP.
        ELSE.
          APPEND VALUE #( %is_draft       = lr_smst->%is_draft
                %tky            = lr_smst->%tky
                %element-formula = if_abap_behv=>mk-on
                %state_area     = 'validation01'
                %msg            = new_message_with_text(
                                  severity  = if_abap_behv_message=>severity-error
                                  text      = |Formula is not in the specified format.| ) ) TO reported-defsmartstore.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
