players_utils = {
    default_heroes = {},
    main_heroes = {},
    races = {},
    
    GetPlayerDefaultHero = 
    -- Возвращает базового героя игрока
    ---@param player PlayerID Id игрока
    ---@return string result
    function (player)
        local result = players_utils.default_heroes[player]
        return result
    end,

    GetPlayerSelectedRace = 
    -- Возвращает расу игрока
    ---@param player PlayerID Id игрока
    ---@return TownType result
    function (player)
        local result = players_utils.races[player]
        return result
    end,

    GetPlayerMainHero =
    -- Возвращает мейн героя игрока
    ---@param player PlayerID Id игрока
    ---@return string result
    function (player)
        local result = players_utils.main_heroes[player]
        return result
    end
}

MapLoadingEvent.AddListener("HRTA_players_utils_map_loading_listener",
function ()
    for player = PLAYER_1, PLAYER_2 do
        players_utils.default_heroes[player] = GetPlayerHeroes(player)[0]
    end
end)