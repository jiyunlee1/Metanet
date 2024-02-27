@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[IF] Supplier Interface AutoBill'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDIF_I_SUPPLIER_01
  as select from    I_Supplier                  as s
    left outer join I_KR_SupplierVATInformation as k on k.Supplier = s.Supplier
{
  key s.Supplier                                                                 as Supplier,

      s.SupplierName                                                             as SupplierName,
      
      cast(substring(k.TaxNumber2,3,length(k.TaxNumber2)) as abap.char(10) )     as EmployeeNumber
      
}where s._SupplierToBusinessPartner._BusinessPartner.BusinessPartnerGrouping = 'ZBP4' or s._SupplierToBusinessPartner._BusinessPartner.BusinessPartnerGrouping = 'ZBP6'
