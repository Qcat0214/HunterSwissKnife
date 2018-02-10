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

HunterSwissKnifeModule_PermanentAspects_OnAction["Aspect of the Pack"] = function(slot, checkFlags, checkSelf)
    if not HunterSwissKnifeCore_IsAuraActive(AURA_PACK, "player", true, false) then
        CastSpellByName("Aspect of the Pack");
    end
end

HunterSwissKnifeModule_PermanentAspects_OnAction["Aspect of the Beast"] = function(slot, checkFlags, checkSelf)
    if not HunterSwissKnifeCore_IsAuraActive(AURA_BEAST, "player", true, false) then
        CastSpellByName("Aspect of the Beast");
    end
end

HunterSwissKnifeModule_PermanentAspects_OnAction["Aspect of the Wild"] = function(slot, checkFlags, checkSelf)
    if not HunterSwissKnifeCore_IsAuraActive(AURA_WILD, "player", true, false) then
        CastSpellByName("Aspect of the Wild");
    end
end