*&---------------------------------------------------------------------*
*& Report ZSCRIPT_WATERMARK
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zscript_watermark.

DATA: it_material  TYPE TABLE OF mara,
      it_material2 TYPE TABLE OF mara, 
      ls_material  TYPE mara.

DATA: countpages TYPE i.
countpages = 0.
DATA: lv_countpages TYPE char10.

DATA: info1 TYPE string,
      info2 TYPE string,
      info3 TYPE string,
      info4 TYPE string.

info1 = 'INFO1'.
info2 = 'INFO2'.
info3 = 'INFO3'.
info4 = 'INFO4'.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM open_form.
  PERFORM print_watermark.
  PERFORM print_table.
  PERFORM close_form.

FORM get_data.

  DO 20 TIMES.
    SELECT * FROM mara INTO TABLE it_material.

    LOOP AT it_material INTO ls_material.
      APPEND ls_material TO it_material2.
    ENDLOOP.
  ENDDO.

ENDFORM.

FORM open_form.

  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
*     APPLICATION                 = 'TX'
*     ARCHIVE_INDEX               =
*     ARCHIVE_PARAMS              =
      device                      = 'PRINTER'
*     DIALOG                      = 'X'
      form                        = 'ZF_SAPSCRIPT000'
      language                    = sy-langu
*     OPTIONS                     =
*     MAIL_SENDER                 =
*     MAIL_RECIPIENT              =
*     MAIL_APPL_OBJECT            =
*     RAW_DATA_INTERFACE          = '*'
*     SPONUMIV                    =
* IMPORTING
*     LANGUAGE                    =
*     NEW_ARCHIVE_PARAMS          =
*     RESULT                      =
    EXCEPTIONS
      canceled                    = 1
      device                      = 2
      form                        = 3
      options                     = 4
      unclosed                    = 5
      mail_options                = 6
      archive_error               = 7
      invalid_fax_number          = 8
      more_params_needed_in_batch = 9
      spool_error                 = 10
      codepage                    = 11
      OTHERS                      = 12.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM print_watermark.

  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element                  = 'PRINT'
*     FUNCTION                 = 'SET'
*     TYPE                     = 'BODY'
      window                   = 'MAIN'
* IMPORTING
*     PENDING_LINES            =
    EXCEPTIONS
      element                  = 1
      function                 = 2
      type                     = 3
      unopened                 = 4
      unstarted                = 5
      window                   = 6
      bad_pageformat_for_print = 7
      spool_error              = 8
      codepage                 = 9
      OTHERS                   = 10.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM print_table.

  LOOP AT it_material2 INTO ls_material.

    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element                  = 'LINES'
*       FUNCTION                 = 'SET'
*       TYPE                     = 'BODY'
        window                   = 'MAIN'
* IMPORTING
*       PENDING_LINES            =
      EXCEPTIONS
        element                  = 1
        function                 = 2
        type                     = 3
        unopened                 = 4
        unstarted                = 5
        window                   = 6
        bad_pageformat_for_print = 7
        spool_error              = 8
        codepage                 = 9
        OTHERS                   = 10.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    ADD 1 TO countpages.
    lv_countpages = countpages.

    IF countpages EQ 10.
      CALL FUNCTION 'CONTROL_FORM'
        EXPORTING
          command  = 'NEW-PAGE'
        EXCEPTIONS
          unopened = 1
          OTHERS   = 2.

      PERFORM PRINT_WATERMARK.

      CLEAR countpages.
    ENDIF.

  ENDLOOP.

ENDFORM.

FORM close_form.

  CALL FUNCTION 'CLOSE_FORM'
* IMPORTING
*   RESULT                         =
*   RDI_RESULT                     =
* TABLES
*   OTFDATA                        =
    EXCEPTIONS
      unopened                 = 1
      bad_pageformat_for_print = 2
      send_error               = 3
      spool_error              = 4
      codepage                 = 5
      OTHERS                   = 6.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
