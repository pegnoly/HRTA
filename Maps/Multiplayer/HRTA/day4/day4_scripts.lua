-- Скрипты запускающиеся на 4 день

PATH_TO_DAY4_SCRIPTS = GetMapDataPath().."day4/";
PATH_TO_DAY4_MESSAGES = PATH_TO_DAY4_SCRIPTS.."messages/";

doFile(PATH_TO_DAY4_SCRIPTS.."day4_constants.lua");
sleep(1);

-- Соотношение игроков на Id гарнизонов для выноса армии из города
MAP_GARNISON_FOR_TOWN_STASHE = {
  [PLAYER_1] = 'Garrison3',
  [PLAYER_2] = 'Garrison4',
};

-- Соотношение существ к их грейдам
MAP_CREATURES_ON_GRADE = {
  -- Стандартные существа из замка
  [CREATURE_PRIEST] = CREATURE_ZEALOT,
  [CREATURE_CAVALIER] = CREATURE_CHAMPION,
  [CREATURE_ANGEL] = CREATURE_SERAPH,
  [CREATURE_SUCCUBUS] = CREATURE_SUCCUBUS_SEDUCER,
  [CREATURE_NIGHTMARE] = CREATURE_HELLMARE,
  [CREATURE_PIT_FIEND] = CREATURE_PIT_SPAWN,
  [CREATURE_DEVIL] = CREATURE_ARCH_DEMON,
  [CREATURE_VAMPIRE] = CREATURE_NOSFERATU,
  [CREATURE_LICH] = CREATURE_LICH_MASTER,
  [CREATURE_WIGHT] = CREATURE_BANSHEE,
  [CREATURE_BONE_DRAGON] = CREATURE_HORROR_DRAGON,
  [CREATURE_DRUID] = CREATURE_HIGH_DRUID,
  [CREATURE_UNICORN] = CREATURE_WHITE_UNICORN,
  [CREATURE_TREANT] = CREATURE_ANGER_TREANT,
  [CREATURE_GREEN_DRAGON] = CREATURE_RAINBOW_DRAGON,
  [CREATURE_MAGI] = CREATURE_COMBAT_MAGE,
  [CREATURE_GENIE] = CREATURE_DJINN_VIZIER,
  [CREATURE_RAKSHASA] = CREATURE_RAKSHASA_KSHATRI,
  [CREATURE_RAKSHASA_RUKH] = CREATURE_TITAN,
  [CREATURE_GIANT] = CREATURE_STORM_LORD,
  [CREATURE_RIDER] = CREATURE_BLACK_RIDER,
  [CREATURE_HYDRA] = CREATURE_ACIDIC_HYDRA,
  [CREATURE_MATRON] = CREATURE_SHADOW_MISTRESS,
  [CREATURE_DEEP_DRAGON] = CREATURE_RED_DRAGON,
  [CREATURE_BROWLER] = CREATURE_BATTLE_RAGER,
  [CREATURE_RUNE_MAGE] = CREATURE_FLAME_KEEPER,
  [CREATURE_THANE] = CREATURE_THUNDER_THANE,
  [CREATURE_MAGMA_DRAGON] = CREATURE_LAVA_DRAGON,
  [CREATURE_SHAMAN] = CREATURE_SHAMAN_HAG,
  [CREATURE_ORCCHIEF_BUTCHER] = CREATURE_ORCCHIEF_CHIEFTAIN,
  [CREATURE_WYVERN] = CREATURE_WYVERN_PAOKAI,
  [CREATURE_CYCLOP] = CREATURE_CYCLOP_BLOODEYED,

  -- Специальные существа, замененные навыками или или специализациями
  [CREATURE_ROYAL_GRIFFIN] = CREATURE_BATTLE_GRIFFIN, -- Гриффоны без бага?
};

-- Отключение всех кастомных способностей
function disableCustomAbilities(heroName)
  print "disableCustomAbilities"

  local allCustomAbilityTable = {
    CUSTOM_ABILITY_1,
    CUSTOM_ABILITY_2,
    CUSTOM_ABILITY_3,
    CUSTOM_ABILITY_4,
  };

  for _, ability in allCustomAbilityTable do
    ControlHeroCustomAbility(heroName, ability, CUSTOM_ABILITY_DISABLED);
  end;
