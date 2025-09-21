-- Скрипт, описывающий механизм выбора расы

-- Подключение общего функционала
doFile(PATH_TO_DAY1_MODULE.."choice_of_races/common.lua");

sleep(1);

MSG_PATH = PATH_TO_DAY1_MODULE.."choice_of_races/five/"

-- Переменные для голосования
AUCTION_VOTE = {
  [PLAYER_1] = nil,  -- true = "ДА", false = "НЕТ"
  [PLAYER_2] = nil,
}

CURRENT_CHERK_STAGE = 1  -- этапы от 1 до 4

-- Точка входа — начало черка матчапов
function startAuctionVote()
  print "startAuctionVote"

  -- Запускаем голосование у обоих
  QuestionBoxForPlayers(GetPlayerFilter(PLAYER_1),
    MSG_PATH.."question_auction.txt",
    'onAuctionVoteYes('..PLAYER_1..')',
    'onAuctionVoteNo('..PLAYER_1..')'
  )
  QuestionBoxForPlayers(GetPlayerFilter(PLAYER_2),
    MSG_PATH.."question_auction.txt",
    'onAuctionVoteYes('..PLAYER_2..')',
    'onAuctionVoteNo('..PLAYER_2..')'
  )
end

-- Игрок нажал "Да"
function onAuctionVoteYes(playerId)
  print("onAuctionVoteYes", playerId)
  
  AUCTION_VOTE[playerId] = 1
  tryFinishAuctionVoting()
end

-- Игрок нажал "Нет"
function onAuctionVoteNo(playerId)
  print("onAuctionVoteNo", playerId)
  
  AUCTION_VOTE[playerId] = 0
  tryFinishAuctionVoting()
end

-- Проверяем, оба ли уже проголосовали
function tryFinishAuctionVoting()
  print "tryFinishAuctionVoting"
  if AUCTION_VOTE[PLAYER_1] == nil or AUCTION_VOTE[PLAYER_2] == nil then
    return
  end
  endChoiseMatchupsOfRaces()
end

function endChoiseMatchupsOfRaces()
  print "endChoiseMatchupsOfRaces"

  local redVote  = AUCTION_VOTE[PLAYER_1]
  local blueVote = AUCTION_VOTE[PLAYER_2]
  local messageFile

  -- Безопасно устанавливаем режим торгов
  if redVote == 1 or blueVote == 1 then
    CUSTOM_GAME_MODE_AUCTION = 1
  else
    CUSTOM_GAME_MODE_AUCTION = 0
  end

  -- Выбираем файл по сценарию
  if redVote == 1 and blueVote == 1 then
    messageFile = "both_yes.txt"
  elseif redVote == 1 and blueVote == 0 then
    messageFile = "red_yes_blue_no.txt"
  elseif redVote == 0 and blueVote == 1 then
    messageFile = "red_no_blue_yes.txt"
  else
    messageFile = "both_no.txt"
  end

  -- Показываем каждому игроку его итоговое сообщение
  ShowFlyingSign(MSG_PATH..messageFile, Biara,    PLAYER_1, 7)
  ShowFlyingSign(MSG_PATH..messageFile, Djovanni, PLAYER_2, 7)

  -- Генерация матчапов и справка
  
  if CUSTOM_GAME_MODE_AUCTION == 1 then
    spawnAuctionGoldDecor()
  end;
  
  generateAllMatchups()
  cherkHelp()
  showAllMatchups()
end

