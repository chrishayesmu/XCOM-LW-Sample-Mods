class ArtifactRepair_StrategyListener extends LWCEStrategyListener;

function OnItemsBuilt(out array<LWCE_TItem> arrItems)
{
    local LWCE_TItem kItem;

    foreach class'ArtifactRepairMod'.default.arrRepairItems(kItem)
    {
        arrItems.AddItem(kItem);
    }
}