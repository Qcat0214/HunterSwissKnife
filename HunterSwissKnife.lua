function HunterSwissKnife_OnCmd(argument)
    HunterSwissKnifeMenu_OnShow();
end


function HunterSwissKnife_OnLoad()
    --TODO: make conditional RegisterEvent
    --this:RegisterEvent("PLAYER_LOGIN");
    HunterSwissKnifeModule_AntiDaze_OnLoad(this);
    HunterSwissKnifeModule_AimedShotTracker_OnLoad(this);
    HunterSwissKnifeModule_AutoShotTracker_OnLoad(this);

    SlashCmdList["HUNTERSWISSKNIFE"] = HunterSwissKnife_OnCmd;

    HunterSwissKnifeCore_PrintToChat(HSK_GRE..HSK_TITLE.." "..HSK_VERSION.." is loaded");
end


function HunterSwissKnife_OnUpdate()
    if aimedTracker then
        HunterSwissKnifeModule_AimedShotTracker_OnUpdate();
    end
    if autoShotTracker then
        HunterSwissKnifeModule_AutoShotTracker_OnUpdate();
    end
end


function HunterSwissKnife_OnEvent()
    if antiDaze and HunterSwissKnifeModule_AntiDaze_OnEvent[event]then
        HunterSwissKnifeModule_AntiDaze_OnEvent[event](arg1);
    end
    if aimedTracker and HunterSwissKnifeModule_AimedShotTracker_OnEvent[event] then
        HunterSwissKnifeModule_AimedShotTracker_OnEvent[event]();
    end
    if autoShotTracker and HunterSwissKnifeModule_AutoShotTracker_OnEvent[event] then
        HunterSwissKnifeModule_AutoShotTracker_OnEvent[event]();
    end
end


HunterSwissKnife_OriginalCastSpell = CastSpell;
function CastSpell(spellID, spellTab)
    if aimedTracker then
        HunterSwissKnifeModule_AimedShotTracker_OnCastSpell(spellID, spellTab);
    end

    --ORIGINAL CAST: should not be called if triggered and original action are exclusive
    HunterSwissKnife_OriginalCastSpell(spellID, spellTab);
end


HunterSwissKnife_OriginalCastSpellByName = CastSpellByName;
function CastSpellByName(spellName)
    if aimedTracker and HunterSwissKnifeModule_AimedShotTracker_OnCastSpellByName[spellName] then
        HunterSwissKnifeModule_AimedShotTracker_OnCastSpellByName[spellName](spellName);
    end

    --ORIGINAL CAST: should not be called if triggered and original action are exclusive
    HunterSwissKnife_OriginalCastSpellByName(spellName);
end


local actionTooltip = CreateFrame("GameTooltip", "actionTooltip", UIParent, "GameTooltipTemplate");
actionTooltip:SetOwner(UIParent,"ANCHOR_NONE");

HunterSwissKnife_OriginalUseAction = UseAction;
function UseAction(slot, checkFlags, checkSelf)
    actionTooltip:ClearLines();
    actionTooltip:SetAction(slot);
    local spellName = actionTooltipTextLeft1:GetText();

    if aimedTracker and HunterSwissKnifeModule_AimedShotTracker_OnAction[spellName] then
        HunterSwissKnifeModule_AimedShotTracker_OnAction[spellName](slot, checkFlags, checkSelf);
    end

    --ORIGINAL CAST: should not be called if triggered and original action are exclusive
    local isOriginalExcluded = false;
    if permanentAspects and HunterSwissKnifeModule_PermanentAspects_OnAction[spellName] then
        HunterSwissKnifeModule_PermanentAspects_OnAction[spellName](slot, checkFlags, checkSelf);
        isOriginalExcluded = true;
    end
    if autoShotOverride and HunterSwissKnifeModule_PermanentAutoShot_OnAction[spellName] then
        HunterSwissKnifeModule_PermanentAutoShot_OnAction[spellName](slot, checkFlags, checkSelf);
        isOriginalExcluded = true;
    end
    if callPetOverrride and HunterSwissKnifeModule_MultifunctionalCallPet_OnAction[spellName] then
        HunterSwissKnifeModule_MultifunctionalCallPet_OnAction[spellName](slot, checkFlags, checkSelf);
        isOriginalExcluded = true;
    end
    if not isOriginalExcluded then
        HunterSwissKnife_OriginalUseAction(slot, checkFlags, checkSelf);
    end
end