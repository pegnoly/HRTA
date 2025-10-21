auction = {

    path = "Text/HRTA/drafts/Auction/",

    ---@type table<PlayerID, Position>
    player_heroes_initial_positions = {
        [PLAYER_1] = { x = 35, y = 87 },
        [PLAYER_2] = { x = 42, y = 22 }
    },

    ---@type table<PlayerID, Position>
    gold_positions = {
        [PLAYER_1] = { x = 34, y = 88 },
        [PLAYER_2] = { x = 41, y = 23 }
    },

    ---@type table<PlayerID, Position>
    postament_positions = {
        [PLAYER_1] = { x = 34, y = 86 },
        [PLAYER_2] = { x = 41, y = 21 }
    },

    bid_amounts = { 500, 1000, 2000 },

    ---@type TownType[]
    player_races = {},

    ---@type table<PlayerID, string[]>
    player_race_objects = {},

    ---@type table<PlayerID, AuctionPlayerRaceObject>
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
    current_active_player = PLAYER_1,

    ---@type number
    current_bid = 0,

    SetupHero = 
    ---comment
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
    ---comment
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
    function (hero, object)

    end,

    TouchGoldObject =
    ---comment
    ---@param hero string
    ---@param bid_index number
    function (hero, bid_index)
        local amount = auction.bid_amounts[bid_index]
        if MCCS_QuestionBoxForPlayers(GetObjectOwner(hero), {auction.path.."wanna_increase_bid.txt"; amount = amount}) then
            auction.current_bid = auction.current_bid + amount
            local tr, to = auction.player_races[PLAYER_2], auction.player_race_objects[PLAYER_2]
            auction.player_races[PLAYER_2] = auction.player_races[PLAYER_1]
            auction.player_races[PLAYER_1] = tr
            auction.player_race_objects[PLAYER_2] = auction.player_race_objects[PLAYER_1]
            auction.player_race_objects[PLAYER_1] = to
            for player = PLAYER_1, PLAYER_2 do
                startThread(auction.UpdateRaceObjects, player)
                MessageQueue.AddMessage(player, {auction.path.."current_bid.txt"; bid_amount = amount, bid_total = auction.current_bid}, hero, 10.0)
            end
            startThread(auction.GiveTurnToNextPlayer)
        end
    end,

    GiveTurnToNextPlayer = 
    function ()
        unlim_moves_threads.UpdateMoveThreadType(players_utils.GetPlayerDefaultHero(auction.current_active_player), MOVE_THREAD_TYPE_NO_MOVES)
        auction.current_active_player = 3 - auction.current_active_player
        unlim_moves_threads.UpdateMoveThreadType(players_utils.GetPlayerDefaultHero(auction.current_active_player), MOVE_THREAD_TYPE_UNLIM)
    end
}