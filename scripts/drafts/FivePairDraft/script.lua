-----------------------
-- Пятичерк

while not drafts_core do
    sleep()
end

---@alias BargainsVoteType
--- | `PLAYER_BARGAINS_VOTE_YES`
--- | `PLAYER_BARGAINS_VOTE_NO`
PLAYER_BARGAINS_VOTE_YES = 1
PLAYER_BARGAINS_VOTE_NO = 2

---@alias BargainsUsageType
---|`BARGAINS_TYPE_WITH_BARGAINS`
---|`BARGAINS_TYPE_WITHOUT_BARGAINS`
BARGAINS_TYPE_WITH_BARGAINS = 1
BARGAINS_TYPE_WITHOUT_BARGAINS = 2

five_pair_draft = {
    path = "/Text/HRTA/drafts/FivePairDraft/",
    
    ---@type string
    -- Префикс имен объектов, используемых в драфте 
    entities_prefix = "5draft_",

    ---@type number
    -- Число матчапов для генерации
    matchups_count = 5,

    ---@type number
    -- Максимально число зеркалок для генерации
    max_mirrors_count = 1,

    ---@type table<PlayerID, BargainsVoteType>
    -- Результаты голосования за торги для игроков
    players_bargains_votes = {},

    ---@type BargainsUsageType
    -- Статус выбора торгов
    voted_bargains_type = nil,

    ---@type number[]
    -- Число матчапов для вычерка по очереди игроков
    matchups_remove_queue = {1, 2, 1},

    ---@type number
    -- Текущее положение очереди вычеркиваний
    matchups_remove_queue_position = 1,

    ---@type PlayerID
    -- Текущий игрок, вычеркивающий пару
    current_player_removing_matchup = PLAYER_1,

    ---@type number
    -- Число пар, которые нужно вычеркнуть для завершения драфта
    max_pairs_to_remove = 4,

    ---@type number[]
    -- Номера вычеркнутых в ходе драфта пар
    removed_pairs = {},

    ---@type table<number, table<PlayerID, Position[]>>
    -- Позиции, в которых должны быть размещены пары для черка
    matchups_generation_points = {
        {
            [PLAYER_1] = { 
                { x = 38, y = 90, rot = 90 },
                { x = 46, y = 25, rot = 270 },
            },
            [PLAYER_2] = {
                { x = 39, y = 90, rot = 270 },
                { x = 45, y = 25, rot = 90 },
            }
        },
        {
            [PLAYER_1] = { 
                { x = 38, y = 87, rot = 90 },
                { x = 46, y = 22, rot = 270 },
            },
            [PLAYER_2] = {
                { x = 39, y = 87, rot = 270 },
                { x = 45, y = 22, rot = 90 },
            }
        },
        {
            [PLAYER_1] = { 
                { x = 38, y = 84, rot = 90 },
                { x = 46, y = 19, rot = 270 },
            },
            [PLAYER_2] = {
                { x = 39, y = 84, rot = 270 },
                { x = 45, y = 19, rot = 90 },
            }
        },
        {
            [PLAYER_1] = { 
                { x = 31, y = 90, rot = 90 },
                { x = 39, y = 25, rot = 270 },
            },
            [PLAYER_2] = {
                { x = 32, y = 90, rot = 270 },
                { x = 38, y = 25, rot = 90 },
            }
        },
        {
            [PLAYER_1] = { 
                { x = 31, y = 84, rot = 90 },
                { x = 39, y = 19, rot = 270 },
            },
            [PLAYER_2] = {
                { x = 32, y = 84, rot = 270 },
                { x = 38, y = 19, rot = 90 },
            }
        },
    },

    ---@type DraftPairModel[]
    -- Список сгенерированных пар для черка
    generated_pairs_data = {},

    GeneratePairs = 
    --- Генерирует случайные пары для драфта
    ---@return DraftPairModel [] pairs
    function ()
        local generated_pairs, pairs_count, mirrors_count = {}, 0, 0
        local races = range_generator.FromTop(TOWN_HEAVEN, TOWN_STRONGHOLD)
        while pairs_count ~= five_pair_draft.matchups_count do
            local selected_race = Random.FromTable(races)
            local possible_matchups = list_iterator.Filter(races, 
                function (race)
                    local selected_race = %selected_race
                    local mirrors_count = %mirrors_count
                    if race == selected_race then 
                        if five_pair_draft.max_mirrors_count == mirrors_count then
                            return nil
                        end
                        return 1
                    else
                        local generated_pairs = %generated_pairs
                        if list_iterator.Any(generated_pairs, function (pair)
                            local race = %race
                            local selected_race = %selected_race
                            if not ((pair[1] == race and pair[2] == selected_race) or (pair[1] == selected_race and pair[2] == race)) then
                                return 1
                            else
                                return nil
                            end
                        end) then
                            return 1
                        else 
                            return nil
                        end
                    end
                end)
            local possible_matchup = Random.FromTable(possible_matchups)
            if possible_matchup == selected_race then
                mirrors_count = mirrors_count + 1
            end
            pairs_count = pairs_count + 1
            generated_pairs[pairs_count] = { [1] = selected_race, [2] = possible_matchup }
            races = list_iterator.Filter(races, function (r)
                local selected_race = %selected_race
                if selected_race == r then
                    return nil
                end
                return 1
            end)
            sleep()
        end
        ---@type DraftPairModel[]
        local final_generated_pairs_info = {}
        for i, pair in generated_pairs do
            local first_player_creature = drafts_core.town_representations[pair[1]]
            local second_player_creature = drafts_core.town_representations[pair[2]]
            startThread(five_pair_draft.PlaceMatchups, PLAYER_1, first_player_creature, second_player_creature, i)
            startThread(five_pair_draft.PlaceMatchups, PLAYER_2, second_player_creature, first_player_creature, i)
            final_generated_pairs_info[i] = {
                first_race = pair[1],
                second_race = pair[2],
                [PLAYER_1] = {
                    five_pair_draft.entities_prefix.."p"..i.."_p"..PLAYER_1.."_u1",
                    five_pair_draft.entities_prefix.."p"..i.."_p"..PLAYER_1.."_u2"
                },
                [PLAYER_2] = {
                    five_pair_draft.entities_prefix.."p"..i.."_p"..PLAYER_2.."_u1",
                    five_pair_draft.entities_prefix.."p"..i.."_p"..PLAYER_2.."_u2"
                },
            }
        end

        asha.AddGlobalField("Matchups", "["..list_iterator.Concat(
            list_iterator.FilterMap(generated_pairs, function (pair)
                local result = '{"First": '..pair[1]..', "Second": '..pair[2]..'}'
                return result
            end),
            ","
        ).."]")

        return final_generated_pairs_info
    end,

    PlaceMatchups = 
    -- Генерирует существ, представляющих собой фракции в матчапах для игрока
    ---@param player PlayerID Игрок
    ---@param first_creature CreatureID Первое существо в паре
    ---@param second_creature CreatureID Второе существо в паре
    ---@param matchup_number number Номер матчапа
    function (player, first_creature, second_creature, matchup_number)
        local pair_first_creature_name = five_pair_draft.entities_prefix.."p"..matchup_number.."_p"..player.."_u1"
        local pair_second_creature_name = five_pair_draft.entities_prefix.."p"..matchup_number.."_p"..player.."_u2"
        local x1, y1, f1 = RegionToPoint(pair_first_creature_name)
        local x2, y2, f2 = RegionToPoint(pair_second_creature_name)
        local rot1 = five_pair_draft.matchups_generation_points[matchup_number][player][player == PLAYER_1 and 1 or 2].rot
        local rot2 = five_pair_draft.matchups_generation_points[matchup_number][player][player == PLAYER_1 and 2 or 1].rot
        CreateMonster(pair_first_creature_name, first_creature, 1, x1, y1, f1, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, rot1 or 0)
        CreateMonster(pair_second_creature_name, second_creature, 1, x2, y2, f2, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, rot2 or 0)
        while not (IsObjectExists(pair_first_creature_name) and IsObjectExists(pair_second_creature_name)) do
            sleep()
        end
        Touch.DisableMonster(pair_first_creature_name, DISABLED_INTERACT)
        Touch.DisableMonster(pair_second_creature_name, DISABLED_INTERACT)
        sleep()
    end,

    CheckPlayerBargainsVote = 
    --- Проверяет статус выбора режима торгов для игроков
    function ()
        while not (five_pair_draft.players_bargains_votes[PLAYER_1] and five_pair_draft.players_bargains_votes[PLAYER_2]) do
            sleep()
        end
        if list_iterator.All({PLAYER_1, PLAYER_2},
            function (player)
                if five_pair_draft.players_bargains_votes[player] == PLAYER_BARGAINS_VOTE_NO then
                    return 1
                else
                    return nil
                end
            end)
        then
            five_pair_draft.voted_bargains_type = BARGAINS_TYPE_WITHOUT_BARGAINS
            for player = PLAYER_1, PLAYER_2 do
                local hero = GetPlayerHeroes(player)[0]
                MessageQueue.AddMessage(player, five_pair_draft.path.."both_no.txt", hero, 7.0)
            end
        else
            five_pair_draft.voted_bargains_type = BARGAINS_TYPE_WITH_BARGAINS
            for player = PLAYER_1, PLAYER_2 do
                local hero = GetPlayerHeroes(player)[0]
                MessageQueue.AddMessage(player, five_pair_draft.path.."anyone_yes.txt", hero, 7.0)
            end
        end
        startThread(five_pair_draft.MovePairs)
    end,

    MovePairs = 
    --- Перемещает заранее сгенерированные пары на их необходимые позиции для драфта
    function ()
        for i, pair in five_pair_draft.generated_pairs_data do
            local this_pair_units, n = {}, 0
            for player = PLAYER_1, PLAYER_2 do
                local points_data = five_pair_draft.matchups_generation_points[i][player]
                for j = 1, 2 do
                    local unit = pair[player][j]
                    SetObjectPosition(unit, points_data[j].x, points_data[j].y, GROUND, 0)
                    SetObjectRotation(unit, points_data[j].rot)
                    n = n + 1
                    this_pair_units[n] = unit
                end
            end
            startThread(five_pair_draft.SetupPairUnitsTouch, this_pair_units, i)
        end
        startThread(five_pair_draft.StartPairRemoving)
    end,

    SetupPairUnitsTouch = 
    -- Назначает необходимые триггеры касания существам в паре 
    ---@param units string[] Скриптовые имена юнитов в паре
    ---@param pair_number number Номер пары
    function (units, pair_number)
        for _, unit in units do
            Touch.SetFunction(unit, "_touch", 
            function (hero, _)
                local units = %units
                local pair_number = %pair_number
                if MCCS_QuestionBoxForPlayers(GetObjectOwner(hero), five_pair_draft.path.."wanna_remove_pair.txt") then
                    Object.RemoveTable(units)
                    five_pair_draft.removed_pairs[length(five_pair_draft.removed_pairs) + 1] = pair_number
                    five_pair_draft.matchups_remove_queue[five_pair_draft.matchups_remove_queue_position] = five_pair_draft.matchups_remove_queue[five_pair_draft.matchups_remove_queue_position] - 1
                    if five_pair_draft.matchups_remove_queue[five_pair_draft.matchups_remove_queue_position] == 0 then
                        if length(five_pair_draft.removed_pairs) == five_pair_draft.max_pairs_to_remove then
                            startThread(five_pair_draft.FinishDraft)
                        else
                            five_pair_draft.GiveTurnToNextPlayer()
                        end
                    end
                end
            end)
        end
    end,

    StartPairRemoving =
    --- Стартует непосредственно процесс вычеркивания
    function ()
        unlim_moves_threads.UpdateMoveThreadType(players_utils.GetPlayerDefaultHero(five_pair_draft.current_player_removing_matchup), MOVE_THREAD_TYPE_UNLIM)
    end,

    GiveTurnToNextPlayer = 
    --- Передает ход следующему игроку для вычеркивания
    function ()
        local next_player = PLAYER_3 - five_pair_draft.current_player_removing_matchup
        unlim_moves_threads.UpdateMoveThreadType(players_utils.GetPlayerDefaultHero(five_pair_draft.current_player_removing_matchup), MOVE_THREAD_TYPE_NO_MOVES)
        unlim_moves_threads.UpdateMoveThreadType(players_utils.GetPlayerDefaultHero(next_player), MOVE_THREAD_TYPE_UNLIM)
        five_pair_draft.current_player_removing_matchup = next_player
        five_pair_draft.matchups_remove_queue_position = five_pair_draft.matchups_remove_queue_position + 1
    end,

    FinishDraft = 
    --- Завершает драфт. Определяет выбранную пару и переносит игроков в некст стадию в зависимости от статуса выбора торгов.
    function ()
        local selected_pair_index = range_generator.FromTop(1, 5, function (index)
            if not contains(five_pair_draft.removed_pairs, index) then
                return 1
            end
            return nil
        end)[1]
        local selected_pair = five_pair_draft.generated_pairs_data[selected_pair_index]
        asha.AddGlobalField("RemovedMatchups", "["..list_iterator.Concat(five_pair_draft.removed_pairs, ",").."]")
        if five_pair_draft.voted_bargains_type == BARGAINS_TYPE_WITH_BARGAINS then
            Object.RemoveTable(selected_pair[PLAYER_2])
            startThread(auction.Init, {selected_pair.first_race, selected_pair.second_race}, selected_pair[PLAYER_1])
        else
            players_utils.races[PLAYER_1] = selected_pair.first_race
            players_utils.races[PLAYER_2] = selected_pair.second_race
            Object.RemoveTable(selected_pair[PLAYER_1])
            Object.RemoveTable(selected_pair[PLAYER_2])
            startThread(single_heroes_draft.Init)
        end
    end
}

NewDayEvent.AddListener("HRTA_five_pair_draft_generate_pairs_listener", 
function (day)
    if day == DRAFTS_SKIP_DAY and drafts_core.GetDraftType() == DRAFT_TYPE_FIVE then
        five_pair_draft.generated_pairs_data = five_pair_draft.GeneratePairs()
    end
end)

NewDayEvent.AddListener("HRTA_five_pair_draft_start_listener",
function (day)
    if day == DRAFTS_START_DAY and IS_TEST_MODE == 0 then
        startThread(five_pair_draft.CheckPlayerBargainsVote)
        for player = PLAYER_1, PLAYER_2 do
            startThread(
            function (p)
                if MCCS_QuestionBoxForPlayers(p, five_pair_draft.path.."question_auction.txt") then
                    five_pair_draft.players_bargains_votes[p] = PLAYER_BARGAINS_VOTE_YES
                else
                    five_pair_draft.players_bargains_votes[p] = PLAYER_BARGAINS_VOTE_NO
                end
            end, player)
        end
    end
end)