
PATH_TO_CHOISE_OF_HEROES = PATH_TO_DAY1_MODULE.."choice_of_heroes/";

doFile(PATH_TO_CHOISE_OF_HEROES.."common.lua");
sleep(1);

-- Структура, описывающая группы, состоящих из 6 случайных героев выбранных ранее рас
RANDOM_GROUPS_HERO_ICONS = {
  [PLAYER_1] = {
    raceId = nil,
    heroGroups = {
      {
        deleted = nil,
        selected = nil,
        heroes = {
          { name = nil, red = { icon = nil, x = 31, y = 90 }, blue = { icon = nil, x = 46, y = 25 } },
          { name = nil, red = { icon = nil, x = 32, y = 90 }, blue = { icon = nil, x = 45, y = 25 } },
          { name = nil, red = { icon = nil, x = 33, y = 90 }, blue = { icon = nil, x = 44, y = 25 } },
          { name = nil, red = { icon = nil, x = 31, y = 89 }, blue = { icon = nil, x = 46, y = 24 } },
          { name = nil, red = { icon = nil, x = 32, y = 89 }, blue = { icon = nil, x = 45, y = 24 } },
        }
      },
      {
        deleted = nil,
        selected = nil,
        heroes = {
          { name = nil, red = { icon = nil, x = 31, y = 84 }, blue = { icon = nil, x = 46, y = 19 } },
          { name = nil, red = { icon = nil, x = 32, y = 84 }, blue = { icon = nil, x = 45, y = 19 } },
          { name = nil, red = { icon = nil, x = 33, y = 84 }, blue = { icon = nil, x = 44, y = 19 } },
          { name = nil, red = { icon = nil, x = 31, y = 85 }, blue = { icon = nil, x = 46, y = 20 } },
          { name = nil, red = { icon = nil, x = 32, y = 85 }, blue = { icon = nil, x = 45, y = 20 } },
        }
      },
    },
  },
  [PLAYER_2] = {
    raceId = nil,
    heroGroups = {
      {
        deleted = nil,
        selected = nil,
        heroes = {
          { name = nil, red = { icon = nil, x = 39, y = 90 }, blue = { icon = nil, x = 38, y = 25 } },
          { name = nil, red = { icon = nil, x = 38, y = 90 }, blue = { icon = nil, x = 39, y = 25 } },
          { name = nil, red = { icon = nil, x = 37, y = 90 }, blue = { icon = nil, x = 40, y = 25 } },
          { name = nil, red = { icon = nil, x = 39, y = 89 }, blue = { icon = nil, x = 38, y = 24 } },
          { name = nil, red = { icon = nil, x = 38, y = 89 }, blue = { icon = nil, x = 39, y = 24 } },
        }
      },
      {
        deleted = nil,
        selected = nil,
        heroes = {
          { name = nil, red = { icon = nil, x = 39, y = 84 }, blue = { icon = nil, x = 38, y = 19 } },
          { name = nil, red = { icon = nil, x = 38, y = 84 }, blue = { icon = nil, x = 39, y = 19 } },
          { name = nil, red = { icon = nil, x = 37, y = 84 }, blue = { icon = nil, x = 40, y = 19 } },
          { name = nil, red = { icon = nil, x = 39, y = 85 }, blue = { icon = nil, x = 38, y = 20 } },
          { name = nil, red = { icon = nil, x = 38, y = 85 }, blue = { icon = nil, x = 39, y = 20 } },
        }
      },
    },
  },
};

-- Черк наборов героев
function cherkGroupHeroes()
  print "cherkGroupHeroes"

  SetObjectPosition(Biara, 35, 87);
  SetObjectPosition(Djovanni, 42, 22);

  -- Удаляем триггеры на регионы
  removeRegionTriggersForHeroGroupSelect();
  -- Меняем описание портретов всех героев выбранных рас
  changeDescriptionForSelectedRaceHeroIcons();
  -- Генерация групп случайных героев выбранных рас
  generateRandomGroupHero(SELECTED_RACE_ID_TABLE[1], SELECTED_RACE_ID_TABLE[2]);
  -- Показ сгенерированных групп и навешивание триггеров
  showAllRandomHeroGroups();

  if HOTSEAT_STATUS == not nil then
    -- Передача хода первому игроку
    changeTurnSelectedHeroGroup(PLAYER_2);
  else
    -- Передача хода первому игроку
    changeTurnSelectedHeroGroup(PLAYER_1);
  end;
end;

-- Удаление триггеров местности перед черком групп героев
function removeRegionTriggersForHeroGroupSelect()
  print "removeRegionTriggersForHeroGroupSelect"
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

