auction = {

    path = "Text/HRTA/drafts/Auction/",

    ---@type table<PlayerID, Position>
    gold_positions = {
        [PLAYER_1] = { x = 34, y = 88 },
        [PLAYER_2] = { x = 43, y = 23, rot = 180 }
    },

    ---@type table<PlayerID, Position>
    postament_positions = {
        [PLAYER_1] = { x = 34, y = 86 },
        [PLAYER_2] = { x = 41, y = 21, rot = 180 }
    },

    bid_amounts = { 500, 1000, 2000 },

    ---@type TownType[]
    player_races = {},

    ---@type string[]
    player_race_objects = {},

    ---@type table<PlayerID, AuctionPlayerRaceObject>
    player_race_objects_positions = {
        [PLAYER_1] = {
            self = { x = 32, y = 87 },
            opp = { x = 38, y = 87 }
        },
        [PLAYER_2] = {
            self = { x = 32, y = 87 },
            opp = { x = 38, y = 87 }
        }
    },

    ---@type PlayerID
    current_active_player = PLAYER_1,

    ---@type number
    current_bid = 0,

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
        local shift = player == PLAYER_1 and bid_index - 1 or -(bid_index - 1)
        local pos = auction.gold_positions[player]
        pos.x = pos.x + shift
        SetObjectPosition(name, pos.x, pos.y, GROUND)
        if pos.rot then
            SetObjectRotation(name, pos.rot)
        end
        Touch.DisableObject(name, DISABLED_DEFAULT, auction.path.."bid_amount_"..bid_index..".txt")
        Touch.SetFunction(name, "_touch", function (hero, _)
            local bi = %bid_index
            startThread(auction.TouchGoldObject, hero, bi)
        end)
    end,

    UpdateRaceObjects =
    function (player)
        local player_object = auction.player_race_objects[player]
        local opp_object = auction.player_race_objects[3 - player]
        local pos = auction.player_race_objects_positions[player]
        SetObjectPosition(player_object, pos.self.x, pos.self.y, GROUND)
        SetObjectPosition(opp_object, pos.opp.x, pos.opp.y, GROUND)
    end,

    Init =
    function (races, objects)
        for player = PLAYER_1, PLAYER_2 do
            auction.player_races[player] = races[player]
            auction.player_race_objects[player] = objects[player]
            startThread(auction.SetupPostaments, player)
            startThread(auction.SetupGoldObjects, player)
            startThread(auction.UpdateRaceObjects, player)

            local hero = players_utils.GetPlayerDefaultHero(player)
            if player == auction.current_active_player then
                unlim_moves_threads.UpdateMoveThreadType(hero, MOVE_THREAD_TYPE_UNLIM)
            else
                unlim_moves_threads.UpdateMoveThreadType(hero, MOVE_THREAD_TYPE_NO_MOVES)
            end
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
                startThread(MCCS_MessageBoxForPlayers, player, {auction.path.."current_bid.txt"; bid_amount = amount, bid_total = auction.current_bid})
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