-- Скрипт, описывающий механизм выбора расы при черке матчапов

-- Подключение общего функционала
doFile(PATH_TO_DAY1_MODULE.."choice_of_races/common.lua");
sleep(1);

-- Список всех матчапов, для заполнения и предоставления игрокам
MATCHUPS = {
  {
    [PLAYER_1] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm121', poster = 'PosterRed_2', x = 38, y = 90, rot = 90 },
      {name = 'm122', poster = 'PosterRed_8', x = 46, y = 25, rot = 270 },
    }},
    [PLAYER_2] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm222', poster = 'PosterBlue_8', x = 39, y = 90, rot = 270 },
      {name = 'm221', poster = 'PosterBlue_2', x = 45, y = 25, rot = 90 },
    }},
  },
  {
    [PLAYER_1] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm141', poster = 'PosterRed_4', x = 38, y = 87, rot = 90 },
      {name = 'm142', poster = 'PosterRed_10', x = 46, y = 22, rot = 270 },
    }},
    [PLAYER_2] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm242', poster = 'PosterBlue_10', x = 39, y = 87, rot = 270 },
      {name = 'm241', poster = 'PosterBlue_4',  x = 45, y = 22, rot = 90 },
    }},
  },
  {
    [PLAYER_1] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm161', poster = 'PosterRed_6',  x = 38, y = 84, rot = 90 },
      {name = 'm162', poster = 'PosterRed_12', x = 46, y = 19, rot = 270 },
    }},
    [PLAYER_2] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm262', poster = 'PosterBlue_12', x = 39, y = 84, rot = 270 },
      {name = 'm261', poster = 'PosterBlue_6',  x = 45, y = 19, rot = 90 },
    }},
  },
};

-- Точка входа
function choiseMatchupsOfRaces()
  print "choiseMatchupsOfRaces"

  disableAreaInteractive();

  deleteAllDelimeters();

  generateAllMatchups();

  blockedRegionMA();

  cherkHelp();

  showAllMatchups();
end;

-- инициализирование справки
function cherkHelp()
  print "cherkHelp"

  SetObjectEnabled('QuickCherkHelp1', nil);
  SetObjectEnabled('QuickCherkHelp2', nil);

--  SetObjectPosition('red10', 1, 1, UNDERGROUND);
  SetObjectPosition('QuickCherkHelp1', 33, 87, GROUND);
  SetObjectPosition('QuickCherkHelp2', 40, 22, GROUND);

  SetDisabledObjectMode('QuickCherkHelp1', DISABLED_INTERACT);
  SetDisabledObjectMode('QuickCherkHelp2', DISABLED_INTERACT);

  OverrideObjectTooltipNameAndDescription('QuickCherkHelp1', PATH_TO_DAY1_MODULE.."messages/nameAboutFastCherk.txt", PATH_TO_DAY1_MODULE.."messages/deskAboutFastCherk.txt");
  OverrideObjectTooltipNameAndDescription('QuickCherkHelp2', PATH_TO_DAY1_MODULE.."messages/nameAboutFastCherk.txt", PATH_TO_DAY1_MODULE.."messages/deskAboutFastCherk.txt");

  Trigger(OBJECT_TOUCH_TRIGGER, 'QuickCherkHelp1', 'messageAboutFastCherkRed');
  Trigger(OBJECT_TOUCH_TRIGGER, 'QuickCherkHelp2', 'messageAboutFastCherkBlue');
end;

-- сообщение о черке
function messageAboutFastCherkRed()
  print "messageAboutFastCherkRed"

  MessageBoxForPlayers(GetPlayerFilter(PLAYER_1), PATH_TO_DAY1_MODULE.."messages/messageAboutFastCherk.txt")
end;

-- сообщение о черке
function messageAboutFastCherkBlue()
  print "messageAboutFastCherkBlue"

  MessageBoxForPlayers(GetPlayerFilter(PLAYER_2), PATH_TO_DAY1_MODULE.."messages/messageAboutFastCherk.txt")
end;

-- ?aaeiiu aeiee?iaee auno?iai ?a?ea auee
function blockedRegionMA()
  print("blockedRegionMA")

  SetRegionBlocked ('Fast_ma_1', 1);
  SetRegionBlocked ('Fast_ma_2', 1);

  SetRegionBlocked ('Fast_ma_3', 1);
  SetRegionBlocked ('Fast_ma_4', 1);

  SetRegionBlocked ('auction2', 1);
  SetRegionBlocked ('auction4', 1);
  SetRegionBlocked ('auction6', 1);
  SetRegionBlocked ('auction8', 1);

end;

