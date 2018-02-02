function HunterSwissKnife_OnCmd(argument)
    HunterSwissKnife_Core_PrintToChat(RED_C.."Not implemented yet");
    if (argument == "test") then
        HunterSwissKnife_Core_PrintToChat("Print for test");
    end
end


function HunterSwissKnife_OnLoad()
    SlashCmdList["HUNTERSWISSKNIFE"] = HunterSwissKnife_OnCmd;

    HunterSwissKnife_AntiDaze_OnLoad(this);
    HunterSwissKnife_AutoShotTracker_OnLoad(this);

    HunterSwissKnife_Core_PrintToChat(GRE_C..HUNTERSWISSKNIFE_TITLE.." "..HUNTERSWISSKNIFE_VESRION.." is loaded");
end


function HunterSwissKnife_OnUpdate()
    HunterSwissKnife_AutoShotTracker_OnUpdate();
end


function HunterSwissKnife_OnEvent()
    if HunterSwissKnife_AntiDaze_OnEvent[event] then
        HunterSwissKnife_AntiDaze_OnEvent[event]();
    end
    if HunterSwissKnife_AutoShotTracker_OnEvent[event] then
        HunterSwissKnife_AutoShotTracker_OnEvent[event]();
    end
end


local actionTooltip = CreateFrame("GameTooltip", "actionTooltip", UIParent, "GameTooltipTemplate");
actionTooltip:SetOwner(UIParent,"ANCHOR_NONE");

HunterSwissKnife_OriginalUseAction = UseAction;
function UseAction(slot, checkFlags, checkSelf)
  actionTooltip:ClearLines();
  actionTooltip:SetAction(slot);
  local spellName = actionTooltipTextLeft1:GetText();

  if HunterSwissKnife_AutoShotTracker_OnAction[spellName] then
      HunterSwissKnife_AutoShotTracker_OnAction[spellName](slot, checkFlags, checkSelf);
  end

  --ORIGINAL CAST: should not be called if triggered and original action is exclusive
  if HunterSwissKnife_PermanentAspects_OnAction[spellName] then
      HunterSwissKnife_PermanentAspects_OnAction[spellName](slot, checkFlags, checkSelf);
  else
      HunterSwissKnife_OriginalUseAction(slot, checkFlags, checkSelf);
  end
end


HunterSwissKnife_OriginalCastSpellByName = CastSpellByName;
function CastSpellByName(spellName)
  if HunterSwissKnife_AutoShotTracker_OnCastSpellByName[spellName] then
      HunterSwissKnife_AutoShotTracker_OnCastSpellByName[spellName](spellName);
  end

  --ORIGINAL CAST: should not be called if triggered and original action is exclusive
  HunterSwissKnife_OriginalCastSpellByName(spellName);
end


HunterSwissKnife_OriginalCastSpell = CastSpell;
function CastSpell(spellID, spellTab)
  HunterSwissKnife_AutoShotTracker_OnCastSpell(spellID, spellTab);

  --ORIGINAL CAST: should not be called if triggered and original action is exclusive
  HunterSwissKnife_OriginalCastSpell(spellID, spellTab);
end