function spawnAuctionGoldDecor()
  print "spawnAuctionGoldDecor"

  SetObjectEnabled('goldAuction500_Player1', nil);  SetDisabledObjectMode('goldAuction500_Player1', DISABLED_BLOCKED);
  SetObjectEnabled('goldAuction500_Player2', nil);  SetDisabledObjectMode('goldAuction500_Player2', DISABLED_BLOCKED);
  
  SetObjectPosition('goldAuction500_Player1', 35, 91);
  SetObjectPosition('goldAuction500_Player2', 42, 18);
  
  OverrideObjectTooltipNameAndDescription(
        'goldAuction500_Player1',
        PATH_TO_DAY1_MODULE.."choice_of_races/auction/auctionOn.txt",
        PATH_TO_DAY1_MODULE.."choice_of_races/auction/blank.txt"
    )
  OverrideObjectTooltipNameAndDescription(
        'goldAuction500_Player2',
        PATH_TO_DAY1_MODULE.."choice_of_races/auction/auctionOn.txt",
        PATH_TO_DAY1_MODULE.."choice_of_races/auction/blank.txt"
    )
end;

-- Убрали препятствия
function deleteAuctionGoldDecor()
  print "deleteAuctionGoldDecor"

  SetObjectPosition('goldAuction500_Player1', 1, 1);
  SetObjectPosition('goldAuction500_Player2', 1, 1);
  
end

-- Точка входа
function startChoiseMatchupsOfRaces()
  print "startChoiseMatchupsOfRaces"

  disableAreaInteractive();

  deleteAllDelimeters();
  
  startAuctionVote();

end;

-- инициализирование справки
function cherkHelp()
  print "cherkHelp"

  SetObjectEnabled('QuickCherkHelp1', nil);
  SetObjectEnabled('QuickCherkHelp2', nil);

  SetObjectPosition('QuickCherkHelp1', 33, 87, GROUND);
  SetObjectPosition('QuickCherkHelp2', 40, 22, GROUND);

  SetDisabledObjectMode('QuickCherkHelp1', DISABLED_INTERACT);
  SetDisabledObjectMode('QuickCherkHelp2', DISABLED_INTERACT);

  OverrideObjectTooltipNameAndDescription('QuickCherkHelp1', PATH_TO_DAY1_MODULE.."messages/nameAboutFiveCherk.txt", PATH_TO_DAY1_MODULE.."messages/deskAboutFiveCherk.txt");
  OverrideObjectTooltipNameAndDescription('QuickCherkHelp2', PATH_TO_DAY1_MODULE.."messages/nameAboutFiveCherk.txt", PATH_TO_DAY1_MODULE.."messages/deskAboutFiveCherk.txt");

  Trigger(OBJECT_TOUCH_TRIGGER, 'QuickCherkHelp1', 'messageAboutFiveCherkRed');
  Trigger(OBJECT_TOUCH_TRIGGER, 'QuickCherkHelp2', 'messageAboutFiveCherkBlue');
end;

-- сообщение о черке
function messageAboutFiveCherkRed()
  print "messageAboutFiveCherkRed"

  MessageBoxForPlayers(GetPlayerFilter(PLAYER_1), PATH_TO_DAY1_MODULE.."messages/messageAboutFiveCherk.txt")
end;

-- сообщение о черке
function messageAboutFiveCherkBlue()
  print "messageAboutFiveCherkBlue"

  MessageBoxForPlayers(GetPlayerFilter(PLAYER_2), PATH_TO_DAY1_MODULE.."messages/messageAboutFiveCherk.txt")
end;

