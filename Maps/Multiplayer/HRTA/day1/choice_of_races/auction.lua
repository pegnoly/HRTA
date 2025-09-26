-- ��������� ���������� ���������� ��� �������� ��������� ����
PLAYER_TURN = 'RED'
PLAYER_1_GOLD = 10000
PLAYER_2_GOLD = 10000
SELECTED_PAIR = nil
EXTRA_GOLD = 0

TURN = 0;

COUNT_BID = 0;

ACTION_OBJECT = {
    [PLAYER_1] = {'goldAuction500_Player1', 'goldAuction1000_Player1', 'goldAuction2000_Player1'},
    [PLAYER_2] = {'goldAuction500_Player2', 'goldAuction1000_Player2', 'goldAuction2000_Player2'},
}

-- ������� ��� ��������� �������� ��������
function setupAuctionObjects(hero, bids, agreement)
    print("setupAuctionObjects")
    for i = 1, 3 do -- � ��� ������ 3 ������
        local bid = bids[i]

        SetObjectEnabled(bid.name, nil)
        SetObjectPosition(bid.name, bid.x, bid.y)
        SetDisabledObjectMode(bid.name, DISABLED_INTERACT)

        Trigger(OBJECT_TOUCH_TRIGGER, bid.name, 'playerBid("'..hero..'", "'..bid.name..'")')

        -- ������������� ��� � �������� ��� ������� �������
        OverrideObjectTooltipNameAndDescription(
            bid.name,
            PATH_TO_DAY1_MODULE.."choice_of_races/auction/"..bid.name.."_name.txt",
            PATH_TO_DAY1_MODULE.."choice_of_races/auction/swap.txt"
        )
    end

    -- ������������� ������ ��������
    SetObjectEnabled(agreement.name, nil)
    SetObjectPosition(agreement.name, agreement.x, agreement.y, GROUND)
    SetDisabledObjectMode(agreement.name, DISABLED_INTERACT)
    Trigger(OBJECT_TOUCH_TRIGGER, agreement.name, 'playerAgreement("'..hero..'")')

    -- ������������� ��� � �������� ��� ������� ��������
    OverrideObjectTooltipNameAndDescription(
        agreement.name,
        PATH_TO_DAY1_MODULE.."choice_of_races/auction/"..agreement.name.."_name.txt",
        PATH_TO_DAY1_MODULE.."choice_of_races/auction/blank.txt"
    )

end

-- ������������� �������� � ��������� ���������� ���������
function initializeAuction()
    print("initializeAuction")

    SetObjectPosition(Biara, 35, 87)
    SetObjectPosition(Djovanni, 42, 22)
    blockedRegionAuction()

    removeHeroMovePoints(Djovanni);
    addHeroMovePoints(Biara);

    ShowFlyingSign({PATH_TO_DAY1_MODULE.."choice_of_races/auction/startAuction.txt"}, Biara, PLAYER_1, 5);
    ShowFlyingSign({PATH_TO_DAY1_MODULE.."choice_of_races/auction/startAuction.txt"}, Djovanni, PLAYER_2, 5);

    -- ������� ���������� � ���� ������� ��� ������� ������
    print("������ ����: ", SELECTED_RACE_ID_TABLE[1], " � ", SELECTED_RACE_ID_TABLE[2])

    -- ��������� ����������� � ������ ��� ������ 1
    local player1Bids = {
        { name = 'goldAuction500_Player1', x = 34, y = 88 },
        { name = 'goldAuction1000_Player1', x = 35, y = 88 },
        { name = 'goldAuction2000_Player1', x = 36, y = 88 }
    }
    local player1Agreement = { name = 'spell_nabor1', x = 34, y = 86 }
    local player1InfoPedestal = { name = 'spell_nabor3', x = 36, y = 86 }

    -- ��������� ����������� � ������ ��� ������ 2
    local player2Bids = {
        { name = 'goldAuction2000_Player2', x = 43, y = 23 },
        { name = 'goldAuction1000_Player2', x = 42, y = 23 },
        { name = 'goldAuction500_Player2', x = 41, y = 23 }
    }
    local player2Agreement = { name = 'spell_nabor2', x = 41, y = 21 }
    local player2InfoPedestal = { name = 'spell_nabor4', x = 43, y = 21 }

    -- ��������� �������� � ���������
    deleteAllDelimeters()
    moveDelimetersToRandomChoise()
    showRaces()
    setupAuctionObjects(Biara, player1Bids, player1Agreement)
    setupAuctionObjects(Djovanni, player2Bids, player2Agreement)

    -- ��������� ����������� ��� ����������� ������
    SetObjectEnabled(player1InfoPedestal.name, nil)
    SetObjectPosition(player1InfoPedestal.name, player1InfoPedestal.x, player1InfoPedestal.y, GROUND)
    SetDisabledObjectMode(player1InfoPedestal.name, DISABLED_INTERACT)
    Trigger(OBJECT_TOUCH_TRIGGER, player1InfoPedestal.name, 'showCurrentBids("' .. Biara .. '")')

    OverrideObjectTooltipNameAndDescription(
            player1InfoPedestal.name,
            PATH_TO_DAY1_MODULE.."choice_of_races/auction/showBit.txt",
            PATH_TO_DAY1_MODULE.."choice_of_races/auction/blank.txt"
         --   PATH_TO_DAY1_MODULE.."choice_of_races/auction/"..bid.name.."_description.txt"
        )

    SetObjectEnabled(player2InfoPedestal.name, nil)
    SetObjectPosition(player2InfoPedestal.name, player2InfoPedestal.x, player2InfoPedestal.y, GROUND)
    SetDisabledObjectMode(player2InfoPedestal.name, DISABLED_INTERACT)
    Trigger(OBJECT_TOUCH_TRIGGER, player2InfoPedestal.name, 'showCurrentBids("' .. Djovanni .. '")')

    OverrideObjectTooltipNameAndDescription(
            player2InfoPedestal.name,
            PATH_TO_DAY1_MODULE.."choice_of_races/auction/showBit.txt",
            PATH_TO_DAY1_MODULE.."choice_of_races/auction/blank.txt"
         --   PATH_TO_DAY1_MODULE.."choice_of_races/auction/"..bid.name.."_description.txt"
        )
