class MassProductionMod extends LWCEModBase
    config(MassProductionMod);

var config int iProductionThresholdGeneral;
var config int iProductionThresholdArmor;
var config int iProductionThresholdSmallItems;
var config int iProductionThresholdWeapons;
var config array<LWCE_TItemQuantity> arrProductionThresholdOverrides;

defaultproperties
{
    ModFriendlyName="Mass Production"
    ModIDRange=(MinInclusive=546210000, MaxInclusive=546219999)
    VersionInfo=(Major=0, Minor=1, Revision=0)
    StrategyListenerClass=class'MassProduction_StrategyListener'
}