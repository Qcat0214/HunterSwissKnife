HunterSwissKnife_EventHandlers = {}


HunterSwissKnife_EventHandlers["UNIT_AURA"] = function()
    -- HunterSwissKnife_Core_PrintToChat("UNIT AURA TRIGGER");

    if not ((IsMounted) and UnitIsMounted("player")) then
        if arg1 == "player" and HunterSwissKnife_Core_IsAuraActive(AURA_DAZED, arg1, false, true) then
            HunterSwissKnife_Core_CancelAura(AURA_PACK);
            HunterSwissKnife_Core_CancelAura(AURA_CHEETAH);
        elseif (arg1 == (string.find(arg1,"party%d")) or arg1 == (string.find(arg1,"pet"))) and HunterSwissKnife_Core_IsAuraActive(AURA_DAZED, arg1, false, true) then
            -- TODO: replace with UnitPlayerOrPetInParty("unit")
            -- TODO: replace with UnitPlayerOrPetInRaid("unit")
            HunterSwissKnife_Core_CancelAura(AURA_PACK);
        end
    end
end


-- HunterSwissKnife_EventHandlers["PLAYER_AURAS_CHANGED"] = function()
--     -- HunterSwissKnife_Core_PrintToChat("PLAYERS AURAS CHANGED TRIGGER");
-- end