@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[IF] Invoice Payment Interface Coupa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDIF_I_PAYMENT_01
  as select from    I_JournalEntryItem as i
    left outer join I_JournalEntry     as h on h.AccountingDocument = i.AccountingDocument
{
  key i.AccountingDocument                                                                                                      as AccountingDocument,

      cast(substring(h.DocumentReferenceID,6,length(h.DocumentReferenceID)) as abap.char(10))                                   as CoupaId,

      i.AccountingDocumentType                                                                                                  as AccountingDocumentType,

      i.ClearingJournalEntry                                                                                                    as ClearingAccountingDocument,

      i.TransactionCurrency                                                                                                     as TransactionCurrency,

      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      i.AmountInTransactionCurrency * -1                                                                                        as PayAmount,

      i.ClearingDate                                                                                                            as ClearingDate,

      h.IsReversed                                                                                                              as IsReversed,

      h.IsReversal                                                                                                              as IsReversal,

      cast(concat(i._ClearingJournalEntry.AccountingDocumentCreationDate, i._ClearingJournalEntry.CreationTime)as abap.char(15)) as CreateDateTime

}
where
      i.SourceLedger           =    '0L'      // 0L, 3L 중복 제거
  and i.AccountingDocumentType =    'CT'      // KZ, ZP 제거
  and h.IsReversed             <>   'X'       // 역분개된 전표 제거
  and h.IsReversal             <>   'X'       // 역분개한 전표 제거
  and h.DocumentReferenceID    like 'COUPA%'  // Coupa ID 번호 유뮤 확인
  and i.ClearingJournalEntry   is not initial // Clear 데이터 추출
