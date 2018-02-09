local AutoShotTrackerFrame;
local AutoShotTrackerBar;

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
local reloadingTime;

local posX, posY;
local gCooldownStartOld;


local function CheckGCD()
    local spellId = HunterSwissKnifeCore_GetSpellIdByName("Serpent Sting");

    if spellId then
        local gCooldownStart, gCooldownTime = GetSpellCooldown(spellId,"BOOKTYPE_SPELL");

        return gCooldownStart, gCooldownTime;
    end
end


local function GunReset()
    AutoShotTrackerBar:SetVertexColor(1,1,0);

    reloadingStart = false;
    posX, posY     = GetPlayerMapPosition("player");

    aimingStart    = GetTime();
end


local function GunReload()
    AutoShotTrackerBar:SetVertexColor(1,0,0);

    reloadingStart = GetTime();
    reloadingTime  = UnitRangedDamage("player") - aimingTime;

    aimingStart    = false;
end


function HunterSwissKnifeModule_AutoShotTracker_CreateBar()
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


function HunterSwissKnifeModule_AutoShotTracker_OnLoad(frame)
    frame:RegisterEvent("START_AUTOREPEAT_SPELL");
    frame:RegisterEvent("STOP_AUTOREPEAT_SPELL");

    frame:RegisterEvent("SPELLCAST_STOP");
    frame:RegisterEvent("ITEM_LOCK_CHANGED");

    HunterSwissKnifeCore_PrintToChat(HSK_CYA.."AutoShotTracker Module |rLoaded");
end


function HunterSwissKnifeModule_AutoShotTracker_OnUpdate()
    if not reloadingStart then
        if shooting then
            local cposX, cposY = GetPlayerMapPosition("player");

            if cposX == posX and cposY == posY then
                AutoShotTrackerFrame:SetAlpha(1);

                local timePassed = GetTime() - aimingStart;
                if timePassed <= aimingTime then
                    AutoShotTrackerBar:SetWidth(trackingFrame["width"] * timePassed/aimingTime);
                end
            else
                AutoShotTrackerFrame:SetAlpha(0);
                GunReset();
            end
        end
    else
        local timePassed = GetTime() - reloadingStart;
        if timePassed <= reloadingTime then
            AutoShotTrackerBar:SetWidth(trackingFrame["width"] - (trackingFrame["width"] * timePassed/reloadingTime));
        else
            if not shooting then
                AutoShotTrackerFrame:SetAlpha(0);
                AutoShotTrackerBar:SetWidth(0);
            end
            GunReset();
        end
    end
end


HunterSwissKnifeModule_AutoShotTracker_OnEvent = {}

HunterSwissKnifeModule_AutoShotTracker_OnEvent["START_AUTOREPEAT_SPELL"] = function()
    shooting = true;
    aimingStart = GetTime();
end

HunterSwissKnifeModule_AutoShotTracker_OnEvent["STOP_AUTOREPEAT_SPELL"] = function()
    shooting = false;
    aimingStart = false;

    if not reloadingStart then
        AutoShotTrackerFrame:SetAlpha(0);
    end
end

HunterSwissKnifeModule_AutoShotTracker_OnEvent["SPELLCAST_STOP"] = function()
    local gCooldownStart, gCooldownTime = CheckGCD();

    if gCooldownTime == 1.5 then
        gCooldownStartOld = gCooldownStart;
    end
end

HunterSwissKnifeModule_AutoShotTracker_OnEvent["ITEM_LOCK_CHANGED"] = function()
    if shooting then
        local gCooldownStart, gCooldownTime = CheckGCD();

        if gCooldownTime ~= 1.5 then
            GunReload();
        elseif gCooldownStartOld == gCooldownStart then
            GunReload();
        else
            gCooldownStartOld = gCooldownStart;
        end
    end
end