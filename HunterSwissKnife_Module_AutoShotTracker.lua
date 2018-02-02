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


local function HunterSwissKnife_AutoShotTracker_CreateBar()
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
	Bar:SetTexture("Interface\\AddOns\\HunterSwissKnife\\Textures\\Bar.tga");

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


local function HunterSwissKnife_AutoShotTracker_CheckGCD()
    local spellId = HunterSwissKnife_Core_GetSpellIdByName("Serpent Sting");

    if (spellId) then
        local gCooldownStart, gCooldownTime = GetSpellCooldown(spellId,"BOOKTYPE_SPELL");

        return gCooldownStart, gCooldownTime;
    end
end


local function HunterSwissKnife_AutoShotTracker_AimingStart()
	AutoShotTrackerBar:SetVertexColor(1,1,0);
	posX, posY = GetPlayerMapPosition("player");
	aimingStart = GetTime();
end


local function HunterSwissKnife_AutoShotTracker_AimingUpdate()
    AutoShotTrackerFrame:SetAlpha(1);
	
	  local timePassed = GetTime() - aimingStart;
	  if ( timePassed > aimingTime ) then
		    aimingStart = false;
	  elseif (reloadingStart == false) then
		    AutoShotTrackerBar:SetWidth(Table["Width"] * timePassed/aimingTime);
	  end
end


local function HunterSwissKnife_AutoShotTracker_AimingStop()
	AutoShotTrackerFrame:SetAlpha(0);
	reloadingStart = false;
	HunterSwissKnife_AutoShotTracker_AimingStart();
end


local function HunterSwissKnife_AutoShotTracker_GunStart()
	HunterSwissKnife_AutoShotTracker_AimingStart();
	shooting = true;
end

local function HunterSwissKnife_AutoShotTracker_GunStop()
	if (reloadingStart == false) then
		AutoShotTrackerFrame:SetAlpha(0);
	end
	aimingStart = false;
	shooting = false;
end

local function HunterSwissKnife_AutoShotTracker_GunReload()
	reloadingTime = UnitRangedDamage("player") - aimingTime;
	AutoShotTrackerBar:SetVertexColor(1,0,0);
	aimingStart = false;
	reloadingStart = GetTime();
end


local function HunterSwissKnife_AutoShotTracker_AimedShotStart()
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

local function HunterSwissKnife_AutoShotTracker_CheckBerserk()
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


function HunterSwissKnife_AutoShotTracker_OnLoad(frame)
    frame:RegisterEvent("UNIT_AURA");
    frame:RegisterEvent("SPELLCAST_STOP");
    frame:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");
    frame:RegisterEvent("START_AUTOREPEAT_SPELL");
    frame:RegisterEvent("STOP_AUTOREPEAT_SPELL");
    frame:RegisterEvent("ITEM_LOCK_CHANGED");

    HunterSwissKnife_AutoShotTracker_CreateBar();
    HunterSwissKnife_Core_PrintToChat(CYA_C.."AutoShotTracker Module |rLoaded");
end


function HunterSwissKnife_AutoShotTracker_OnUpdate()
    if (shooting == true) then
        if (aimingStart ~= false) then
            local cposX, cposY = GetPlayerMapPosition("player");

            if (cposX == posX and cposY == posY) then
                HunterSwissKnife_AutoShotTracker_AimingUpdate();
            else
                HunterSwissKnife_AutoShotTracker_AimingStop();
            end
        end
    end

    if (reloadingStart ~= false) then
        local timePassed = GetTime() - reloadingStart;
        AutoShotTrackerBar:SetWidth(Table["Width"] - (Table["Width"] * timePassed/reloadingTime));

        if (timePassed > reloadingTime) then
            if (shooting == true and aimedShotStart == false) then
                HunterSwissKnife_AutoShotTracker_AimingStart();
            else
                AutoShotTrackerBar:SetWidth(0);
                AutoShotTrackerFrame:SetAlpha(0);
            end

            reloadingStart = false;
        end
    end
end


function HunterSwissKnife_AutoShotTracker_OnCastSpell(spellId, spellTab)
    if (GetSpellName(spellId,"BOOKTYPE_SPELL") == "Aimed Shot") then
        HunterSwissKnife_AutoShotTracker_AimedShotStart();
    end
end


HunterSwissKnife_AutoShotTracker_OnCastSpellByName = {}

HunterSwissKnife_AutoShotTracker_OnCastSpellByName["Aimed Shot"] = function(spellName)
    HunterSwissKnife_AutoShotTracker_AimedShotStart();
end


HunterSwissKnife_AutoShotTracker_OnAction = {}

HunterSwissKnife_AutoShotTracker_OnAction["Aimed Shot"] = function(slot, checkFlags, checkSelf)
    HunterSwissKnife_AutoShotTracker_AimedShotStart();
end


HunterSwissKnife_AutoShotTracker_OnEvent = {}

HunterSwissKnife_AutoShotTracker_OnEvent["UNIT_AURA"] = function()
    HunterSwissKnife_AutoShotTracker_CheckBerserk();
end

HunterSwissKnife_AutoShotTracker_OnEvent["SPELLCAST_STOP"] = function()
    if (aimedShotStart ~= false) then
        aimedShotStart = false;
    end

    local gCooldownStart, gCooldownTime = HunterSwissKnife_AutoShotTracker_CheckGCD();
    if (gCooldownTime == 1.5) then
        gCooldownStartOld = gCooldownStart;
    end
end

HunterSwissKnife_AutoShotTracker_OnEvent["CURRENT_SPELL_CAST_CHANGED"] = function()
    if (reloadingStart == false and aimedShotStart == false) then
        HunterSwissKnife_AutoShotTracker_AimingStop();
    end
end

HunterSwissKnife_AutoShotTracker_OnEvent["START_AUTOREPEAT_SPELL"] = function()
  HunterSwissKnife_AutoShotTracker_GunStart();
end

HunterSwissKnife_AutoShotTracker_OnEvent["STOP_AUTOREPEAT_SPELL"] = function()
  HunterSwissKnife_AutoShotTracker_GunStop();
end

HunterSwissKnife_AutoShotTracker_OnEvent["ITEM_LOCK_CHANGED"] = function()
    if (shooting == true) then
        local gCooldownStart, gCooldownTime = HunterSwissKnife_AutoShotTracker_CheckGCD();

        if (aimedShotStart ~= false) then
            AutoShotTrackerFrame:SetAlpha(1);
            HunterSwissKnife_AutoShotTracker_AimingStart();
        elseif (gCooldownTime ~= 1.5) then
            HunterSwissKnife_AutoShotTracker_GunReload();
        elseif (gCooldownStartOld == gCooldownStart) then
            HunterSwissKnife_AutoShotTracker_GunReload();
        else
            gCooldownStartOld = gCooldownStart;
        end
    end
end
