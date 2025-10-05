
PATH_TO_CHOISE_OF_HEROES = PATH_TO_DAY1_MODULE.."choice_of_heroes/";

doFile(PATH_TO_CHOISE_OF_HEROES.."common.lua");
sleep(1);

-- Список случайных героев для выбранных рас
randomHeroList = {
  [PLAYER_1] = {
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
  },
  [PLAYER_2] = {
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
  },
};

-- Черк по одному герою
function cherkSingleHeroes()
  print "cherkSingleHeroes"

--  SetObjectEnabled('red1', nil); SetDisabledObjectMode('red17', DISABLED_BLOCKED);
--  SetObjectEnabled('red2', nil); SetDisabledObjectMode('red18', DISABLED_BLOCKED);
--  SetObjectEnabled('blue1', nil); SetDisabledObjectMode('blue17', DISABLED_BLOCKED);
--  SetObjectEnabled('blue2', nil); SetDisabledObjectMode('blue18', DISABLED_BLOCKED);

--  SetObjectPosition('red1', 31, 86);
--  SetObjectPosition('red2', 39, 86);
--  SetObjectPosition('blue1', 31, 88);
--  SetObjectPosition('blue2', 39, 88);

    SetObjectPosition('blue10', 1, 1);

    SetObjectPosition('red1', 42, 26);
    SetObjectPosition('blue1', 42, 18);

    SetObjectPosition('blue2', 35, 91);

--  SetObjectPosition('red19', 44, 24);
--  SetObjectPosition('red20', 44, 24);
--  SetObjectPosition('blue19', 44, 24);
--  SetObjectPosition('blue20', 44, 24);



--  SetObjectEnabled('red19', nil); SetDisabledObjectMode('red19', DISABLED_BLOCKED);
--  SetObjectEnabled('red20', nil); SetDisabledObjectMode('red20', DISABLED_BLOCKED);
--  SetObjectEnabled('blue19', nil); SetDisabledObjectMode('blue19', DISABLED_BLOCKED);
--  SetObjectEnabled('blue20', nil); SetDisabledObjectMode('blue20', DISABLED_BLOCKED);

  SetObjectPosition(Biara, 35, 87);
  SetObjectPosition(Djovanni, 42, 22);

  removeHeroMovePoints(Djovanni);
  addHeroMovePoints(Biara)

  removeRaceRegionTriggers();

  -- Меняем описание портретов всех героев выбранных рас
  changeDescriptionForSelectedRaceHeroIcons();

  -- Генерируем списки случайных героев для обоих игроков
  generateRandomHeroListByPlayerIdAndRaceId(PLAYER_1, SELECTED_RACE_ID_TABLE[1]);
  generateRandomHeroListByPlayerIdAndRaceId(PLAYER_2, SELECTED_RACE_ID_TABLE[2]);

  -- Расставляем сгенерированных героев для выбора
  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId];

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      if playerId == PLAYER_1 then
        SetObjectPosition(heroData.red_icon, (31 + heroIndex), 85, GROUND);
        SetObjectPosition(heroData.blue_icon, (38 + heroIndex), 23, GROUND);
      else
        SetObjectPosition(heroData.red_icon, (31 + heroIndex), 88, GROUND);
        SetObjectPosition(heroData.blue_icon, (38 + heroIndex), 20, GROUND);
      end;

      Trigger(OBJECT_TOUCH_TRIGGER, heroData.red_icon, 'handleTouchHero');
      Trigger(OBJECT_TOUCH_TRIGGER, heroData.blue_icon, 'handleTouchHero');
    end;
  end;

  changePlayersTurnForChoosingHero();
end;

-- Удаление триггеров с регионов, где находились расы
function removeRaceRegionTriggers()
  print "removeRaceRegionTriggers"

  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race1', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race2', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race3', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race4', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race5', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race6', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race7', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race8', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race1', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race2', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race3', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race4', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race5', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race6', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race7', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race8', 'noop');
end;

-- Убираем перегородки
function deleteFlagsCrystal()

    SetObjectPosition('blue10', 42, 26);
    SetObjectPosition('red1', 1, 1);
    SetObjectPosition('blue1', 1, 1);
    SetObjectPosition('blue2', 1, 1);

