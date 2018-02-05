local aimedShotBar   = true;
local berserkValue   = false;

local function AimedShotStart()
    if (aimedShotBar == true) then
        local aimedShotTime = 3;

        for i=1, 32 do
            if (UnitBuff("player", i) == "Interface\\Icons\\Ability_Warrior_InnerRage") then
                aimedShotTime = aimedShotTime / 1.3;
            end
		        if (UnitBuff("player", i) == "Interface\\Icons\\Ability_Hunter_RunningShot") then
                aimedShotTime = aimedShotTime / 1.4;
            end
            if (UnitBuff("player", i) == "Interface\\Icons\\Racial_Troll_Berserk") then
                aimedShotTime = aimedShotTime / berserkValue;
            end
            if (UnitBuff("player", i) == "Interface\\Icons\\Inv_Trinket_Naxxramas04") then
                aimedShotTime = aimedShotTime / 1.2;
            end
        end

		    CastingBarFrameStatusBar:SetStatusBarColor(1.0, 0.7, 0.0);
		    CastingBarSpark:Show();

		    CastingBarFrame.startTime = GetTime();
		    CastingBarFrame.maxValue  = CastingBarFrame.startTime + aimedShotTime;
		    CastingBarFrameStatusBar:SetMinMaxValues(CastingBarFrame.startTime, CastingBarFrame.maxValue);
		    CastingBarFrameStatusBar:SetValue(CastingBarFrame.startTime);

		    CastingBarText:SetText("Aimed Shot   "..string.format("%.2f",aimedShotTime));

		    CastingBarFrame:SetAlpha(1.0);
		    CastingBarFrame.holdTime = 0;
		    CastingBarFrame.casting = 1;
		    CastingBarFrame.fadeOut = nil;
		    CastingBarFrame:Show();
		    CastingBarFrame.mode = "casting";
    end
end

local function CheckBerserk()
    for i = 1, 16 do
        if (UnitBuff("player",i) == "Interface\\Icons\\Racial_Troll_Berserk") then
            if (berserkValue == false) then
                if((UnitHealth("player")/UnitHealthMax("player")) >= 0.40) then
                    berserkValue = 1 + ((1.30 - (UnitHealth("player") / UnitHealthMax("player"))) / 3);
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

    HunterSwissKnifeCore_PrintToChat(HSK_CYA.."AimedShotTracker Module |rLoaded");
end


HunterSwissKnifeModule_AimedShotTracker_OnEvent = {}

HunterSwissKnifeModule_AimedShotTracker_OnEvent["UNIT_AURA"] = function()
    CheckBerserk();
end


function HunterSwissKnifeModule_AimedShotTracker_OnCastSpell(spellId, spellTab)
    if (GetSpellName(spellId,"BOOKTYPE_SPELL") == "Aimed Shot") then
        AimedShotStart();
    end
end


HunterSwissKnifeModule_AimedShotTracker_OnCastSpellByName = {}

HunterSwissKnifeModule_AimedShotTracker_OnCastSpellByName["Aimed Shot"] = function(spellName)
    AimedShotStart();
end


HunterSwissKnifeModule_AimedShotTracker_OnAction = {}

HunterSwissKnifeModule_AimedShotTracker_OnAction["Aimed Shot"] = function(slot, checkFlags, checkSelf)
    AimedShotStart();
end
