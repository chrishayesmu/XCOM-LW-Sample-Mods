class ArtifactRepairMod extends LWCEModBase
    config(ArtifactRepairMod);

var config array<LWCE_TItem> arrRepairItems;

defaultproperties
{
    ModFriendlyName="Artifact Repair"
    ModIDRange=(MinInclusive=1894830000, MaxInclusive=1894839999)
    VersionInfo=(Major=0, Minor=1, Revision=0)
    StrategyListenerClass=class'ArtifactRepair_StrategyListener'
}