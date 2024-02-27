@EndUserText.label: '[GL] Bank Statement Auto - Posting'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZMCDGL_C_AUTO_POST
  provider contract transactional_query
  as projection on ZMCDGL_R_AUTO_POST
  association [1] to ZMCDGL_C_RECEIPT_PAGE as _ReceiptPage on $projection.ID = _ReceiptPage.ID
  association [1] to ZMCDGL_C_SWEEP_PAGE   as _SweepPage   on $projection.ID = _SweepPage.ID
{
  key ID,

      DocSeqNo,

      Company,

      DocType,

      Bank,

      BankAcctID,

      Account,

      DocDate,

      PostingDate,

      TransactionCurrency,

      AmountInTransactionCurrency,


      RefDocHeader,

      _PostingState.StateText,

      @Consumption.valueHelpDefinition: [
       {
         entity.name: 'ZMCDGL_V_POSTING_STATE',
         entity.element: 'State'
       }
      ]
      State,
      
//      RevState,
      
//      RevStateText,
      
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MCDGL_VE_DOCSTATE'
      @EndUserText.label: 'Doc State'
      virtual DocState : abap.char(1),
      
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MCDGL_VE_DOCSTATE'
      @EndUserText.label: 'Reversal Check'
      virtual DocStateText : abap.char(20),
      
      CreatedBy,

      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: false }
      CreatedAt,

      LocalLastChangedBy,

      LocalLastChangedAt,

      LastChangedAt,

      LastChangedBy,

      /* Associations */
      _Linkage,

      _PostingState,

      _ReceiptPage,

      _SweepPage,

      _PostDetail : redirected to composition child ZMCDGL_C_POST_DETAIL
}