-- Генерация всех групп случайных героев для обоих игроков
function generateRandomGroupHero(redRaceId, blueRaceId)
  print "generateRandomGroupHero"

  for playerId = 1, length(RANDOM_GROUPS_HERO_ICONS) do
    local playerData = RANDOM_GROUPS_HERO_ICONS[playerId];

    -- ОПА ОП, ГАВНОКОД!
    -- Я не понимаю, почему и зачем я надумался передавать сюда расы и их потом вычислять. Наркоман
    playerData.raceId = playerId == PLAYER_1 and redRaceId or blueRaceId;

    for groupIndex = 1, length(playerData.heroGroups) do
      local group = playerData.heroGroups[groupIndex];
      local randomHeroIndexList = generateRandomHeroIndexesByRace(playerId, playerData.raceId, 5);

      for randomIndex, heroIndex in randomHeroIndexList do
        local dictionaryHero = HEROES_BY_RACE[playerData.raceId][heroIndex];

        group.heroes[randomIndex].name = dictionaryHero.name;
        group.heroes[randomIndex].red.icon = dictionaryHero[playerId][groupIndex].red_icon;
        group.heroes[randomIndex].blue.icon = dictionaryHero[playerId][groupIndex].blue_icon;
      end;
    end;
  end;
end;

-- Генерация определенного количества не повторяющихся индексов героев по расе
-- Если count будет больше, чем минимальное количество героев у фракции/2 - будет бесконечный цикл (краш)
function generateRandomHeroIndexesByRace(playerId, raceId, count)
  print "generateRandomHeroIndexesByRace"

  -- Получаем список занятых героев из первой группы
  local existHeroNameList = {};

  for _, heroData in RANDOM_GROUPS_HERO_ICONS[playerId].heroGroups[1].heroes do
    existHeroNameList[length(existHeroNameList) + 1] = heroData.name
  end;

  local resultIndexList = {};

  for i = 1, count do
    local allHeroes = HEROES_BY_RACE[raceId];
    local randomHeroName;
    local countExistIndex = 0;
    local randomHeroIndex = 0;

    repeat
      randomHeroIndex = random(length(allHeroes)) + 1;
      countExistIndex = 0;

      -- Запрещаем повторения в генерируемом списке
      for i, index in resultIndexList do
        if index == randomHeroIndex then
          countExistIndex = countExistIndex + 1;
        end;
      end;

      -- Запрещаем повторную генерацию героев из первого списка
      for _, heroName in existHeroNameList do
        if heroName == allHeroes[randomHeroIndex].name then
          countExistIndex = countExistIndex + 1;
        end;
      end;
    until countExistIndex == 0;

    resultIndexList[i] = randomHeroIndex;
  end;

  return resultIndexList;
end;

-- Показ и установка триггеров на все группы героев
function showAllRandomHeroGroups()
  print "showAllRandomHeroGroups"
  for playerId = 1, length(RANDOM_GROUPS_HERO_ICONS) do
    local playerData = RANDOM_GROUPS_HERO_ICONS[playerId];

    for groupIndex = 1, length(playerData.heroGroups) do
      local group = playerData.heroGroups[groupIndex];

      for heroIndex = 1, length(group.heroes) do
        local heroData = group.heroes[heroIndex];

        SetObjectPosition(heroData.red.icon, heroData.red.x, heroData.red.y, GROUND);
        SetObjectPosition(heroData.blue.icon, heroData.blue.x, heroData.blue.y, GROUND);

        Trigger(OBJECT_TOUCH_TRIGGER, heroData.red.icon, "QuestionDeleteHeroGroup");
        Trigger(OBJECT_TOUCH_TRIGGER, heroData.blue.icon, "QuestionDeleteHeroGroup");
      end;
    end;
  end;
end;

-- Передача хода между игроками при черке групп героев
function changeTurnSelectedHeroGroup(currentPlayerId)
  if currentPlayerId == PLAYER_1 then
    removeHeroMovePoints(Djovanni);
    addHeroMovePoints(Biara);
    ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."delete_any_group_hero.txt", Biara, PLAYER_1, 7.0);
  else
    removeHeroMovePoints(Biara);
    addHeroMovePoints(Djovanni);
    ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."delete_any_group_hero.txt", Djovanni, PLAYER_2, 7.0);
  end;
end;

-- Подтверждающий вопрос при выборе группы героев
function QuestionDeleteHeroGroup(triggerHero, triggeredIconName)
  print "QuestionDeleteHeroGroup"
  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local groupPlayerId, groupIndex = getGroupDataByIconName(triggeredIconName);
  local heroName = playerId == PLAYER_1 and Biara or Djovanni;

  local countDeletedGroup = getCountDeletedHeroGroup();

  if not HOTSEAT_STATUS and countDeletedGroup >= 1 and playerId == PLAYER_1 then
    return nil;
  end
  
  -- Позволяем игроку вычеркивать только наборы оппонента
  if not HOTSEAT_STATUS and playerId == groupPlayerId then
    return ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."you_cannot_delete_this_group.txt", heroName, playerId, 7.0);
  end;

  QuestionBoxForPlayers(playerId, PATH_TO_DAY1_MESSAGES.."question_delete_group_hero.txt", "DeleteHeroGroupByIconName('"..triggeredIconName.."')", 'noop')
end;

