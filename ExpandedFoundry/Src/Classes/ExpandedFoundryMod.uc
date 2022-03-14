class ExpandedFoundryMod extends LWCEModBase
    config(ExpandedFoundryMod);

const FoundryID_EleriumBatteries = 549430000;
const FoundryID_ReconTools = 549430001;
const FoundryID_ImprovedMedikitII = 549430002;
const FoundryID_RechargeableTrackers = 549430003;

var config array<LWCE_TFoundryTech> arrFoundryTechs;

var const localized string FoundryNames[4];
var const localized string FoundrySummaries[4];

defaultproperties
{
    ModFriendlyName="Expanded Foundry"
    ModIDRange=(MinInclusive=549430000, MaxInclusive=549439999)
    VersionInfo=(Major=0, Minor=1, Revision=0)
    StrategyListenerClass=class'ExpandedFoundry_StrategyListener'
    TacticalListenerClass=class'ExpandedFoundry_TacticalListener'
}