end;

-- Уничтожаем в городе все постройки существ, исключая возможность менять их грейд
function downgradeTown(playerId)
  print "downgradeTown"

  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
  local raceId = RESULT_HERO_LIST[playerId].raceId;

  local allTownDwellTable = {
    TOWN_BUILDING_DWELLING_1,
    TOWN_BUILDING_DWELLING_2,
    TOWN_BUILDING_DWELLING_3,
    TOWN_BUILDING_DWELLING_4,
    TOWN_BUILDING_DWELLING_5,
    TOWN_BUILDING_DWELLING_6,
    TOWN_BUILDING_DWELLING_7,
  };

  if raceId == RACES.ACADEMY then
    DestroyTownBuildingToLevel(townName, TOWN_BUILDING_ACADEMY_ARTIFACT_MERCHANT, 0, 0);
  end;

  for _, dwellId in allTownDwellTable do
    DestroyTownBuildingToLevel(townName, dwellId, 0, 0);
  end;
end;

-- Блокировка всех прочих построек игрока
function disableAllOtherBuildings(playerId)
  print "disableAllOtherBuildings"

  local PLAYERS_MARKET = {
    [PLAYER_1] = 'market1',
    [PLAYER_2] = 'market2',
  };

  SetObjectEnabled(PLAYERS_MARKET[playerId], nil);
end;

-- Удаление всех очков передвижения у всех героев игрока
function removeAllHeroMovePoints(playerId)
  print "removeAllHeroMovePoints"

  local heroes = RESULT_HERO_LIST[playerId].heroes;

  for _, heroName in heroes do
    local reservedHeroName = getReservedHeroName(playerId, heroName);

    removeHeroMovePoints(reservedHeroName);
  end;

  local hero = playerId == PLAYER_1 and Biara or Djovanni;

  removeHeroMovePoints(hero);
end;

-- Перенос всех артефактов от побочных героев главному
function transferAllArtsToMainHero(playerId)
  print "transferAllArtsToMainHero"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local heroes = RESULT_HERO_LIST[playerId].heroes;

  for _, heroName in heroes do
    local reservedHeroName = getReservedHeroName(playerId, heroName);

    if reservedHeroName ~= mainHeroName then
      transferAllArts(reservedHeroName, mainHeroName);
    end;
  end;
end;

-- Перенос всех фракционных войск, забытых в городе или прочих героях
function transferAllArmyToMain(playerId)
  print "transferAllArmyToMain"

  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local heroes = RESULT_HERO_LIST[playerId].heroes;

  if not IsHeroInTown(mainHeroName, townName, 0, 1) then

      -- Если есть существа в городе
    local hasArmyIsTown = nil;

    for _, unitData in UNITS[raceId] do
      local countUnitInTown = GetObjectCreatures(townName, unitData.id);

      if countUnitInTown > 0 then
        if not hasArmyIsTown then
          hasArmyIsTown = not nil;
        end;

        AddObjectCreatures(MAP_GARNISON_FOR_TOWN_STASHE[playerId], unitData.id, countUnitInTown);
        RemoveObjectCreatures(townName, unitData.id, countUnitInTown)
      end;
    end;

    if hasArmyIsTown then
      startThread(function ()

        awaitMessageBoxForPlayers(%playerId, PATH_TO_DAY4_MESSAGES.."find_additional_army.txt");

        SetObjectOwner(MAP_GARNISON_FOR_TOWN_STASHE[%playerId], %playerId);
        MakeHeroInteractWithObject(%mainHeroName, MAP_GARNISON_FOR_TOWN_STASHE[%playerId]);
      end)

    end;
  end;


  -- Если доступные существа в дополнительных героях
  for _, heroName in heroes do
    local reservedHeroName = getReservedHeroName(playerId, heroName);

    if reservedHeroName ~= mainHeroName then

      local takedUnitFromTownFromHero = nil;

      for _, unitData in UNITS[raceId] do
        if GetObjectCreatures(reservedHeroName, unitData.id) > 0 and not takedUnitFromTownFromHero then
          awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."find_additional_army.txt");

          MakeHeroInteractWithObject(mainHeroName, reservedHeroName);

          takedUnitFromTownFromHero = not nil;
        end;
      end;
    end;
  end;
end;

