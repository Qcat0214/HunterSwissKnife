function HunterSwissKnife_OnCmd(arg)
    HunterSwissKnife_Core_PrintToChat("|cFFFF0000 Not implemented yet");
    if (arg == "test") then
        HunterSwissKnife_Core_PrintToChat("Print for test");
    end
end


function HunterSwissKnife_OnLoad()
    SlashCmdList["HUNTERSWISSKNIFE"] = HunterSwissKnife_OnCmd;

    this:RegisterEvent( "UNIT_AURA" );
    -- this:RegisterEvent( "PLAYER_AURAS_CHANGED" );

    HunterSwissKnife_Core_PrintToChat("|cFFFF0000"..HUNTERSWISSKNIFE_TITLE.." "..HUNTERSWISSKNIFE_VESRION.." is loaded");
end


function HunterSwissKnife_OnEvent()
    HunterSwissKnife_EventHandlers[event](arg1, arg2, arg3, arg4, arg5);
end