end

--����������� ������� ������
function showCurrentBids(triggeredHero)
    print("showCurrentBids")

    local playerId = GetPlayerFilter(GetObjectOwner(triggeredHero))

    -- ���������� ������� �������� �������
    local race1 = GetRaceName(SELECTED_RACE_ID_TABLE[1])
    local race2 = GetRaceName(SELECTED_RACE_ID_TABLE[2])

    -- ��������� ����� ������ ��� ������ �������

        local gold1 = mod(COUNT_BID, 2) == 1 and -EXTRA_GOLD or EXTRA_GOLD
        local gold2 = mod(COUNT_BID, 2) == 0 and -EXTRA_GOLD or EXTRA_GOLD

    -- ���������� ��������� � ������� ������ ������
    ShowFlyingSign({
        PATH_TO_DAY1_MODULE.."choice_of_races/auction/whatBit.txt";
        raceName1 = race1,
        gold1 = gold1,
        raceName2 = race2,
        gold2 = gold2
    }, triggeredHero, playerId, 5)
end



-- ������� ��� ��������� ������ �������
function playerBid(triggeredHero, auctionObject)
    print("playerBid")
    local playerId = GetPlayerFilter(GetObjectOwner(triggeredHero))
    local bidAmount = getBidAmount(auctionObject) -- �������� ������ �� ������ ������� ��������
    local playerGold = playerId == PLAYER_1 and PLAYER_1_GOLD or PLAYER_2_GOLD

    TURN = TURN + 1;
    COUNT_BID = COUNT_BID + 1;

    if playerGold >= bidAmount then
        playerGold = playerGold - bidAmount
        EXTRA_GOLD = EXTRA_GOLD + bidAmount

        -- ���������� ������� �������� �������
        local race1 = GetRaceName(SELECTED_RACE_ID_TABLE[1])
        local race2 = GetRaceName(SELECTED_RACE_ID_TABLE[2])

        -- ��������� ����� ������ ��� ������ �������
        local gold1 =  mod(COUNT_BID, 2) == 0 and -EXTRA_GOLD or EXTRA_GOLD
        local gold2 = mod(COUNT_BID, 2) == 1 and -EXTRA_GOLD or EXTRA_GOLD

        -- �������� ��������� � ��������� ������
        ShowFlyingSign({
            PATH_TO_DAY1_MODULE.."choice_of_races/auction/newBit.txt";
            eq = bidAmount,
            raceName1 = race1,
            gold1 = gold1,
            raceName2 = race2,
            gold2 = gold2
        }, Biara, PLAYER_1, 8)

        ShowFlyingSign({
            PATH_TO_DAY1_MODULE.."choice_of_races/auction/newBit.txt";
            eq = bidAmount,
            raceName1 = race1,
            gold1 = gold1,
            raceName2 = race2,
            gold2 = gold2
        }, Djovanni, PLAYER_2, 8)

        -- ������ �������
        local swap = SELECTED_RACE_ID_TABLE[1]
        SELECTED_RACE_ID_TABLE[1] = SELECTED_RACE_ID_TABLE[2]
        SELECTED_RACE_ID_TABLE[2] = swap

        -- ��������� ��������� ������ �������
        showRaces()
    end

    -- ����� ������� ����
    reverseTurn()