-- Подготовка к выбору заклятых врагов
function prepareForChoiceEnemy(playerId)
  print "prepareForChoiceEnemy"

  while HOTSEAT_STATUS and GetCurrentPlayer() ~= playerId do sleep() end;

  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local opponentPlayerId = PLAYERS_OPPONENT[playerId];
  local opponentMainHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;
  local opponentRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;

  -- Выдаем караваны на нейтралам
  local NEUTRAL_PLAYERS = {
    [PLAYER_1] = PLAYER_3,
    [PLAYER_2] = PLAYER_4,
  };

  -- Временно перекидываем армию героя в караван
  local stash = {};
  local tempCaravanName = "caravan"..playerId;

  CreateCaravan(tempCaravanName, NEUTRAL_PLAYERS[playerId], UNDERGROUND, 1, 1, UNDERGROUND, 1, 1);
  stash[1], stash[2], stash[3], stash[4], stash[5], stash[6], stash[7] = GetHeroCreaturesTypes(mainHeroName);

  for i = 1, 7 do
    if stash[i] ~= 0 then
      AddObjectCreatures(tempCaravanName, stash[i], GetHeroCreatures(mainHeroName, stash[i]));
    end;
  end;

  for i = 1, 7 do
    if stash[i] ~= 0 then
      RemoveHeroCreatures(mainHeroName, stash[i], GetHeroCreatures(mainHeroName, stash[i]));
    end;

    if i == 1 then
      AddHeroCreatures(mainHeroName, CREATURE_PHOENIX, 100);
    end;
  end;

  -- Формируем из существ оппонента пробивочную армию для эльфа
  local stashEnemies = {};
  local tempOpponentCaravanName = "caravan"..opponentPlayerId;
  local avengerCaravan = "avenger"..playerId;

  -- Для красного 1 1 коорды, для синего 2 2
  CreateCaravan(avengerCaravan, NEUTRAL_PLAYERS[playerId], UNDERGROUND, 1, 1, UNDERGROUND, 1, 1);

  -- Со смертельным выстрелом формируем пробивку из армии оппонента
  if HasHeroSkill(mainHeroName, PERK_SNIPE_DEAD) then
    if IsObjectExists(tempOpponentCaravanName) then
      stashEnemies[8], stashEnemies[9], stashEnemies[10], stashEnemies[11], stashEnemies[12], stashEnemies[13], stashEnemies[14] = GetObjectCreaturesTypes(tempOpponentCaravanName);
    end;

    stashEnemies[1], stashEnemies[2], stashEnemies[3], stashEnemies[4], stashEnemies[5], stashEnemies[6], stashEnemies[7] = GetHeroCreaturesTypes(opponentMainHeroName);

    for i = 1, 14 do
      if stashEnemies[i] ~= CREATURE_PHOENIX and stashEnemies[i] ~= 0 and stashEnemies[i] ~= nil then
        local avengerCreature;

        for _, unitData in UNITS[opponentRaceId] do
          if unitData.id == stashEnemies[i] then
            avengerCreature = ELF_ENEMY_GARNISONS[opponentRaceId][unitData.lvl];
          end
        end;

        if avengerCreature ~= nil then
          AddObjectCreatures(avengerCaravan, avengerCreature.id, avengerCreature.kol);
        end;
      end;
    end;
  end;

  -- Без смертельного выстрела формируем из всех возможных юнитов
  if not HasHeroSkill(mainHeroName, PERK_SNIPE_DEAD) then
    for _, enemyData in ELF_ENEMY_GARNISONS[opponentRaceId] do
      AddObjectCreatures(avengerCaravan, enemyData.id, enemyData.kol);
    end;
  end;

  -- Запрещаем получать опыт
  sleep();
  SetHeroesExpCoef(0);
  MakeHeroInteractWithObject(mainHeroName, avengerCaravan)
  sleep();
  UpgradeTownBuilding(townName, TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);

  -- Возвращаем армию героя на следующий день
  startThread(function ()
    while GetDate(DAY) ~= 5 do sleep() end;

    for i = 1, 7 do
      if i == 7 then
        RemoveHeroCreatures(%mainHeroName, CREATURE_PHOENIX, GetHeroCreatures(%mainHeroName, CREATURE_PHOENIX));
      end;

      if %stash[i] ~= 0 then
        AddHeroCreatures(%mainHeroName, %stash[i], GetObjectCreatures(%tempCaravanName, %stash[i]));
      end;
    end;
  end)
