--- Торги. Main.
--- 

---@alias AuctionActionType
---| `AUCTION_ACTION_BID`
---| `AUCTION_ACTION_SKIP`
AUCTION_ACTION_BID = 1
AUCTION_ACTION_SKIP = 2

auction = {

    path = "Text/HRTA/drafts/Auction/",

    ---@type table<PlayerID, Position>
    -- Позиции, в которые ставятся мейн герои игроков при начале торга
    player_heroes_initial_positions = {
        [PLAYER_1] = { x = 35, y = 87 },
        [PLAYER_2] = { x = 42, y = 22 }
    },

    ---@type table<PlayerID, Position>
    -- Позиции, начиная с которых размещаются объекты, отвечающие за повышение ставки
    gold_positions = {
        [PLAYER_1] = { x = 34, y = 88 },
        [PLAYER_2] = { x = 41, y = 23 }
    },

    ---@type table<PlayerID, Position>
    -- Позиции, в которых размещаются объекты для соглашения с торгом
    postament_positions = {
        [PLAYER_1] = { x = 34, y = 86 },
        [PLAYER_2] = { x = 41, y = 21 }
    },

    ---@type number[]
    -- Размер в торга в зависимости от номера объекта
    bid_amounts = { 500, 1000, 2000 },

    ---@type TownType[]
    -- Текущие фракции игроков
    player_races = {},

    ---@type table<PlayerID, string[]>
    -- Объекты, представляющие текущее распределение фракций при торге
    player_race_objects = {},

    ---@type table<PlayerID, AuctionPlayerRaceObject>
    -- Позиции, в которых размещаются объекты, представляющие распределение фракций
    player_race_objects_positions = {
        [PLAYER_1] = {
            self = { x = 32, y = 87 },
            opp = { x = 38, y = 87 }
        },
        [PLAYER_2] = {
            self = { x = 39, y = 22 },
            opp = { x = 45, y = 22 }
        }
    },

    ---@type PlayerID
    -- Текущий игрок, совершающий ставку
    current_active_player = PLAYER_1,

    ---@type AuctionActionType
    -- Последнее действие, совершенное игроками
    last_action = nil,

    ---@type number
    -- Текущий размер ставки
    current_bid = 0,

    ---@type table<PlayerID, number>
    -- Золото игроков по итогам торгов
    final_gold_amount = {[PLAYER_1] = 0, [PLAYER_2] = 0},

    SetupHero =
    ---@param player PlayerID
    function (player)
        local hero = players_utils.GetPlayerDefaultHero(player)
        local pos = auction.player_heroes_initial_positions[player]
        SetObjectPosition(hero, pos.x, pos.y, GROUND)
        if player == auction.current_active_player then
            unlim_moves_threads.UpdateMoveThreadType(hero, MOVE_THREAD_TYPE_UNLIM)
        else
            unlim_moves_threads.UpdateMoveThreadType(hero, MOVE_THREAD_TYPE_NO_MOVES)
        end
    end,

    SetupPostaments =
    ---@param player PlayerID
    function (player)
        local main_name = "auction_postament_"..player
        local main_pos = auction.postament_positions[player]
        SetObjectPosition(main_name, main_pos.x, main_pos.y, GROUND)
        if main_pos.rot then
            SetObjectRotation(main_name, main_pos.rot)
        end
        Touch.DisableObject(main_name, DISABLED_DEFAULT, auction.path.."postament_name.txt")
        Touch.SetFunction(main_name, "_touch", auction.TouchMainPostament)
    end,

    SetupGoldObjects =
    -- Настраивает кучки золота для ставок
    ---@param player PlayerID
    function (player)
        for bid_index = 1, 3 do
            startThread(auction.SetupGoldObject, player, bid_index)
        end
    end,

    SetupGoldObject =
    ---@param player PlayerID
    ---@param bid_index number
    function (player, bid_index)
        local name = "auction_gold_"..player..""..bid_index
        local shift = bid_index - 1
        local pos = auction.gold_positions[player]
        SetObjectPosition(name, pos.x + shift, pos.y, GROUND)
        if pos.rot then
            SetObjectRotation(name, pos.rot)
        end
        Touch.DisableObject(name, DISABLED_DEFAULT, auction.path.."bid_amount_"..bid_index..".txt")
        Touch.SetFunction(name, "_touch", function (hero, _)
            local bi = %bid_index
            startThread(auction.TouchGoldObject, hero, bi)
        end)
    end,

    SetupRaceObjects =
    ---@param player PlayerID
    ---@param pair_model DraftPairModel
    function (player, pair_model)
        auction.player_races[player] = player == PLAYER_1 and pair_model.first_race or pair_model.second_race
        auction.player_race_objects[player] = pair_model[player]
        for _, object in auction.player_race_objects[player] do
            SetObjectRotation(object, 0)
            Touch.RemoveFunctions(object)
        end
        startThread(auction.UpdateRaceObjects, player)
    end,

    UpdateRaceObjects =
    ---@param player PlayerID
    function (player)
        local player_objects = auction.player_race_objects[player]
        local pos = auction.player_race_objects_positions[player]
        SetObjectPosition(player_objects[1], pos.self.x, pos.self.y, GROUND)
        SetObjectPosition(player_objects[2], pos.opp.x, pos.opp.y, GROUND)
    end,

    Init =
    -- Мейн функция инициализации торгов
    ---@param pair_model DraftPairModel
    function (pair_model)
        for player = PLAYER_1, PLAYER_2 do
            auction.SetupHero(player)
            startThread(auction.SetupPostaments, player)
            startThread(auction.SetupGoldObjects, player)
            startThread(auction.SetupRaceObjects, player, pair_model)
        end
    end,

    TouchMainPostament =
    ---@param hero string
    function (hero, _)
        local player = GetObjectOwner(hero)
        if not auction.last_action then
            if MCCS_QuestionBoxForPlayers(player, auction.path.."wanna_skip_bid.txt") then
                auction.last_action = AUCTION_ACTION_SKIP
                MessageQueue.AddMessage(player, auction.path.."skipped.txt", hero, 5.0)
                MessageQueue.AddMessage(3 - player, auction.path.."opponent_skipped.txt", players_utils.GetPlayerDefaultHero(3 - player), 8.0)
                startThread(auction.GiveTurnToNextPlayer)
            end
        end
        if auction.last_action == AUCTION_ACTION_BID then
            if MCCS_QuestionBoxForPlayers(player, auction.path.."wanna_agree_with_bid.txt") then
                startThread(auction.FinishBid, player)
            end
        else
            if MCCS_QuestionBoxForPlayers(player, auction.path.."wanna_finish_bid.txt") then
                startThread(auction.FinishBid, player)
            end
        end
    end,

    TouchGoldObject =
    ---@param hero string
    ---@param bid_index number
    function (hero, bid_index)
        local amount = auction.bid_amounts[bid_index]
        if MCCS_QuestionBoxForPlayers(GetObjectOwner(hero), {auction.path.."wanna_increase_bid.txt"; amount = amount}) then
            auction.last_action = AUCTION_ACTION_BID
            auction.current_bid = auction.current_bid + amount
            local tr, to = auction.player_races[PLAYER_2], auction.player_race_objects[PLAYER_2]
            auction.player_races[PLAYER_2] = auction.player_races[PLAYER_1]
            auction.player_races[PLAYER_1] = tr
            auction.player_race_objects[PLAYER_2] = auction.player_race_objects[PLAYER_1]
            auction.player_race_objects[PLAYER_1] = to

            local player = GetObjectOwner(hero)
            MessageQueue.AddMessage(player, {
                auction.path.."current_bid.txt";
                color1 = RACE_COLORS[auction.player_races[player]],
                race1 = RACE_NAMES[auction.player_races[player]],
                bid_amount1 = -auction.current_bid,
                color2 = RACE_COLORS[auction.player_races[3 - player]],
                race2 = RACE_NAMES[auction.player_races[3 - player]],
                bid_amount2 = auction.current_bid,
            }, hero, 10.0)
            MessageQueue.AddMessage(3 - player, {
                auction.path.."opponent_increased_bid.txt";
                amount = amount,
                color1 = RACE_COLORS[auction.player_races[3 - player]],
                race1 = RACE_NAMES[auction.player_races[3 - player]],
                bid_amount1 = auction.current_bid,
                color2 = RACE_COLORS[auction.player_races[player]],
                race2 = RACE_NAMES[auction.player_races[player]],
                bid_amount2 = -auction.current_bid,
            }, players_utils.GetPlayerDefaultHero(3 - player), 10.0)

            for p = PLAYER_1, PLAYER_2 do
                startThread(auction.UpdateRaceObjects, p)
            end
            startThread(auction.GiveTurnToNextPlayer)
        end
    end,

    GiveTurnToNextPlayer =
    function ()
        unlim_moves_threads.UpdateMoveThreadType(players_utils.GetPlayerDefaultHero(auction.current_active_player), MOVE_THREAD_TYPE_NO_MOVES)
        auction.current_active_player = 3 - auction.current_active_player
        unlim_moves_threads.UpdateMoveThreadType(players_utils.GetPlayerDefaultHero(auction.current_active_player), MOVE_THREAD_TYPE_UNLIM)
    end,

    FinishBid = 
    -- Завершает торг, переводит драфт в стадию пика героев
    ---@param player PlayerID
    function (player)
        auction.final_gold_amount[player] = -auction.current_bid
        auction.final_gold_amount[3 - player] = auction.current_bid
        players_utils.races[player] = auction.player_races[player]
        players_utils.races[3 - player] = auction.player_races[3 - player]
        auction.ClearBids()
        sleep(5)
        single_heroes_draft.Init()
    end,

    ClearBids = 
    function ()
        for player = PLAYER_1, PLAYER_2 do
            for i = 1, 3 do
                local name = "auction_gold_"..player..""..i
                RemoveObject(name)
            end
            Object.RemoveTable(auction.player_race_objects[player])
            RemoveObject("auction_postament_"..player)
        end
    end
}