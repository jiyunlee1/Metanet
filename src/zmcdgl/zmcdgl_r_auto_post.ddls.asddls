@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GL] Bank Statement Auto - Posting'
define root view entity ZMCDGL_R_AUTO_POST as select from ZMCDGL_I_AUTO_POST
composition [0..*] of ZMCDGL_R_POST_DETAIL as _PostDetail
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
    State,
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    LastChangedBy,
//    RevState,
//    RevStateText,
    /* Associations */
    _Linkage,
    _PostingState,
    _PostDetail // Make association public
}