end;

-- Получение количества ресурсов, получаемых для изготовки миниартефактов
function getCountResourcesForMiniArts(playerId)
  print "getCountResourcesForMiniArts"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);
  local RESOURCES_BY_ARTIFICIER = 30;

  local result = RESOURCES_BY_ARTIFICIER;

  if dictHeroName == HEROES.MAAHIR then
    local MAAHIR_BONUS_RESOURCES = 15;

    result = result + MAAHIR_BONUS_RESOURCES;
  end;

  return result;
end;

-- Подготовка к крафту миниартефактов
function prepareForCraftMiniArtifacts(playerId)
  print "prepareForCraftMiniArtifacts"

  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];

  UpgradeTownBuilding(townName, TOWN_BUILDING_ACADEMY_ARCANE_FORGE);

  local countResources = getCountResourcesForMiniArts(playerId);

  local allRecourcesTable = {WOOD, ORE, MERCURY, CRYSTAL, SULFUR, GEM};

  for _, recourceId in allRecourcesTable do
    SetPlayerResource(playerId, recourceId, countResources);
  end;
end;

-- Бонус к некромантии
function getNecromancyCoef(heroName)

  local coef = 1;

  local dictHeroName = getDictionaryHeroName(heroName);

  local extraLvl = 0;

  -- Бонус к некромантии для Маркела
  if dictHeroName == HEROES.BEREIN then
    local MARKEL_KOEF = 0.0185;
    if HasHeroSkill(heroName,HERO_SKILL_MENTORING) then
      extraLvl = 6;
    end;

    coef = coef + MARKEL_KOEF * (GetHeroLevel(heroName) + extraLvl);
  end;

  return coef;
end;

READY_FOR_NECROMANCY = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil
};

function readyForNecomancy(strPlayerId)
  print "readyForNecomancy"
  local playerId = strPlayerId + 0;
  READY_FOR_NECROMANCY[playerId] = not nil

end;

