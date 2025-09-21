-- ћодуль предназначен дл€ выбора пол€ бо€

PATH_TO_MODULES = GetMapDataPath().."modules/";
PATH_TO_MODULES_MESSAGES = PATH_TO_MODULES.."messages/";

-- ћесто дл€ телепортации геро€ на выбор зон
PLAYERS_TELEPORT_TO_BATTLE_POSITION = {
  [PLAYER_1] = { x = 35, y = 46 },
  [PLAYER_2] = { x = 60, y = 46 },
};

-- Ёлементы декора на выборе пол€ дл€ бо€
PLAYERS_BOAT = {
  [PLAYER_1] = 'boat1',
  [PLAYER_2] = 'boat2',
};

PLAYERS_TOWER = {
  [PLAYER_1] = 'tow1',
  [PLAYER_2] = 'tow2',
};

-- Ѕыл ли совершен предварительный телепорт геро€ на пол€ну
HAS_BEEN_PRELIMINARY_TELEPORT = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

function getHasBeenPreliminaryTeleport()
  print "getHasBeenPreliminaryTeleport"
  
  for _, hasBeen in HAS_BEEN_PRELIMINARY_TELEPORT do
    if hasBeen then
      return not nil;
    end;
  end;
  
  return nil;
end;

-- —оотношение расы на регион родной земли с маленькими преп€тстви€ми
MAP_RACE_ON_NATIVE_REGIONS = {
  [RACES.HAVEN] = 'land_block_race1',
  [RACES.INFERNO] = 'land_block_race2',
  [RACES.NECROPOLIS] = 'land_block_race3',
  [RACES.SYLVAN] = 'land_block_race1',
  [RACES.ACADEMY] = 'land_block_race5',
  [RACES.DUNGEON] = 'land_block_race6',
  [RACES.FORTRESS] = 'land_block_race7',
  [RACES.STRONGHOLD] = 'land_block_race8',
};

REGION_COBBLESTONE_HALL = 'land_block0' -- номер региона каменные залы

-- —оотношение расы на регион родной земли с маленькими преп€тстви€ми, но с морем
MAP_RACE_ON_ADDITIONAL_REGIONS = {
  [RACES.HAVEN] = 'land_block1',
  [RACES.INFERNO] = 'land_block2',
  [RACES.NECROPOLIS] = 'land_block3',
  [RACES.SYLVAN] = 'land_block1',
  --[RACES.ACADEMY] = '',
  [RACES.DUNGEON] = 'land_block6',
  [RACES.FORTRESS] = 'land_block7',
  --[RACES.STRONGHOLD] = '',
};

-- √арнизоны дл€ сражени€ с эльфом
ELF_ENEMY_GARNISONS = {
  [RACES.HAVEN] = {
    { kol = 44, id =  1 },
    { kol = 24, id =  3 },
    { kol = 20, id =  5 },
    { kol = 10, id =  7 },
    { kol =  6, id =  9 },
    { kol =  4, id = 11 },
    { kol =  2, id = 13 },
  },
  [RACES.INFERNO] = {
    { kol = 32, id = 15 },
    { kol = 30, id = 17 },
    { kol = 16, id = 19 },
    { kol = 10, id = 21 },
    { kol =  6, id = 23 },
    { kol =  4, id =136 },
    { kol =  2, id = 27 },
  },
  [RACES.NECROPOLIS] = {
    { kol = 40, id = 29 },
    { kol = 30, id = 31 },
    { kol = 18, id = 34 },
    { kol = 10, id = 35 },
    { kol =  6, id = 37 },
    { kol =  4, id = 39 },
    { kol =  2, id = 41 },
  },
  [RACES.SYLVAN] = {
    { kol = 30, id = 43 },
    { kol = 18, id = 45 },
    { kol = 14, id = 47 },
    { kol =  8, id = 49 },
    { kol =  6, id = 51 },
    { kol =  4, id = 53 },
    { kol =  2, id = 55 },
  },
  [RACES.ACADEMY] = {
    { kol = 40, id = 57 },
    { kol = 28, id = 59 },
    { kol = 18, id = 61 },
    { kol = 10, id = 63 },
    { kol =  6, id = 65 },
    { kol =  4, id = 67 },
    { kol =  2, id = 69 },
  },
  [RACES.DUNGEON] = {
    { kol = 14, id = 92 },
    { kol = 10, id = 73 },
    { kol = 12, id = 75 },
    { kol =  8, id = 77 },
    { kol =  6, id = 79 },
    { kol =  4, id = 81 },
    { kol =  2, id = 83 },
  },
  [RACES.FORTRESS] = {
    { kol = 36, id =  71 },
    { kol = 28, id =  94 },
    { kol = 14, id =  96 },
    { kol = 12, id =  98 },
    { kol =  6, id = 100 },
    { kol =  4, id = 102 },
    { kol =  2, id = 105 },
  },
  [RACES.STRONGHOLD] = {
    { kol = 50, id = 117 },
    { kol = 28, id = 119 },
    { kol = 22, id = 121 },
    { kol = 10, id = 123 },
    { kol = 10, id = 125 },
    { kol =  4, id = 127 },
    { kol =  2, id = 129 },
  },
};

