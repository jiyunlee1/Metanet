@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GR] Bank Statement Auto Posting - Journal Entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZMCDGL_I_JOURNAL
  as select from I_JournalEntry
{
  key CompanyCode,
  
  key FiscalYear,
  
  key AccountingDocument,
  
      IsReversed

}