function prepareSelectNecromancy(playerId)
  print "prepareSelectNecromancy"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local countAllowStack = GetHeroSkillMastery(mainHeroName, SKILL_NECROMANCY);
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  MessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."select_necromancy.txt", 'readyForNecomancy("'..playerId..'")');
  while READY_FOR_NECROMANCY[playerId] == nil do sleep() end;

  if HasHeroSkill(mainHeroName, NECROMANCER_FEAT_LORD_OF_UNDEAD) then
    countAllowStack = countAllowStack + 1;
  end;

  local stash = {
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
  };

  local garnisonName = MAP_GARNISON_FOR_NECROMANCY[playerId];

  DenyGarrisonCreaturesTakeAway(garnisonName, 1);
  SetObjectOwner(garnisonName, playerId);

  stash[1].id, stash[2].id, stash[3].id, stash[4].id, stash[5].id, stash[6].id, stash[7].id = GetHeroCreaturesTypes(mainHeroName);

  local coef = getNecromancyCoef(mainHeroName);

  for _, stachedUnit in stash do
    for _, dictUnit in UNITS[RACES.NECROPOLIS] do
      if stachedUnit.id == dictUnit.id then
        local countUnit = MAP_UNIT_LEVEL_ON_DEFAULT_UNIT_COUNT[dictUnit.lvl] * coef;
        print(countUnit)
        AddObjectCreatures(garnisonName, dictUnit.id, rounding(countUnit));
      end;
    end;
  end;


  MakeHeroInteractWithObject(mainHeroName, garnisonName);

  local garnisonStash = {
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
  };

  garnisonStash[1].id, garnisonStash[2].id, garnisonStash[3].id, garnisonStash[4].id, garnisonStash[5].id, garnisonStash[6].id, garnisonStash[7].id = GetObjectCreaturesTypes(garnisonName);

  for _, stashedArmy in garnisonStash do
    if stashedArmy.id > 0 then
      stashedArmy.kol = GetObjectCreatures(garnisonName, stashedArmy.id);
    end;
  end;

  local countTakedUnits = 0;

  local noRestForTheWickedTaken = nil;  -- Переменная для отслеживания использования "вечного рабства"


  while countTakedUnits < countAllowStack do
    for _, stashedArmy in garnisonStash do
      if stashedArmy.id > 0 then
        local currentCountUnits = GetObjectCreatures(garnisonName, stashedArmy.id);
        local diffUnits = stashedArmy.kol - currentCountUnits;
        local extraLvl = 0;

        -- учитывая Менторство
        if HasHeroSkill(mainHeroName,HERO_SKILL_MENTORING) then
          extraLvl = 6;
        end;
        -- формула рабства
        local slaveUnits = diffUnits/getNecromancyCoef(mainHeroName) * floor((0.6 + 0.05 * (GetHeroLevel(mainHeroName) + extraLvl)) * 100 + 0.5) / 100

        -- Если появилась разница в количестве войск - значит ее взял игрок
        if diffUnits > 0 then
          countTakedUnits = countTakedUnits + 1;

          stashedArmy.kol = 0;

          -- Если игрок отделил часть юнитов - считаем, что он использовал на них некромантию
          if currentCountUnits > 0 then
            RemoveObjectCreatures(garnisonName, stashedArmy.id, currentCountUnits);
          end;

  -- Если есть вечное рабство и оно еще не использовано
  -- Проверка использования "вечного рабства"
  if HasHeroSkill(mainHeroName, PERK_NO_REST_FOR_THE_WICKED) and noRestForTheWickedTaken == nil then
    -- Если взяли обычный грейд существ
    local resultGradeId;
    
    if MAP_NECRO_UNIT_ON_GRADE_UNIT[stashedArmy.id] ~= nil then
      resultGradeId = MAP_NECRO_UNIT_ON_GRADE_UNIT[stashedArmy.id];
    else
      resultGradeId = MAP_NECRO_GRADE_UNIT_ON_UNIT[stashedArmy.id];
    end;

    print(resultGradeId)

    if resultGradeId ~= nil and GetHeroCreatures(mainHeroName, resultGradeId) > 0 then
      AddHeroCreatures(mainHeroName, resultGradeId, slaveUnits);
      RemoveObjectCreatures(garnisonName, resultGradeId, GetObjectCreatures(garnisonName, resultGradeId));

      -- Убираем всех существ альтернативного грейда, если их забрали через вечное рабство
      for _, stash in garnisonStash do
        if stash.id == resultGradeId then
          stash.kol = 0;
        end;
      end;

      noRestForTheWickedTaken = 1;  -- Помечаем, что вечное рабство использовано
    end;
  end;
          end;
        end;
      end;

      sleep(1);
    end;

    -- Забираем все оставшиеся войска из гарнизона
    for _, stashedArmy in garnisonStash do
      if stashedArmy.kol > 0 then
        RemoveObjectCreatures(garnisonName, stashedArmy.id, stashedArmy.kol);
    end;
  end;
end;

-- Выдача гному ресурсов в соответствии с его навыками
function giveRuneResources(playerId)
  print "giveRuneResources"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  local countLowRes = 6;
  local countHighRes = 6;

  -- Бранд
  if dictHeroName == HEROES.BRAND then
    -- Количество уровней для увеличения ресурсов на 1
    local BRAND_LEVEL_BY_RUNE = 6;
    local brandResCount = floor(GetHeroLevel(mainHeroName)/BRAND_LEVEL_BY_RUNE);

    countLowRes = countLowRes + brandResCount;
    countHighRes = countHighRes + brandResCount;
  end;

  -- Завершенка дает по 3 каждого ресурса
  if HasHeroSkill(mainHeroName, HERO_SKILL_FINE_RUNE) then
    countLowRes = countLowRes + 2;
    countHighRes = countHighRes + 2;
  end;

  for _, resId in { WOOD, ORE } do
    SetPlayerResource(playerId, resId, countLowRes);
  end;

  for _, resId in { MERCURY, CRYSTAL, SULFUR, GEM } do
    SetPlayerResource(playerId, resId, countHighRes);
  end;
end;

ACTIVE_TRAINING_STATUS = nil;

