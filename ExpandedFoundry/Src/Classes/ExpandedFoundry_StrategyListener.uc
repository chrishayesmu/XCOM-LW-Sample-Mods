class ExpandedFoundry_StrategyListener extends LWCEStrategyListener;

function OnFoundryTechsBuilt(out array<LWCE_TFoundryTech> Techs)
{
    local int iLocIndex;
    local LWCE_TFoundryTech kTech;

    foreach class'ExpandedFoundryMod'.default.arrFoundryTechs(kTech)
    {
        iLocIndex = kTech.iTechId - class'ExpandedFoundryMod'.default.ModIDRange.MinInclusive;
        kTech.strName = class'ExpandedFoundryMod'.default.FoundryNames[iLocIndex];
        kTech.strSummary = class'ExpandedFoundryMod'.default.FoundrySummaries[iLocIndex];

        Techs.AddItem(kTech);
    }
}