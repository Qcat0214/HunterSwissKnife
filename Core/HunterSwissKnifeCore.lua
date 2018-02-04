function HunterSwissKnifeCore_PrintToChat(text)
    DEFAULT_CHAT_FRAME:AddMessage(text);
end


function HunterSwissKnifeCore_IsAuraActive(auraName, unit, trackInBuffs, trackInDebuffs)
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


function HunterSwissKnifeCore_CancelAura(auraName)
    local auraIndex = HunterSwissKnifeCore_IsAuraActive(auraName, "player", true, false);
    if (auraIndex) then
        CancelPlayerBuff(auraIndex);
    end
end


function HunterSwissKnifeCore_isDazed(unit)
    if not ((IsMounted) and UnitIsMounted("player")) then
        if HunterSwissKnifeCore_IsAuraActive(AURA_DAZED, unit, false, true) then
            return true;
        end
    end

    return false;
end


function HunterSwissKnifeCore_HasPet()
    local hasUI, isHunterPet = HasPetUI();
    if hasUI and isHunterPet then
        return true;
    else
        return false;
    end
end


function HunterSwissKnifeCore_GetSpellNameById(spellId)
    return GetSpellName(spellId,"BOOKTYPE_SPELL");
end


function HunterSwissKnifeCore_GetSpellIdByName(spellName, spellPage)
    local whatPage = spellPage;
    if not (spellPage) then whatPage = GetNumSpellTabs() end

    local _, _, offset, numSpells = GetSpellTabInfo(whatPage);
    numSpells = offset + numSpells;
    if not (spellPage) then offset = 0 end

    for spellId = numSpells, offset+1, -1 do
        if GetSpellName(spellId, "BOOKTYPE_SPELL") == spellName then
            return spellId;
        end
    end
end
