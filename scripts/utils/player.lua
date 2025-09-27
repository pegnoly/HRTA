players_utils = {
    default_heroes = {},
    
    GetPlayerDefaultHero = 
    function (player)
        local result = players_utils.default_heroes[player]
        return result
    end
}

MapLoadingEvent.AddListener("HRTA_players_utils_map_loading_listener",
function ()
    for player = PLAYER_1, PLAYER_2 do
        players_utils.default_heroes[player] = GetPlayerHeroes(player)[0]
    end
end)