end;

-- Меняем имя и описание для всех героев переданных рас
function changeDescriptionForSelectedRaceHeroIcons()
  print "changeDescriptionForSelectedRaceHeroIcons"

  -- Изменяем название и описание портретов всех героев выбранных рас на карте
  for raceIndex, raceId in SELECTED_RACE_ID_TABLE do
    local currentRaceHeroList = HEROES_BY_RACE[raceId];

    for heroIndex, heroData in currentRaceHeroList do
      local playerList = { PLAYER_1, PLAYER_2 };

      for playerIndex, playerId in playerList do
        for iconsIndex = 1, length(heroData[playerId]) do
          local icons = heroData[playerId][iconsIndex];

          SetObjectEnabled(icons.red_icon, nil);
          OverrideObjectTooltipNameAndDescription(icons.red_icon, PATH_TO_HERO_NAMES..heroData.txt, heroData.dsc);
          SetObjectEnabled(icons.blue_icon, nil);
          OverrideObjectTooltipNameAndDescription(icons.blue_icon, PATH_TO_HERO_NAMES..heroData.txt, heroData.dsc);
        end;
      end;
    end;
  end;
end;

-- Генерация 7 случайных героев переданной расы для выбранного игрока
function generateRandomHeroListByPlayerIdAndRaceId(playerId, raceId)
  print "generateRandomHeroListByPlayerIdAndRaceId"

  for generateIndex = 1, 7 do
    local currentRaceHeroList = HEROES_BY_RACE[raceId];
    local randomHeroIndex, randomHeroName, isHeroExist;

    repeat
      randomHeroIndex = random(length(currentRaceHeroList)) + 1;
      randomHeroName = currentRaceHeroList[randomHeroIndex].name;

      isHeroExist = getHasHeroInHeroRandomList(playerId, randomHeroName);
    until not isHeroExist;

    randomHeroList[playerId][generateIndex] = {
      name = randomHeroName,
      raceId = raceId,
      red_icon = currentRaceHeroList[randomHeroIndex][playerId][1].red_icon,
      blue_icon = currentRaceHeroList[randomHeroIndex][playerId][1].blue_icon,
    };
  end;
end;

-- Получение признака, есть ли такой герой в списке для выбора у определенного игрока
function getHasHeroInHeroRandomList(playerId, heroName)
  print "getHasHeroInHeroRandomList"

  local count = 0;
  local randomHeroes = randomHeroList[playerId]

  for indexHero = 1, length(randomHeroes) do
    if (randomHeroes[indexHero].name == heroName) then
      count = count + 1;
    end;
  end;

  return count > 0;
end;

-- Обработчик касания героев для выбора
function handleTouchHero(triggerPlayerHero, triggeredHeroIconName)
  print "handleTouchHero"

  -- игрок, которому принадлежит этот герой
  local player, heroName = getRelatedPlayerAndHeroNameByHeroIconName(triggeredHeroIconName);

  local triggerPlayer = GetPlayerFilter(GetObjectOwner(triggerPlayerHero));
  local action = getCurrentTurnAction();
  local question = action == TURN_ACTIONS.CHOOSING and "question_add_hero.txt" or "question_delete_hero.txt";

  QuestionBoxForPlayers(triggerPlayer, PATH_TO_DAY1_MESSAGES..question, "handlerAddOrDeleteHero('"..player.."', '"..heroName.."')", 'noop');
end;

-- Получение игрока, которому принадлежит выбранный герой
function getRelatedPlayerAndHeroNameByHeroIconName(heroIconName)
  print "getRelatedPlayerAndHeroNameByHeroIconName"

  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId];

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      if (heroData.red_icon == heroIconName or heroData.blue_icon == heroIconName) then
        return playerId, heroData.name;
      end;
    end;
  end;
end;

-- Признак, что идет первым: выбор или удаление: 0 - сначала добавляем, 1 - сначала удаляем
RANDOM_CHOOSE_FIRST_FLAG = 1;--random(2);

-- Перечисление типов хода при черке героев: 0 - Вычеркиваем, 1 - Добавляем
TURN_ACTIONS = {
  CHOOSING = 1,
  DELETING = 0,
};

