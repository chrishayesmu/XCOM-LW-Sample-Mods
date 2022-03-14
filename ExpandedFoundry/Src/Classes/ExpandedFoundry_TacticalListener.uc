class ExpandedFoundry_TacticalListener extends LWCETacticalListener;

/*
simulated function Override_GetTWeapon(out CE_TWeapon kWeapon)
{
    if (kWeapon.iItemId != `LW_ITEM_ID(Medikit))
    {
        return;
    }

    if (`CE_UTILS.IsFoundryTechResearched(class'ExpandedFoundryMod'.const.FoundryID_ImprovedMedikitII))
    {
        if (kWeapon.arrAbilities.Find(eAbility_Revive) == INDEX_NONE)
        {
            //`EF_LOG_CLS("Adding eAbility_Revive to Medikit"); // TODO remove stabilize?
            kWeapon.arrAbilities.AddItem(eAbility_Revive);
        }
    }
}

simulated function OnAbilitiesBuilt(array<TAbility> arrAbilities)
{
    ScriptTrace();

    SetTimer(1.0, false, 'CheckForRechargeableBatteries');
}

function OnUpdateItemCharges(XGUnit kUnit)
{
    local TCharacter kChar;

    kChar = kUnit.GetCharacter().m_kChar;

    if (kChar.iType != eChar_Soldier && kChar.iType != eChar_Tank)
    {
        return;
    }

    if (kChar.eClass == eSC_Mec)
    {
        return;
    }

    if (!class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(kChar.kInventory, `LW_ITEM_ID(MotionTracker)))
    {
        return;
    }

    if (`CE_TAC_CARGO.HasFoundryTech(class'ExpandedFoundryMod'.const.FoundryID_RechargeableTrackers))
    {
        kUnit.SetProximityMines(999999);
    }
    else if (`CE_TAC_CARGO.HasFoundryTech(class'ExpandedFoundryMod'.const.FoundryID_EleriumBatteries))
    {
        kUnit.SetProximityMines(kUnit.GetProximityMines() + 1);
    }
}

function OnVolumeCreated(XGVolume kVolume)
{
    if (kVolume.GetType() != eVolume_Spy)
    {
        return;
    }

    if (!`CE_TAC_CARGO.HasFoundryTech(class'ExpandedFoundryMod'.const.FoundryID_EleriumBatteries))
    {
        return;
    }

    kVolume.m_iTurnTimer += 2; // TODO config
}

protected function CheckForRechargeableBatteries()
{
    local int Index;
    local LWCE_XGAbilityTree kAbilityTree;

    `EF_LOG_CLS("CheckForRechargeableBatteries: change the following if statement!");
    if (`CE_IS_TAC_GAME)
    {
        // Battle needs to be present so we can get to the cargo and check our Foundry tech
        if (`BATTLE == none)
        {
            SetTimer(0.1, false, 'CheckForRechargeableBatteries');
            return;
        }

        if (!`CE_TAC_CARGO.HasFoundryTech(class'ExpandedFoundryMod'.const.FoundryID_RechargeableTrackers))
        {
            return;
        }
    }
    else
    {
        if (!`CE_ENGINEERING.IsFoundryTechResearched(class'ExpandedFoundryMod'.const.FoundryID_RechargeableTrackers))
        {
            return;
        }
    }

    kAbilityTree = `CE_ABILITYTREE;

    if (kAbilityTree == none)
    {
        `EF_LOG_CLS("Couldn't find an ability tree to reference!");
        return;
    }

    // Give motion tracker a cooldown
    Index = kAbilityTree.m_arrAbilities.Find('iType', 51);

    if (Index == INDEX_NONE)
    {
        `EF_LOG_CLS("Couldn't find Motion Tracker ability (maybe another mod removed it?)");
        return;
    }

    kAbilityTree.m_arrAbilities[Index].iCooldown = 4;
}
     */
