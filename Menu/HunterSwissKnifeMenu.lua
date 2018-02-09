local defaultPermanentAspects = true;
local defaultAntiDaze         = true;
local defaultAimedTracker     = true;
local defaultAutoShotTracker  = true;
local defaultAutoShotOverride = true;
local defaultCallPetOverrride = true;

permanentAspects = defaultPermanentAspects;
antiDaze         = defaultAntiDaze;
aimedTracker     = defaultAimedTracker;
autoShotTracker  = defaultAutoShotTracker;
autoShotOverride = defaultAutoShotOverride;
callPetOverrride = defaultCallPetOverrride;


-- GetChecked returns nil if unchecked, so the wrapper function is necessary
local function CheckBoxIsEnabled(checkButtonFrame)
    return checkButtonFrame:GetChecked() and true or false;
end


local function CheckBoxIsChanged()
    if not (
        permanentAspects == CheckBoxIsEnabled(HunterSwissKnifeMenuPermanentAspects) and
        antiDaze         == CheckBoxIsEnabled(HunterSwissKnifeMenuAntiDaze) and
        aimedTracker     == CheckBoxIsEnabled(HunterSwissKnifeMenuAimedTracker) and
        autoShotTracker  == CheckBoxIsEnabled(HunterSwissKnifeMenuAutoShotTracker) and
        autoShotOverride == CheckBoxIsEnabled(HunterSwissKnifeMenuPermanentAutoShot) and
        callPetOverrride == CheckBoxIsEnabled(HunterSwissKnifeMenuMultifunctionalCallPet))
    then
        return true;
    else
        return false;
    end
end


local function CheckBoxIsDefault()
    if  defaultPermanentAspects == CheckBoxIsEnabled(HunterSwissKnifeMenuPermanentAspects) and
        defaultAntiDaze         == CheckBoxIsEnabled(HunterSwissKnifeMenuAntiDaze) and
        defaultAimedTracker     == CheckBoxIsEnabled(HunterSwissKnifeMenuAimedTracker) and
        defaultAutoShotTracker  == CheckBoxIsEnabled(HunterSwissKnifeMenuAutoShotTracker) and
        defaultAutoShotOverride == CheckBoxIsEnabled(HunterSwissKnifeMenuPermanentAutoShot) and
        defaultCallPetOverrride == CheckBoxIsEnabled(HunterSwissKnifeMenuMultifunctionalCallPet)
    then
        return true;
    else
        return false;
    end
end


local function GlobalVarsSetToDefault()
    permanentAspects = defaultPermanentAspects;
    antiDaze         = defaultAntiDaze;
    aimedTracker     = defaultAimedTracker;
    autoShotTracker  = defaultAutoShotTracker;
    autoShotOverride = defaultAutoShotOverride;
    callPetOverrride = defaultCallPetOverrride;
end


local function GlobalVarsSetToCheckBox()
    permanentAspects = CheckBoxIsEnabled(HunterSwissKnifeMenuPermanentAspects);
    antiDaze         = CheckBoxIsEnabled(HunterSwissKnifeMenuAntiDaze);
    aimedTracker     = CheckBoxIsEnabled(HunterSwissKnifeMenuAimedTracker);
    autoShotTracker  = CheckBoxIsEnabled(HunterSwissKnifeMenuAutoShotTracker);
    autoShotOverride = CheckBoxIsEnabled(HunterSwissKnifeMenuPermanentAutoShot);
    callPetOverrride = CheckBoxIsEnabled(HunterSwissKnifeMenuMultifunctionalCallPet);
end


local function CheckBoxSetToGlobalVars()
    HunterSwissKnifeMenuPermanentAspects:SetChecked(permanentAspects);
    HunterSwissKnifeMenuAntiDaze:SetChecked(antiDaze);
    HunterSwissKnifeMenuAimedTracker:SetChecked(aimedTracker);
    HunterSwissKnifeMenuAutoShotTracker:SetChecked(autoShotTracker);
    HunterSwissKnifeMenuPermanentAutoShot:SetChecked(autoShotOverride);
    HunterSwissKnifeMenuMultifunctionalCallPet:SetChecked(callPetOverrride);
end


function HunterSwissKnifeMenu_CheckButton_OnClick()
    if CheckBoxIsChanged() then
        HunterSwissKnifeMenuSave:Enable();
    else
        HunterSwissKnifeMenuSave:Disable();
    end

    if not CheckBoxIsDefault() then
        HunterSwissKnifeMenuDefault:Enable();
    else
        HunterSwissKnifeMenuDefault:Disable();
    end
end


function HunterSwissKnifeMenu_Default_OnClick()
    GlobalVarsSetToDefault();
    CheckBoxSetToGlobalVars();

    HunterSwissKnifeMenu_CheckButton_OnClick();
end


function HunterSwissKnifeMenu_Save_OnClick()
    GlobalVarsSetToCheckBox();

    HunterSwissKnifeMenu:Hide();
end


function HunterSwissKnifeMenu_OnShow()
   CheckBoxSetToGlobalVars();

   HunterSwissKnifeMenu_CheckButton_OnClick();
   HunterSwissKnifeMenu:Show();
end