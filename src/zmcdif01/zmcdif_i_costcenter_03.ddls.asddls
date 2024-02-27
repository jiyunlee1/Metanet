@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[IF] Cost Center Interface Coupa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDIF_I_COSTCENTER_03 
    as select from I_CostCenter
{
    key CostCenter                                                                                               as CostCenter,
    
        concat_with_space(_Text[ Language = $session.system_language ].CostCenterName, CostCenter,1)             as CostCenterName,

        concat_with_space(_Text[ Language = $session.system_language ].CostCenterDescription, CostCenter,1)      as CostCenterDesc,
    
        case
            when        ValidityEndDate < $session.system_date
                 and    ValidityStartDate > $session.system_date
                 then   'No'
            else 'Yes'
        end                                                                                       				 as Active,
    
        cast( 'Cost Center' as abap.char( 20 ) )                                                  				 as Lookup,
    
        ValidityEndDate                                                                           				 as EndDate,
    
        ValidityStartDate                                                                         				 as StartDate
        
}where CompanyCode = '1000';