-- Получение типа действия текущего хода:
function getCurrentTurnAction()
  print "getCurrentTurnAction"

  -- Соотношение хода героя к типу действия при черке
  local mapFlagToTurnAction = {
    [0] = { TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING },
    [1] = { TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING },
  };
  local turn = getHeroTurn();

  return mapFlagToTurnAction[RANDOM_CHOOSE_FIRST_FLAG][turn + 1];
end;

-- Получение номера текущего хода
function getHeroTurn()
  print "getHeroTurn"

  local count = 0;

  -- Считаем всех героев, которые были добавлены или удалены игроками
  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId];

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      if (heroData.manual_change) then
        count = count + 1;
      end;
    end;
  end;

  return count;
end;

-- Обработчик удаления или добавления героя
function handlerAddOrDeleteHero(playerId, heroName)
  print "handlerAddOrDeleteHero"

  -- Преобразование строки к числу
  local playerId = playerId + 0;

  local action = getCurrentTurnAction();
  if action == TURN_ACTIONS.CHOOSING then
    addHeroForPlayer(playerId, heroName, true);
  else
  --  hideHeroToUnderground(playerId, heroName, true);
    banHero(playerId, heroName)
  end;

  checkOnSelectMaximumHeroes();
  changePlayersTurnForChoosingHero();
end;

BAN_ICONS_START = {
    red_zone = {
        red   = {x = 36, y = 24}, -- красные герои
        blue  = {x = 29, y = 89}, -- синие герои
    },
    blue_zone = {
        red   = {x = 29, y = 84}, -- красные герои
        blue  = {x = 36, y = 19}, -- синие герои
    }
}

-- счетчики банов
BAN_COUNT = {
  [PLAYER_1] = 0,
  [PLAYER_2] = 0,
}

-- стартовые точки столбиков бана
BAN_STEP = 1
BAN_START = {
  red_zone  = { -- координаты у красного
    red  = {x = 48, y = 25}, -- бан КРАСНЫХ героев
    blue = {x = 41, y = 90}, -- бан СИНИХ героев
  },
  blue_zone = { -- координаты у синего
    red  = {x = 29, y = 83}, -- бан КРАСНЫХ героев
    blue = {x = 36, y = 18}, -- бан СИНИХ героев
  }
}

-- направления по Y: красный столбик растёт вверх, синий — вниз
BAN_DIR_Y = {
  red_zone  = -1,
  blue_zone =  1
}

-- Бан героя (иконки летят в столбики и сдвигаются на 1)
function banHero(playerId, heroName)
  print "banHero"

  -- если первый бан для игрока – ставим бан-иконки в начало очереди
  if BAN_COUNT[playerId] == 0 then
    if playerId == PLAYER_1 then
      local rz = BAN_START.red_zone.red
      local bz = BAN_START.blue_zone.red
      SetObjectPosition('banRed_1',  rz.x, rz.y, GROUND)
      OverrideObjectTooltipNameAndDescription('banRed_1', PATH_TO_DAY1_MESSAGES.."ban_icon.txt", GetMapDataPath().."notext.txt");
      Trigger(OBJECT_TOUCH_TRIGGER, 'banRed_1', 'noop')
      SetObjectPosition('banRed_2', bz.x, bz.y, GROUND)
      OverrideObjectTooltipNameAndDescription('banRed_2', PATH_TO_DAY1_MESSAGES.."ban_icon.txt", GetMapDataPath().."notext.txt");
      Trigger(OBJECT_TOUCH_TRIGGER, 'banRed_2', 'noop')
    else
      local rz = BAN_START.red_zone.blue
      local bz = BAN_START.blue_zone.blue
      SetObjectPosition('banBlue_1',  rz.x, rz.y, GROUND)
      OverrideObjectTooltipNameAndDescription('banBlue_1', PATH_TO_DAY1_MESSAGES.."ban_icon.txt", GetMapDataPath().."notext.txt");
      Trigger(OBJECT_TOUCH_TRIGGER, 'banBlue_1', 'noop')
      SetObjectPosition('banBlue_2', bz.x, bz.y, GROUND)
      OverrideObjectTooltipNameAndDescription('banBlue_2', PATH_TO_DAY1_MESSAGES.."ban_icon.txt", GetMapDataPath().."notext.txt");
      Trigger(OBJECT_TOUCH_TRIGGER, 'banBlue_2', 'noop')
    end
    BAN_COUNT[playerId] = BAN_COUNT[playerId] + 1

  end

  -- ищем и двигаем забаненного героя
  for i = 1, length(randomHeroList[playerId]) do
    local heroData = randomHeroList[playerId][i]
    if heroData.name == heroName then
      heroData.deleted = true
      heroData.manual_change = true

      local shift = BAN_COUNT[playerId] * BAN_STEP

      if playerId == PLAYER_1 then
        local rz = BAN_START.red_zone.red
        local bz = BAN_START.blue_zone.red
        SetObjectPosition(heroData.red_icon,  rz.x, rz.y + BAN_DIR_Y.red_zone  * shift, GROUND)
        SetObjectPosition(heroData.blue_icon, bz.x, bz.y + BAN_DIR_Y.blue_zone * shift, GROUND)
      else
        local rz = BAN_START.red_zone.blue
        local bz = BAN_START.blue_zone.blue
        SetObjectPosition(heroData.red_icon,  rz.x, rz.y + BAN_DIR_Y.red_zone  * shift, GROUND)
        SetObjectPosition(heroData.blue_icon, bz.x, bz.y + BAN_DIR_Y.blue_zone * shift, GROUND)
      end

      Trigger(OBJECT_TOUCH_TRIGGER, heroData.red_icon,  'noop')
      Trigger(OBJECT_TOUCH_TRIGGER, heroData.blue_icon, 'noop')

      BAN_COUNT[playerId] = BAN_COUNT[playerId] + 1

    end
  end
