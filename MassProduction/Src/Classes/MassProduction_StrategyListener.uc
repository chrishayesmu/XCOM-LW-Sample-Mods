class MassProduction_StrategyListener extends HighlanderStrategyListener;

var private array<int> arrOutstandingAlerts;

function Override_GetItem(out HL_TItem kItem, int iTransactionType)
{
    kItem.bIsInfinite = kItem.bIsInfinite || IsMassProducible(kItem);
}

function bool Override_GetInfinitePrimary(XGStrategySoldier kSoldier, out int iItemId)
{
    local int iPotentialItemId;

    // Rather than equipping new soldiers with the default ballistic weapons,
    // give them something more advanced if it's already been made infinite
    switch (kSoldier.m_kSoldier.kClass.eWeaponType)
    {
        case eWP_Support:
            iPotentialItemId = FirstMassProducibleOf(`LW_ITEM_ID(PlasmaNovagun), `LW_ITEM_ID(PulseAutoblaster), `LW_ITEM_ID(GaussAutorifle), `LW_ITEM_ID(Autolaser));
        case eWP_Assault:
            iPotentialItemId = FirstMassProducibleOf(`LW_ITEM_ID(ReflexRifle), `LW_ITEM_ID(ScatterBlaster), `LW_ITEM_ID(AlloyCannon), `LW_ITEM_ID(ScatterLaser));
        case eWP_Sniper:
            iPotentialItemId = FirstMassProducibleOf(`LW_ITEM_ID(PlasmaSniperRifle), `LW_ITEM_ID(PulseSniperRifle), `LW_ITEM_ID(GaussLongRifle), `LW_ITEM_ID(LaserSniperRifle));
        case eWP_Integrated:
            iPotentialItemId = FirstMassProducibleOf(`LW_ITEM_ID(SuperheavyPlasma), `LW_ITEM_ID(SuperheavyPulser), `LW_ITEM_ID(SentryGun), `LW_ITEM_ID(SuperheavyLaser));
        case eWP_Mec:
            iPotentialItemId = FirstMassProducibleOf(`LW_ITEM_ID(ParticleCannon), `LW_ITEM_ID(PulseLance), `LW_ITEM_ID(Railgun), `LW_ITEM_ID(LaserLance));
        default:
            iPotentialItemId = FirstMassProducibleOf(`LW_ITEM_ID(PlasmaRifle), `LW_ITEM_ID(PulseRifle), `LW_ITEM_ID(GaussRifle), `LW_ITEM_ID(LaserRifle));
    }

    if (iPotentialItemId > 0)
    {
        iItemId = iPotentialItemId;
        return true;
    }

    return false;
}

