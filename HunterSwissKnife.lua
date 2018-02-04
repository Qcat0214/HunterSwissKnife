function HunterSwissKnife_OnCmd(argument)
    -- HunterSwissKnifeMenu_OnShow();
end


function HunterSwissKnife_OnLoad()
    SlashCmdList["HUNTERSWISSKNIFE"] = HunterSwissKnife_OnCmd;

    HunterSwissKnifeModule_AntiDaze_OnLoad(this);
    HunterSwissKnifeModule_AutoShotTracker_OnLoad(this);

    HunterSwissKnifeCore_PrintToChat(HSK_GRE..HSK_TITLE.." "..HSK_VERSION.." is loaded");
end


function HunterSwissKnife_OnUpdate()
    HunterSwissKnifeModule_AutoShotTracker_OnUpdate();
end


function HunterSwissKnife_OnEvent()
    if HunterSwissKnifeModule_AntiDaze_OnEvent[event] then
        HunterSwissKnifeModule_AntiDaze_OnEvent[event](arg1);
    end
    if HunterSwissKnifeModule_AutoShotTracker_OnEvent[event] then
        HunterSwissKnifeModule_AutoShotTracker_OnEvent[event]();
    end
end


local actionTooltip = CreateFrame("GameTooltip", "actionTooltip", UIParent, "GameTooltipTemplate");
actionTooltip:SetOwner(UIParent,"ANCHOR_NONE");

HunterSwissKnife_OriginalUseAction = UseAction;
function UseAction(slot, checkFlags, checkSelf)
  actionTooltip:ClearLines();
  actionTooltip:SetAction(slot);
  local spellName = actionTooltipTextLeft1:GetText();

  if HunterSwissKnifeModule_AutoShotTracker_OnAction[spellName] then
      HunterSwissKnifeModule_AutoShotTracker_OnAction[spellName](slot, checkFlags, checkSelf);
  end

  --ORIGINAL CAST: should not be called if triggered and original action is exclusive
  if HunterSwissKnifeModule_PermanentAspects_OnAction[spellName] then
      HunterSwissKnifeModule_PermanentAspects_OnAction[spellName](slot, checkFlags, checkSelf);
  else
      HunterSwissKnife_OriginalUseAction(slot, checkFlags, checkSelf);
  end
end


HunterSwissKnife_OriginalCastSpellByName = CastSpellByName;
function CastSpellByName(spellName)
  if HunterSwissKnifeModule_AutoShotTracker_OnCastSpellByName[spellName] then
      HunterSwissKnifeModule_AutoShotTracker_OnCastSpellByName[spellName](spellName);
  end

  --ORIGINAL CAST: should not be called if triggered and original action is exclusive
  HunterSwissKnife_OriginalCastSpellByName(spellName);
end


HunterSwissKnife_OriginalCastSpell = CastSpell;
function CastSpell(spellID, spellTab)
  HunterSwissKnifeModule_AutoShotTracker_OnCastSpell(spellID, spellTab);

  --ORIGINAL CAST: should not be called if triggered and original action is exclusive
  HunterSwissKnife_OriginalCastSpell(spellID, spellTab);
end