end


-- Проставление герою признака выбранного
function addHeroForPlayer(playerId, heroName, manual)
  print "addHeroForPlayer"

  for heroIndex = 1, length(randomHeroList[playerId]) do
    local heroData = randomHeroList[playerId][heroIndex];

    if (heroData.name == heroName) then
      heroData.selected = true;
      heroData.manual_change = manual;

      for indexDictHero = 1, length(HEROES_BY_RACE[heroData.raceId]) do
        local dictHero = HEROES_BY_RACE[heroData.raceId][indexDictHero];

        if (dictHero.name == heroName) then
          local icons = dictHero[playerId][1];

          if playerId == PLAYER_1 then
            SetObjectPosition(icons.red_icon, (31 + heroIndex), 84, GROUND);
            SetObjectPosition(icons.blue_icon, (38 + heroIndex), 24, GROUND);
          else
            SetObjectPosition(icons.red_icon, (31 + heroIndex), 89, GROUND);
            SetObjectPosition(icons.blue_icon, (38 + heroIndex), 19, GROUND);
          end;

          Trigger(OBJECT_TOUCH_TRIGGER, icons.red_icon, 'noop');
          Trigger(OBJECT_TOUCH_TRIGGER, icons.blue_icon, 'noop');
        end;
      end;
    end;
  end;
end;

-- Скрытие иконки героя в подземелье
function hideHeroToUnderground(playerId, heroName, manual)
  print "hideHeroToUnderground"

  for heroIndex = 1, length(randomHeroList[playerId]) do
    local heroData = randomHeroList[playerId][heroIndex];

    if (heroData.name == heroName) then
      heroData.deleted = true;
      heroData.manual_change = manual;

      SetObjectPosition(heroData.red_icon, 1, 1, UNDERGROUND);
      SetObjectPosition(heroData.blue_icon, 1, 1, UNDERGROUND);
    end;
  end;
  -- TODO
end;

-- Проверка на максимум выбранных героев на каждой стороне
function checkOnSelectMaximumHeroes()
  print "checkOnSelectMaximumHeroes"

  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId];
    local countDeletedHero = 0;
    local countSelectedHero = 0;

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      if heroData.deleted then
        countDeletedHero = countDeletedHero + 1;
      end;

      if heroData.selected then
        countSelectedHero = countSelectedHero + 1;
      end;
    end;

    -- Если вычеркнуто 3 героя, добавляем всех оставшихся героев в набор
    if countDeletedHero > 2 then
      for heroIndex = 1, length(heroList) do
        local heroData = heroList[heroIndex];

        if (not heroData.deleted and not heroData.selected) then
          addHeroForPlayer(playerId, heroData.name)
        end;
      end;
    end;

    -- Если добавлено 3 героя, удаляем всех оставшихся героев в набор
    if countSelectedHero > 3 then
      for heroIndex = 1, length(heroList) do
        local heroData = heroList[heroIndex];

        if (not heroData.deleted and not heroData.selected) then
          banHero(playerId, heroData.name)
          --hideHeroToUnderground(playerId, heroData.name);
        end;
      end;
    end;
  end;
