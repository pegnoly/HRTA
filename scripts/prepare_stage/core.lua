while not PREPARE_STAGE_FIGHT_DAY do
    sleep()
end

prepare_stage_core = {

    active_heroes_count = 2,
    -- Герои игроков, изначально доступные для выбора
    ---@type table<PlayerID, string[]>
    heroes_by_player = {},

    -- Герои игроков, находящиеся в таверне
    ---@type table<PlayerID, string>
    tavern_heroes_by_player = {},

    SpawnHeroes =
    function (player)
        for i, hero in prepare_stage_core.heroes_by_player[player] do
            local name = player == PLAYER_2 and hero.."2" or hero
            local region = "player_"..player.."_hero_"..i.."_spawn"
            DeployReserveHero(name, RegionToPoint(region))
            while not IsObjectExists(name) do
                sleep()
            end
            unlim_moves_threads.UpdateMoveThreadType(name, MOVE_THREAD_TYPE_UNLIM)
        end

        if prepare_stage_core.tavern_heroes_by_player[player] then
            local hero = prepare_stage_core.tavern_heroes_by_player[player]
            local name = player == PLAYER_2 and hero.."2" or hero
            local region = "player_"..player.."_tavern_spawn"
            DeployReserveHero(name, RegionToPoint(region))
            while not IsObjectExists(name) do
                sleep()
            end
            unlim_moves_threads.UpdateMoveThreadType(name, MOVE_THREAD_TYPE_NO_MOVES)
        end
    end
}

NewDayEvent.AddListener("HRTA_prepare_stage_init_listener",
function (day)
    if day == PREPARE_STAGE_LEVELING_DAY then
        for player = PLAYER_1, PLAYER_2 do
            SetObjectOwner("player_"..player.."_main_town", player)
            startThread(prepare_stage_core.SpawnHeroes, player)
            unlim_moves_threads.UpdateMoveThreadType(players_utils.GetPlayerDefaultHero(player), MOVE_THREAD_TYPE_UNLIM)
            startThread(army_generation.Setup)
        end
    end
end)