function bool Override_GetInfiniteSecondary(XGStrategySoldier kSoldier, out int iItemId)
{
    local int iPotentialItemId;

    if (kSoldier.HasPerk(`LW_PERK_ID(FireRocket)))
    {
        iPotentialItemId = FirstMassProducibleOf(`LW_ITEM_ID(BlasterLauncher), `LW_ITEM_ID(RecoillessRifle));
    }
    else
    {
        iPotentialItemId = FirstMassProducibleOf(`LW_ITEM_ID(PlasmaPistol), `LW_ITEM_ID(LaserPistol));
    }

    if (iPotentialItemId > 0)
    {
        iItemId = iPotentialItemId;
        return true;
    }

    return false;
}

function OnItemCompleted(HL_TItemProject kItemProject, int iQuantity, optional bool bInstant)
{
    local int iAlertId, iCurrentQuantity, iPreviousQuantity, iThreshold;
    local Highlander_XGGeoscape kGeoscape;
    local Highlander_XGStorage kStorage;
    local HL_TItem kItem;

    kGeoscape = `HL_GEOSCAPE;
    kStorage = `HL_STORAGE;
    kItem = `HL_ITEM(kItemProject.iItemId);

    iCurrentQuantity = `HL_UTILS.GetItemQuantity(kStorage.m_arrHLItemArchives, kItemProject.iItemId).iQuantity;
    iPreviousQuantity = iCurrentQuantity - iQuantity;
    iThreshold = GetMassProductionThreshold(kItem);

    if (iThreshold <= 0)
    {
        return;
    }

    // Don't do anything if we aren't at the threshold, or if we've already been there before
    if (iCurrentQuantity < iThreshold || iPreviousQuantity >= iThreshold)
    {
        return;
    }

    // Trigger a Geoscape alert to inform the player that they've hit the threshold; store the alert ID
    // so that we recognize it when the Highlander calls us to populate the alert data
    iAlertId = kGeoscape.Mod_Alert(kGeoscape.MakeAlert(0, kItem.iItemId));
    arrOutstandingAlerts.AddItem(iAlertId);
}

function PopulateAlert(int iAlertId, TGeoscapeAlert kGeoAlert, out TMCAlert kAlert)
{
    local int iItemId, Index;
    local HL_TItem kItem;
    local TText txtTemp;
    local TMenuOption kReply;

    Index = arrOutstandingAlerts.Find(iAlertId);

    if (Index == INDEX_NONE)
    {
        return;
    }

    arrOutstandingAlerts.Remove(Index, 1);

    iItemId = kGeoAlert.arrData[0];
    kItem = `HL_ITEM(iItemId);

    // TODO: localize
    kAlert.txtTitle.StrValue = "Mass Production Unlocked";
    kAlert.txtTitle.iState = eUIState_Good;
    kAlert.imgAlert.strPath = kItem.ImagePath;

    txtTemp.StrValue = kItem.strName $ ": Mass production threshold reached.\n\nEngineering can provide us with unlimited supplies at no additional cost.";
    txtTemp.iState = eUIState_Highlight;
    kAlert.arrText.AddItem(txtTemp);

    txtTemp.StrValue = "Engineering can provide us with unlimited supplies at no additional cost.";
    kAlert.arrText.AddItem(txtTemp);

    kReply.strText = class'XGMissionControlUI'.default.m_strLabelCarryOn;
    kAlert.mnuReplies.arrOptions.AddItem(kReply);
}

function bool IsMassProducible(HL_TItem kItem)
{
    local int iCurrentQuantity, iThreshold;

    // Don't apply to artifacts, corpses, or captives
    if (kItem.iCategory == 5 || kItem.iCategory == 6)
    {
        return false;
    }

    if (kItem.iItemId == `LW_ITEM_ID(Interceptor) || kItem.iItemId == `LW_ITEM_ID(Firestorm))
    {
        return false;
    }

    // Check threshold config: negative values mean the item can never be mass produced
    iThreshold = GetMassProductionThreshold(kItem);

    if (iThreshold < 0)
    {
        return false;
    }

    iCurrentQuantity = `HL_UTILS.GetItemQuantity(`HL_STORAGE.m_arrHLItemArchives, kItem.iItemId).iQuantity;

    return iCurrentQuantity >= iThreshold;
}

/// <summary>A simple function that returns the first of the four given item IDs that can be mass-produced already.</summary>
protected function int FirstMassProducibleOf(int Id1, int Id2, int Id3 = 0, int Id4 = 0)
{
    local int Id;
    local array<int> arrIds;
    local HL_TItem kItem;

    arrIds.AddItem(Id1);
    arrIds.AddItem(Id2);
    arrIds.AddItem(Id3);
    arrIds.AddItem(Id4);

    foreach arrIds(Id)
    {
        if (Id == 0)
        {
            continue;
        }

        kItem = `HL_ITEM(Id);

        if (IsMassProducible(kItem))
        {
            return Id;
        }
    }

    return 0;
}

protected function int GetMassProductionThreshold(HL_TItem kItem)
{
    local Highlander_XGItemTree kItemTree;
    local HL_TItemQuantity kCustomThreshold;

    kItemTree = `HL_ITEMTREE;

    foreach class'MassProductionMod'.default.arrProductionThresholdOverrides(kCustomThreshold)
    {
        if (kCustomThreshold.iItemId == kItem.iItemId)
        {
            return kCustomThreshold.iQuantity;
        }
    }

    if (kItem.iCategory != 1 && kItem.iCategory != 2 && kItem.iCategory != 3)
    {
        return class'MassProductionMod'.default.iProductionThresholdGeneral;
    }

    if (kItemTree.IsArmor(kItem.iItemId))
    {
        return class'MassProductionMod'.default.iProductionThresholdArmor;
    }

    if (kItemTree.IsWeapon(kItem.iItemId))
    {
        return class'MassProductionMod'.default.iProductionThresholdWeapons;
    }

    if (kItemTree.IsSmallItem(kItem.iItemId))
    {
        return class'MassProductionMod'.default.iProductionThresholdSmallItems;
    }

    return class'MassProductionMod'.default.iProductionThresholdGeneral;
}