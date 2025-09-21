-- Скрипт, описывающий механизм выбора расы при простом выборе

-- Подключение общего функционала
doFile(PATH_TO_DAY1_MODULE.."choice_of_races/common.lua");
sleep(1);

-- Точка входа
function simple_choice_of_races()
  print "simple_choice_of_races"

  -- Расставляем перегородки
  disableAreaInteractive();
  changeChoiceArea();
  
  -- Предоставляем мумию для случайного выбора рас
  doFile(PATH_TO_DAY1_MODULE.."choice_of_races/mummy/mummy.lua");

  -- Предоставляем голема для выбора гейм-мода
  doFile(PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/golem.lua");
  
  -- Все расы
  showAllRaces();
end;

-- Изменение положения препятствий
function changeChoiceArea()
  print "changeChoiceArea"

  SetObjectPosition('blue1', 44, 24);
  SetObjectPosition('blue2', 45, 24);
  SetObjectPosition('blue3', 46, 24);
  SetObjectPosition('blue4', 44, 22);
  SetObjectPosition('blue5', 45, 22);
  SetObjectPosition('blue6', 46, 22);
  SetObjectPosition('blue7', 44, 20);
  SetObjectPosition('blue8', 45, 20);
  SetObjectPosition('blue9', 46, 20);
  SetObjectPosition('red12', 37, 89);
  SetObjectPosition('red13', 38, 89);
  SetObjectPosition('red14', 39, 89);
  SetObjectPosition('red15', 37, 87);
  SetObjectPosition('red16', 38, 87);
  SetObjectPosition('red17', 39, 87);
  SetObjectPosition('red18', 37, 85);
  SetObjectPosition('red19', 38, 85);
  SetObjectPosition('red20', 39, 85);
end;

-- Установка всех рас для каждого игрока
function showAllRaces()
  print "showAllRaces"

  for indexRace = 1, length(ALL_RACES_WITH_COORDINATES) do
    local currentRace = ALL_RACES_WITH_COORDINATES[indexRace];
    
    setHanderOnRace(currentRace[PLAYER_1]);
    setHanderOnRace(currentRace[PLAYER_2]);
  end;
end;

-- Установка конкретной расы в определенное место и навешивание триггера
function setHanderOnRace(race)
  print "setHanderOnRace"
  
  SetObjectPosition(race.unit, race.x, race.y);
  SetDisabledObjectMode(race.unit, DISABLED_INTERACT);
  Trigger(OBJECT_TOUCH_TRIGGER, race.unit, 'questionPickRace');
end;

-- Вопрос при выборе расы
function questionPickRace(triggeredHero, triggerRaceUnit)
  print "questionPickRace"
  
  local race = getRaceByRaceUnit(triggerRaceUnit);
  local player = GetPlayerFilter(GetObjectOwner(triggeredHero));

  QuestionBoxForPlayers(player, PATH_TO_DAY1_MESSAGES..race.question, 'selectRace("'..player..'","'..race.raceId..'")', 'noop');
end;

-- Получение расы по одному из ее юнитов
function getRaceByRaceUnit(unitName)
  print "getRaceByRaceUnit"
  
  for indexRace = 1, length(ALL_RACES_WITH_COORDINATES) do
    local currentRace = ALL_RACES_WITH_COORDINATES[indexRace];
    
    if (currentRace[PLAYER_1].unit == unitName or currentRace[PLAYER_2].unit == unitName) then
      return currentRace;
    end;
  end;
end;

-- Запись выбранной расы в список рас для черка героев
function selectRace(playerId, raceId)
  print "selectRace"

  -- Приводим из строки к числу
  local playerId = playerId + 0;
  local raceId = raceId + 0;
  
  SELECTED_RACE_ID_TABLE[playerId] = raceId;
  
  if playerId == PLAYER_1 then
    removeHeroMovePoints(Biara);
  else
    removeHeroMovePoints(Djovanni);
  end;
  
  local countSelectedRace = getSimpleChoiseCountSelectedRace();
  
  if countSelectedRace == 2 then
    finishSimpleChoiseOfRaces();
  end;
end;

-- Получение количества выбранных рас
function getSimpleChoiseCountSelectedRace()
  print "getSimpleChoiseCountSelectedRace"
  
  local countSelectedRace = 0;
  
  for playerIndex = 1, 2 do
    if SELECTED_RACE_ID_TABLE[playerIndex] then
      countSelectedRace = countSelectedRace + 1;
    end;
  end;

  return countSelectedRace;
end;

-- Окончание простого выбора рас
function finishSimpleChoiseOfRaces()
  print "finishSimpleChoiseOfRaces"
  
  RemoveObject('mumiya');
  RemoveObject('golem');
  SetObjectPosition('red10', 35, 83, GROUND);
  deleteAllDelimeters();
  deleteAllRacesUnit();

  if CUSTOM_GAME_MODE_ONLY_CHERK_SINGLE_HEROES == 1 then
    doFile(PATH_TO_DAY1_MODULE.."choice_of_heroes/cherk_single_heroes.lua");
  else
    doFile(PATH_TO_DAY1_MODULE.."choice_of_heroes/cherk_group_heroes.lua");
  
  end;
end;



simple_choice_of_races();