PATH_TO_DAY3_SCRIPTS = GetMapDataPath().."day3/";

PATH_TO_DAY3_MESSAGES = PATH_TO_DAY3_SCRIPTS.."messages/";
doFile(PATH_TO_DAY3_SCRIPTS.."day3_constants.lua");
doFile(PATH_TO_DAY3_SCRIPTS.."day3_common.lua");
sleep(1);

-- Точка входа в модуль
function day3()
  print "day3"

  CLEAR_CHOSING_STAGE(); -- удаление иконок героев

  addHeroesToPlayers();
  setInfityMoveRegions();
  startThread(controlInitialCreaturesThread);
  setHeroesInitialProperties();
  setEnemyHeroPosters();
  changePlayersArea();
  checkCustomGameMode();
  doFile(PATH_TO_DAY3_SCRIPTS.."spells_generate/spells_generate_scripts.lua");
  doFile(PATH_TO_DAY3_SCRIPTS.."start_bonus/start_bonus_scripts.lua");
  doFile(PATH_TO_DAY3_SCRIPTS.."town_building/town_building_scripts.lua");
  doFile(PATH_TO_DAY3_SCRIPTS.."set_initial_resources/set_initial_resources_scripts.lua");
  doFile(PATH_TO_DAY3_SCRIPTS.."start_learning/start_learning_scripts.lua");
  doFile(PATH_TO_DAY3_SCRIPTS.."buy_hero/buy_hero_scripts.lua");
end;

-- Установка контроля над стартовыми воздушками
function controlInitialCreaturesThread()
  print "controlInitialCreaturesThread"

  while GetDate(DAY) < 5 do
    -- Убираем из армии героев
    for _, playerId in PLAYER_ID_TABLE do
      local playerData = RESULT_HERO_LIST[playerId];

      for indexHero, heroName in playerData.heroes do

        -- берем зарезервированных героев для игроков
        local reservedHeroName = getReservedHeroName(playerId, heroName);

        local s1,s2 = GetHeroCreaturesTypes(reservedHeroName);

        local countAirElemental = GetHeroCreatures(reservedHeroName, CREATURE_AIR_ELEMENTAL);

        if s2 > 0 and countAirElemental > 0 then
          RemoveHeroCreatures(reservedHeroName, CREATURE_AIR_ELEMENTAL, countAirElemental);
        end;
      end;
      
      -- Убираем из города
      local town = MAP_PLAYER_TO_TOWNNAME[playerId];
      
      local countAirElemental = GetObjectCreatures(town, CREATURE_AIR_ELEMENTAL);
      
      if countAirElemental > 0 then
        RemoveObjectCreatures(town, CREATURE_AIR_ELEMENTAL, countAirElemental);
      end;
    end;
  
    sleep(10);
  end;
end;

-- Добавление героев игрокам
function addHeroesToPlayers()
  print "addHeroesToPlayers"
  
  local INITIAL_HERO_COORDINATES = {
    [PLAYER_1] = {
      { x = 41, y = 78 },
      { x = 44, y = 78 },
      { x = 40, y = 82 },
    },
    [PLAYER_2] = {
      { x = 43, y = 15 },
      { x = 41, y = 15 },
      { x = 53, y = 18 },
    },
  };

  for _, playerId in PLAYER_ID_TABLE do
    local playerData = RESULT_HERO_LIST[playerId];

    for indexHero, heroName in playerData.heroes do
    
      if RESULT_HERO_LIST[PLAYER_1].raceId == RESULT_HERO_LIST[PLAYER_2].raceId and indexHero == 3 then
        return nil
      end;
      
      local coords = INITIAL_HERO_COORDINATES[playerId][indexHero];

      
      -- берем зарезервированных героев для игроков
      local reservedHeroName = getReservedHeroName(playerId, heroName);

      print(reservedHeroName)
      DeployReserveHero(reservedHeroName, coords.x, coords.y, GROUND);
    end;
  end;
end;