-- Удаление списка героев
function DeleteHeroGroupByIconName(iconName)
  print "DeleteHeroGroupByIconName"

  -- Удаляем выбранный набор
  local playerId, deleteGroupIndex = getGroupDataByIconName(iconName);
  hideGroupToUndergroundByIndex(playerId, deleteGroupIndex);

  -- Снимаем с другого набора триггеры
  for groupIndex = 1, length(RANDOM_GROUPS_HERO_ICONS[playerId].heroGroups) do
    local group = RANDOM_GROUPS_HERO_ICONS[playerId].heroGroups[groupIndex];

    if groupIndex ~= deleteGroupIndex then
      group.selected = true;

      for heroIndex = 1, length(group.heroes) do
        local heroData = group.heroes[heroIndex];

        Trigger(OBJECT_TOUCH_TRIGGER, heroData.red.icon, 'noop');
        Trigger(OBJECT_TOUCH_TRIGGER, heroData.blue.icon, 'noop');
      end;
    end;
  end;

  -- Завершаем черк групп героев
  local countDeletedGroup = getCountDeletedHeroGroup();
  if countDeletedGroup == 2 then
    finishGroupCherk();
  else
    -- Если 2 игрок еще не ходил, передаем ему ход
    changeTurnSelectedHeroGroup(PLAYER_2);
  end;
end;

-- Скрытие иконок
function hideGroupToUndergroundByIndex(playerId, hideIndexGroup)
  print "hideGroupToUndergroundByIndex"

  local playerData = RANDOM_GROUPS_HERO_ICONS[playerId];

  for groupIndex = 1, length(playerData.heroGroups) do
    local group = playerData.heroGroups[groupIndex];

    if groupIndex == hideIndexGroup then
      group.deleted = true;

      for heroIndex = 1, length(group.heroes) do
        local heroData = group.heroes[heroIndex];

        SetObjectPosition(heroData.red.icon, heroData.red.x, heroData.red.y, UNDERGROUND);
        SetObjectPosition(heroData.blue.icon, heroData.blue.x, heroData.blue.y, UNDERGROUND);
      end;
    end;
  end;
end;

-- Удаление оставшихся групп героев
function deleteResultHeroGroups()
  print "deleteResultHeroGroups"

  for _, playerId in PLAYER_ID_TABLE do
     local playerData = RANDOM_GROUPS_HERO_ICONS[playerId];

     for groupIndex = 1, length(playerData.heroGroups) do
       local group = playerData.heroGroups[groupIndex];

       if not group.deleted then
         hideGroupToUndergroundByIndex(playerId, groupIndex);
       end;
     end;
  end;
end;

-- Получение количество удаленных списков героев
function getCountDeletedHeroGroup()
  print "getCountDeletedHeroGroup"
  local count = 0;

  for playerId = 1, length(RANDOM_GROUPS_HERO_ICONS) do
    local playerData = RANDOM_GROUPS_HERO_ICONS[playerId];

    for groupIndex = 1, length(playerData.heroGroups) do
      local group = playerData.heroGroups[groupIndex];

      if group.deleted then
        count = count + 1;
      end;
    end;
  end;

  return count
end;

-- Получение группы иконок по названию имени одной из них
function getGroupDataByIconName(iconName)
  print "getGroupDataByIconName"
  for playerId = 1, length(RANDOM_GROUPS_HERO_ICONS) do
    local playerData = RANDOM_GROUPS_HERO_ICONS[playerId];

    for groupIndex = 1, length(playerData.heroGroups) do
      local group = playerData.heroGroups[groupIndex];

      for heroIndex = 1, length(group.heroes) do
        local heroData = group.heroes[heroIndex];

        if (heroData.red.icon == iconName or heroData.blue.icon == iconName) then
           return playerId, groupIndex;
        end;
      end;
    end;
  end;
end;

-- Убираемся после черков героев и определяем конечный набор героев для 2 игроков
function finishGroupCherk()
  print "finishGroupCherk"

  removeHeroMovePoints(Biara);
  removeHeroMovePoints(Djovanni);

  sleep(1);

  -- Получение итоговых героев для всех игроков
  for playerId = 1, length(RANDOM_GROUPS_HERO_ICONS) do
    local playerData = RANDOM_GROUPS_HERO_ICONS[playerId];
    local selectedHeroes = {};

    for groupIndex = 1, length(playerData.heroGroups) do
      local group = playerData.heroGroups[groupIndex];

      if group.selected then
        for heroIndex = 1, length(group.heroes) do
          local heroData = group.heroes[heroIndex];

          selectedHeroes[heroIndex] = heroData.name;
        end;
      end;
    end;

    -- Записываем список героев, которые будем показывать оппоненту
    RESULT_HERO_LIST[playerId].choised_heroes = selectedHeroes;
        -- Записываем расу игрока
    RESULT_HERO_LIST[playerId].raceId = playerData.raceId;
  end;

  -- Заполняем итоговый список 2 случайными выбранными героями и 1 рандомным
  setRandomHeroFromHeroList();
end;

CLEAR_CHOSING_STAGE = deleteResultHeroGroups;

cherkGroupHeroes();