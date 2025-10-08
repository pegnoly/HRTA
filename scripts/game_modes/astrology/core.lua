while not ASTROLOGY_WEEK_ARHYDEVI do
    sleep()
end

astrology_core = {

    current_week = ASTROLOGY_WEEK_SITHIS,

    start_day = 2,

    path = "/Text/HRTA/GameModes/Astrology/",

    ---@type table<AstrologyModeWeekType, string>
    week_type_messages = {
        [ASTROLOGY_WEEK_NARGOTT] = "nargott_week_desc",
        [ASTROLOGY_WEEK_SITHIS] = "sithis_week_desc",
        [ASTROLOGY_WEEK_AUOTOR] = "auotor_week_desc",
        [ASTROLOGY_WEEK_ARHYDEVI] = "arhydevi_week_desc"
    },

    Select = 
    function (_, _)
        if MCCS_QuestionBoxForPlayers(PLAYER_1, astrology_core.path.."activate.txt") then
            return 1
        else
            return nil
        end
    end,

    GenerateWeek = 
    function ()
        local result = Random.FromSelection(ASTROLOGY_WEEK_NARGOTT, ASTROLOGY_WEEK_SITHIS, ASTROLOGY_WEEK_AUOTOR, ASTROLOGY_WEEK_ARHYDEVI)
        return result
    end
}

NewDayEvent.AddListener("HRTA_astrology_show_selected_week_listener",
function (day)
    if day == astrology_core.start_day then
        local week_type = astrology_core.current_week
        for player = PLAYER_1, PLAYER_2 do
           startThread(MCCS_MessageBoxForPlayers, player, astrology_core.path..astrology_core.week_type_messages[week_type]..".txt")
        end
    end
end)