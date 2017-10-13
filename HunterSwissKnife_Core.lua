function HunterSwissKnife_Core_PrintToChat(text)
    DEFAULT_CHAT_FRAME:AddMessage(text);
end


function HunterSwissKnife_Core_IsAuraActive(auraName, unit, trackInBuffs, trackInDebuffs)
    if not (auraName) then return end
    if not (unit) then unit = "player" end
    if not (trackInBuffs) then trackInBuffs = true end
    if not (trackInDebuffs) then trackInDebuffs = true end

    local it= 1;
    while (trackInBuffs) do
        local itBuff = UnitBuff(unit, it);
        if not (itBuff) then break end

        if (string.find(itBuff, auraName)) then
            return it-1;
        end

        it = it + 1;
    end

    it= 1;
    while (trackInDebuffs) do
        local itDebuff = UnitDebuff(unit, it);
        if not (itDebuff) then break end

        if (string.find(itDebuff, auraName)) then
            return it-1;
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