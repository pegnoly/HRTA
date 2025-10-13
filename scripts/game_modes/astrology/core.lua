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

    week_type_names = {
        [ASTROLOGY_WEEK_NARGOTT] = "nargott",
        [ASTROLOGY_WEEK_SITHIS] = "sithis",
        [ASTROLOGY_WEEK_AUOTOR] = "auotor",
        [ASTROLOGY_WEEK_ARHYDEVI] = "arhydevi",
    },

    Select = 
    function (_, _)
        if MCCS_QuestionBoxForPlayers(PLAYER_1, astrology_core.path.."activate.txt") then
            return 1
        else
            return nil
        end
    end,

    SetupHandSelection = 
    function ()
        ControlHeroCustomAbility("Biara", CUSTOM_ABILITY_2, CUSTOM_ABILITY_ENABLED)
        Trigger(CUSTOM_ABILITY_TRIGGER, "astrology_core.HandSelectionActivated")
    end,

    HandSelectionActivated = 
    function (hero, ability_id)
        if ability_id == CUSTOM_ABILITY_2 then
            for week = ASTROLOGY_WEEK_NARGOTT, ASTROLOGY_WEEK_ARHYDEVI do
                local select_msg = astrology_core.path.."select_"..astrology_core.week_type_names[week].."_week.txt"
                if MCCS_QuestionBoxForPlayers(GetObjectOwner(hero), select_msg) then
                    astrology_core.current_week = week
                    Trigger(CUSTOM_ABILITY_TRIGGER, nil)
                    ControlHeroCustomAbility(hero, CUSTOM_ABILITY_2, CUSTOM_ABILITY_NOT_PRESENT)
                    ShowFlyingSign(
                        {astrology_core.path.."week_selected.txt"; week_name = astrology_core.path..astrology_core.week_type_names[week]..".txt"}, 
                        hero,
                        GetObjectOwner(hero),
                        10.0
                    )
                    return
                end
            end
        end
    end,

    GenerateWeek = 
    function ()
        -- if random(1000) == 765 then
        --     return ASTROLOGY_WEEK_VERY_RARE
        -- end
        local result = Random.FromSelection(ASTROLOGY_WEEK_NARGOTT, ASTROLOGY_WEEK_SITHIS, ASTROLOGY_WEEK_AUOTOR, ASTROLOGY_WEEK_ARHYDEVI)
        -- local result = Random.FromSelection(ASTROLOGY_WEEK_AUOTOR)
        return result
    end
}