-- Генерация всех матчапов
function generateAllMatchups()
  -- Счётчик всех рас
  local raceCount = {}
  for i = 0, 7 do
    raceCount[i] = 0
  end

  -- Хранилище уже использованных матчапов
  local uniqueKeys = {}

  for index = 1, length(MATCHUPS) do
    local matchup
    local r1, r2, key, reverseKey
    local isValid = false

    repeat
      r1 = getRandomRace()
      r2 = getRandomRace()

      -- Сортируем для ключа — исключаем зеркальность вида 3 1 и 1 3
      local a = r1
      local b = r2
      if a > b then
        local tmp = a
        a = b
        b = tmp
      end
      key = a.."_"..b

      -- Проверка условий:
      -- 1. Уникальность
      -- 2. Не больше 1 зеркал
      -- 3. Не более 4х по каждой расе
      if not uniqueKeys[key] and raceCount[r1] < 4 and raceCount[r2] < 4 then
        -- Проверка зеркал (всего разрешаем 1 зеркальный матчап)
        local mirrorCount = getCountMirrorMatchups({r1, r2})
        if mirrorCount < 2 then
          isValid = true
          uniqueKeys[key] = true
          raceCount[r1] = raceCount[r1] + 1
          raceCount[r2] = raceCount[r2] + 1
        end
      end
    until isValid

    matchup = MATCHUPS[index]
    matchup[PLAYER_1].raceId     = r1
    matchup[PLAYER_1].creatureId = MAPPING_RACE_TO_CREATURES[r1].ID1
    matchup[PLAYER_2].raceId     = r2
    matchup[PLAYER_2].creatureId = MAPPING_RACE_TO_CREATURES[r2].ID1

    changeMatchupPostersDescription(matchup)
    print("Generated:", r1, r2)
  end
end


-- Получение случайных данных для нового матчапа
function changeMatchupPostersDescription(matchup)
  print "changeMatchupPostersDescription"

  -- Явно для двух игроков
  for playerId = PLAYER_1, PLAYER_2 do
    local sideData = matchup[playerId]

    -- У sideData.creatures — числовой массив, длину берём через length()
    for idx = 1, length(sideData.creatures) do
      local unit = sideData.creatures[idx]

      -- Делаем Override, подставляя нужный файл с названием расы
      OverrideObjectTooltipNameAndDescription(
        unit.poster,
      --  PATH_TO_DAY1_MODULE.."choice_of_races/five/"..MAP_RACE_ID_TO_RACE_NAME[sideData.raceId]..".txt",
        MAP_RACE_ID_TO_RACE_NAME[sideData.raceId],
        GetMapDataPath().."notext.txt"
      )
    end
  end
end


-- Список всех матчапов, для заполнения и предоставления игрокам
MATCHUPS = {
  {
   removed     = false,
    [PLAYER_1] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm_1', poster = 'PosterRed_2', x = 38, y = 90, rot = 90 },
      {name = 'm_2', poster = 'PosterRed_8', x = 46, y = 25, rot = 270 },
    }},
    [PLAYER_2] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm_3', poster = 'PosterBlue_8', x = 39, y = 90, rot = 270 },
      {name = 'm_4', poster = 'PosterBlue_2', x = 45, y = 25, rot = 90 },
    }},
  },
  {
   removed     = false,
    [PLAYER_1] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm_5', poster = 'PosterRed_4', x = 38, y = 87, rot = 90 },
      {name = 'm_6', poster = 'PosterRed_10', x = 46, y = 22, rot = 270 },
    }},
    [PLAYER_2] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm_7', poster = 'PosterBlue_10', x = 39, y = 87, rot = 270 },
      {name = 'm_8', poster = 'PosterBlue_4',  x = 45, y = 22, rot = 90 },
    }},
  },
  {
   removed     = false,
    [PLAYER_1] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm_9', poster = 'PosterRed_6',  x = 38, y = 84, rot = 90 },
      {name = 'm_10', poster = 'PosterRed_12', x = 46, y = 19, rot = 270 },
    }},
    [PLAYER_2] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm_11', poster = 'PosterBlue_12', x = 39, y = 84, rot = 270 },
      {name = 'm_12', poster = 'PosterBlue_6',  x = 45, y = 19, rot = 90 },
    }},
  },
  {
  removed     = false,
    [PLAYER_1] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm_13', poster = 'PosterRed_1',  x = 31, y = 90, rot = 90 },
      {name = 'm_14', poster = 'PosterRed_3', x = 39, y = 25, rot = 270 },
    }},
    [PLAYER_2] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm_15', poster = 'PosterBlue_3', x = 32, y = 90, rot = 270 },
      {name = 'm_16', poster = 'PosterBlue_1',  x = 38, y = 25, rot = 90 },
    }},
  },
  {
  removed     = false,
    [PLAYER_1] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm_17', poster = 'PosterRed_5',  x = 31, y = 84, rot = 90 },
      {name = 'm_18', poster = 'PosterRed_7', x = 39, y = 19, rot = 270 },
    }},
    [PLAYER_2] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm_19', poster = 'PosterBlue_7', x = 32, y = 84, rot = 270 },
      {name = 'm_20', poster = 'PosterBlue_5',  x = 38, y = 19, rot = 90 },
    }},
  },
};


