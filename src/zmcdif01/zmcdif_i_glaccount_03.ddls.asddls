@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[IF] GL Account Interface Coupa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMCDIF_I_GLACCOUNT_03 
    as select from I_GLAccount
{
    key GLAccount                                                                                       as GLAccount,
        
        concat_with_space(_Text[ Language = $session.system_language ].GLAccountName, GLAccount,1)      as GLAccountName,
        
        _Text[ Language = $session.system_language ].GLAccountLongName                                  as GLAccountLongName,
        
        cast( 'GL Account' as abap.char( 20 ) )                        									as Lookup,
        
        case
            when        _GLAccountInChartOfAccounts.AccountIsBlockedForPosting = 'X'
                 then   'No'
            else 'Yes'
        end                                   									                        as Active
        
}where ChartOfAccounts = 'YCOA'
   and CompanyCode = '1000'
   and (GLAccountType = 'X' or GLAccountType = 'P');