-- Установка героям начальных свойств
function setHeroesInitialProperties()
  print "setHeroesInitialProperties"

  for _, playerId in PLAYER_ID_TABLE do
    local playerData = RESULT_HERO_LIST[playerId];

    for indexHero, heroName in playerData.heroes do
      -- берем зарезервированных героев для игроков
      local reservedHeroName = getReservedHeroName(playerId, heroName);
      local heroMana = GetHeroStat(reservedHeroName, STAT_MANA_POINTS);
      
      ChangeHeroStat(reservedHeroName, STAT_MANA_POINTS, 0 - heroMana);
      LockMinHeroSkillsAndAttributes(reservedHeroName);

      -- Герою из таверны даем 5 мувов, чтоб мог себя выкупить
      if indexHero == 3 then
        removeHeroMovePoints(reservedHeroName);
        ChangeHeroStat(reservedHeroName, STAT_MOVE_POINTS, 500);
      end;

      for _, skill in INITIAL_HERO_SKILLS[heroName] do
        GiveHeroSkill(reservedHeroName, skill);
      end;
    end;
  end;
  
  SetObjectPosition(Biara, 35, 85);
  MoveCameraForPlayers(PLAYER_1, 35, 85, GROUND, 50, 1.57, 0, 0, 0, 1);
  
  SetObjectPosition(Djovanni, 42, 24);
  MoveCameraForPlayers(PLAYER_2, 42, 24, GROUND, 50, 1.57, 3.14, 0, 0, 1);

  -- Непонятно, зачем выдавать им эти перки?)
  GiveHeroSkill(Biara, PERK_DEMONIC_FIRE);
  GiveHeroSkill(Biara, HERO_SKILL_SNATCH);
  GiveHeroSkill(Djovanni, HERO_SKILL_SNATCH);
end;

-- Изменение игровых зон обоих игроков
function changePlayersArea()
  print "changePlayersArea"
  
  OpenCircleFog(57, 80, GROUND, 14, PLAYER_1);
  OpenCircleFog(31, 14, GROUND, 17, PLAYER_2);
  OpenCircleFog(54, 12, GROUND, 14, PLAYER_2);
  
  SetRegionBlocked('block1', 1);
  SetRegionBlocked('block2', 1);
  SetRegionBlocked('block3', 1);
  SetRegionBlocked('block4', 1);
  SetRegionBlocked('reg_shop3', 1);
  SetRegionBlocked('reg_shop4', 1);
  SetRegionBlocked('reg_shop5', 1);
  SetRegionBlocked('reg_shop6', 1);
  SetRegionBlocked ('block1', 1);
  SetRegionBlocked ('block2', 1);
  SetRegionBlocked ('block3', 1);
  SetRegionBlocked ('block4', 1);
end;

--Проверка кастомных режимов игры
function checkCustomGameMode()
  print "checkNoMentorStatus"
  if CUSTOM_GAME_MODE_NO_MENTOR == 1 then
    closeMentorObject()
  end;
end;


-- Маппинг ИД расы на ее наименование
MAP_CREATURE_TO_NAME = {
  PATH_TO_DAY3_MESSAGES.."message_mage1_1.txt",
  PATH_TO_DAY3_MESSAGES.."message_mage1_2.txt",
  PATH_TO_DAY3_MESSAGES.."message_mage1_3.txt",
  PATH_TO_DAY3_MESSAGES.."message_mage1_4.txt",
  PATH_TO_DAY3_MESSAGES.."message_mage1_5.txt",
  PATH_TO_DAY3_MESSAGES.."message_mage1_6.txt"
}


