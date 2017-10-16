HunterSwissKnife_ActionHandlers = {}


HunterSwissKnife_ActionHandlers["Aspect of the Cheetah"] = function()
    if not HunterSwissKnife_Core_IsAuraActive(AURA_CHEETAH, "player", true, false) then
        CastSpellByName("Aspect of the Cheetah");
    end
end


HunterSwissKnife_ActionHandlers["Aspect of the Hawk"] = function()
    if not HunterSwissKnife_Core_IsAuraActive(AURA_HAWK, "player", true, false) then
        CastSpellByName("Aspect of the Hawk");
    end
end


HunterSwissKnife_ActionHandlers["Aspect of the Monkey"] = function()
    if not HunterSwissKnife_Core_IsAuraActive(AURA_MONKEY, "player", true, false) then
        CastSpellByName("Aspect of the Monkey");
    end
end


HunterSwissKnife_ActionHandlers["Freezing Trap"] = function()
    CastSpellByName("Freezing Trap");

    if HunterSwissKnife_Macro_HasPet() and HunterSwissKnife_Core_IsAuraActive(AURA_FREEZINGTRAP, "pettarget", false, true) then
        PetFollow();
    end
end