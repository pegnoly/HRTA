while not drafts_core do
    sleep()
end

single_heroes_draft = {

    path = "/Text/HRTA/drafts/SingleHeroDraft/",

    -- число героев для генерации набора
    ---@type number
    heroes_count = 7,

    -- число героев, которые должны быть в наличии у игроков для завершения черка
    ---@type number
    heroes_count_to_finish = 4,

    -- технически, наборы героев генерируются на 1 день, т.к. это не моментальный процесс и вызывает задержку, если вызывать непосредственно перед черком
    ---@type table<TownType, table<PlayerID, string[]>>
    pregenerated_sets = {
        [TOWN_HEAVEN] = {},
        [TOWN_INFERNO] = {},
        [TOWN_NECROMANCY] = {},
        [TOWN_PRESERVE] = {},
        [TOWN_DUNGEON] = {},
        [TOWN_ACADEMY] = {},
        [TOWN_FORTRESS] = {},
        [TOWN_STRONGHOLD] = {}
    },

    ---@type table<PlayerID, Position>
    -- тайлы, с которых начинается генерация портретов
    generation_start_points = {
        [PLAYER_1] = { x = 31, y = 85 },
        [PLAYER_2] = { x = 38, y = 20 }
    },

    --- Таблица путей к эффектам героев
    ---@type table<string, string>
    effects_by_heroes = {},

    -- Таблица соответствий героев их портретам
    ---@type table<string, string>
    heroes_by_portraits = {},

    -- Таблица данных о сгенерированных героях для драфта
    ---@type table<string, PlayerDraftableHero>
    generated_heroes_data = {},

    -- Игрок, совершающий выбор в текущий момент
    ---@type PlayerID
    current_drafter = PLAYER_1,

    -- Текущая стадия драфта
    ---@type SingleHeroDraftPhase
    current_phase = SINGLE_HERO_DRAFT_PHASE_BAN,

    ---@type number
    current_phase_actions_count = 0,

    -- Сообщения, вызываемые при разных действиях игроков в процессе драфта
    ---@type table<DraftActionType, string>
    draft_action_messages = {
        [HERO_SELF_PICKED] = "pick_for_self",
        [HERO_SELF_BANNED] = "ban_for_self",
        [HERO_BANNED_FOR_OPP] = "ban_for_opp",
        [HERO_PICKED_FOR_OPP] = "pick_for_opp"
    },

    -- Выбранные герои для игроков
    ---@type table<PlayerID, string[]>
    picked_heroes = {
        [PLAYER_1] = {},
        [PLAYER_2] = {}
    },

    -- Забаненные герои для игроков
    ---@type table<PlayerID, string[]>
    banned_heroes = {
        [PLAYER_1] = {},
        [PLAYER_2] = {}
    },

    -- Герои, не пикнутые и не забаненные на момент текущей стадии драфта
    ---@type table<PlayerID, string []>
    heroes_left_in_set = {
        [PLAYER_1] = {},
        [PLAYER_2] = {}
    },

    -- Последовательность банов/пиков
    ---@type CompletedDraftAction []
    draft_actions_queue = {},

    ---@type table<PlayerID, 1|nil>
    -- Статус завершения драфта для игроков
    draft_finished_for_player = {},

    Init =
    function ()
        single_heroes_draft.heroes_left_in_set[PLAYER_1] = single_heroes_draft.pregenerated_sets[players_utils.GetPlayerSelectedRace(PLAYER_1)][PLAYER_1]
        single_heroes_draft.heroes_left_in_set[PLAYER_2] = single_heroes_draft.pregenerated_sets[players_utils.GetPlayerSelectedRace(PLAYER_2)][PLAYER_2]
        startThread(single_heroes_draft.GeneratePortraits, PLAYER_1, players_utils.GetPlayerSelectedRace(PLAYER_1))
        startThread(single_heroes_draft.GeneratePortraits, PLAYER_2, players_utils.GetPlayerSelectedRace(PLAYER_2))
    end,

    PregenerateSets =
    function ()
        for player = PLAYER_1, PLAYER_2 do
            for race = TOWN_HEAVEN, TOWN_STRONGHOLD do
                startThread(
                function ()
                    local race = %race
                    local player = %player
                    single_heroes_draft.pregenerated_sets[race][player] = list_iterator.TakeRandom(drafts_core.heroes_pool[race], single_heroes_draft.heroes_count)
                end)
            end
        end
    end,

    GeneratePortraits =
    --- Генерирует портреты героев игрока
    ---@param player PlayerID Игрок, для которого производится генерация
    ---@param race TownType Фракция игрока
    function (player, race)
        for index = 1, single_heroes_draft.heroes_count do
            local hero = single_heroes_draft.pregenerated_sets[race][player][index]
            startThread(single_heroes_draft.SetupHeroPortraits, hero, player, index)
        end
    end,

    SetupHeroPortraits =
    --- Сетапит эффекты и триггеры для портретов конкретного героя
    ---@param hero string Скриптовое имя героя
    ---@param player PlayerID Игрок, набору которого принадлежит герой
    ---@param index number Индекс героя в наборе
    function (hero, player, index)
        local effect = "/Effects/Drafts/"..hero.."/active.(Effect).xdb#xpointer(/Effect)"
        single_heroes_draft.effects_by_heroes[hero] = effect
        local player_side_placeholder = "placeholder_"..index.."_p"..player.."_self"
        local opponent_side_placeholder = "placeholder_"..index.."_p"..player.."_opp"
        single_heroes_draft.heroes_by_portraits[player_side_placeholder] = hero
        single_heroes_draft.heroes_by_portraits[opponent_side_placeholder] = hero
        local player_start_pos = single_heroes_draft.generation_start_points[player]
        local opponent_side_pos = single_heroes_draft.generation_start_points[PLAYER_3 - player]

        Touch.DisableObject(player_side_placeholder, DISABLED_INTERACT, Hero.Params.Name(hero), Hero.Params.SpecDesc(hero))
        Touch.DisableObject(opponent_side_placeholder, DISABLED_INTERACT, Hero.Params.Name(hero), Hero.Params.SpecDesc(hero))
        Touch.SetFunction(player_side_placeholder, "_touch", single_heroes_draft.TouchPortait)
        Touch.SetFunction(opponent_side_placeholder, "_touch", single_heroes_draft.TouchPortait)

        SetObjectPosition(player_side_placeholder, player_start_pos.x + index, player_start_pos.y, GROUND, 0)
        SetObjectPosition(opponent_side_placeholder, opponent_side_pos.x + index, opponent_side_pos.y + 3, GROUND, 0)
        PlayVisualEffect(effect, player_side_placeholder, player_side_placeholder.."_fx", 0, 0, 0.2)
        PlayVisualEffect(effect, opponent_side_placeholder, opponent_side_placeholder.."_fx", 0, 0, 0.2)

        single_heroes_draft.generated_heroes_data[hero] = {
            owner = player,
            player_portait = player_side_placeholder,
            opponent_portrait = opponent_side_placeholder,
            picked = function () local h = %hero startThread(single_heroes_draft.PickHero, h) end,
            banned = function () local h = %hero startThread(single_heroes_draft.BanHero, h) end
        }
    end,

    DisplacePortraitsOnAction =
    --- Управляет перемещениями портретов героев при действиях игроков в ходе драфта
    ---@param hero string Скриптовое имя героя
    ---@param reason DraftActionReason Причина, по которой было активировано перемещение
    function (hero, reason)
        local hero_data = single_heroes_draft.generated_heroes_data[hero]
        local effect = single_heroes_draft.effects_by_heroes[hero]
        local player_fx = hero_data.player_portait.."_fx"
        local opp_fx = hero_data.opponent_portrait.."_fx"

        StopVisualEffects(player_fx)
        StopVisualEffects(opp_fx)
        Touch.RemoveFunctions(hero_data.player_portait)
        Touch.RemoveFunctions(hero_data.opponent_portrait)
        Touch.ResetTrigger(hero_data.player_portait)
        Touch.ResetTrigger(hero_data.opponent_portrait)

        if reason == DRAFT_ACTION_REASON_PICK then
            local player_shift, opp_shift = -1, 1
            local x1, y1, f1 = GetObjectPosition(hero_data.player_portait)
            SetObjectPosition(hero_data.player_portait, x1, y1 + player_shift, f1, 0)
            local x2, y2, f2 = GetObjectPosition(hero_data.opponent_portrait)
            SetObjectPosition(hero_data.opponent_portrait, x2, y2 + opp_shift, f2, 0)
            sleep()
            PlayVisualEffect(effect, hero_data.player_portait, player_fx, 0, 0, 0.2)
            PlayVisualEffect(effect, hero_data.opponent_portrait, opp_fx, 0, 0, 0.2)
        else
            --!TODO Перемещения портретов забаненных героев
            Object.RemoveSelection(hero_data.player_portait, hero_data.opponent_portrait)
        end
    end,

    RemoveHeroFromSet =
    --- Удаляет героя из набора игрока
    ---@param hero string Скриптовое имя героя
    ---@param owner PlayerID Игрок, из набора которого удаляется герой
    ---@return table set_after_remove Набор героев после удаления
    function (hero, owner)
        local set_after_remove = list_iterator.Filter(single_heroes_draft.heroes_left_in_set[owner],
            function (v)
                local h = %hero
                if h == v then
                    return nil
                end
                return 1
            end)
        return set_after_remove
    end,

    PickHero =
    ---Вызывается, если клик на портрет был совершен в фазе пика героев
    ---@param hero string Герой, на портрет которого кликнул игрок
    function (hero)
        local hero_data = single_heroes_draft.generated_heroes_data[hero]
        local draft_action_type = single_heroes_draft.current_drafter ~= hero_data.owner and HERO_PICKED_FOR_OPP or HERO_SELF_PICKED
        if MCCS_QuestionBoxForPlayers(single_heroes_draft.current_drafter, {
            single_heroes_draft.path..single_heroes_draft.draft_action_messages[draft_action_type]..".txt"; hero_name = Hero.Params.Name(hero)})
        then
            table.push(single_heroes_draft.draft_actions_queue, { made_by = single_heroes_draft.current_drafter, type = draft_action_type, hero = hero })
            if draft_action_type == HERO_SELF_PICKED then
                table.push(single_heroes_draft.picked_heroes[single_heroes_draft.current_drafter], hero)
                single_heroes_draft.heroes_left_in_set[single_heroes_draft.current_drafter] = single_heroes_draft.RemoveHeroFromSet(hero, single_heroes_draft.current_drafter)
            else
                table.push(single_heroes_draft.picked_heroes[hero_data.owner], hero)
                single_heroes_draft.heroes_left_in_set[hero_data.owner] = single_heroes_draft.RemoveHeroFromSet(hero, hero_data.owner)
            end
            single_heroes_draft.DisplacePortraitsOnAction(hero, DRAFT_ACTION_REASON_PICK)
            single_heroes_draft.MoveToNextTurn()
        end
    end,

    BanHero =
    --- Вызывается, если клик на портрет был совершен в фазе бана героев
    ---@param hero string Герой, на портрет которого кликнул игрок
    function (hero)
        local hero_data = single_heroes_draft.generated_heroes_data[hero]
        local draft_action_type = single_heroes_draft.current_drafter ~= hero_data.owner and HERO_BANNED_FOR_OPP or HERO_SELF_BANNED
        if MCCS_QuestionBoxForPlayers(single_heroes_draft.current_drafter, {
            single_heroes_draft.path..single_heroes_draft.draft_action_messages[draft_action_type]..".txt"; hero_name = Hero.Params.Name(hero)})
        then
            table.push(single_heroes_draft.draft_actions_queue, { made_by = single_heroes_draft.current_drafter, type = draft_action_type, hero = hero })
            if draft_action_type == HERO_SELF_BANNED then
                table.push(single_heroes_draft.banned_heroes[single_heroes_draft.current_drafter], hero)
                single_heroes_draft.heroes_left_in_set[single_heroes_draft.current_drafter] = single_heroes_draft.RemoveHeroFromSet(hero, single_heroes_draft.current_drafter)
            else
                table.push(single_heroes_draft.banned_heroes[hero_data.owner], hero)
                single_heroes_draft.heroes_left_in_set[hero_data.owner] = single_heroes_draft.RemoveHeroFromSet(hero, hero_data.owner)
            end
            single_heroes_draft.DisplacePortraitsOnAction(hero, DRAFT_ACTION_REASON_BAN)
            single_heroes_draft.MoveToNextTurn()
        end
    end,

    TouchPortait =
    --- Вызывается при любом клике на активный портрет героя
    ---@param _ any
    ---@param portrait string Скриптовое имя портрета
    function (_, portrait)
        local hero_data = single_heroes_draft.generated_heroes_data[single_heroes_draft.heroes_by_portraits[portrait]]
        if single_heroes_draft.current_phase == SINGLE_HERO_DRAFT_PHASE_PICK then
            hero_data.picked()
        else
            hero_data.banned()
        end
    end,

    MoveToNextTurn =
    --- Вызывается при завершении каждого действия в ходе драфта, определяет следующее действие
    function ()
        local prev_drafter = single_heroes_draft.current_drafter
        local new_drafter = PLAYER_3 - single_heroes_draft.current_drafter

        single_heroes_draft.current_phase_actions_count = single_heroes_draft.current_phase_actions_count + 1
        if single_heroes_draft.current_phase_actions_count == 2 then
            single_heroes_draft.current_phase_actions_count = 0
            single_heroes_draft.current_phase = 3 - single_heroes_draft.current_phase 
        end

        local draft_finished_for_curr_drafter = single_heroes_draft.CheckDraftCanBeContinuedForSide(new_drafter)
        local draft_finished_for_prev_drafter = single_heroes_draft.CheckDraftCanBeContinuedForSide(prev_drafter)

        if not (draft_finished_for_curr_drafter or draft_finished_for_prev_drafter) then -- драфт закончен для обеих сторон
            startThread(single_heroes_draft.CompleteDraftStage)
            return
        else
            single_heroes_draft.current_drafter = new_drafter
            unlim_moves_threads.UpdateMoveThreadType(players_utils.GetPlayerDefaultHero(prev_drafter), MOVE_THREAD_TYPE_NO_MOVES)
            unlim_moves_threads.UpdateMoveThreadType(players_utils.GetPlayerDefaultHero(new_drafter), MOVE_THREAD_TYPE_UNLIM)
        end
    end,

    CheckDraftCanBeContinuedForSide =
    --- Проверяет, может ли драфт считаться оконченным для заданного игрока.
    --- Есть 2 условия завершения - либо пикнуто достаточное число героев, либо число пикнутых + число оставшихся в пуле равно достаточному
    ---@param drafter PlayerID Игрок, для которого производится проверка
    ---@return 1|nil can_be_continued Драфт может продолжаться/нет
    function (drafter)
        if single_heroes_draft.draft_finished_for_player[drafter] then
            return nil
        end
        local heroes_picked = length(single_heroes_draft.picked_heroes[drafter])
        local heroes_left = length(single_heroes_draft.heroes_left_in_set[drafter])
        if heroes_picked == single_heroes_draft.heroes_count_to_finish then
            startThread(single_heroes_draft.FinishDraftForSideWithReason, drafter, DRAFT_FINISH_REASON_ALL_PICKED)
            return nil
        else
            if (heroes_picked + heroes_left) == single_heroes_draft.heroes_count_to_finish then
                startThread(single_heroes_draft.FinishDraftForSideWithReason, drafter, DRAFT_FINISH_REASON_NOONE_TO_BAN)
                return nil
            end
        end
        return 1
    end,

    FinishDraftForSideWithReason =
    -- Завершает стадию драфта для конкретного игрока(иначе говоря, делает невозможным пикать/банить героев из его набора)
    ---@param drafter PlayerID Игрок, для которого завершается драфт
    ---@param reason DraftFinishReason Причина завершения драфта
    function (drafter, reason)
        single_heroes_draft.draft_finished_for_player[drafter] = 1
        if reason == DRAFT_FINISH_REASON_ALL_PICKED then
            for i, hero in single_heroes_draft.heroes_left_in_set[drafter] do
                if hero then
                    local hero_data = single_heroes_draft.generated_heroes_data[hero]
                    StopVisualEffects(hero_data.player_portait.."_fx")
                    StopVisualEffects(hero_data.opponent_portrait.."_fx")
                    Object.RemoveSelection(hero_data.player_portait, hero_data.opponent_portrait)
                end
            end
        else
            for _, hero in single_heroes_draft.heroes_left_in_set[drafter] do
                if hero then
                    single_heroes_draft.picked_heroes[drafter][length(single_heroes_draft.picked_heroes[drafter]) + 1] = hero
                    startThread(
                        single_heroes_draft.DisplacePortraitsOnAction,
                        hero,
                        DRAFT_ACTION_REASON_PICK,
                        drafter == single_heroes_draft.current_drafter and HERO_SELF_PICKED or HERO_PICKED_FOR_OPP
                    )
                end
            end
        end
    end,

    CompleteDraftStage =
    -- Завершает стадию драфта, рандомит героев для игроков, определяет последовательность дней для следующих действий.
    -- Записывает инфу о порядке действий в драфте в Асху.
    function ()
        unlim_moves_threads.UpdateMoveThreadType(players_utils.GetPlayerDefaultHero(PLAYER_1), MOVE_THREAD_TYPE_NO_MOVES)
        unlim_moves_threads.UpdateMoveThreadType(players_utils.GetPlayerDefaultHero(PLAYER_2), MOVE_THREAD_TYPE_NO_MOVES)

        PREPARE_STAGE_LEVELING_DAY = GetDate(DAY) + 1
        PREPARE_STAGE_SPECIAL_DAY = GetDate(DAY) + 2
        PREPARE_STAGE_PREFIGHT_DAY = GetDate(DAY) + 3
        PREPARE_STAGE_FIGHT_DAY = GetDate(DAY) + 4
        
        for player = PLAYER_1, PLAYER_2 do
            local selected_heroes = list_iterator.TakeRandom(single_heroes_draft.picked_heroes[player], prepare_stage_core.active_heroes_count)
            prepare_stage_core.heroes_by_player[player] = selected_heroes
            if players_utils.GetPlayerSelectedRace(player) ~= players_utils.GetPlayerSelectedRace(PLAYER_3 - player) then
                local heroes_left = list_iterator.Filter(single_heroes_draft.picked_heroes[player], function (hero)
                    local sh = %selected_heroes
                    if contains(sh, hero) then
                        return nil
                    end
                    return 1
                end)
                prepare_stage_core.tavern_heroes_by_player[player] = Random.FromTable(heroes_left)
            end
        end

        startThread(towns_setup.Init)

        asha.AddGlobalField("DraftActions", "["..list_iterator.Concat(
            list_iterator.FilterMap(single_heroes_draft.draft_actions_queue,
                ---@param a CompletedDraftAction
                function (a)
                    local result = '{"MadeBy": '..a.made_by..', "Type": '..a.type..', "Hero": '..a.hero..'}'
                    return result
                end),
                ","
            )
        )
    end
}

