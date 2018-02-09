HunterSwissKnifeModule_PermanentAutoShot_OnAction = {}

HunterSwissKnifeModule_PermanentAutoShot_OnAction["Auto Shot"] = function(slot, checkFlags, checkSelf)
    if CheckInteractDistance("target", 3) and (not PlayerFrame.inCombat) then
        AttackTarget();
    elseif not IsAutoRepeatAction(slot) then
        CastSpellByName("Auto Shot");
    end
end