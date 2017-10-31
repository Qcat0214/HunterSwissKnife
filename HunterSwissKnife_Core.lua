function HunterSwissKnife_Core_PrintToChat(text)
    DEFAULT_CHAT_FRAME:AddMessage(text);
end


function HunterSwissKnife_Core_IsAuraActive(auraName, unit, trackInBuffs, trackInDebuffs)
    if not (auraName) then return end
    if not (unit) then unit = "player" end
    if not (trackInBuffs) then trackInBuffs = true end
    if not (trackInDebuffs) then trackInDebuffs = true end

    local it= 0;
    while (trackInBuffs) do
        local buffTexture = UnitBuff(unit, it+1);
        if not (buffTexture) then break end

        if (string.find(buffTexture, auraName)) then
            return it;
        end

        it = it + 1;
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