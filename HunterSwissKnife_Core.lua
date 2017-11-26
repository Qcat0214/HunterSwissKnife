function HunterSwissKnife_Core_PrintToChat(text)
    DEFAULT_CHAT_FRAME:AddMessage(text);
end


function HunterSwissKnife_Core_IsAuraActive(auraName, unit, trackInBuffs, trackInDebuffs)
    if not (auraName) then return end
    if not (unit) then unit = "player" end
    if not (trackInBuffs) then trackInBuffs = true end
    if not (trackInDebuffs) then trackInDebuffs = true end

    local it= 0;
    if unit == "player" then
        while (trackInBuffs) do
            local buffIndex = GetPlayerBuff(it);
            if (buffIndex == -1) then break end

            if (string.find(GetPlayerBuffTexture(buffIndex), auraName)) then
                return it;
            end

            it = it + 1;
        end
    else
        while (trackInBuffs) do
            local buffTexture = UnitBuff(unit, it+1);
            if not (buffTexture) then break end

            if (string.find(buffTexture, auraName)) then
                return it;
            end

            it = it + 1;
        end
    end

    it= 0;
    while (trackInDebuffs) do
        local debuffTexture = UnitDebuff(unit, it+1);
        if not (debuffTexture) then break end

        if (string.find(debuffTexture, auraName)) then
            return it;
        end

        it = it + 1;
    end

    return;
end


function HunterSwissKnife_Core_CancelAura(auraName)
    local auraIndex = HunterSwissKnife_Core_IsAuraActive(auraName, "player", true, false);
    if (auraIndex) then
        CancelPlayerBuff(auraIndex);
    end
end


function HunterSwissKnife_Core_CheckDaze(unit)
    if not ((IsMounted) and UnitIsMounted("player")) then
        if HunterSwissKnife_Core_IsAuraActive(AURA_DAZED, unit, false, true) then
            if unit == "player" then
                HunterSwissKnife_Core_CancelAura(AURA_PACK);
                HunterSwissKnife_Core_CancelAura(AURA_CHEETAH);
            elseif (unit == (string.find(unit,"party%d")) or unit == (string.find(unit,"pet"))) then
                -- TODO: replace with UnitPlayerOrPetInParty("unit")
                -- TODO: replace with UnitPlayerOrPetInRaid("unit")
                HunterSwissKnife_Core_CancelAura(AURA_PACK);
            end
        end
    end
end


function HunterSwissKnife_Core_HasPet()
    local hasUI, isHunterPet = HasPetUI();
    if hasUI and isHunterPet then
        return true
    else
        return false
    end
end