function showAllMatchups()
print("showAllMatchups")
  for idx = 1, length(MATCHUPS) do
    local matchup = MATCHUPS[idx]
    local redSide = matchup[PLAYER_1]
    local blueSide = matchup[PLAYER_2]

    local redCount = length(redSide.creatures)
    local blueCount = length(blueSide.creatures)



    local count = redCount
    if blueCount < count then
      count = 1
    end

    for i = 1, count do
      local red = redSide.creatures[i]
      local blue = blueSide.creatures[i]

      SetObjectPosition(red.poster, red.x, red.y, GROUND);
      SetObjectEnabled(red.poster, nil);
      CreateMonster(red.name, redSide.creatureId, 1, red.x, red.y, GROUND, 1, 2, red.rot, 0)
      SetObjectEnabled(red.name, nil);
      SetDisabledObjectMode(red.name, DISABLED_INTERACT)
      SetObjectPosition(red.name, red.x, red.y, GROUND);
      Trigger(OBJECT_TOUCH_TRIGGER, red.name, 'questionRemoveMatchup');

      SetObjectPosition(blue.poster, blue.x, blue.y, GROUND);
      SetObjectEnabled(blue.poster, nil);
      CreateMonster(blue.name, blueSide.creatureId, 1, blue.x, blue.y, GROUND, 1, 2, blue.rot, 0)
      SetObjectEnabled(blue.name, nil);
      SetDisabledObjectMode(blue.name, DISABLED_INTERACT)
      SetObjectPosition(blue.name, blue.x, blue.y, GROUND);
      Trigger(OBJECT_TOUCH_TRIGGER, blue.name, 'questionRemoveMatchup');

    end
  end
end

function getCountRemoved()
print "getCountRemoved"
  local cnt = 0
  for i = 1, length(MATCHUPS) do
    if MATCHUPS[i].removed then
      cnt = cnt + 1
    end
  end
  return cnt
end

function removeLastRemaining()
print "removeLastRemaining"
  for i = 1, length(MATCHUPS) do
    local m = MATCHUPS[i]
    if not m.removed then
      hideMatchupForPlayer(m, PLAYER_1)
      hideMatchupForPlayer(m, PLAYER_2)
      return
    end
  end
 end

-- Вопрос желает ли игрок вычеркнуть этот матчап
function questionRemoveMatchup(triggeredHero, triggerUnit)
  print "questionRemoveMatchup"

  local playerId = GetPlayerFilter(GetObjectOwner(triggeredHero))

  QuestionBoxForPlayers(playerId, PATH_TO_DAY1_MESSAGES.."question_delete_matchup.txt", 'removeMatchup("'..playerId..'", "'..triggerUnit..'")', 'noop');
end;

-- Проверка хода игроков и выдача мувов
function updateCherkMovePoints()
print "updateCherkMovePoints"

  if CURRENT_CHERK_STAGE == 1 then
    addHeroMovePoints(Biara);     removeHeroMovePoints(Djovanni)
  elseif CURRENT_CHERK_STAGE == 2 or CURRENT_CHERK_STAGE == 3 then
    addHeroMovePoints(Djovanni);  removeHeroMovePoints(Biara)
    ShowFlyingSign(MSG_PATH.."your_turn.txt", Djovanni, PLAYER_2, 5.0);
  elseif CURRENT_CHERK_STAGE == 4 then
    addHeroMovePoints(Biara);     removeHeroMovePoints(Djovanni)
    ShowFlyingSign(MSG_PATH.."your_turn.txt", Biara, PLAYER_1, 5.0);
  else
    print("Ошибка: неверный этап черка:", CURRENT_CHERK_STAGE)
  end
