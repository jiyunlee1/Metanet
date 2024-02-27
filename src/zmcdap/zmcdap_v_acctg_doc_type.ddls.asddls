@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AP] Accounting Document Type Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZMCDAP_V_ACCTG_DOC_TYPE as select from I_AccountingDocumentType
{
      @EndUserText.label: '문서 유형'
      @Consumption.valueHelpDefault.display: true
      @ObjectModel.text.element  : [ 'DocTypeNM' ]
      @Search : {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.8
      }

  key AccountingDocumentType                                                as DocType,

      @EndUserText.label: '문서 유형 Text'
      @Consumption.valueHelpDefault.display: true
      @Semantics.text: true
      @Search : {
        defaultSearchElement: true,
        fuzzinessThreshold: 0.8
      }
      _Text[Language = $session.system_language].AccountingDocumentTypeName as DocTypeNM
}
where AccountingDocumentType = 'KR'
or AccountingDocumentType = 'KG'
or AccountingDocumentType = 'CT'
