HunterSwissKnife_EventHandlers = {}


HunterSwissKnife_EventHandlers["UNIT_AURA"] = function()
    if arg1 ~= "player" then 
        HunterSwissKnife_Core_CheckDaze(arg1);
    end
end


HunterSwissKnife_EventHandlers["COMBAT_TEXT_UPDATE"] = function()
    if arg1 == "AURA_START_HARMFUL" then 
        HunterSwissKnife_Core_CheckDaze("player");
    end
end


-- HunterSwissKnife_EventHandlers["PLAYER_AURAS_CHANGED"] = function()
--     -- HunterSwissKnife_Core_PrintToChat("PLAYERS AURAS CHANGED TRIGGER");
-- end