--закрытие объектов - ментор, ментор-хелпер и обелиск(покупка баз)
function closeMentorObject()
  print "closeMentorObject"
  
  SetObjectPosition('mage1', 54, 87);
  SetObjectPosition('mage2', 60, 87);
  SetObjectPosition('mage3', 51, 9);
  SetObjectPosition('mage4', 57, 9);

  SetObjectPosition('gremlin1', 58, 80);
  SetObjectPosition('gremlin2', 58, 14);
  
  for _, creature in {"mage1", 'mage2', 'gremlin1', 'mage3', 'mage4', 'gremlin2'} do
      SetObjectEnabled(creature, nil)
      SetDisabledObjectMode(creature, DISABLED_INTERACT)
      Trigger(OBJECT_TOUCH_TRIGGER, creature,  'messageCreatureNoMentor');
    end;

end;


-- Сообщение у существ закрывающих Ментора
function messageCreatureNoMentor(heroName)
  print "messageCreatureNoMentor"
  
    local playerId = GetPlayerFilter(GetObjectOwner(heroName));

    local message = MAP_CREATURE_TO_NAME[random(length(MAP_CREATURE_TO_NAME))]

    ShowFlyingSign(message, heroName, playerId, 5);

end;


-- Отображение иконок выбранного списка героев у оппонента
function setEnemyHeroPosters()
  print "setEnemyHeroPosters"

  local ENEMY_POSTERS_POSITION = {
    [PLAYER_1] = {
      { x = 31, y = 86 },
      { x = 31, y = 87 },
      { x = 31, y = 88 },
      { x = 31, y = 89 },
      { x = 31, y = 90 },
    },
    [PLAYER_2] = {
      { x = 46, y = 19 },
      { x = 46, y = 20 },
      { x = 46, y = 21 },
      { x = 46, y = 22 },
      { x = 46, y = 23 },
    },
  };
  
  for _, playerId in PLAYER_ID_TABLE do
    local enemyPlayerId = PLAYERS_OPPONENT[playerId];
    local enemyChoisedHeroes = RESULT_HERO_LIST[enemyPlayerId].choised_heroes;

    for indexHero, heroName in enemyChoisedHeroes do
      local iconName = getHeroIconByHeroName(enemyPlayerId, heroName);
      
      SetObjectPosition(iconName, ENEMY_POSTERS_POSITION[playerId][indexHero].x, ENEMY_POSTERS_POSITION[playerId][indexHero].y, GROUND);

      if playerId == PLAYER_2 then
        SetObjectRotation(iconName, 180);
      end;
    end;
  end;
end;

-- Установка триггеров на регионы, дающие бесконечные очки передвижения
function setInfityMoveRegions()
  print "setInfityMoveRegions"
  
  local MAP_REGIONS_ON_PLAYERS = {
    [PLAYER_1] = {
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
      '10', '11', '12', '13', '14', '15', '16', '17', '18', '19',
      '20', '21', '22', '23', '24', '25', '26', '27', '28', '29',
      '30', '31', '32', '33', '34', '35', '36', '37', '38', '39',
      '40', '41', '42', '43', '44', '45', '46', '47', '48', '49',
      '50', '51', '52', '53', '54', '55', '56', '57', '58', '59',
      '60', '61', '62', '63', '64', '65', '66', '67', '68', '69',
      '70', '71', '72', '73', '74', '75', '76', '77', '78', '79',
      '80', '81', '82', '83', '84', '85', '86', '87', '88', '89',
      '90', '91', '92', '93', '94', '95', '96', '97', '98', '99',
      '100', '101', '102', '103', '104', '105', '106', '107', '108', '109',
      '110', '111', '112', '113', '114', '115', '116', '117', '118', '119',
      '120', '121', '122', '123', '124', '125', '126',
    },
    [PLAYER_2] = {
      '103', '104', '105', '106', '107', '108', '109',
      '110', '111', '112', '113', '114', '115', '116', '117', '118', '119',
      '120', '121', '122', '123', '124', '125', '126',
    },
  };
  
  for _, playerId in PLAYER_ID_TABLE do
    for _, regionId in MAP_REGIONS_ON_PLAYERS[playerId] do
      Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, regionId, 'addHeroMovePoints');
    end;
  end;
end;

-- Точка входа
day3();
