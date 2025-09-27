MOVE_THREAD_TYPE_DEFAULT = 1
MOVE_THREAD_TYPE_UNLIM = 2
MOVE_THREAD_TYPE_NO_MOVES = 3

unlim_moves_threads = {
    heroes_states = {},

    UnlimMoveThread = 
    function (hero)
        while 1 do
            if unlim_moves_threads.heroes_states[hero] == MOVE_THREAD_TYPE_UNLIM then
                ChangeHeroStat(hero, STAT_MOVE_POINTS, 100000)
            end
            sleep()
        end
    end,

    NoMovesThread = 
    function (hero)
        while 1 do
            if unlim_moves_threads.heroes_states[hero] == MOVE_THREAD_TYPE_NO_MOVES then
                ChangeHeroStat(hero, STAT_MOVE_POINTS, -100000)
            end
            sleep()
        end
    end,

    UpdateMoveThreadType = 
    function (hero, type)
        unlim_moves_threads.heroes_states[hero] = type
    end
}

MapLoadingEvent.AddListener("HRTA_start_move_remove_listener",
function ()
    for _, hero in GetObjectNamesByType("HERO") do
        ChangeHeroStat(hero, STAT_MOVE_POINTS, -100000)
    end
end)

AddHeroEvent.AddListener("HRTA_unlim_move_thread_add_hero_listener",
function (hero)
    unlim_moves_threads.heroes_states[hero] = MOVE_THREAD_TYPE_DEFAULT
    startThread(unlim_moves_threads.UnlimMoveThread, hero)
    startThread(unlim_moves_threads.NoMovesThread, hero)
end)