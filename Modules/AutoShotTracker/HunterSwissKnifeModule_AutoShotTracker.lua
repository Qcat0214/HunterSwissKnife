local AutoShotTrackerFrame = nil;
local AutoShotTrackerBar = nil;

local trackingFrame = {
    ["posX"]   = 0;
    ["posY"]   = -235;
    ["height"] = 12;
    ["width"]  = 100;
}

local shooting       = false;

local aimingStart    = false;
local aimingTime     = 0.65;

local reloadingStart = false;
local reloadingTime

local posX, posY;
local gCooldownStartOld;



function CreateBar()
    trackingFrame["posX"]   = trackingFrame["posX"]   * GetScreenWidth()   / 1000;
    trackingFrame["posY"]   = trackingFrame["posY"]   * GetScreenHeight()  / 1000;
    trackingFrame["height"] = trackingFrame["height"] * GetScreenHeight()  / 1000;
    trackingFrame["width"]  = trackingFrame["width"]  * GetScreenWidth()   / 1000;

    local frame = HunterSwissKnifeModule_AutoShotTracker;
    frame:SetHeight(trackingFrame["height"]);
    frame:SetWidth(trackingFrame["width"]);
    frame:SetPoint("CENTER", UIParent, "CENTER", trackingFrame["posX"], trackingFrame["posY"]);

    local bar = HunterSwissKnifeModule_AutoShotTrackerBar;
    bar:SetHeight(trackingFrame["height"]);

    local borderIn = HunterSwissKnifeModule_AutoShotTrackerBorderIn;
    borderIn:SetHeight(trackingFrame["height"] + 4);
    borderIn:SetWidth(trackingFrame["width"] + 4);

    local borderOut = HunterSwissKnifeModule_AutoShotTrackerBorderOut;
    borderOut:SetHeight(trackingFrame["height"] + 6);
    borderOut:SetWidth(trackingFrame["width"] + 6);

    AutoShotTrackerFrame = frame;
    AutoShotTrackerBar   = bar;
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
		    AutoShotTrackerBar:SetWidth(trackingFrame["width"] * timePassed/aimingTime);
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


function HunterSwissKnifeModule_AutoShotTracker_OnLoad(frame)
    frame:RegisterEvent("SPELLCAST_STOP");
    frame:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");
    frame:RegisterEvent("START_AUTOREPEAT_SPELL");
    frame:RegisterEvent("STOP_AUTOREPEAT_SPELL");
    frame:RegisterEvent("ITEM_LOCK_CHANGED");

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
        AutoShotTrackerBar:SetWidth(trackingFrame["width"] - (trackingFrame["width"] * timePassed/reloadingTime));

        if (timePassed > reloadingTime) then
            if (shooting == true) then
                AimingStart();
            else
                AutoShotTrackerBar:SetWidth(0);
                AutoShotTrackerFrame:SetAlpha(0);
            end

            reloadingStart = false;
        end
    end
end


HunterSwissKnifeModule_AutoShotTracker_OnEvent = {}

HunterSwissKnifeModule_AutoShotTracker_OnEvent["START_AUTOREPEAT_SPELL"] = function()
  GunStart();
end

HunterSwissKnifeModule_AutoShotTracker_OnEvent["STOP_AUTOREPEAT_SPELL"] = function()
  GunStop();
end

HunterSwissKnifeModule_AutoShotTracker_OnEvent["CURRENT_SPELL_CAST_CHANGED"] = function()
    if (reloadingStart == false) then
        AimingStop();
    end
end

HunterSwissKnifeModule_AutoShotTracker_OnEvent["SPELLCAST_STOP"] = function()
    local gCooldownStart, gCooldownTime = CheckGCD();

    if (gCooldownTime == 1.5) then
        gCooldownStartOld = gCooldownStart;
    end
end

HunterSwissKnifeModule_AutoShotTracker_OnEvent["ITEM_LOCK_CHANGED"] = function()
    if (shooting == true) then
        local gCooldownStart, gCooldownTime = CheckGCD();

        if (gCooldownTime ~= 1.5) then
            GunReload();
        elseif (gCooldownStartOld == gCooldownStart) then
            GunReload();
        else
            gCooldownStartOld = gCooldownStart;
        end
    end
end