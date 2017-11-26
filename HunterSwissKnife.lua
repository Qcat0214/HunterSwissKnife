function HunterSwissKnife_OnCmd(arg)
    HunterSwissKnife_Core_PrintToChat("|cFFFF0000 Not implemented yet");
    if (arg == "test") then
        HunterSwissKnife_Core_PrintToChat("Print for test");
    end
end


function HunterSwissKnife_OnLoad()
    SlashCmdList["HUNTERSWISSKNIFE"] = HunterSwissKnife_OnCmd;

    this:RegisterEvent( "UNIT_AURA" );
    this:RegisterEvent("COMBAT_TEXT_UPDATE");
    -- this:RegisterEvent( "PLAYER_AURAS_CHANGED" );

    HunterSwissKnife_Core_PrintToChat("|cFFFF0000"..HUNTERSWISSKNIFE_TITLE.." "..HUNTERSWISSKNIFE_VESRION.." is loaded");
end


function HunterSwissKnife_OnEvent()
    HunterSwissKnife_EventHandlers[event](arg1, arg2, arg3, arg4, arg5);
end


local actionTooltip = CreateFrame("GameTooltip", "actionTooltip", UIParent, "GameTooltipTemplate");
actionTooltip:SetOwner(UIParent,"ANCHOR_NONE");

HunterSwissKnife_OriginalUseAction = UseAction;
function UseAction( slot, checkFlags, checkSelf )
  actionTooltip:ClearLines();
  actionTooltip:SetAction(slot);
  local spellName = actionTooltipTextLeft1:GetText();
  -- HunterSwissKnife_Core_PrintToChat(spellName);
  
  if HunterSwissKnife_ActionHandlers[spellName] then
      HunterSwissKnife_ActionHandlers[spellName]();
  else
      HunterSwissKnife_OriginalUseAction( slot, checkFlags, checkSelf );
  end
end