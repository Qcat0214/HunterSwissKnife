HunterSwissKnife_PermanentAspects_OnAction = {}


HunterSwissKnife_PermanentAspects_OnAction["Aspect of the Cheetah"] = function(slot, checkFlags, checkSelf)
    if not HunterSwissKnife_Core_IsAuraActive(AURA_CHEETAH, "player", true, false) then
        CastSpellByName("Aspect of the Cheetah");
    end
end


HunterSwissKnife_PermanentAspects_OnAction["Aspect of the Hawk"] = function(slot, checkFlags, checkSelf)
    if not HunterSwissKnife_Core_IsAuraActive(AURA_HAWK, "player", true, false) then
        CastSpellByName("Aspect of the Hawk");
    end
end


HunterSwissKnife_PermanentAspects_OnAction["Aspect of the Monkey"] = function(slot, checkFlags, checkSelf)
    if not HunterSwissKnife_Core_IsAuraActive(AURA_MONKEY, "player", true, false) then
        CastSpellByName("Aspect of the Monkey");
    end
end


HunterSwissKnife_PermanentAspects_OnAction["Freezing Trap"] = function(slot, checkFlags, checkSelf)
    CastSpellByName("Freezing Trap");

    if (HunterSwissKnife_Core_HasPet() and 
    HunterSwissKnife_Core_IsAuraActive(AURA_FREEZINGTRAP, "pettarget", false, true)) then
        PetFollow();
    end
end


HunterSwissKnife_PermanentAspects_OnAction["Auto Shot"] = function(slot, checkFlags, checkSelf)
    if CheckInteractDistance("target", 3) and (not PlayerFrame.inCombat) then
        AttackTarget();
    elseif not(IsAutoRepeatAction(slot)) then
        CastSpellByName("Auto Shot");
    end
end


HunterSwissKnife_PermanentAspects_OnAction["Call Pet"] = function(slot, checkFlags, checkSelf)
    if HunterSwissKnife_Core_HasPet() then
        if GetUnitName("playertarget") and GetUnitName("playertarget") ~= GetUnitName("pettarget") then
            PetAttack();
        else
            PetFollow();
        end   
    else
        CastSpellByName("Call Pet");
    end
end