-- Запуск фракционных плюшек
function runRaceAbility(playerId)
  print "runRaceAbility"

  local raceId = RESULT_HERO_LIST[playerId].raceId;

  -- Отправляем на выбор заклятых
  if raceId == RACES.SYLVAN then
    startThread(prepareForChoiceEnemy, playerId);
  end;

  -- Отправляем на крафт миников
  if raceId == RACES.ACADEMY then
    startThread(prepareForCraftMiniArtifacts, playerId);
  end;

  -- Предлагаем выбрать существ с некромантии
  if raceId == RACES.NECROPOLIS then
    startThread(prepareSelectNecromancy, playerId);
  end;

  -- Гному даем ресурсы на руны
  if raceId == RACES.FORTRESS then
    giveRuneResources(playerId);
  end;

  -- Хумов радуем новым тренингом
  if raceId == RACES.HAVEN and not ACTIVE_TRAINING_STATUS then
    ACTIVE_TRAINING_STATUS = not nil;

    doFile(PATH_TO_DAY4_SCRIPTS..'modules/training.lua');
  end
end;

-- Показ игроку информацию о необходимых действиях на текущий день
function showDay4InfoMessage(playerId)
  print "showDay4InfoMessage"

  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  if raceId == RACES.SYLVAN then
    ShowFlyingSign(PATH_TO_DAY4_MESSAGES.."avenger_info.txt", mainHeroName, playerId, 5);
  end;

  if raceId == RACES.ACADEMY then
    ShowFlyingSign(PATH_TO_DAY4_MESSAGES.."create_mini_arts_info.txt", mainHeroName, playerId, 5);
  end;

  if raceId == RACES.NECROPOLIS then
    ShowFlyingSign({ PATH_TO_DAY4_MESSAGES.."necromance_info.txt"; eq = GetHeroSkillMastery(mainHeroName, SKILL_NECROMANCY) }, mainHeroName, playerId, 5);
  end;

  local opponentPlayerId = PLAYERS_OPPONENT[playerId];
  local opponentRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;

  if
    raceId ~= RACES.SYLVAN
    and raceId ~= RACES.ACADEMY
    and raceId ~= RACES.NECROPOLIS
    and raceId ~= RACES.HAVEN
  then
    if opponentRaceId == RACES.SYLVAN then
      ShowFlyingSign(PATH_TO_DAY4_MESSAGES.."enemy_avenger_info.txt", mainHeroName, playerId, 5);
    end;

    if opponentRaceId == RACES.ACADEMY then
      ShowFlyingSign(PATH_TO_DAY4_MESSAGES.."create_mini_arts_enemy_info.txt", mainHeroName, playerId, 5);
    end;

    if opponentRaceId == RACES.HAVEN then
      ShowFlyingSign(PATH_TO_DAY4_MESSAGES.."training_enemy_info.txt", mainHeroName, playerId, 5);
    end;
  end;
end;

-- Телепорт главного героя перед городом
function teleportMainHeroToNearTown(playerId)
  print "teleportMainHeroToNearTown"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local position = PLAYERS_TELEPORT_NEAR_TOWN_POSITION[playerId];
  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];

--  DisableAutoEnterTown(townName, true)
 local difY = playerId == PLAYER_1 and 1 or -1
  SetObjectPosition(mainHeroName, position.x, position.y);
  SetObjectPosition(mainHeroName, position.x, position.y+difY);
  local rotate = playerId == PLAYER_2 and 3.14 or 0;

  MoveCameraForPlayers(playerId, position.x, position.y, GROUND, 50, 1.57, rotate, 0, 0, 1);
--  DisableAutoEnterTown(townName,enable)
  addHeroMovePoints(mainHeroName);
end;

-- Телепортируем героев в их места на карте
function additionalDayBeforeSelectBattlefield()
  print "additionalDayBeforeSelectBattlefield"

  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;

    if raceId == RACES.SYLVAN or raceId == RACES.ACADEMY or raceId == RACES.HAVEN then
      teleportMainHeroToNearTown(playerId);
    else
      preliminaryTeleportHeroToSelectBattlefield(playerId);
    end;
  end;
end;


