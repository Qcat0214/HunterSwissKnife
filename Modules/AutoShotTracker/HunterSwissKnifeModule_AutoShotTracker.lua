local AutoShotTrackerFrame = nil;
local AutoShotTrackerBar = nil;

local Table = {
  ["posX"] = 0;
  ["posY"] = -235;
	["Height"] = 15;
	["Width"] = 100;
}

local posX, posY;
local gCooldownStartOld;

local shooting       = false;

local aimingStart    = false;
local aimingTime     = 0.65;

local reloadingStart = false;
local reloadingTime

local aimedShotBar   = true;
local aimedShotStart = false;
local berserkValue   = false;


local function CreateBar()
	Table["posX"]   = Table["posX"]   * GetScreenWidth()  / 1000;
	Table["posY"]   = Table["posY"]   * GetScreenHeight() / 1000;
	Table["Width"]  = Table["Width"]  * GetScreenWidth()  / 1000;
	Table["Height"] = Table["Height"] * GetScreenHeight() / 1000;
	
	local Frame = CreateFrame("Frame", nil, UIParent);
	Frame:SetPoint("CENTER", UIParent, "CENTER", Table["posX"], Table["posY"]);
	Frame:SetHeight(Table["Height"]);
	Frame:SetWidth(Table["Width"]);
	Frame:SetFrameStrata("HIGH");
	Frame:SetAlpha(0);

	local Bar = Frame:CreateTexture(nil, "OVERLAY");
	Bar:SetPoint("CENTER", Frame, "CENTER");
	Bar:SetHeight(Table["Height"]);
	Bar:SetTexture("Interface\\AddOns\\HunterSwissKnife\\Modules\\AutoShotTracker\\Textures\\Bar.tga");

	local Background = Frame:CreateTexture(nil, "ARTWORK");
	Background:SetAllPoints(Frame);
	Background:SetTexture(15/100, 15/100, 15/100, 1);
	
	local Border = Frame:CreateTexture(nil,"BORDER");
	Border:SetPoint("CENTER", Frame, "CENTER");
	Border:SetHeight(Table["Height"] + 3);
	Border:SetWidth(Table["Width"] + 3);
	Border:SetTexture(0, 0, 0);

	local Border = Frame:CreateTexture(nil, "BACKGROUND");
	Border:SetPoint("CENTER", Frame, "CENTER");
	Border:SetHeight(Table["Height"] + 6);
	Border:SetWidth(Table["Width"] + 6);
	Border:SetTexture(1, 1, 1);
	
	AutoShotTrackerFrame = Frame;
	AutoShotTrackerBar   = Bar;
end


local function CheckGCD()
    local spellId = HunterSwissKnifeCore_GetSpellIdByName("Serpent Sting");

    if (spellId) then
        local gCooldownStart, gCooldownTime = GetSpellCooldown(spellId,"BOOKTYPE_SPELL");

        return gCooldownStart, gCooldownTime;
    end
end


local function AimingStart()
	AutoShotTrackerBar:SetVertexColor(1,1,0);
	posX, posY = GetPlayerMapPosition("player");
	aimingStart = GetTime();
end


local function AimingUpdate()
    AutoShotTrackerFrame:SetAlpha(1);
	
	  local timePassed = GetTime() - aimingStart;
	  if ( timePassed > aimingTime ) then
		    aimingStart = false;
	  elseif (reloadingStart == false) then
		    AutoShotTrackerBar:SetWidth(Table["Width"] * timePassed/aimingTime);
	  end
end


local function AimingStop()
	AutoShotTrackerFrame:SetAlpha(0);
	reloadingStart = false;
	AimingStart();
end


local function GunStart()
	AimingStart();
	shooting = true;
end

local function GunStop()
	if (reloadingStart == false) then
		AutoShotTrackerFrame:SetAlpha(0);
	end
	aimingStart = false;
	shooting = false;
end

local function GunReload()
	reloadingTime = UnitRangedDamage("player") - aimingTime;
	AutoShotTrackerBar:SetVertexColor(1,0,0);
	aimingStart = false;
	reloadingStart = GetTime();
