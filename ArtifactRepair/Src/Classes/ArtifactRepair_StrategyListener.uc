class ArtifactRepair_StrategyListener extends HighlanderStrategyListener;

function OnItemsBuilt(out array<HL_TItem> arrItems)
{
    local HL_TItem kItem;

    foreach class'ArtifactRepairMod'.default.arrRepairItems(kItem)
    {
        arrItems.AddItem(kItem);
    }
}