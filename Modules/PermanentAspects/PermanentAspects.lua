HunterSwissKnifeModule_PermanentAspects_OnAction = {}

HunterSwissKnifeModule_PermanentAspects_OnAction["Aspect of the Cheetah"] = function(slot, checkFlags, checkSelf)
    if not HunterSwissKnifeCore_IsAuraActive(AURA_CHEETAH, "player", true, false) then
        CastSpellByName("Aspect of the Cheetah");
    end
end

HunterSwissKnifeModule_PermanentAspects_OnAction["Aspect of the Hawk"] = function(slot, checkFlags, checkSelf)
    if not HunterSwissKnifeCore_IsAuraActive(AURA_HAWK, "player", true, false) then
        CastSpellByName("Aspect of the Hawk");
    end
end

HunterSwissKnifeModule_PermanentAspects_OnAction["Aspect of the Monkey"] = function(slot, checkFlags, checkSelf)
    if not HunterSwissKnifeCore_IsAuraActive(AURA_MONKEY, "player", true, false) then
        CastSpellByName("Aspect of the Monkey");
    end
end