end


local function AimedShotStart()
    aimedShotStart = GetTime();
    aimingStart = false;

    if (reloadingStart == false) then
		    AutoShotTrackerFrame:SetAlpha(0);
		end

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


function HunterSwissKnifeModule_AutoShotTracker_OnLoad(frame)
    frame:RegisterEvent("UNIT_AURA");
    frame:RegisterEvent("SPELLCAST_STOP");
    frame:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");
    frame:RegisterEvent("START_AUTOREPEAT_SPELL");
    frame:RegisterEvent("STOP_AUTOREPEAT_SPELL");
    frame:RegisterEvent("ITEM_LOCK_CHANGED");

    CreateBar();
    HunterSwissKnifeCore_PrintToChat(HSK_CYA.."AutoShotTracker Module |rLoaded");
end


function HunterSwissKnifeModule_AutoShotTracker_OnUpdate()
    if (shooting == true) then
        if (aimingStart ~= false) then
            local cposX, cposY = GetPlayerMapPosition("player");

            if (cposX == posX and cposY == posY) then
                AimingUpdate();
            else
                AimingStop();
            end
        end
    end

    if (reloadingStart ~= false) then
        local timePassed = GetTime() - reloadingStart;
        AutoShotTrackerBar:SetWidth(Table["Width"] - (Table["Width"] * timePassed/reloadingTime));

        if (timePassed > reloadingTime) then
            if (shooting == true and aimedShotStart == false) then
                AimingStart();
            else
                AutoShotTrackerBar:SetWidth(0);
                AutoShotTrackerFrame:SetAlpha(0);
            end

            reloadingStart = false;
        end
    end
end


function HunterSwissKnifeModule_AutoShotTracker_OnCastSpell(spellId, spellTab)
    if (GetSpellName(spellId,"BOOKTYPE_SPELL") == "Aimed Shot") then
        AimedShotStart();
    end
end


HunterSwissKnifeModule_AutoShotTracker_OnCastSpellByName = {}

HunterSwissKnifeModule_AutoShotTracker_OnCastSpellByName["Aimed Shot"] = function(spellName)
    AimedShotStart();
end


HunterSwissKnifeModule_AutoShotTracker_OnAction = {}

HunterSwissKnifeModule_AutoShotTracker_OnAction["Aimed Shot"] = function(slot, checkFlags, checkSelf)
    AimedShotStart();
end


HunterSwissKnifeModule_AutoShotTracker_OnEvent = {}

HunterSwissKnifeModule_AutoShotTracker_OnEvent["UNIT_AURA"] = function()
    CheckBerserk();
end

HunterSwissKnifeModule_AutoShotTracker_OnEvent["SPELLCAST_STOP"] = function()
    if (aimedShotStart ~= false) then
        aimedShotStart = false;
    end

    local gCooldownStart, gCooldownTime = CheckGCD();
    if (gCooldownTime == 1.5) then
        gCooldownStartOld = gCooldownStart;
    end
end

HunterSwissKnifeModule_AutoShotTracker_OnEvent["CURRENT_SPELL_CAST_CHANGED"] = function()
    if (reloadingStart == false and aimedShotStart == false) then
        AimingStop();
    end
end

HunterSwissKnifeModule_AutoShotTracker_OnEvent["START_AUTOREPEAT_SPELL"] = function()
  GunStart();
end

HunterSwissKnifeModule_AutoShotTracker_OnEvent["STOP_AUTOREPEAT_SPELL"] = function()
  GunStop();
end

HunterSwissKnifeModule_AutoShotTracker_OnEvent["ITEM_LOCK_CHANGED"] = function()
    if (shooting == true) then
        local gCooldownStart, gCooldownTime = CheckGCD();

        if (aimedShotStart ~= false) then
            AutoShotTrackerFrame:SetAlpha(1);
            AimingStart();
        elseif (gCooldownTime ~= 1.5) then
            GunReload();
        elseif (gCooldownStartOld == gCooldownStart) then
            GunReload();
        else
            gCooldownStartOld = gCooldownStart;
        end
    end
end
