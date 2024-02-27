@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[AR] 전표 유형 Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDAR_V_DOC_TYPE
  as select from I_AccountingDocumentType
{
      @EndUserText.label: '문서 유형'
      @Consumption.valueHelpDefault.display: true
  key AccountingDocumentType                                                as DocType,

      @EndUserText.label: '문서 유형 Text'
      @Consumption.valueHelpDefault.display: true
      _Text[Language = $session.system_language].AccountingDocumentTypeName as DocTypeNM
}
