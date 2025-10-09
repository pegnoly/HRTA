while not ASTROLOGY_WEEK_ARHYDEVI do
    sleep()
end

astrology_core = {

    ---@type AstrologyModeWeekType
    current_week = ASTROLOGY_WEEK_SITHIS,

    start_day = 2,

    path = "/Text/HRTA/GameModes/Astrology/",

    ---@type table<AstrologyModeWeekType, string>
    week_type_messages = {
        [ASTROLOGY_WEEK_NARGOTT] = "nargott_week_desc",
        [ASTROLOGY_WEEK_SITHIS] = "sithis_week_desc",
        [ASTROLOGY_WEEK_AUOTOR] = "auotor_week_desc",
        [ASTROLOGY_WEEK_ARHYDEVI] = "arhydevi_week_desc",
        [ASTROLOGY_WEEK_VERY_RARE] = "very_rare_week_desc"
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
        if random(1000) == 765 then
            return ASTROLOGY_WEEK_VERY_RARE
        end
        -- local result = Random.FromSelection(ASTROLOGY_WEEK_NARGOTT, ASTROLOGY_WEEK_SITHIS, ASTROLOGY_WEEK_AUOTOR, ASTROLOGY_WEEK_ARHYDEVI)
        local result = Random.FromSelection(ASTROLOGY_WEEK_SITHIS)
        return result
    end
}