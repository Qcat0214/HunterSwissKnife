HunterSwissKnifeModule_MultifunctionalCallPet_OnAction = {}

HunterSwissKnifeModule_MultifunctionalCallPet_OnAction["Call Pet"] = function(slot, checkFlags, checkSelf)
    if HunterSwissKnifeCore_HasPet() then
        if GetUnitName("playertarget") and GetUnitName("playertarget") ~= GetUnitName("pettarget") then
            PetAttack();
        else
            PetFollow();
        end
    else
        CastSpellByName("Call Pet");
    end
end