-- Ѕлок полей снизу
function blockFriendlyBattlefield()
  print "blockFriendlyBattlefield"
  
  for _, region in MAP_RACE_ON_ADDITIONAL_REGIONS do
      SetRegionBlocked(region, not nil);
    end;
    
end;

-- ѕодготовка места дл€ выбора пол€ бо€
function prepareSelectBattlefield()
  print "prepareSelectBattlefield"

  local choicePlayerId = getSelectedBattlefieldPlayerId();

  -- ≈сли поле выбирает красный игрок, то рокируем их
  if choicePlayerId == PLAYER_1 then
    local opponentPlayerId = PLAYERS_OPPONENT[choicePlayerId];
    local playerPosition = PLAYERS_TELEPORT_TO_BATTLE_POSITION[choicePlayerId];
    local opponentPosition = PLAYERS_TELEPORT_TO_BATTLE_POSITION[opponentPlayerId];

    -- ћен€ем их точки дл€ телепортации
    PLAYERS_TELEPORT_TO_BATTLE_POSITION[choicePlayerId] = opponentPosition;
    PLAYERS_TELEPORT_TO_BATTLE_POSITION[opponentPlayerId] = playerPosition;

    -- ћен€ем их декор
    PLAYERS_BOAT[choicePlayerId], PLAYERS_BOAT[opponentPlayerId] = PLAYERS_BOAT[opponentPlayerId], PLAYERS_BOAT[choicePlayerId];
    PLAYERS_TOWER[choicePlayerId], PLAYERS_TOWER[opponentPlayerId] = PLAYERS_TOWER[opponentPlayerId], PLAYERS_TOWER[choicePlayerId];
  end;

 blockFriendlyBattlefield();
end;

-- ѕредварительный телепорт геро€ на выбор пол€ны
function preliminaryTeleportHeroToSelectBattlefield(playerId)
  print "preliminaryTeleportHeroToSelectBattlefield"
  
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  
  prepareSelectBattlefield();
  
  teleportHeroToSelectBattlefield(playerId);

  ShowFlyingSign(PATH_TO_MODULES_MESSAGES.."please_skip_turn.txt", mainHeroName, playerId, 5.0);
  
  HAS_BEEN_PRELIMINARY_TELEPORT[playerId] = not nil;
end;

-- ѕоказываем игроку сообщение с необходимым действием
function showSelectBattlefieldMessage(playerId)
  print "showSelectBattlefieldMessage"
  
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  local choisedFieldPlayerId = getSelectedBattlefieldPlayerId();
  
  local pathToMsg = choisedFieldPlayerId == playerId and PATH_TO_MODULES_MESSAGES.."choise_battlefield.txt" or PATH_TO_MODULES_MESSAGES.."please_skip_turn.txt";

  ShowFlyingSign(pathToMsg, mainHeroName, playerId, 5.0);
end;

-- “елепорт геро€ дл€ выбора пол€ бо€
function teleportHeroToSelectBattlefield(playerId)
  print "teleportHeroToSelectBattlefield"

  local position = PLAYERS_TELEPORT_TO_BATTLE_POSITION[playerId];
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  SetObjectPosition(mainHeroName, position.x, position.y);
  SetObjectOwner(PLAYERS_BOAT[playerId], playerId);
  SetObjectOwner(PLAYERS_TOWER[playerId], playerId);

  MoveCameraForPlayers(playerId, position.x, position.y, GROUND, 50, 1.57, 0, 0, 0, 1);
  OpenCircleFog(47, 46, GROUND, 16, playerId);
end;

-- ѕроверка необходимости телепорта игрока дл€ выбора пол€ бо€
function checkAndTeleportHeroToSelectBattlefield(playerId)
  print "checkAndTeleportHeroToSelectBattlefield"
  
  if HAS_BEEN_PRELIMINARY_TELEPORT[playerId] then
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    local x, y = GetObjectPosition(mainHeroName);
    local position = PLAYERS_TELEPORT_TO_BATTLE_POSITION[playerId];
    
    -- ≈сли герой уже стоит на свое месте дл€ телепортации - оставл€ем его там, иначе - телепортируем
    if position.x ~= x or position.y ~= y then
      teleportHeroToSelectBattlefield(playerId);
    end;
  else
    teleportHeroToSelectBattlefield(playerId);
  end;
end;

-- ƒаем мувы выбирающему герою
function giveMovePointsSelectableHero()
  print "giveMovePointsSelectableHero"
  
  local choisedFieldPlayerId = getSelectedBattlefieldPlayerId();
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[choisedFieldPlayerId].name;

  addHeroMovePoints(mainHeroName);
end;

function selectBattlefield()
  print "selectBattlefield"

  if not getHasBeenPreliminaryTeleport() then
    prepareSelectBattlefield();
  end;

  for _, playerId in PLAYER_ID_TABLE do
    checkAndTeleportHeroToSelectBattlefield(playerId);
    
    showSelectBattlefieldMessage(playerId);
  end;
  
  giveMovePointsSelectableHero();
end;