end;

-- Обработчик изменения
function changePlayersTurnForChoosingHero()
  print "changePlayersTurnForChoosingHero"

  -- Номер текущего хода черка героев
  local turn = getHeroTurn();
  local turnAction = getCurrentTurnAction();
  local countSideFullfied = getCountSideFullfied();
  local message = turnAction == TURN_ACTIONS.CHOOSING and "include_single_hero.txt" or "exclude_single_hero.txt";

  -- Если 2 списка заполнены - заканчиваем черк
  if countSideFullfied == 2 then
    setResultHeroes();
  else
    -- Четные ходы выбирает красный, Нечетные - синий
    if mod(turn, 2) == 0 then
      removeHeroMovePoints(Djovanni);
      addHeroMovePoints(Biara);
      --addHeroMovePoints(Djovanni);
      ShowFlyingSign(PATH_TO_DAY1_MESSAGES..message, Biara, PLAYER_1, 5.0);
    else
      removeHeroMovePoints(Biara);
      addHeroMovePoints(Djovanni);
      --addHeroMovePoints(Biara);
      ShowFlyingSign(PATH_TO_DAY1_MESSAGES..message, Djovanni, PLAYER_2, 5.0);
    end;
  end;
end;

-- Признак заполнена ли одна из сторон или нет: 0 - Не заполнены, 1 - Заполнена
function getCountSideFullfied()
  print "getCountSideFullfied"

  local countSide = 0;

  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId];

    local countSelectedHero = 0;

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      if heroData.selected then
        countSelectedHero = countSelectedHero + 1;
      end;
    end;

    if countSelectedHero == 4 then
      countSide = countSide + 1;
    end;
  end;

  return countSide;
end;

-- Удаление оставшихся групп героев
function deleteResultHeroIcons()
  print "deleteResultHeroIcons"

  -- Расставляем сгенерированных героев для выбора
  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId];

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      hideHeroToUnderground(playerId, heroData.name);
      hideHeroToUnderground(playerId, heroData.name);
    end;
  end;
end;

-- Удаление оставшихся групп героев
function deleteBanIcons()
  print "deleteBanIcons"

  SetObjectPosition('banRed_1', 1, 1, UNDERGROUND)
  SetObjectPosition('banRed_2', 1, 1, UNDERGROUND)
  SetObjectPosition('banBlue_1', 1, 1, UNDERGROUND)
  SetObjectPosition('banBlue_2', 1, 1, UNDERGROUND)

end;

-- Получение конечного списка героев для обоих игроков
function setResultHeroes()
  print "setResultHeroes"

  sleep(1);

  removeHeroMovePoints(Biara);
  removeHeroMovePoints(Djovanni);

  ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."single_cherk_end.txt", Biara, PLAYER_1, 4.0);
  ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."single_cherk_end.txt", Djovanni, PLAYER_2, 4.0);

  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId]
    -- Список выбранных героев для рандомного выбора
    local selectedHero = {};

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      if heroData.selected then
        local pushedIndex = length(selectedHero) + 1;

        selectedHero[pushedIndex] = heroData.name;
      end;
    end;

    -- Записываем список героев, которых будем показывать оппоненту
    RESULT_HERO_LIST[playerId].choised_heroes = selectedHero;
    -- Записываем расу игрока
    RESULT_HERO_LIST[playerId].raceId = heroList[1].raceId;
  end;

  -- Заполняем итоговый список 2 случайными выбранными героями и 1 рандомным
  setRandomHeroFromHeroList();

  deleteBanIcons()
  deleteFlagsCrystal()

end;

CLEAR_CHOSING_STAGE = deleteResultHeroIcons;

cherkSingleHeroes();