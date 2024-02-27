@EndUserText.label: '[AP] Deep Parameter Item for Except Control'
define abstract entity ZMCDAP_A_DEEP_ITEM
{
    key DummyKey : abap.char(1);
    IssueNo : abap.char(80);
    ExptStat : zmcdde_expt_status_type;
    _DummyAssociation : association to parent ZMCDAP_A_DEEP_HEADER on $projection.DummyKey = _DummyAssociation.DummyKey;
}
