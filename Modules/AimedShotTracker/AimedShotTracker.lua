local berserkValue   = false;

local aimedStart     = false;
local posX, posY;


local function AimedShotStart()
    local aimedShotTime = 3;

    for i = 1, 32 do
        if UnitBuff("player", i) == "Interface\\Icons\\Ability_Warrior_InnerRage" then
            aimedShotTime = aimedShotTime / 1.3;
        end
        if UnitBuff("player", i) == "Interface\\Icons\\Ability_Hunter_RunningShot" then
            aimedShotTime = aimedShotTime / 1.4;
        end
        if UnitBuff("player", i) == "Interface\\Icons\\Racial_Troll_Berserk" then
            aimedShotTime = aimedShotTime / berserkValue;
        end
        if UnitBuff("player", i) == "Interface\\Icons\\Inv_Trinket_Naxxramas04" then
            aimedShotTime = aimedShotTime / 1.2;
        end
    end


    CastingBarFrame.startTime = GetTime();
    CastingBarFrame.maxValue  = CastingBarFrame.startTime + aimedShotTime;
    CastingBarFrame.mode      = "casting";
    CastingBarFrame.casting   = 1;
    CastingBarFrame.holdTime  = 0;
    CastingBarFrame.fadeOut   = nil;

    CastingBarFrameStatusBar:SetStatusBarColor(1.0, 0.7, 0.0);
    CastingBarFrameStatusBar:SetMinMaxValues(CastingBarFrame.startTime, CastingBarFrame.maxValue);
    CastingBarFrameStatusBar:SetValue(CastingBarFrame.startTime);

    CastingBarText:SetText("Aimed Shot   "..string.format("%.2f",aimedShotTime));


    CastingBarFrame:Show();
    CastingBarFrameStatusBar:Show();
    CastingBarSpark:Show();

    posX, posY = GetPlayerMapPosition("player");
    aimedStart = true;
end


local function AimedShotStop()
    CastingBarFrame:Hide();
    CastingBarFrameStatusBar:Hide();
    CastingBarSpark:Hide();

    aimedStart = false;
end


local function CheckBerserk()
    for i = 1, 16 do
        if UnitBuff("player",i) == "Interface\\Icons\\Racial_Troll_Berserk" then
            if not berserkValue then
                local healthRatio = UnitHealth("player") / UnitHealthMax("player");

                if healthRatio >= 0.40 then
                    berserkValue = 1 + ((1.30 - healthRatio) / 3);
                else
                    berserkValue = 1.30;
                end
            end

            return;
        end
    end

    berserkValue = false;
end


function HunterSwissKnifeModule_AimedShotTracker_OnLoad(frame)
    frame:RegisterEvent("UNIT_AURA");

    frame:RegisterEvent("SPELLCAST_STOP");
    frame:RegisterEvent("SPELLCAST_FAILED");
    frame:RegisterEvent("SPELLCAST_INTERRUPTED");

    HunterSwissKnifeCore_PrintToChat(HSK_CYA.."AimedShotTracker Module |rLoaded");
end


function HunterSwissKnifeModule_AimedShotTracker_OnUpdate()
    if aimedStart then
        local cposX, cposY = GetPlayerMapPosition("player");

        if not (cposX == posX and cposY == posY) then
            AimedShotStop();
        end
    end
end


HunterSwissKnifeModule_AimedShotTracker_OnEvent = {}

HunterSwissKnifeModule_AimedShotTracker_OnEvent["UNIT_AURA"] = function()
    CheckBerserk();
end

HunterSwissKnifeModule_AimedShotTracker_OnEvent["SPELLCAST_STOP"] = function()
    AimedShotStop();
end

HunterSwissKnifeModule_AimedShotTracker_OnEvent["SPELLCAST_FAILED"] = function()
    AimedShotStop();
end

HunterSwissKnifeModule_AimedShotTracker_OnEvent["SPELLCAST_INTERRUPTED"] = function()
    AimedShotStop();
end


HunterSwissKnifeModule_AimedShotTracker_OnAction = {}

HunterSwissKnifeModule_AimedShotTracker_OnAction["Aimed Shot"] = function(slot, checkFlags, checkSelf)
    AimedShotStart();
end


HunterSwissKnifeModule_AimedShotTracker_OnCastSpellByName = {}

HunterSwissKnifeModule_AimedShotTracker_OnCastSpellByName["Aimed Shot"] = function(spellName)
    AimedShotStart();
end


function HunterSwissKnifeModule_AimedShotTracker_OnCastSpell(spellId, spellTab)
    if GetSpellName(spellId,"BOOKTYPE_SPELL") == "Aimed Shot" then
        AimedShotStart();
    end
end