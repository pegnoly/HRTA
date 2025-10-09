while not (GAME_MODE_ASTROLOGY and astrology_core) do
    sleep()
end

game_modes_core = {
    path = "/Text/HRTA/GameModes/",

    ---@type GameModeType
    current_mode = GAME_MODE_DEFAULT,

    TouchActivator = 
    function (hero, object)
        if astrology_core.Select(hero, object) then
            game_modes_core.current_mode = GAME_MODE_ASTROLOGY
            -- GAME_MODE.MIX = 1
            -- GAME_MODE.SIMPLE_CHOOSE = nil
            local week = astrology_core.GenerateWeek()
            astrology_core.current_week = week
            removeHeroMovePoints(Biara)
            removeHeroMovePoints(Djovanni)
            -- RemoveObject('mumiya')
            -- RemoveObject('golem')
            SetObjectPosition('red10', 35, 83, GROUND)
            -- deleteAllDelimeters()
            -- deleteAllRacesUnit()
            -- doFile(PATH_TO_DAY1_MODULE.."choice_of_races/mix.lua")
        end
    end
}