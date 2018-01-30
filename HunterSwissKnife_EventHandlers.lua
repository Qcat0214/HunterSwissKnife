HunterSwissKnife_EventHandlers = {}


HunterSwissKnife_EventHandlers["UNIT_AURA"] = function()
    if arg1 ~= "player" and (arg1 == (string.find(arg1,"party%d")) or arg1 == (string.find(arg1,"pet"))) then 
        -- TODO: replace with UnitPlayerOrPetInParty("unit")
        -- TODO: replace with UnitPlayerOrPetInRaid("unit")
        if HunterSwissKnife_Core_isDazed(arg1) then
            HunterSwissKnife_Core_CancelAura(AURA_PACK);
        end
    end
end


HunterSwissKnife_EventHandlers["COMBAT_TEXT_UPDATE"] = function()
    if arg1 == "AURA_START_HARMFUL" then 
        if HunterSwissKnife_Core_isDazed("player") then
            HunterSwissKnife_Core_CancelAura(AURA_PACK);
            HunterSwissKnife_Core_CancelAura(AURA_CHEETAH);
        end
    end
end


-- HunterSwissKnife_EventHandlers["PLAYER_AURAS_CHANGED"] = function()
--     -- HunterSwissKnife_Core_PrintToChat("PLAYERS AURAS CHANGED TRIGGER");
-- end