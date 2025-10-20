---@alias LevelCostDecorator fun(hero: string, cost: number): number

leveling = {
    current_iteration_for_hero = {},

    current_additional_level_for_hero = {},

    ---@type table<string, LevelCostDecorator>
    level_cost_modifiers = {},

    StartLeveling = 
    function (hero)
        local player = GetObjectOwner(hero)
        local main_hero = players_utils.GetPlayerMainHero(player)
        if main_hero and main_hero ~= hero then
            startThread(MCCS_MessageBoxForPlayers, player, leveling_core.path.."not_main_hero.txt")
            return
        end

        local iteration = leveling.current_iteration_for_hero[hero]
        if iteration == 1 then
            local race = players_utils.GetPlayerSelectedRace(player)
            if MCCS_QuestionBoxForPlayers(player, leveling_core.path.."start_learning_"..race..".txt") then
                players_utils.main_heroes[player] = hero
                leveling.current_iteration_for_hero[hero] = iteration + 1
                startThread(leveling.GiveLevel, hero, iteration)
                return
            end
        end

        if iteration == 2 and MCCS_QuestionBoxForPlayers(player, leveling_core.path.."continue_learning.txt") then
            leveling.current_additional_level_for_hero[hero] = leveling_core.base_additional_level
            leveling.current_iteration_for_hero[hero] = iteration + 1
            startThread(leveling.GiveLevel, hero, iteration)
            return
        end

        startThread(leveling.PurchaseLevel, hero, player)
    end,

    GiveLevel = 
    function (hero, iteration)
        local current_level = GetHeroLevel(hero)
        GiveExp(hero, Levels[leveling_core.iterations[iteration]] - (current_level == 1 and 0 or Levels[current_level]))
    end,

    PurchaseLevel = 
    function (hero, player)
        local level_to_purchase = leveling.current_additional_level_for_hero[hero]
        if level_to_purchase == -1 then
            startThread(MCCS_MessageBoxForPlayers, player, leveling_core.path.."already_max_level.txt")
            return
        end
        local base_cost = leveling_core.levels_cost[level_to_purchase]
        local calculated_cost = base_cost
        ---@param modifier LevelCostDecorator
        for _, modifier in leveling.level_cost_modifiers do
            calculated_cost = modifier(hero, calculated_cost)
        end
        local current_gold = GetPlayerResource(player, GOLD)
        if current_gold < calculated_cost then
            startThread(
                MCCS_MessageBoxForPlayers,
                player,
                {leveling_core.path.."not_enough_gold_to_buy_level.txt"; amount = calculated_cost - current_gold, level = level_to_purchase}
            )
            return
        end
        if MCCS_QuestionBoxForPlayers(player, {leveling_core.path.."buy_level.txt"; level = level_to_purchase, amount = calculated_cost}) then
            local next_level = level_to_purchase == leveling_core.max_additional_level and -1 or level_to_purchase + 1
            leveling.current_additional_level_for_hero[hero] = next_level
            SetPlayerResource(player, GOLD, current_gold - calculated_cost)
            LevelUpHero(hero)
            return
        end
    end
}

AddHeroEvent.AddListener("HRTA_leveling_init_hero_listener",
function (hero)
    leveling.current_iteration_for_hero[hero] = 1
end)