-- ?aaeiiu aeiee?iaee auno?iai ?a?ea auee
function unblockedRegionMA()
  print("unblockedRegionMA")

  SetRegionBlocked ('Fast_ma_1', nil);
  SetRegionBlocked ('Fast_ma_2', nil);

  SetRegionBlocked ('Fast_ma_3', nil);
  SetRegionBlocked ('Fast_ma_4', nil);

end;

-- Генерация всех матчапов для выбора
function generateAllMatchups()
  print "generateAllMatchups"

  -- Счётчик всех рас
  local raceCount = {}
  for i = 0, 7 do
    raceCount[i] = 0
  end

  -- Уникальные ключи матчапов
  local uniqueKeys = {}

  for index = 1, length(MATCHUPS) do
    local r1, r2, key
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

  local isMirror = (r1 == r2)
  local allowMirror = true

  -- Если зеркальный — проверяем шанс 50%
  if isMirror then
    allowMirror = (random(1, 100) <= 50)  -- 50% шанс на зеркалку
  end

  -- 1. Уникальность
  -- 2. Не больше 1 зеркал
  -- 3. Не более 2х по каждой расе
  if allowMirror and not uniqueKeys[key] and raceCount[r1] < 2 and raceCount[r2] < 2 then
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

    local matchup = MATCHUPS[index]
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
  print "changePostersDescription"

  for playerId = 1, length(matchup) do
    local sideData = matchup[playerId];

    for indexUnit = 1, length(sideData.creatures) do
      local unit = sideData.creatures[indexUnit];


      OverrideObjectTooltipNameAndDescription(unit.poster, MAP_RACE_ID_TO_RACE_NAME[sideData.raceId], GetMapDataPath().."notext.txt");
    end;
  end;
end;

-- Получение случайных данных для нового матчапа
function generateRandomMatchup()
  print "generateRandomMatchup"

  local randomRace1 = getRandomRace();
  local randomRace2 = getRandomRace();

  return {
    randomRace1,
    randomRace2,
  };
end;

-- Получение количества переданных матчапов
function getCountMatchups(matchup)
  print "getCountMatchups"

  local count = 0;

  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];

    if (
      currentMatchup[PLAYER_1].raceId == matchup[1]
      and currentMatchup[PLAYER_2].raceId == matchup[2]
    ) then
      count = count + 1;
    end;
  end;

  return count
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

-- Отображение всех сгенерированных матчапов и навешивание триггеров
function showAllMatchups()
  print "showAllMatchups"

  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];

    for playerId = 1, 2 do
      local playerData = currentMatchup[playerId];

      for indexUnit = 1, length(playerData.creatures) do
        local unit = playerData.creatures[indexUnit];

        showSingleUnit(unit, playerData.creatureId);
      end;
    end;
  end;
end;

-- Показ одиночного юнита и навешивание на него триггера
function showSingleUnit(unit, creatureId)
  print "showSingleUnit"


  SetObjectPosition(unit.poster, unit.x, unit.y, GROUND);
  SetObjectEnabled(unit.poster, nil);
  CreateMonster(unit.name, creatureId, 1, unit.x, unit.y, GROUND, 1, 2, unit.rot, 0);
  SetObjectEnabled(unit.name, nil);
  SetDisabledObjectMode(unit.name, DISABLED_INTERACT)
  Trigger(OBJECT_TOUCH_TRIGGER, unit.name, 'questionRemoveMatchup');
  SetObjectPosition(unit.name, unit.x, unit.y, GROUND);
end;

-- Вопрос желает ли игрок вычеркнуть этот матчап
function questionRemoveMatchup(triggeredHero, triggerUnit)
  print "questionRemoveMatchup"

  local playerId = GetPlayerFilter(GetObjectOwner(triggeredHero))

  QuestionBoxForPlayers(playerId, PATH_TO_DAY1_MESSAGES.."question_delete_matchup.txt", 'removeMatchup("'..playerId..'", "'..triggerUnit..'")', 'noop');
end;

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

-- Получение количества удаленных матчапов у переданного игрока
function getCountRemoveMatchupByPlayer(playerId)
  print "getCountRemoveMatchupByPlayer"

  local count = 0;

  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];
    local matchupPlayerData = currentMatchup[playerId];

    if matchupPlayerData.score then
      count = count + 1;
    end;
  end;

  return count;
end;

-- Скрытие переданного матчапа для переданного игрока
function hideMatchupForPlayer(matchup, player)
  print "hideMatchupForPlayer"

  for playerId = 1, length(matchup) do
    local unit = matchup[playerId].creatures[player];

    RemoveObject(unit.name);
    RemoveObject(unit.poster);
  end;
end;

-- Удаление последнего оставшегося матчапа у игрока
function removeLastMatchupForPlayer(player)
  print "removeLastMatchupForPlayer"

  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];
    local matchupPlayerData = currentMatchup[player];

    if not matchupPlayerData.score then
      matchupPlayerData.score = 5;