end


-- Обработчик удаления матчапа и выставления очков матчу
function removeMatchup(strPlayerId, unit)
  print "removeMatchup"
  
  local playerId = strPlayerId + 0;

  local matchup = getMatchupByUnit(unit)
  if not matchup then return end

  matchup.removed = true

  hideMatchupForPlayer(matchup, PLAYER_1)
  hideMatchupForPlayer(matchup, PLAYER_2)

  CURRENT_CHERK_STAGE = CURRENT_CHERK_STAGE + 1
  updateCherkMovePoints()

  finishPlayerChoise(playerId)
end


function finishPlayerChoise(playerId)
  print "finishPlayerChoise"

  local removed = getCountRemoved()
  local total   = length(MATCHUPS)
  
  local hero = playerId == PLAYER_1 and Biara or Djovanni;

  if removed == total - 1 then
    -- если остался ровно один, вычёркиваем его и завершаем
    removeLastRemaining()
    finishChoiseOfMatchups()

  else
--      ShowFlyingSign(MSG_PATH.."wait_for_enemy.txt", 1 - playerId, 5)
  end
end

function finishChoiseOfMatchups()
  print "finishChoiseOfMatchups"

  local selectedMatchup
  for i = 1, length(MATCHUPS) do
    if not MATCHUPS[i].removed then
      selectedMatchup = MATCHUPS[i]
      break
    end
  end

  if not selectedMatchup then
    print("ОШИБКА: не найден оставшийся матчап!")
    return
  end

  for playerId = 1, 2 do
    SELECTED_RACE_ID_TABLE[playerId] = selectedMatchup[playerId].raceId
  end

  SetObjectPosition('QuickCherkHelp1', 1, 1, UNDERGROUND)
  SetObjectPosition('QuickCherkHelp2', 1, 1, UNDERGROUND)

  if CUSTOM_GAME_MODE_AUCTION == 1 then
    deleteAuctionGoldDecor()
    doFile(PATH_TO_DAY1_MODULE.."choice_of_races/auction.lua")
  end
  if CUSTOM_GAME_MODE_AUCTION == 0 then
    doFile(PATH_TO_DAY1_MODULE.."choice_of_heroes/cherk_single_heroes.lua");
--  blockedRegionAU()
--  unblockedRegionMA()
  end;
end




-- Скрытие переданного матчапа для переданного игрока
function hideMatchupForPlayer(matchup, player)
  print "hideMatchupForPlayer"

  local list = matchup[player].creatures
  for i = 1, length(list) do
    RemoveObject(list[i].name)
    RemoveObject(list[i].poster)
  end
end



-- Получение матчапа по name переданного существа
function getMatchupByUnit(inputUnit)
  print "getMatchupByUnit"

  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];

    for playerId = 1, 2 do
      local playerData = currentMatchup[playerId];

      for indexUnit = 1, length(playerData.creatures) do
        local unit = playerData.creatures[indexUnit];

        if unit.name == inputUnit then
          return currentMatchup;
        end;
      end;
    end;
  end;
end;

-- Получение количества зеркальных матчапов включая переданный
function getCountMirrorMatchups(matchup)
  print "getCountMirrorMatchups"

  local count = 0;

  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];

    if (
     currentMatchup[PLAYER_1].raceId and currentMatchup[PLAYER_2].raceId
     and currentMatchup[PLAYER_1].raceId == currentMatchup[PLAYER_2].raceId
    ) then
      count = count + 1;
    end;
  end;

  if matchup[1] == matchup[2] then
     count = count + 1;
  end

  return count;
end;

startChoiseMatchupsOfRaces();