-- Передача всего имеющегося у героя новому
-- В этой функции ваще влом избавляться от магических цифр
function replaceMainHero(playerId, newHeroName)
  print "replaceMainHero"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- Навыки
  local stashSkills = {};

  for indexSkill, skillId in ALL_SKILLS_TABLE do
    local masteryLvl = GetHeroSkillMastery(mainHeroName, skillId);

    for _, raceSkillId in ALL_RACES_SKILL_LIST do
      if skillId == raceSkillId then
        masteryLvl = masteryLvl - 1;
      end;
    end;

    stashSkills[indexSkill] = masteryLvl;
  end;

  -- Умения
  local mainHeroPerksTable = {};

  for _, perkId in ALL_PERKS_TABLE do
    if HasHeroSkill(mainHeroName, perkId) then
      mainHeroPerksTable[length(mainHeroPerksTable) + 1] = perkId;
    end;
  end;

  -- Артефакты
  local mainHeroArtsTable = {};

  for _, artData in ALL_ARTS_LIST do
    if HasArtefact(mainHeroName, artData.id) then
      mainHeroArtsTable[length(mainHeroArtsTable) - 1] = artData.id;
    end;
  end;

  -- Существа
  local stashUnits = {
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
  };

  stashUnits[1].id, stashUnits[2].id, stashUnits[3].id, stashUnits[4].id, stashUnits[5].id, stashUnits[6].id, stashUnits[7].id = GetHeroCreaturesTypes(mainHeroName);

  for _, unit in stashUnits do
    if unit.id > 0 then
      unit.kol = GetHeroCreatures(mainHeroName, unit.id);
    end;
  end;

  -- Машинки
  local warMachinesTable = {};

  for machineId = 1, 4 do
    if HasHeroWarMachine(mainHeroName, machineId) and machineId ~= 2 then
      warMachinesTable[length(warMachinesTable) + 1] = machineId;
    end;
  end;

  -- Показываем фокусы с заменой героя
  local x, y = GetObjectPosition(mainHeroName);
  local heroExp = GetHeroStat(mainHeroName, STAT_EXPERIENCE);

  print(mainHeroName)
  print(newHeroName)

  RemoveObject(mainHeroName);
  DeployReserveHero(newHeroName, x, y, GROUND);

  repeat sleep() until IsObjectExists(newHeroName);

  Trigger(HERO_ADD_SKILL_TRIGGER, newHeroName, 'noop');
  WarpHeroExp(newHeroName, heroExp);

  -- Обучаем навыкам
  for skillId, skillMastery in stashSkills do
    if skillMastery > 0 then
      for i = 1, skillMastery do
        GiveHeroSkill(newHeroName, skillId);
      end;
    end;
  end;

  -- Обучаем умениям
  local allPerkExist = not nil
  while allPerkExist do
    allPerkExist = nil
    for _, perkId in mainHeroPerksTable do
      GiveHeroSkill(newHeroName, perkId);
      if HasHeroSkill(newHeroName, perkId) == nil then
        allPerkExist = not nil
      end
      if perkId == RANGER_FEAT_FOREST_GUARD_EMBLEM and GetHeroCreatures(newHeroName, CREATURE_BLADE_SINGER) > 0 then
        RemoveHeroCreatures(newHeroName, CREATURE_BLADE_SINGER, 10);
      end;
      if perkId == HERO_SKILL_DEFEND_US_ALL and GetHeroCreatures(newHeroName, CREATURE_GOBLIN_DEFILER) > 0 then
        RemoveHeroCreatures(newHeroName, CREATURE_GOBLIN_DEFILER, 15);
      end;
    end;
  end;

  -- Передаем армию
  for index, unit in stashUnits do
    if unit.id > 0 then
      AddHeroCreatures(newHeroName, unit.id, unit.kol);

      local countAirElem = GetHeroCreatures(newHeroName, CREATURE_AIR_ELEMENTAL);

      if countAirElem > 0 then
        RemoveHeroCreatures(newHeroName, CREATURE_AIR_ELEMENTAL, countAirElem);
      end;
    end;
  end;

  -- Передаем арты
  for _, artId in mainHeroArtsTable do
    GiveArtefact(newHeroName, artId);
  end;

  -- Машинки
  for _, machineId in warMachinesTable do
    GiveHeroWarMachine(newHeroName, machineId);
  end;

  -- Производим подмену в свойствах
  PLAYERS_MAIN_HERO_PROPS[playerId].name = newHeroName;

  refreshMainHeroStats(playerId);
end;