--      ShowFlyingSign({ PATH_TO_DAY1_MESSAGES.."score.txt"; eq = 5}, matchupPlayerData.creatures[player].name, player, 2.0);

      hideMatchupForPlayer(currentMatchup, player);
    end;
  end;
end;

-- Получение количества сторон, закончивших черк
function getCountSideFinishedCherk()
  print "getCountSideFinishedCherk"

  local count = 0;

  for playerId = 1, 2 do
    local countRemoveMA = getCountRemoveMatchupByPlayer(playerId);

    if countRemoveMA == 3 then
      count = count + 1;
    end;
  end;

  return count;
end;

-- Завершение черка переданному игроку
function finishPlayerChoise(playerId)
  print "finishPlayerChoise"

  local hero = playerId == PLAYER_1 and Biara or Djovanni;

  removeHeroMovePoints(hero);
  removeLastMatchupForPlayer(playerId);

  local countSideFinished = getCountSideFinishedCherk();

  if countSideFinished == 2 then
    finishChoiseOfMatchups();
  else
    ShowFlyingSign({ PATH_TO_DAY1_MODULE.."messages/waitOpponent.txt"}, hero, playerId, 4.0);
  end;
end;

-- Получение всех матчапов с максимальным количеством очков
function getMaximumScoreMatchups()
  print "getMaximumScoreMatchups"

  local maxSummareScore = 0;
  local maxScoreMatchups = {}; -- массив для хранения индексов матчапов с максимальными очками

  -- Определяем максимальную сумму очков
  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];
    local sumScore = currentMatchup[PLAYER_1].score + currentMatchup[PLAYER_2].score;

    if sumScore > maxSummareScore then
      maxSummareScore = sumScore;
    end;
  end;

  -- Собираем все матчапы с максимальной суммой очков
  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];
    local sumScore = currentMatchup[PLAYER_1].score + currentMatchup[PLAYER_2].score;

    if sumScore == maxSummareScore then
      -- Добавляем матчап в массив по индексу
      maxScoreMatchups[length(maxScoreMatchups) + 1] = currentMatchup;
    end;
  end;

  return maxScoreMatchups;
end;


-- Окончание черка матчапов
function finishChoiseOfMatchups()
  print "finishChoiseOfMatchups"

  local resultMatchup = getMaximumScoreMatchups()

  -- Если матчапов больше одного, выбираем случайный
  local selectedMatchup
  local countMatchups = length(resultMatchup)
  if countMatchups > 1 then
    local randomIndex = (random(countMatchups)) + 1
    selectedMatchup = resultMatchup[randomIndex]
    print("Neo?aeii aua?aiiue iao?ai n eiaaenii: " .. randomIndex)
  else
    selectedMatchup = resultMatchup[1]
    print("Aaeinoaaiiue iao?ai aua?ai aaoiiaoe?anee.")
  end

  -- Устанавливаем расы для игроков
  for playerId = 1, 2 do
    SELECTED_RACE_ID_TABLE[playerId] = selectedMatchup[playerId].raceId
  end

  -- Выполняем следующий модуль
  CUSTOM_GAME_MODE_AUCTION = 1;
  blockedRegionAU();
  unblockedRegionMA();
  SetObjectPosition('QuickCherkHelp1', 1, 1, UNDERGROUND);
  SetObjectPosition('QuickCherkHelp2', 1, 1, UNDERGROUND);
  doFile(PATH_TO_DAY1_MODULE.."choice_of_races/auction.lua");
end

-- Регионы блокировки вкл
function blockedRegionAU()
  print("blockedRegionAU")

  SetRegionBlocked ('auction1', 1);
  SetRegionBlocked ('auction2', 1);
  SetRegionBlocked ('auction3', 1);
  SetRegionBlocked ('auction4', 1);

  SetRegionBlocked ('auction5', 1);
  SetRegionBlocked ('auction6', 1);
  SetRegionBlocked ('auction7', 1);
  SetRegionBlocked ('auction8', 1);
end;

-- Обработчик удаления матчапа и выставления очков матчу
function removeMatchup(playerId, unit)
  print "removeMatchup"

  local playerId = playerId + 0;
  local matchup = getMatchupByUnit(unit);
  local countPlayerDeletedMatchups = getCountRemoveMatchupByPlayer(playerId);

  matchup[playerId].score = countPlayerDeletedMatchups;
  --ShowFlyingSign({ PATH_TO_DAY1_MESSAGES.."score.txt"; eq = countPlayerDeletedMatchups}, unit, playerId, 2.0);
  hideMatchupForPlayer(matchup, playerId);
  finishPlayerChoise(playerId);

end;

choiseMatchupsOfRaces();