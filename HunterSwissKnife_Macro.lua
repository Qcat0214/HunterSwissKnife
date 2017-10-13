function HunterSwissKnife_Macro_HasPet()
    local hasUI, isHunterPet = HasPetUI();
    if hasUI and isHunterPet then
        return true
    else
        return false
    end
end


function HunterSwissKnife_Macro_Attack(autoShotSlot)
    if not (autoShotSlot) then return end
    
    if CheckInteractDistance("target", 3) and (not PlayerFrame.inCombat) then
        AttackTarget();
    elseif not(IsAutoRepeatAction(autoShotSlot)) then
        CastSpellByName("Auto Shot");
    end
end


function HunterSwissKnife_Macro_PetAttack()
    if HunterSwissKnife_Macro_HasPet() then
        if GetUnitName("playertarget") and GetUnitName("playertarget") ~= GetUnitName("pettarget") then
            PetAttack();
        else
            PetFollow();
        end   
    else
        CastSpellByName("Call Pet");
    end
end


function HunterSwissKnife_Macro_FreezingTrap()
    CastSpellByName("Freezing Trap");

    if HunterSwissKnife_Macro_HasPet() and HunterSwissKnife_Core_IsAuraActive(AURA_FREEZINGTRAP, "pettarget", false, true) then
        PetFollow();
    end
end


function HunterSwissKnife_Macro_Cheetah()
    if not HunterSwissKnife_Core_IsAuraActive(AURA_CHEETAH, "player", true, false) then
        CastSpellByName("Aspect of the Cheetah");
    end
end


function HunterSwissKnife_Macro_Hawk()
    if not HunterSwissKnife_Core_IsAuraActive(AURA_HAWK, "player", true, false) then
        CastSpellByName("Aspect of the Hawk");
    end
end