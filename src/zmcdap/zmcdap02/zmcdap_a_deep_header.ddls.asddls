@EndUserText.label: '[AP] Deep Parameter Header for Except Control'
define root abstract entity ZMCDAP_A_DEEP_HEADER
{
    key DummyKey : abap.char(1);
    _SelectedItems : composition [0..*] of ZMCDAP_A_DEEP_ITEM;
}