end

-- ������� ��� ��������� ����� ������� �� ������ ID
function GetRaceName(raceId)
    local raceNames = {
        [0] = PATH_TO_DAY1_MODULE.."race_names/haven.txt",         -- ����� �������
        [1] = PATH_TO_DAY1_MODULE.."race_names/inferno.txt",       -- �������
        [2] = PATH_TO_DAY1_MODULE.."race_names/necropolis.txt",    -- ����������
        [3] = PATH_TO_DAY1_MODULE.."race_names/sylvan.txt",        -- ������ ����
        [4] = PATH_TO_DAY1_MODULE.."race_names/academy.txt",       -- �������� ����������
        [5] = PATH_TO_DAY1_MODULE.."race_names/dungeon.txt",       -- ���� �����
        [6] = PATH_TO_DAY1_MODULE.."race_names/fortress.txt",      -- �������� �����
        [7] = PATH_TO_DAY1_MODULE.."race_names/stronghold.txt",    -- ������� ����
    }
    return raceNames[raceId]
end

-- ������� ��� ��������� ����� ������ �� ������ ������� ��������
function getBidAmount(auctionObject)
    print("getBidAmount")
    -- �����������, ��� ������� �������� ������� � ����������� �� ������� ������
    if auctionObject == 'goldAuction500_Player1' or auctionObject == 'goldAuction500_Player2' then
        return 500
    elseif auctionObject == 'goldAuction1000_Player1' or auctionObject == 'goldAuction1000_Player2' then
        return 1000
    elseif auctionObject == 'goldAuction2000_Player1' or auctionObject == 'goldAuction2000_Player2' then
        return 2000
    else
      return 0
    end
end

-- ������� ��� ��������� �������� ������
function playerAgreement(triggeredHero)
    print("playerAgreement")
    local playerId = GetPlayerFilter(GetObjectOwner(triggeredHero))
    local opponentPlayerId = nil
    local hero = nil
    local heroOp = nil
    print(playerId)
    TURN = TURN + 1;
    COUNT_BID = COUNT_BID + 1;

    if TURN == 1 then

      if playerId == PLAYER_1 then
        hero = Biara
        heroOp = Djovanni
        opponentPlayerId = PLAYER_2
      else
        hero = Djovanni
        heroOp = Biara
        opponentPlayerId = PLAYER_1
      end;

      ShowFlyingSign({PATH_TO_DAY1_MODULE.."choice_of_races/auction/Accept.txt"; eq = EXTRA_GOLD}, hero, playerId, 5);
      ShowFlyingSign({PATH_TO_DAY1_MODULE.."choice_of_races/auction/opAccept.txt"; eq = EXTRA_GOLD}, heroOp, opponentPlayerId, 5);
      reverseTurn()
      return nil
    end;

    if SELECTED_PAIR == nil then
        SELECTED_PAIR = playerId
        finalizeAuction()
    else
        print("���� ��� ������� ������� ", SELECTED_PAIR)
    end
end

-- ���������� �������� ������
function showRaces()
    print("showRaces")

  local RED_FIELD = {
    [PLAYER_1] = {x = 32, y = 87 },
    [PLAYER_2] = {x = 38, y = 87 },
  }

  local BLUE_FIELD = {
    [PLAYER_1] = {x = 45, y = 22 },
    [PLAYER_2] = {x = 39, y = 22 },
  }

  for playerIndex = 1, 2 do

    local raceId = SELECTED_RACE_ID_TABLE[playerIndex];
    local raceData = ALL_RACES_WITH_COORDINATES[raceId+1];

    local unitForRedFiend = raceData[PLAYER_1].unit;
    local unitForBlueFiend = raceData[PLAYER_2].unit;

    SetObjectPosition(unitForRedFiend, RED_FIELD[playerIndex].x, RED_FIELD[playerIndex].y, GROUND)
    SetObjectPosition(unitForBlueFiend, BLUE_FIELD[playerIndex].x, BLUE_FIELD[playerIndex].y, GROUND)
    SetObjectRotation(unitForRedFiend, 0);
    SetObjectRotation(unitForBlueFiend, 0);

 end;