-- Замена обычного героя на героя с рташными особенностями
function replaceHeroOnSpecial(playerId)
  print "replaceHeroOnSpecial"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  -- Аларон
  if dictHeroName == HEROES.ILDAR then
    local lightMagicLevel = GetHeroSkillMastery(mainHeroName, SKILL_LIGHT_MAGIC);

    if lightMagicLevel == 3 then
      local PLAYERS_SUPER_EXPERT_HERO = {
        [PLAYER_1] = "Ildar3",
        [PLAYER_2] = "Ildar4",
      };

      replaceMainHero(playerId, PLAYERS_SUPER_EXPERT_HERO[playerId]);
    end;

    if lightMagicLevel < 3 and lightMagicLevel > 0 then
      Trigger(HERO_ADD_SKILL_TRIGGER, mainHeroName, 'noop');
      GiveHeroSkill(mainHeroName, SKILL_LIGHT_MAGIC);
    end;
  end;

  -- Илайя
  if dictHeroName == HEROES.SHADWYN then
    local invocationLevel = GetHeroSkillMastery(mainHeroName, SKILL_INVOCATION);

    if invocationLevel == 3 then
      local PLAYERS_SUPER_EXPERT_HERO = {
        [PLAYER_1] = "Shadwyn3",
        [PLAYER_2] = "Shadwyn4",
      };

      replaceMainHero(playerId, PLAYERS_SUPER_EXPERT_HERO[playerId]);
    end;

    if invocationLevel < 3 and invocationLevel > 0 then
      Trigger(HERO_ADD_SKILL_TRIGGER, mainHeroName, 'noop');
      GiveHeroSkill(mainHeroName, SKILL_INVOCATION);
    end;
  end;

end;

-- Замена определенного существа в герое на другое
function replaceUnitInHero(heroName, targetUnitId, replaceUnitId)
  print "replaceUnitInHero"
  local creatureCount = GetHeroCreatures(heroName, targetUnitId);
  if creatureCount > 0 then
    RemoveHeroCreatures(heroName, targetUnitId, creatureCount);
    AddHeroCreatures(heroName, replaceUnitId, creatureCount);
  end;
end;

-- Замена существ в городе
function replaceUnitInTown(townName, playerId, targetUnitId, replaceUnitId)
  print "replaceUnitInTown"

    local creatureCount = GetObjectCreatures(MAP_GARNISON_FOR_TOWN_STASHE[playerId], targetUnitId);
  if creatureCount > 0 then

    RemoveObjectCreatures(MAP_GARNISON_FOR_TOWN_STASHE[playerId], targetUnitId, creatureCount);
    AddObjectCreatures(MAP_GARNISON_FOR_TOWN_STASHE[playerId], replaceUnitId, creatureCount);
  end;

  local creatureCount2 = GetObjectCreatures(townName, targetUnitId);
  if creatureCount2 > 0 then
--   Creatures(MAP_GARNISON_FOR_TOWN_STASHE[playerId], unitData.id, countUnitInTown);
    RemoveObjectCreatures(townName, targetUnitId, creatureCount2);
    AddObjectCreatures(townName, replaceUnitId, creatureCount2);
  end;

end;


-- Точка входа
function day4_scripts()
  print "day4_scripts"

  for _, playerId in PLAYER_ID_TABLE do
    removeAllHeroMovePoints(playerId);

  end;
  
  local isNeedPostponeBattle = needPostponeBattle()

  if isNeedPostponeBattle then
    -- Объявляем промежуточный день для фракционных плюшек
    additionalDayBeforeSelectBattlefield();
  end;
  
  if not isNeedPostponeBattle then
    -- Отправляем на выбор поляны
    selectBattlefield();
  end;
  
  -- Если у расы игроков есть действия на 4 день - вызываем их
  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

    disableAllOtherBuildings(playerId);

    SetPlayerResource(playerId, GOLD, 0);

    disableCustomAbilities(mainHeroName);

    downgradeTown(playerId);

    transferAllArtsToMainHero(playerId);

    transferAllArmyToMain(playerId);
  end;

  for _, playerId in PLAYER_ID_TABLE do
    replaceHeroOnSpecial(playerId);
  end;

  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

    showDay4InfoMessage(playerId);

    runRaceAbility(playerId);
  end;


  
end;

-- Точка входа
day4_scripts();