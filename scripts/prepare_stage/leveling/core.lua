-- Прокачка. Константы и базовые функции.

leveling_core = {

    path = "Text/HRTA/PrepareStage/Leveling/",

    ---@type number []
    -- Уровень, выдаваемый за итерацию кача
    iterations = { 9, 18 },

    base_additional_level = 19,
    max_additional_level = 25,

    levels_cost = {
        [19] = 7500,
        [20] = 8000,
        [21] = 8500,
        [22] = 9000,
        [23] = 10000,
        [24] = 10500,
        [25] = 11000
    },

    TouchLevelingPlace = 
    function (hero, _)
        startThread(leveling.StartLeveling, hero)
    end,

    Init =
    function ()
        for player = PLAYER_1, PLAYER_2 do
            Touch.DisableObject(
                "leveling_place_"..player, 
                DISABLED_DEFAULT, 
                leveling_core.path.."learning_place_name.txt",
                leveling_core.path.."learning_place_desc.txt"
            )
            Touch.SetFunction("leveling_place_"..player, "_touch", leveling_core.TouchLevelingPlace)
        end
    end
}

MapLoadingEvent.AddListener("HRTA_leveling_init_listener",
function ()
    startThread(leveling_core.Init)
end)