NewDayEvent.AddListener("HRTA_single_heroes_draft_generate_portaits_listener",
function (day)
    if day == DRAFTS_SKIP_DAY and drafts_core.GetDraftType() == DRAFT_TYPE_FIVE then
        startThread(single_heroes_draft.PregenerateSets)
    end
end)

NewDayEvent.AddListener("HRTA_test_heroes_generation_listener",
function (day)
    if day == DRAFTS_SKIP_DAY and IS_TEST_MODE == 1 then
        while not single_heroes_draft.pregenerated_sets[TOWN_STRONGHOLD][PLAYER_2] do
            sleep()
        end
        for player = PLAYER_1, PLAYER_2 do
            local race = Random.FromTable(range_generator.FromTop(TOWN_HEAVEN, TOWN_STRONGHOLD))
            players_utils.races[player] = race
            local heroes = list_iterator.TakeRandom(single_heroes_draft.pregenerated_sets[race][player], 2)
            prepare_stage_core.heroes_by_player[player] = heroes
            startThread(towns_setup.Init)
        end
        PREPARE_STAGE_LEVELING_DAY = 2
        PREPARE_STAGE_SPECIAL_DAY = 3
        PREPARE_STAGE_PREFIGHT_DAY = 4
        PREPARE_STAGE_FIGHT_DAY = 5
    end
end)