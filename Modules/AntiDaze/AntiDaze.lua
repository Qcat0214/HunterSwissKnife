function HunterSwissKnifeModule_AntiDaze_OnLoad(frame)
    frame:RegisterEvent("UNIT_AURA");
    frame:RegisterEvent("COMBAT_TEXT_UPDATE");
end


HunterSwissKnifeModule_AntiDaze_OnEvent = {}

HunterSwissKnifeModule_AntiDaze_OnEvent["UNIT_AURA"] = function(arg)
    if arg ~= "player" and (arg == (string.find(arg,"party%d")) or arg == (string.find(arg,"pet"))) then
        -- TODO: replace with UnitPlayerOrPetInParty("unit")
        -- TODO: replace with UnitPlayerOrPetInRaid("unit")
        if HunterSwissKnifeCore_isDazed(arg) then
            HunterSwissKnifeCore_CancelAura(AURA_PACK);
        end
    end
end

HunterSwissKnifeModule_AntiDaze_OnEvent["COMBAT_TEXT_UPDATE"] = function(arg)
    if arg == "AURA_START_HARMFUL" then
        if HunterSwissKnifeCore_isDazed("player") then
            HunterSwissKnifeCore_CancelAura(AURA_PACK);
            HunterSwissKnifeCore_CancelAura(AURA_CHEETAH);
        end
    end
end