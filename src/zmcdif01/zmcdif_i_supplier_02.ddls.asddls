@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[IF] Supplier Interface Coupa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDIF_I_SUPPLIER_02
  as select from    I_Supplier                  as s
    left outer join I_KR_SupplierVATInformation as kt on kt.Supplier = s.Supplier
{
  key s.Supplier                                                                                        as SupplierNumber,

      cast(substring(s.BusinessPartnerName4,6,length(s.BusinessPartnerName4) - 5) as abap.char(35))     as CoupaId,

      s.SupplierName                                                                                    as Name,

      concat_with_space(s.BusinessPartnerName1, kt.TaxNumber2,1)                                        as DisplayName,
     
      case 
        when s.IsOneTimeAccount = 'X'
            then 'true'
            else 'false'
      end                                                                                               as IsOneTimeAccount,

      s._EmailAddress.EmailAddress                                                                      as EmailAddress,

      kt.TaxNumber2                                                                                     as BPTaxNumber,
      
      substring(s._CurrentDfltLandlinePhoneNmbr.InternationalPhoneNumber,2,length(s._CurrentDfltLandlinePhoneNmbr.InternationalPhoneNumber) - length(replace(s._CurrentDfltLandlinePhoneNmbr.PhoneAreaCodeSubscriberNumber, '-', '' )))    as PhoneCountry,
      
      replace(s._CurrentDfltLandlinePhoneNmbr.PhoneAreaCodeSubscriberNumber, '-', '' )                  as PhoneNumber,
      
      substring(s._CurrentDfltMobilePhoneNumber.InternationalPhoneNumber,2,length(s._CurrentDfltMobilePhoneNumber.InternationalPhoneNumber) - length(replace(s._CurrentDfltMobilePhoneNumber.PhoneAreaCodeSubscriberNumber, '-', '' )))    as MobileCountry,
      
      replace(s._CurrentDfltMobilePhoneNumber.PhoneAreaCodeSubscriberNumber, '-', '' )                  as MobileNumber,

      substring(s._CurrentDfltFaxNumber.InternationalFaxNumber,2,length(s._CurrentDfltFaxNumber.InternationalFaxNumber) - length(replace(s._CurrentDfltFaxNumber.FaxAreaCodeSubscriberNumber, '-', '' )))                                  as FaxCountry,
      
      replace(s._CurrentDfltFaxNumber.FaxAreaCodeSubscriberNumber, '-', '' )                            as FaxNumber,
      
      s.TaxInvoiceRepresentativeName                                                                    as FullName,
      
      s.StreetName                                                                                      as StreetName,

      s.CityName                                                                                        as CityName,

      s.Country                                                                                         as Country,

      s.PostalCode                                                                                      as PostalCode,

      s._SupplierCompany.PaymentTerms                                                                   as PaymentTerms,
      
      s._SupplierCompany.PaymentMethodsList                                                             as PaymentMethod,

      concat(s._SupplierToBusinessPartner._BusinessPartner.CreationDate, s._SupplierToBusinessPartner._BusinessPartner.CreationTime)                as CreateDateTime,

      concat(s._SupplierToBusinessPartner._BusinessPartner.LastChangeDate, s._SupplierToBusinessPartner._BusinessPartner.LastChangeTime)            as LastChangeDateTime,

      s._SupplierToBusinessPartner._BusinessPartner.BusinessPartnerIsBlocked                            as CentralBlock,

      s._SupplierToBusinessPartner._BusinessPartner.BusinessPartnerIsNotReleased                        as NotReleased,
      
      case
            when        s._SupplierToBusinessPartner._BusinessPartner.BusinessPartnerIsBlocked = 'X'
                 then   'inactive'
            when        s._SupplierToBusinessPartner._BusinessPartner.BusinessPartnerIsNotReleased = 'X'
                 then   'inactive'
            else 'active'
      end                                                                                               as Status

}