end;

-- ����� ����
function reverseTurn()
    print("reverseTurn")

    if mod(TURN, 2) == 0 then
      removeHeroMovePoints(Djovanni);
      addHeroMovePoints(Biara);
     -- ShowFlyingSign(PATH_TO_DAY1_MESSAGES..message, Biara, PLAYER_1, 7.0);
    else
      removeHeroMovePoints(Biara);
      addHeroMovePoints(Djovanni);
     -- ShowFlyingSign(PATH_TO_DAY1_MESSAGES..message, Djovanni, PLAYER_2, 7.0);
    end;


end;

-- ������ �����������
function deleteAllDelimetersAuction()
  print "deleteAllDelimetersAuction"

  SetObjectPosition('goldAuction500_Player1', 1, 1);
  SetObjectPosition('goldAuction500_Player2', 1, 1);
  SetObjectPosition('goldAuction1000_Player1', 1, 1);
  SetObjectPosition('goldAuction1000_Player2', 1, 1);
  SetObjectPosition('goldAuction2000_Player1', 1, 1);
  SetObjectPosition('goldAuction2000_Player2', 1, 1);
  SetObjectPosition('spell_nabor1', 1, 1);
  SetObjectPosition('spell_nabor2', 1, 1);
  SetObjectPosition('spell_nabor3', 1, 1);
  SetObjectPosition('spell_nabor4', 1, 1);
end;

-- ������ ������� �������
function deleteAllRaces()
    print("deleteAllRaces")

    for playerIndex = 1, 2 do
        local raceId = SELECTED_RACE_ID_TABLE[playerIndex]
        print(raceId)
        local raceData = ALL_RACES_WITH_COORDINATES[raceId + 1]

        local unitForRedFiend = raceData[PLAYER_1].unit
        local unitForBlueFiend = raceData[PLAYER_2].unit

        SetObjectPosition(unitForRedFiend, 1, 1, GROUND)
        SetObjectPosition(unitForBlueFiend, 1, 1, GROUND)
    end
end;

-- ������� ���������� ����
function unblockedRegion()
  print("unblockedRegion")

  SetRegionBlocked ('auction1', nil);
  SetRegionBlocked ('auction2', nil);
  SetRegionBlocked ('auction3', nil);
  SetRegionBlocked ('auction4', nil);

  SetRegionBlocked ('auction5', nil);
  SetRegionBlocked ('auction6', nil);
  SetRegionBlocked ('auction7', nil);
  SetRegionBlocked ('auction8', nil);
  
  SetRegionBlocked ('Fast_ma_1', nil);
  SetRegionBlocked ('Fast_ma_2', nil);

  SetRegionBlocked ('Fast_ma_3', nil);
  SetRegionBlocked ('Fast_ma_4', nil);
end;


function blockedRegionAuction()
  print("blockedRegionAuction")

  SetRegionBlocked ('auction1', 1);
  SetRegionBlocked ('auction2', 1);
  SetRegionBlocked ('auction3', 1);
  SetRegionBlocked ('auction4', 1);

  SetRegionBlocked ('auction5', 1);
  SetRegionBlocked ('auction6', 1);
  SetRegionBlocked ('auction7', 1);
  SetRegionBlocked ('auction8', 1);
  
  --��� ������ ����������
  SetRegionBlocked ('Fast_ma_1', 1);
  SetRegionBlocked ('Fast_ma_2', 1);

  SetRegionBlocked ('Fast_ma_3', 1);
  SetRegionBlocked ('Fast_ma_4', 1);
end;



-- ��������� ���������� ������
function finalizeAuction()
    print("finalizeAuction")

    -- ����������, ��� �������, � ��� ��������
    if SELECTED_PAIR == PLAYER_1 then
        PLAYER_1_GOLD = 0 - EXTRA_GOLD
        PLAYER_2_GOLD = 0 + EXTRA_GOLD

    else
        PLAYER_1_GOLD = 0 + EXTRA_GOLD
        PLAYER_2_GOLD = 0 - EXTRA_GOLD
    end

    asha.AddGlobalField("BargainsWinner", SELECTED_PAIR)
    asha.AddGlobalField("BargainsAmount", EXTRA_GOLD)
    -- ������� ������� � ��������� � ���������� �����
    deleteAllRaces()
    deleteAllDelimeters()
    deleteAllDelimetersAuction()
    unblockedRegion()
    doFile(PATH_TO_DAY1_MODULE.."choice_of_heroes/cherk_single_heroes.lua")
end

initializeAuction()