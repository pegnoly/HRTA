single_heroes_draft = {

    path = "/Text/HRTA/drafts/SingleHeroDraft/",

    -- число героев для генерации набора
    ---@type number
    heroes_count = 7,

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
    current_phase = SINGLE_HERO_DRAFT_PHASE_PICK,

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

    -- Последовательность банов/пиков
    ---@type CompletedDraftAction []
    draft_actions_queue = {},

    Init = 
    function ()
        startThread(single_heroes_draft.GeneratePortraits, PLAYER_1, players_utils.GetPlayerSelectedRace(PLAYER_1))
        startThread(single_heroes_draft.GeneratePortraits, PLAYER_2, players_utils.GetPlayerSelectedRace(PLAYER_2))
    end,

    PregenerateSets = 
    function ()
        for player = PLAYER_1, PLAYER_2 do
            for race = TOWN_HEAVEN, TOWN_STRONGHOLD do
                single_heroes_draft.pregenerated_sets[race][player] = list_iterator.Take(drafts_core.heroes_pool[race], single_heroes_draft.heroes_count)
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
            picked = function (initiator)
                local h = %hero
                startThread(single_heroes_draft.PickHero, h, initiator)
            end,
            banned = function (initiator)
                local h = %hero
                startThread(single_heroes_draft.BanHero, h, initiator)
            end
        }
    end,

    DisplacePortraitsOnAction =
    ---comment
    ---@param hero string
    ---@param reason PortraitDisplaceReason
    ---@param action_type DraftActionType
    function (hero, reason, action_type)
        local hero_data = single_heroes_draft.generated_heroes_data[hero]

        local effect = single_heroes_draft.effects_by_heroes[hero]
        local player_fx = hero_data.player_portait.."_fx"
        local opp_fx = hero_data.opponent_portrait.."_fx"
        StopVisualEffects(player_fx)
        StopVisualEffects(opp_fx)
        
        if reason == PORTRAIT_DISPLACE_REASON_PICK then
            local player_shift, opp_shift
            if action_type == HERO_SELF_PICKED then
                player_shift = -1
                opp_shift = 1
            else
                player_shift = 1
                opp_shift = -1
            end
            local x1, y1, f1 = GetObjectPosition(hero_data.player_portait)
            SetObjectPosition(hero_data.player_portait, x1, y1 + player_shift, f1, 0)
            local x2, y2, f2 = GetObjectPosition(hero_data.opponent_portrait)
            SetObjectPosition(hero_data.opponent_portrait, x2, y2 + opp_shift, f2, 0)
            sleep()
            PlayVisualEffect(effect, hero_data.player_portait, player_fx, 0, 0, 0.2)
            PlayVisualEffect(effect, hero_data.opponent_portrait, opp_fx, 0, 0, 0.2)
        else
            -- ban move logic
        end
    end,

    PickHero = 
    ---comment
    ---@param hero string
    function (hero, initiator)
        local hero_data = single_heroes_draft.generated_heroes_data[hero]
        local drafter = single_heroes_draft.current_drafter
        local draft_action_type = HERO_SELF_PICKED
        if drafter ~= hero_data.owner then
            draft_action_type = HERO_PICKED_FOR_OPP
        end
        if MCCS_QuestionBoxForPlayers(drafter, {
            single_heroes_draft.path..single_heroes_draft.draft_action_messages[draft_action_type]..".txt"; hero_name = Hero.Params.Name(hero)})
        then
            local queue_len = length(single_heroes_draft.draft_actions_queue)
            single_heroes_draft.draft_actions_queue[queue_len + 1] = {
                made_by = drafter,
                type = draft_action_type,
                hero = hero
            }
            if draft_action_type == HERO_SELF_PICKED then
                single_heroes_draft.picked_heroes[drafter][length(single_heroes_draft.picked_heroes[drafter]) + 1] = hero
            else
                single_heroes_draft.picked_heroes[hero_data.owner][length(single_heroes_draft.picked_heroes[hero_data.owner]) + 1] = hero
            end
            single_heroes_draft.DisplacePortraitsOnAction(hero, PORTRAIT_DISPLACE_REASON_PICK, draft_action_type)
            -- move to the next drafter
        end
    end,

    BanHero = 
    --- Мейн функция для бана героев
    ---@param hero string
    function (hero, initiator)

    end,

    TouchPortait = 
    function (initiator, portrait)
        local current_phase = single_heroes_draft.current_phase
        local hero = single_heroes_draft.heroes_by_portraits[portrait]
        local hero_data = single_heroes_draft.generated_heroes_data[hero]
        if current_phase == SINGLE_HERO_DRAFT_PHASE_PICK then
            hero_data.picked(initiator)
        else
            hero_data.banned(initiator)
        end
    end
}

NewDayEvent.AddListener("HRTA_single_heroes_draft_generate_portaits_listener", 
function (day)
    if day == DRAFTS_SKIP_DAY then
        startThread(single_heroes_draft.PregenerateSets)
    end
end)