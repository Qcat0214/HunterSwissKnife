function HunterSwissKnife_Macro_Attack(autoShotSlot)
    if not (autoShotSlot) then return end
    
    if CheckInteractDistance("target", 3) and (not PlayerFrame.inCombat) then
        AttackTarget();
    elseif not(IsAutoRepeatAction(autoShotSlot)) then
        CastSpellByName("Auto Shot");
    end
end


function HunterSwissKnife_Macro_PetAttack()
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