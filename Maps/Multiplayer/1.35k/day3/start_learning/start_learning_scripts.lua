
PATH_TO_START_LEARNING_MODULE = PATH_TO_DAY3_SCRIPTS.."start_learning/";
PATH_TO_START_LEARNING_MESSAGES = PATH_TO_START_LEARNING_MODULE.."messages/";

doFile(PATH_TO_START_LEARNING_MODULE..'mentor_helper/mentor_helper.lua');
doFile(PATH_TO_START_LEARNING_MODULE..'start_learning_constants.lua');
sleep(1);

-- Скрипты для обработки прокачки героя
function start_learning_script()
  print "start_learning_script"

  setLearningTriggers();
  setMentorTriggers();
  setBuySkillTriggers();
  setBuyStatsTriggers();
  doFile(PATH_TO_START_LEARNING_MODULE..'reGenerationStats/reGeneration_stats_script.lua');
end;

-- Установка триггеров на покупку дополнительных статов
function setBuyStatsTriggers()
  print "setBuyStatsTriggers"

  for _, playerId in PLAYER_ID_TABLE do
    for _, statId in ALL_MAIN_STATS_LIST do
      local object = BUY_STATS_OBJECTS_NAMES[playerId][statId];

      SetObjectEnabled(object.id, nil);
      OverrideObjectTooltipNameAndDescription(object.id, object.name, object.desc);
      Trigger(OBJECT_TOUCH_TRIGGER, object.id, 'handleTouchBuyStatObject("'..playerId..'", "'..statId..'")');
    end;
  end;
end;

-- Обработчик взаимодействия героя с объектом для покупки стата
function handleTouchBuyStatObject(strPlayerId, strStatId)
  print "handleTouchBuyStatObject"

  local playerId = strPlayerId + 0;
  local statId = strStatId + 0;

  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  if playerMainHeroProps.name == nil then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."need_main_hero.txt");

    return nil;
  end;

  if playerMainHeroProps.count_buy_stats == 2 then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."has_maximum_buy_stats.txt");

    return nil;
  end;

  if GetPlayerResource(playerId, GOLD) < 2500 then
    MessageBoxForPlayers(playerId, {PATH_TO_START_LEARNING_MESSAGES.."not_enough_n_gold.txt"; eq=2500});

    return nil;
  end;

  QuestionBoxForPlayers(playerId, MAP_BUY_STAT_ON_QUESTIONS[statId], 'buyStat("'..playerId..'", "'..statId..'")', 'noop');
end;

-- Обновление игровых статистик главного героя на основе скриптовых
function refreshMainHeroStats(playerId)
  print "refreshMainHeroStats"

-- Снимаем с героя все шмотки
  moveAllMainHeroArtsToStorage(playerId);

  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId];

  for _, statId in ALL_MAIN_STATS_LIST do
    local changeStatValue = playerMainHero.stats[statId]
      + playerMainHero.start_stats[statId]
      + playerMainHero.stats_for_skills[statId]
      + playerMainHero.buy_stats[statId]
      - GetHeroStat(playerMainHero.name, statId);

    -- Если есть образло, считываем статы за все уровни образла
    if playerMainHero.current_learning_level > 0 then
      for learningLevel = 1, playerMainHero.current_learning_level do
        changeStatValue = changeStatValue + playerMainHero.learning[learningLevel][statId]
      end;
    end;

    ChangeHeroStat(playerMainHero.name, statId, changeStatValue);
  end;

  -- Отдаем шмотки обратно
  getAllMainHeroArtsFromStorage(playerId);
end;

-- Увеличение значение переданного стата у главного героя игрока
function changeMainHeroMainStat(playerId, statId, count)
  print "changeMainHeroMainStat"

  if count == nil then
    count = 1;
  end;

  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId];

  -- Меняем скриптовое состояние главных статистик героя
  playerMainHero.stats[statId] = playerMainHero.stats[statId] + count;

  -- Обновляем статы ГГ
  refreshMainHeroStats(playerId);
end;

-- Изменение у ГГ статов, полученных за навыки
function changeMainHeroStatsForSkills(playerId, statId, count)
  print "changeMainHeroStatsForSkills"

  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId];

  -- Меняем скриптовое состояние главных статистик героя
  playerMainHero.stats_for_skills[statId] = playerMainHero.stats_for_skills[statId] + count;

  -- Обновляем статы ГГ
  refreshMainHeroStats(playerId);
end;

-- Покупка стата игроком
function buyStat(strPlayerId, strStatId)
  print "buyStat"

  local playerId = strPlayerId + 0;
  local statId = strStatId + 0;

  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  playerMainHeroProps.buy_stats[statId] = playerMainHeroProps.buy_stats[statId] + 1;
  playerMainHeroProps.count_buy_stats = playerMainHeroProps.count_buy_stats + 1;

  SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) - 2500));

  -- Обновляем статы ГГ
  refreshMainHeroStats(playerId);

  ShowFlyingSign(MAP_STAT_ON_ADDING_MESSAGE[statId], playerMainHeroProps.name, playerId, 5.0);
end;

-- Установка триггеров на покупку базы
function setBuySkillTriggers()
  print "setBuySkillTriggers"

  for _, playerId in PLAYER_ID_TABLE do
    SetObjectEnabled(BUY_SKILL_OBJECTS_NAME[playerId], nil);
    OverrideObjectTooltipNameAndDescription(
      BUY_SKILL_OBJECTS_NAME[playerId],
      PATH_TO_START_LEARNING_MESSAGES..'buy_skill_name.txt',
      PATH_TO_START_LEARNING_MESSAGES..'buy_skill_description.txt'
    );
    Trigger(OBJECT_TOUCH_TRIGGER, BUY_SKILL_OBJECTS_NAME[playerId], 'handleTouchBuySkill');
  end;
end;


-- Получение текущей стоимости покупки навыка
function getPriceBuySkill(playerId)
  print "getPriceBuySkill"

  local playerMainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- на старте прокачки
  if playerMainHeroName == nil then
    return 12000;
  end;

  -- если герой уже прокачан
    return 11000;
end;

-- Возвращает статус, что герой уже имеет максимум навыков
function getIsHeroHasMaximumCountSkills(heroName)
  print "getIsHeroHasMaximumCountSkills"

  local MAXIMUM_COUNT_HAS_HERO_SKILL = 5;
  local countSkills = 0;

  for _, skillId in ALL_NOT_RACES_SKILL_LIST do
    if GetHeroSkillMastery(heroName, skillId) > 0 then
      countSkills = countSkills + 1;
    end;
  end;

  return countSkills == MAXIMUM_COUNT_HAS_HERO_SKILL;
end;

-- Обработчик взаимодействия с алтарем для покупки базы
function handleTouchBuySkill(triggerHero)
  print "handleTouchBuySkill"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local priceBuySkill = getPriceBuySkill(playerId);

  -- пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
  if MENTOR_HELPER_ACTIVE[playerId] then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."need_to_disable_mentor_helper.txt");
    return nil;
  end;

  if getIsHeroHasMaximumCountSkills(triggerHero) then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."has_maximum_skills.txt");

    return nil;
  end;

  if GetPlayerResource(playerId, GOLD) < priceBuySkill then
    MessageBoxForPlayers(
      playerId,
      {PATH_TO_START_LEARNING_MESSAGES.."not_enough_n_gold.txt"; eq=priceBuySkill}
    );

    return nil;
  end;

  questionBuySkill(triggerHero, priceBuySkill, 1);
end;

-- Вопрос на покупку навыка
function questionBuySkill(heroName, priceStr, skillIndexStr)
  print "questionBuySkill"

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));

  -- Приведение приходящей строки к числу
  local price = priceStr + 0;
  local skillIndex = skillIndexStr + 0;

  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;

  -- Если предложили уже все варианты
  if skillIndex > length(ALLOW_BUY_SKILL_LIST_BY_RACE[playerRaceId]) then
    return nil;
  end;

  local offerSkillId = ALLOW_BUY_SKILL_LIST_BY_RACE[playerRaceId][skillIndex];

  -- Если герой уже имеет данную базу - предлагаем следующую
  if GetHeroSkillMastery(heroName, offerSkillId) > 0 then
    questionBuySkill(heroName, price, skillIndex + 1);

    return nil;
  end;

  QuestionBoxForPlayers(
    playerId,
    { PATH_TO_START_LEARNING_MESSAGES..BUY_SKILL_QUESTIONS[offerSkillId]; eq = price },
    'addHeroOfferSkill("'..heroName..'", "'..offerSkillId..'", "'..price..'")',
    'questionBuySkill("'..heroName..'", "'..price..'", "'..(skillIndex + 1)..'")'
  );
end;

-- Добавляем герою купленный навык
function addHeroOfferSkill(heroName, skillIdStr, priceStr)
  print "addHeroOfferSkill"

  local skillId = skillIdStr + 0;
  local price = priceStr + 0;
  local COUNT_LEVEL_BY_SKILL_OFFER = 1;

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;
  local heroLevel = GetHeroLevel(heroName);

  if heroLevel == 1 then
    PLAYERS_MAIN_HERO_PROPS[playerId].name = heroName;
    setControlStatsTriggerOnHero(playerId);
  end;

  local needExp = TOTAL_EXPERIENCE_BY_LEVEL[heroLevel + COUNT_LEVEL_BY_SKILL_OFFER] - TOTAL_EXPERIENCE_BY_LEVEL[heroLevel];
  WarpHeroExp(heroName, GetHeroStat(heroName, STAT_EXPERIENCE) + needExp);

  -- пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
  local randomGenerateStatId = getRandomStatByRace(playerRaceId);
  changeMainHeroMainStat(playerId, randomGenerateStatId);

  GiveHeroSkill(heroName, skillIdStr);
  Trigger(OBJECT_TOUCH_TRIGGER, BUY_SKILL_OBJECTS_NAME[playerId], 'noop');
  SetPlayerResource(playerId, GOLD, (GetPlayerResource (playerId, GOLD) - price));
end;

-- Установка триггеров для обучения героя
function setMentorTriggers()
  print "setMentorTriggers"

  for _, playerId in PLAYER_ID_TABLE do
    local heroes = RESULT_HERO_LIST[playerId].heroes;

    for _, heroName in heroes do
      local reservedHero = getReservedHeroName(playerId, heroName);

      Trigger(HERO_REMOVE_SKILL_TRIGGER, reservedHero, 'handleHeroRemoveSkill');
    end;
  end;
end;

-- Установка триггеров для обучения героя
function setLearningTriggers()
  print "setLearningTriggers"

  for _, playerId in PLAYER_ID_TABLE do
    SetObjectEnabled(PLAYER_LEARNING_OBJECTS_NAMES[playerId], nil);
    OverrideObjectTooltipNameAndDescription(
      PLAYER_LEARNING_OBJECTS_NAMES[playerId],
      LEARNING_OBJECTS_NAME_AND_DESCRIPTION_MAP[PLAYER_LEARNING_OBJECTS_NAMES[playerId]].name,
      LEARNING_OBJECTS_NAME_AND_DESCRIPTION_MAP[PLAYER_LEARNING_OBJECTS_NAMES[playerId]].description
    );
    Trigger(
      OBJECT_TOUCH_TRIGGER,
      PLAYER_LEARNING_OBJECTS_NAMES[playerId],
      'questionLearning'
    );
  end;
end;

-- Вопрос пользователю о начале прокачки
function questionLearning(triggerHero)
  print "questionLearning"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;
  local question = QUESTION_BY_RACE[playerRaceId];

  -- Предложение начать бесплатное обучение
  if MENTOR_HELPER_ACTIVE[playerId] then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."need_to_disable_mentor_helper.txt");
    return nil;
  end;

  local playerMainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- Предложение продолжить бесплатное обучение
  if (
    playerMainHeroName == nil
    or (playerMainHeroName ~= nil and GetHeroLevel(playerMainHeroName) < HALF_FREE_LEARNING_LEVEL)
  ) then
    QuestionBoxForPlayers(
      playerId,
      question,
      'learning("'..playerId..'", "'..triggerHero..'", "'..'1'..'")',
      'noop'
    );

    return nil;
  end;

  local playerMainHeroLvl = GetHeroLevel(playerMainHeroName);

  -- Если достигнут максимум в прокачке
  if playerMainHeroLvl >= HALF_FREE_LEARNING_LEVEL and playerMainHeroLvl < FREE_LEARNING_LEVEL then
    QuestionBoxForPlayers(
      playerId,
      PATH_TO_START_LEARNING_MESSAGES..'question_continue_learning.txt',
      'learning("'..playerId..'", "'..triggerHero..'", "'..'2'..'")',
      'noop'
    );

    return nil;
  end;

  -- Если достигнут максимум в прокачке
  if PLAYERS_ALLOW_BUYING_LEVEL[playerId] == 0 then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES..'hero_already_has_the_maximum_level.txt');

    return nil;
  end;

  local needGold = MAP_LEVEL_BY_PRICE[playerMainHeroLvl + 1];
  local currentPlayerGold = GetPlayerResource(playerId, GOLD);

  -- Если недостаточно денег для покупки уровня
  if needGold > currentPlayerGold then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES..'not_enough_money.txt');

    return nil;
  end;

  -- Предложение купить дополнительные уровни
  if playerMainHeroLvl >= FREE_LEARNING_LEVEL then
    QuestionBoxForPlayers(
      playerId,
      {
        PATH_TO_START_LEARNING_MESSAGES..'question_buy_level.txt';
        eq = getNeedGoldForLvlUp(playerMainHeroName)
      },
      'learning("'..playerId..'", "'..triggerHero..'", "'..'3'..'")',
      'noop'
    );

    return nil;
  end;
end;


-- Получение количество существ 1 уровня из замка переданного игрока
function getFirstUnitCountInTown(playerId)
--  print "getFirstUnitCountInTown"

  return GetObjectDwellingCreatures(MAP_PLAYER_TO_TOWNNAME[playerId], 1);
end;

-- Отслеживание спецы Эллайны
function specEllainaTread(heroName)
  print "specEllainaTread"

  playerId = GetObjectOwner(heroName);

  countFirstUnitInTown = getFirstUnitCountInTown(playerId);

  while countFirstUnitInTown > 0 do
    currentFirstUnitCountInTown = getFirstUnitCountInTown(playerId);

    if countFirstUnitInTown > currentFirstUnitCountInTown then
      currentDiscount = ELLAINA_DISCOUNT * (countFirstUnitInTown - currentFirstUnitCountInTown);

      SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) + currentDiscount);
      ShowFlyingSign({ PATH_TO_START_LEARNING_MESSAGES.."n_goldback.txt"; eq = currentDiscount }, heroName, playerId, 5);

      countFirstUnitInTown = currentFirstUnitCountInTown;
    end;

    sleep(10);
  end;
end;

-- Выдача игроку дополнительного замка с дополнительными существами
function givePlayerSecondTown(playerId)
  print "givePlayerSecondTown"

  local dwellId = MAP_PLAYERS_ON_DWELL_NAME[playerId];
  local dwellPosition = MAP_PLAYERS_ON_DWELL_POSITION[playerId];

  if GetObjectOwner(dwellId) ~= playerId then
    SetObjectOwner(dwellId, playerId);
    SetObjectDwellingCreatures(dwellId, CREATURE_MUMMY, 0);
    SetObjectDwellingCreatures(dwellId, CREATURE_DEATH_KNIGHT, 0);
    MoveCameraForPlayers(playerId, dwellPosition.x, dwellPosition.y, GROUND, 40, 0, dwellPosition.rotate, 0, 0, 1);
  end;
end;

-- Передача юнитов из двелла - главному герою игрока
function transferUnitsFromDwellToHero(playerId, creatureId, countCreature)
  print "transferUnitsFromDwellToHero"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
  local dwellId = MAP_PLAYERS_ON_DWELL_NAME[playerId];

  -- Если игрок заказал доставку на дом
  if IsHeroInTown(mainHeroName, townName, 0, 1) then
    AddObjectCreatures(townName, creatureId, countCreature);
  else
    AddObjectCreatures(mainHeroName, creatureId, countCreature);
  end;

  RemoveObjectCreatures(dwellId, creatureId, countCreature);
end;

-- Отслеживание спецы Николаса
function specNikolasTread(heroName)
  print "specNikolasTread"

  local playerId = GetObjectOwner(heroName);

  local countAllowBlackKnight = 15;
  local dwellId = MAP_PLAYERS_ON_DWELL_NAME[playerId];

  givePlayerSecondTown(playerId);
  SetObjectDwellingCreatures(dwellId, CREATURE_DEATH_KNIGHT, countAllowBlackKnight);
  -- Если купили всадников - передаем их мейну игрока
  local countBuyBlackKnight = 0;

  while countBuyBlackKnight < countAllowBlackKnight and GetDate(DAY) == 3 do
    local currentCountBuyBlackKnight = GetObjectCreatures(dwellId, CREATURE_DEATH_KNIGHT);

    if currentCountBuyBlackKnight > 0 then
      transferUnitsFromDwellToHero(playerId, CREATURE_DEATH_KNIGHT, currentCountBuyBlackKnight);
      countBuyBlackKnight = countBuyBlackKnight + currentCountBuyBlackKnight;
    end;

    sleep(10);
  end;
end;


-- Отслеживание спецы Золтана
function specZoltanTread(heroName)
  print "specZoltanTread"

  local playerId = GetObjectOwner(heroName);

  local countAllowMummy = 30;
  local dwellId = MAP_PLAYERS_ON_DWELL_NAME[playerId];

  givePlayerSecondTown(playerId);
  SetObjectDwellingCreatures(dwellId, CREATURE_MUMMY, countAllowMummy);
  -- Если купили существ - передаем их мейну игрока
  local countBuyMummy = 0;

  while countBuyMummy < countAllowMummy and GetDate(DAY) == 3 do
    local currentCountBuyMummy = GetObjectCreatures(dwellId, CREATURE_MUMMY);

    if currentCountBuyMummy > 0 then
      transferUnitsFromDwellToHero(playerId, CREATURE_MUMMY, currentCountBuyMummy);
      countBuyMummy = countBuyMummy + currentCountBuyMummy;
    end;

    sleep(10);
  end;
end;


-- Отслеживание спецы Свеи
function specVegeyrTread(heroName)
  print "specVegeyrTread"

  local isSpecUsed = nil;

  while not isSpecUsed do
    if GetDate(DAY) == 5 then
      if KnowHeroSpell(heroName, SPELL_LIGHTNING_BOLT) then
        TeachHeroSpell(heroName, SPELL_EMPOWERED_LIGHTNING_BOLT);
      end;
      if KnowHeroSpell(heroName, SPELL_CHAIN_LIGHTNING) then
        TeachHeroSpell(heroName, SPELL_EMPOWERED_CHAIN_LIGHTNING);
      end;

      isSpecUsed = not nil;
    end;

    sleep(10);
  end;
end;

-- Проверка героя на наличие скриптовых специализаций и их запуск
function checkAndRunHeroSpec(heroName)
  print "checkAndRunHeroSpec"

  local dictHeroName = getDictionaryHeroName(heroName);

  -- Если скриптовая спеца - запускаем ее
  if dictHeroName == HEROES.NATHANIEL then
    startThread(specEllainaTread, heroName);
  end;

  if dictHeroName == HEROES.ABERRAR then
    startThread(specZoltanTread, heroName);
  end;

  if dictHeroName == HEROES.NIKOLAS then
    startThread(specNikolasTread, heroName);
  end;

  if dictHeroName == HEROES.VEGEYR then
    startThread(specVegeyrTread, heroName);
  end;

  if HasHeroSkill(heroName, PERK_DARK_RITUAL) then
    startThread(darkRitualTread, heroName);
  end;

  -- Навигация
  if HasHeroSkill(heroName, PERK_NAVIGATION) then
    setNavigationTriggers(heroName);
  end;

  for skillId, customAbility in MAP_SKILL_ON_CUSTOM_ABILITY do
    if HasHeroSkill(heroName, skillId) then
      ControlHeroCustomAbility(heroName, customAbility, CUSTOM_ABILITY_ENABLED);
      Trigger(CUSTOM_ABILITY_TRIGGER, "handleUseCustomAbility");
    end;
  end;
end;

-- Высчитывает компенсацию за стартовые навыки логистики
function startLogisticCompensation(heroName)
  print "startLogisticCompensation"

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));

  local newValue = GetPlayerResource(playerId, GOLD) + GetHeroSkillMastery(heroName, SKILL_LOGISTICS) * LOGISTIC_BONUS;

  SetPlayerResource(playerId, GOLD, newValue);
end;

-- Повышение уровней переданного героя
function learning(strPlayerId, heroName, stage)
  print "learning"

  local playerId = strPlayerId + 0;

  -- Начало бесплатной прокачки
  if stage == '1' then
    local heroLevel = GetHeroLevel(heroName);

    if heroLevel == 1 then
      PLAYERS_MAIN_HERO_PROPS[playerId].name = heroName;
      setControlStatsTriggerOnHero(playerId);
    end;

    -- Если опп заюзал разведку - отчитываемся о начале прокачки
    local enemyPlayerId = PLAYERS_OPPONENT[playerId];

--    if PLAYER_SCOUTING_WAITING_STATUS[enemyPlayerId] ~= nil then
--      MessageBoxForPlayers(enemyPlayerId, PATH_TO_START_LEARNING_MESSAGES.."opponent_start_learning.txt" );

--      scouting(enemyPlayerId);
--    end;

    checkAndRunHeroSpec(heroName);

    startLogisticCompensation(heroName);

    -- Навигация
    if HasHeroSkill(heroName, PERK_NAVIGATION) then
      setNavigationTriggers(heroName);
    end;

    -- Путь войны
    if HasHeroSkill(heroName, HERO_SKILL_PATH_OF_WAR) then
      setPathOfWarTriggers(heroName);
    end;

    -- Казна
    if HasHeroSkill(heroName, PERK_ESTATES) then
      local newValue = GetPlayerResource(playerId, GOLD) + ESTATES_BONUS;

      SetPlayerResource(playerId, GOLD, newValue);
    end;

    local needExperience = TOTAL_EXPERIENCE_BY_LEVEL[HALF_FREE_LEARNING_LEVEL + heroLevel] - TOTAL_EXPERIENCE_BY_LEVEL[heroLevel];

    ChangeHeroStat(heroName, STAT_EXPERIENCE, needExperience);
  end;

  -- Продолжение бесплатной прокачки
  if stage == '2' then
    local SECOND_HALF_LEARNING_LEVEL = 9;

    local playerMainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    local heroLevel = GetHeroLevel(playerMainHeroName);

    local needExperience = TOTAL_EXPERIENCE_BY_LEVEL[SECOND_HALF_LEARNING_LEVEL + heroLevel] - TOTAL_EXPERIENCE_BY_LEVEL[heroLevel];

    ChangeHeroStat(playerMainHeroName, STAT_EXPERIENCE, needExperience);
  end;

  -- Покупка дополнительных уровней
  if stage == '3' then
    local playerMainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    local playerMainHeroLevel = GetHeroLevel(playerMainHeroName);
    local needExperience = TOTAL_EXPERIENCE_BY_LEVEL[playerMainHeroLevel + 1] - TOTAL_EXPERIENCE_BY_LEVEL[playerMainHeroLevel];

    PLAYERS_ALLOW_BUYING_LEVEL[playerId] = PLAYERS_ALLOW_BUYING_LEVEL[playerId] - 1;

    ChangeHeroStat(playerMainHeroName, STAT_EXPERIENCE, needExperience);

    -- TODO: Для Винраэля учитывать скидку на этапе стоимости,
    -- чтобы можно было покупать уровень, если денег хватит только со скидкой
    local needGold = getNeedGoldForLvlUp(playerMainHeroName);

    SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) - needGold);


  end;
end;

-- пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
function getNeedGoldForLvlUp(playerMainHeroName)
  print "getNeedGoldForLvlUp"

  local playerMainHeroLevel = GetHeroLevel(playerMainHeroName);
  local levelPrise = MAP_LEVEL_BY_PRICE[playerMainHeroLevel + 1]


  -- пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
  local dictHeroName = getDictionaryHeroName(playerMainHeroName);

  if dictHeroName == HEROES.ELLESHAR then
    levelPrise = levelPrise - ELLESHAR_DISCOUNT
  end;

  local playerId = GetPlayerFilter(GetObjectOwner(playerMainHeroName));


  local correntLearningLvl = PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level

  if LEVEL_DISCOUNT_BY_ENL[correntLearningLvl] ~= nil then
    levelPrise = levelPrise - LEVEL_DISCOUNT_BY_ENL[correntLearningLvl]
  end;

  return levelPrise

end;

-- Перемещение всех артефактов ГГ во временное хранилище
function moveAllMainHeroArtsToStorage(playerId)
  print "moveAllMainHeroArtsToStorage"

  local mainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  for _, art in ALL_ARTS_LIST do
    if HasArtefact(mainHeroProps.name, art.id) then
      mainHeroProps.removedHeroArtIdList[length(mainHeroProps.removedHeroArtIdList)] = art.id;
      RemoveArtefact(mainHeroProps.name, art.id);
    end;
  end;
end;

-- Получение всех артефактов ГГ из временное хранилище
function getAllMainHeroArtsFromStorage(playerId)
  print "getAllMainHeroArtsFromStorage"

  local mainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  -- Отдаем шмотки обратно
  for _, removedArtId in mainHeroProps.removedHeroArtIdList do
    GiveArtifact(mainHeroProps.name, removedArtId);
  end;

  mainHeroProps.removedHeroArtIdList = {};
end;

-- Установка триггеров на контроль статистик героев
function setControlStatsTriggerOnHero(playerId)
  print "setControlStatsTriggerOnHero"

  local heroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- Снимаем с героя все шмотки
  moveAllMainHeroArtsToStorage(playerId);

  -- Переводим стартовые статы героев в стартовые скриптовые
  for _, statId in ALL_MAIN_STATS_LIST do
    PLAYERS_MAIN_HERO_PROPS[playerId].start_stats[statId] = GetHeroStat(heroName, statId);
  end;

  -- Отдаем шмотки обратно
  getAllMainHeroArtsFromStorage(playerId);

  -- Если у героя есть образло, выдаем ему положенные статы за него
  if HasHeroSkill(heroName, SKILL_LEARNING) then
    local learningLevel = GetHeroSkillMastery(heroName, SKILL_LEARNING);

    for level = 1, learningLevel do
      addPlayerMainHeroLearningStats(playerId);
    end;
  end;

  -- Если у героя есть стартовые навыки, добавляющиеся в книгу заклинаний
  for skillId, ability in MAP_SKILL_ON_CUSTOM_ABILITY do
    if HasHeroSkill(heroName, skillId) then
      ControlHeroCustomAbility(heroName, ability, CUSTOM_ABILITY_ENABLED);
      Trigger(CUSTOM_ABILITY_TRIGGER, "handleUseCustomAbility");
    end;
  end;

  Trigger(HERO_LEVELUP_TRIGGER, heroName, 'handleHeroLevelUp("'..heroName..'")');
  Trigger(HERO_ADD_SKILL_TRIGGER, heroName, 'handleHeroAddSkill');
  Trigger(HERO_REMOVE_SKILL_TRIGGER, heroName, 'handleHeroRemoveSkill');
end;

-- Отслеживание активации Темного ритуала
function darkRitualTread(heroName)
  print "darkRitualTread"

  while GetDate(DAY) == 3 do
    if HasHeroSkill(heroName, PERK_DARK_RITUAL) then
      if GetHeroStat(heroName, STAT_MANA_POINTS) > 0 then
        ChangeHeroStat(heroName, STAT_MOVE_POINTS, 30000);
        ChangeHeroStat(heroName, STAT_MANA_POINTS, 0 - GetHeroStat(heroName, STAT_MANA_POINTS));
      end;
    end

    sleep(20);
  end;
end;

-- Безопасное изменение статистик главного героя у игрока
function safetyRemoveStat(playerId, statId, diff)
  print "safetyRemoveStat"

  local mainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  local currentValue = mainHeroProps.start_stats[statId] + mainHeroProps.stats[statId];

  -- Если стат превысит нижний лимит
  if currentValue - diff < MAP_STATS_ON_MINIMUM[statId] then
    return nil;
  end;

  -- Если хватает статов с уровней - берем их
  if mainHeroProps.stats[statId] >= diff then
    mainHeroProps.stats[statId] = mainHeroProps.stats[statId] - diff;

    return not nil;
  end;

  -- Если не хватает - берем еще и стартовые
  local diffForStartStats = diff - mainHeroProps.stats[statId];
  local diffForStats = diff - diffForStartStats;

  if mainHeroProps.stats[statId] > 0 then
    mainHeroProps.stats[statId] = mainHeroProps.stats[statId] - diffForStats;
  end;

  if mainHeroProps.start_stats[statId] > 0 then
    mainHeroProps.start_stats[statId] = mainHeroProps.start_stats[statId] - diffForStartStats;
  end;

  return not nil;
end;

-- Удаление стека, полученного с навыка "Лесной лидер"
function removeForestGuardBonusStek(heroName)
  print "removeForestGuardBonusStek"

  local COUNT_FOREST_GUARD_BONUS = 10;

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));

  if PLAYERS_GET_FOREST_GUARD_STATUS[playerId] == nil then
    PLAYERS_GET_FOREST_GUARD_STATUS[playerId] = not nil;

    if GetHeroCreatures(heroName, CREATURE_BLADE_SINGER) > 0 then
      RemoveHeroCreatures(heroName, CREATURE_BLADE_SINGER, COUNT_FOREST_GUARD_BONUS);
    elseif GetHeroCreatures(heroName, CREATURE_BLADE_JUGGLER) > 0 then
      RemoveHeroCreatures(heroName, CREATURE_BLADE_JUGGLER, COUNT_FOREST_GUARD_BONUS);
    end;
  end;
end;

-- Удаление стека, полученного с навыка "Защити нас всех"
function removeDefendUsAllBonusStek(heroName)
  print "removeDefendUsAllBonusStek"

  local BONUS_VALUE = 15;

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));

  if PLAYERS_GET_DEFEND_US_ALL_STATUS[playerId] == nil then
    PLAYERS_GET_DEFEND_US_ALL_STATUS[playerId] = not nil;

    if GetHeroCreatures(heroName, CREATURE_GOBLIN_DEFILER) > 0 then
      RemoveHeroCreatures(heroName, CREATURE_GOBLIN_DEFILER, BONUS_VALUE);
    elseif GetHeroCreatures(heroName, CREATURE_GOBLIN) > 0 then
      RemoveHeroCreatures(heroName, CREATURE_GOBLIN, BONUS_VALUE);
    end;
  end;
end;

-- Отслеживание возможности передачи артефакта с навигации главному герою
function navigationTread(playerId)
  print "navigationTread"

  local hero = playerId == PLAYER_1 and Biara or Djovanni;
  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  local used = nil;

  while not used do
    if HasHeroSkill(playerMainHero, PERK_NAVIGATION) and GetDate(DAY) == 4 then
      transferAllArts(hero, playerMainHero);

      used = not nil;
    end;

    sleep(20);
  end;
end;

-- Обработчик взятия артефакта игроком
function handleTouchNavigationArt(triggerHero)
  print "handleTouchNavigationArt"

  if GetDate(DAY) ~= 3 then
    return nil
  end;

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local navigationArts = PLAYERS_ON_NAVIGATION_ARTS_TABLE[playerId];

  for _, artName in navigationArts do
    if IsObjectExists(artName) then
      RemoveObject(artName);
    end;
  end;

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  if HasHeroSkill(playerMainHero, PERK_NAVIGATION) then
    transferAllArts(triggerHero, playerMainHero);
    PLAYERS_USE_NAVIGATION_STATUS[playerId] = not nil;
  else
    startThread(navigationTread, playerId);
  end;

  local position = PLAYERS_POSITION_AFTER_USE_NAVIGATION[playerId];

  SetObjectPosition(triggerHero, position.x, position.y);
end;

-- Обработчик использования лодки синим игроком (т.к. до артефактов навигации ему далеко :D)
function handleTouchBoat(heroName)
  print "handleTouchBoat"

  print(heroName)
  if heroName == Djovanni then
    MoveHeroRealTime(heroName, 9, 18);
  end
  if heroName == Biara then
    MoveHeroRealTime(heroName, 19, 84);
  end

end;

-- Навык "Навигация"
function setNavigationTriggers(heroName)
  print "setNavigationTriggers"

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  local hero = playerId == PLAYER_1 and Biara or Djovanni;
  local position = MAP_POSITION_FOR_NAVIGATION[playerId];
  local navigationArts = PLAYERS_ON_NAVIGATION_ARTS_TABLE[playerId];

   -- пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
  if playerId == PLAYER_2 then
    OpenRegionFog(playerId, "navigation_blue")
  end;

  if playerId == PLAYER_1 then
    OpenRegionFog(playerId, "navigation_red_1")
    OpenRegionFog(playerId, "navigation_red_2")
    OpenRegionFog(playerId, "navigation_red_3")
  end;

  if IsObjectExists(PLAYERS_WALL_CELL_FOR_NAVIGATION[playerId]) then
    RemoveObject(PLAYERS_WALL_CELL_FOR_NAVIGATION[playerId]);
  end;

  Trigger(OBJECT_TOUCH_TRIGGER, 'boat4', 'handleTouchBoat("'..hero..'")');
  Trigger(OBJECT_TOUCH_TRIGGER, 'boat3', 'handleTouchBoat("'..hero..'")');
  MoveHeroRealTime(hero, position.x, position.y);

  for _, artName in navigationArts do
    if IsObjectExists(artName) then
      Trigger(OBJECT_TOUCH_TRIGGER, artName, 'handleTouchNavigationArt');
    end;
  end;
end;

-- Обработчик взаимодействия с порталом
function handleTouchTeleportPOW(triggerHero)
  print "handleTouchTeleportPOW"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero))
  local position = PLAYERS_TELEPORT_POW_POSITION[playerId]
  local rotate = playerId == PLAYER_1 and 0 or 3.14

  MoveCameraForPlayers(playerId, position.x, position.y, GROUND, 60, 3.14, rotate, 0, 0, 1)
  SetObjectPosition(triggerHero, position.x, position.y)
end

-- Обработчик взаимодействия с порталом
function handleTouchTeleportReturnPOW(triggerHero)
  print "handleTouchTeleportReturnPOW"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero))
  local position = PLAYERS_TELEPORT_POW_RETURN_POSITION[playerId]
  local rotate = playerId == PLAYER_1 and 0 or 3.14

  MoveCameraForPlayers(playerId, position.x, position.y, GROUND, 60, 3.14, rotate, 0, 0, 1)
  SetObjectPosition(triggerHero, position.x, position.y)
end

-- Обработчик взаимодействия с POW1
function handleTouchPOW(triggerHero, objectKeyPOW)
  print "handleTouchPOW"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero))

  local raceId = RESULT_HERO_LIST[playerId].raceId;

  if raceId ~= RACES.FORTRESS and objectKeyPOW == 'POW3' then
    ShowFlyingSign(POW_OBJECTS_TAKE_NOT_MASSAGE['POW3'], triggerHero, playerId, 5);
    return nil
  end;

  if raceId == RACES.STRONGHOLD and objectKeyPOW == 'POW4' then
    ShowFlyingSign(POW_OBJECTS_TAKE_NOT_MASSAGE['POW4'], triggerHero, playerId, 5);
    return nil
  end;

  if raceId ~= RACES.STRONGHOLD and objectKeyPOW == 'POW6' then
    ShowFlyingSign(POW_OBJECTS_TAKE_NOT_MASSAGE['POW6'], triggerHero, playerId, 5);
    return nil
  end;

  if PLAYERS_USE_PATH_OF_WAR_STATUS[playerId] == nil then
    QuestionBoxForPlayers(playerId, POW_OBJECTS_QUESTIONS[objectKeyPOW], 'activateBonusPOW("'..playerId..'", "'..objectKeyPOW..'")', 'noop');
  end;
end

-- активировать бонус Путь войны
function activateBonusPOW(playerId, objectKeyPOW)
  print "activateBonusPOW"

  local playerId = playerId + 0;
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  SetObjectPosition(POW_OBJECTS_NAMES[playerId]['POW_PORTAL_1'].id, 1, 1, UNDERGROUND);

  PLAYERS_USE_PATH_OF_WAR_STATUS[playerId] = not nil;
  PLAYERS_USE_PATH_OF_WAR_BONUS[playerId] = objectKeyPOW;

  handleTouchTeleportReturnPOW(mainHeroName)

end;

-- Путь войны треад, отключение портала на 4 день
function POWTread()
  print "POWTread"

  local used = nil;

  while not used do
    if GetDate(DAY) == 4 then
      SetObjectPosition(POW_OBJECTS_NAMES[PLAYER_1]['POW_PORTAL_1'].id, 1, 1, UNDERGROUND);
      SetObjectPosition(POW_OBJECTS_NAMES[PLAYER_2]['POW_PORTAL_1'].id, 1, 1, UNDERGROUND);

      used = not nil;
    end;

    sleep(20);
  end;
end;

-- Установка триггеров на объекты Путь войны
function setPathOfWarTriggers(heroName)
  print "setPathOfWarTriggers"

  local playerId = GetPlayerFilter(GetObjectOwner(heroName))

  startThread(POWTread);

  if playerId == PLAYER_1 then
    OpenRegionFog(playerId, "pathRed")
    SetObjectPosition('tpPathOfwarRed1', 43, 76)
    MoveCameraForPlayers(PLAYER_1, 42, 77, GROUND, 50, 1.57, 0, 0, 0, 1)

    SetObjectEnabled('tpPathOfwarRed1', nil)
    SetObjectEnabled('tpPathOfwarRed2', nil)
    SetObjectEnabled('POW1Red', nil)
    SetObjectEnabled('POW2Red', nil)
    SetObjectEnabled('POW3Red', nil)
    SetObjectEnabled('POW4Red', nil)
    SetObjectEnabled('POW5Red', nil)
    SetObjectEnabled('POW6Red', nil)

    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_1]['POW_PORTAL_1'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW_PORTAL_1'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW_PORTAL_1'].desc)
    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_1]['POW_PORTAL_2'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW_PORTAL_2'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW_PORTAL_2'].desc)
    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_1]['POW1'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW1'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW1'].desc)
    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_1]['POW2'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW2'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW2'].desc)
    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_1]['POW3'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW3'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW3'].desc)
    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_1]['POW4'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW4'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW4'].desc)
    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_1]['POW5'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW5'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW5'].desc)
    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_1]['POW6'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW6'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW6'].desc)

    Trigger(OBJECT_TOUCH_TRIGGER, 'tpPathOfwarRed1', 'handleTouchTeleportPOW("'..heroName..'")')
    Trigger(OBJECT_TOUCH_TRIGGER, 'tpPathOfwarRed2', 'handleTouchTeleportReturnPOW("'..heroName..'")')
    Trigger(OBJECT_TOUCH_TRIGGER, 'POW1Red', 'handleTouchPOW("'..heroName..'","'..'POW1'..'")')
    Trigger(OBJECT_TOUCH_TRIGGER, 'POW2Red', 'handleTouchPOW("'..heroName..'","'..'POW2'..'")')
    Trigger(OBJECT_TOUCH_TRIGGER, 'POW3Red', 'handleTouchPOW("'..heroName..'","'..'POW3'..'")')
    Trigger(OBJECT_TOUCH_TRIGGER, 'POW4Red', 'handleTouchPOW("'..heroName..'","'..'POW4'..'")')
    Trigger(OBJECT_TOUCH_TRIGGER, 'POW5Red', 'handleTouchPOW("'..heroName..'","'..'POW5'..'")')
    Trigger(OBJECT_TOUCH_TRIGGER, 'POW6Red', 'handleTouchPOW("'..heroName..'","'..'POW6'..'")')
  end

  if playerId == PLAYER_2 then
    OpenRegionFog(playerId, "pathBlue")
    SetObjectPosition('tpPathOfwarBlue1', 48, 11)
    MoveCameraForPlayers(PLAYER_2, 47, 11, GROUND, 50, 1.57, 3.14, 0, 0, 1)

    SetObjectEnabled('tpPathOfwarBlue1', nil)
    SetObjectEnabled('tpPathOfwarBlue2', nil)
    SetObjectEnabled('POW1Blue', nil)
    SetObjectEnabled('POW2Blue', nil)
    SetObjectEnabled('POW3Blue', nil)
    SetObjectEnabled('POW4Blue', nil)
    SetObjectEnabled('POW5Blue', nil)
    SetObjectEnabled('POW6Blue', nil)

    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_2]['POW_PORTAL_1'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW_PORTAL_1'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW_PORTAL_1'].desc)
    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_2]['POW_PORTAL_2'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW_PORTAL_2'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW_PORTAL_2'].desc)
    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_2]['POW1'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW1'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW1'].desc)
    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_2]['POW2'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW2'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW2'].desc)
    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_2]['POW3'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW3'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW3'].desc)
    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_2]['POW4'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW4'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW4'].desc)
    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_2]['POW5'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW5'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW5'].desc)
    OverrideObjectTooltipNameAndDescription(POW_OBJECTS_NAMES[PLAYER_2]['POW6'].id, POW_OBJECTS_NAMES[PLAYER_1]['POW6'].name, POW_OBJECTS_NAMES[PLAYER_1]['POW6'].desc)

    Trigger(OBJECT_TOUCH_TRIGGER, 'tpPathOfwarBlue1', 'handleTouchTeleportPOW("'..heroName..'")')
    Trigger(OBJECT_TOUCH_TRIGGER, 'tpPathOfwarBlue2', 'handleTouchTeleportReturnPOW("'..heroName..'")')
    Trigger(OBJECT_TOUCH_TRIGGER, 'POW1Blue', 'handleTouchPOW("'..heroName..'","'..'POW1'..'")')
    Trigger(OBJECT_TOUCH_TRIGGER, 'POW2Blue', 'handleTouchPOW("'..heroName..'","'..'POW2'..'")')
    Trigger(OBJECT_TOUCH_TRIGGER, 'POW3Blue', 'handleTouchPOW("'..heroName..'","'..'POW3'..'")')
    Trigger(OBJECT_TOUCH_TRIGGER, 'POW4Blue', 'handleTouchPOW("'..heroName..'","'..'POW4'..'")')
    Trigger(OBJECT_TOUCH_TRIGGER, 'POW5Blue', 'handleTouchPOW("'..heroName..'","'..'POW5'..'")')
    Trigger(OBJECT_TOUCH_TRIGGER, 'POW6Blue', 'handleTouchPOW("'..heroName..'","'..'POW6'..'")')
  end
end

-- Получение поличества взятых школ магии
function getCountMagicSchool(heroName)

  local magicSchoolTable = {
    SKILL_LIGHT_MAGIC,
    SKILL_DARK_MAGIC,
    SKILL_DESTRUCTIVE_MAGIC,
    SKILL_SUMMONING_MAGIC,
  };

  local count = 0;

  for _, schoolId in magicSchoolTable do
    if GetHeroSkillMastery(heroName, schoolId) > 0 then
      count = count + 1;
    end;
  end;

  return count;
end;

-- Отслеживание изменений статистик с навыка "Тайное преимущество"
function trackingChangeStatsForCasterCertificate(heroName)
  print "trackingChangeStatsForCasterCertificate"

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  local KOEF = 3;

  while GetDate(DAY) < 5 do
    -- Если у игрока имеется навык
    if HasHeroSkill(heroName, KNIGHT_FEAT_CASTER_CERTIFICATE) then
      local currentCount = getCountMagicSchool(heroName);
      local currentCountForSkill = KOEF * currentCount;

      if currentCountForSkill ~= PLAYERS_COUNT_STATS_FROM_CASTER_CERTIFICATE[playerId] then
        local diff = currentCountForSkill - PLAYERS_COUNT_STATS_FROM_CASTER_CERTIFICATE[playerId];

        changeMainHeroStatsForSkills(playerId, STAT_KNOWLEDGE, diff);
        PLAYERS_COUNT_STATS_FROM_CASTER_CERTIFICATE[playerId] = currentCountForSkill;
      end
    end;

    sleep(20);
  end;
end;

-- Тайное преимущество
function casterCertificate(heroName)
  print "casterCertificate"

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));

  ChangeHeroStat(heroName, STAT_MANA_POINTS, -GetHeroStat(heroName, STAT_MANA_POINTS));

  changeMainHeroStatsForSkills(playerId, STAT_KNOWLEDGE, PLAYERS_COUNT_STATS_FROM_CASTER_CERTIFICATE[playerId]);

  startThread(trackingChangeStatsForCasterCertificate, heroName);
end;

-- Отслеживание изменений статистик с навыка "Хранитель тайного"
function trackingChangeStatsForMasterOfSecret(heroName)
  print "trackingChangeStatsForMasterOfSecret"

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  local KOEF = 2;

  while GetDate(DAY) < 5 do
    -- Если у игрока имеется навык
    if HasHeroSkill(heroName, DEMON_FEAT_MASTER_OF_SECRETS) then
      local currentCount = getCountMagicSchool(heroName);
      local currentCountForSkill = KOEF * currentCount;

      if currentCountForSkill ~= PLAYERS_COUNT_STATS_FROM_MASTER_OF_SECRET[playerId] then
        local diff = currentCountForSkill - PLAYERS_COUNT_STATS_FROM_MASTER_OF_SECRET[playerId];

        changeMainHeroStatsForSkills(playerId, STAT_SPELL_POWER, diff);
        PLAYERS_COUNT_STATS_FROM_MASTER_OF_SECRET[playerId] = currentCountForSkill;
      end
    end;

    sleep(20);
  end;
end;

-- Хранитель тайного
function masterOfSecret(heroName)
  print "masterOfSecret"

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));

  changeMainHeroStatsForSkills(playerId, STAT_SPELL_POWER, PLAYERS_COUNT_STATS_FROM_MASTER_OF_SECRET[playerId]);

  startThread(trackingChangeStatsForMasterOfSecret, heroName);
end;

-- Получение данных по статистикам, которые изменяет данный навык
function getSkillWithStatsDataById(skillId)
  print "getSkillWithStatsDataById"

  -- Заброшенные шахты и СА мага были переделаны под астрологию
  if skillId == WIZARD_FEAT_ABSOLUTE_WIZARDY or skillId == NECROMANCER_FEAT_HAUNT_MINE then
    return MAP_WEEK_ON_ASTROLOGY_STATS[GetCurrentMoonWeek()];
  end;

  return MAP_SKILLS_TO_CHANGING_STATS[skillId];
end;

-- Обработчик получения героем нового навыка
function handleHeroAddSkill(triggerHero, skillId)
  print "handleHeroAddSkill"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- Если не выбран главный герой, не производим никаких внутренних расчетов
  if playerMainHero == nil then
    return nil;
  end;

  if PLAYERS_GOLD_STORE[playerId] ~= nil then
    SetPlayerResource(playerId, GOLD, PLAYERS_GOLD_STORE[playerId]);
    PLAYERS_GOLD_STORE[playerId] = nil
  end;

  local removedSkillId = getRemovedUnremovableSkillId(playerId);

  -- пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ
  local skillByMH = getReturnedSkillByMentorHelper(playerId, skillId);

  local removedSkillIdAndSkillByMH = removedSkillId or skillByMH
  -- Проверяем, не скинул ли игрок нескидываемый навык
  if removedSkillIdAndSkillByMH ~= nil then
    removeHeroSkill(playerMainHero, skillId);

    GiveHeroSkill(playerMainHero, removedSkillIdAndSkillByMH);

--    SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) +  2500));

    ShowFlyingSign(PATH_TO_START_LEARNING_MESSAGES.."cannot_remove_skill.txt", playerMainHero, playerId, 5.0);

    return nil;
  end;

  local skillWithStats = getSkillWithStatsDataById(skillId);

  -- Если навык, дающий статы
  if skillWithStats ~= nil then
    for _, statId in { STAT_ATTACK, STAT_DEFENCE, STAT_SPELL_POWER, STAT_KNOWLEDGE } do
      if skillWithStats[statId] ~= nil then
        changeMainHeroStatsForSkills(playerId, statId, skillWithStats[statId]);
      end;
    end;
  end;

  -- если взяли образование
  if skillId == SKILL_LEARNING or skillId == HERO_SKILL_BARBARIAN_LEARNING then
    addPlayerMainHeroLearningStats(playerId);
  end;

  -- Если трофеи
  if skillId == WIZARD_FEAT_SPOILS_OF_WAR then
    setSpoilsTrigger(playerId);
  end;

  local customAbility = MAP_SKILL_ON_CUSTOM_ABILITY[skillId];

  -- Если навык добавляется в книгу заклинаний
  if customAbility ~= nil then
    ControlHeroCustomAbility(playerMainHero, customAbility, CUSTOM_ABILITY_ENABLED);
    Trigger(CUSTOM_ABILITY_TRIGGER, "handleUseCustomAbility");
  end;

  -- Выпускник
  if skillId == KNIGHT_FEAT_STUDENT_AWARD then
    SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) + STUDENT_AWARD_GOLD));
  end;

  -- Темный ритуал
  if skillId == PERK_DARK_RITUAL then
    startThread(darkRitualTread, playerMainHero);
  end;

  -- Лесной лидер
  if skillId == RANGER_FEAT_FOREST_GUARD_EMBLEM then
    removeForestGuardBonusStek(playerMainHero);
  end;

  -- Защити нас всех
  if skillId == HERO_SKILL_DEFEND_US_ALL then
    removeDefendUsAllBonusStek(playerMainHero);
  end;

  -- Логистика
  if skillId == SKILL_LOGISTICS then
    if PLAYERS_COUNT_LOGISTICS_LEVEL_RETURNED[playerId] > 0 then
      PLAYERS_COUNT_LOGISTICS_LEVEL_RETURNED[playerId] = PLAYERS_COUNT_LOGISTICS_LEVEL_RETURNED[playerId] - 1;
    else
      SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) + LOGISTIC_BONUS));
    end;
  end;

  -- Казна
  if skillId == PERK_ESTATES then
    if PLAYERS_COUNT_ESTATES_LEVEL_RETURNED[playerId] > 0 then
      PLAYERS_COUNT_ESTATES_LEVEL_RETURNED[playerId] = PLAYERS_COUNT_ESTATES_LEVEL_RETURNED[playerId] - 1;
    else
      SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) + ESTATES_BONUS));
    end;
  end;

  -- Навигация
  if skillId == PERK_NAVIGATION then
    setNavigationTriggers(playerMainHero);
  end;

    -- Путь войны
  if skillId == HERO_SKILL_PATH_OF_WAR then
    setPathOfWarTriggers(playerMainHero);
  end;

  -- Тайное преимущество
  if skillId == KNIGHT_FEAT_CASTER_CERTIFICATE then
    casterCertificate(playerMainHero);
  end;

  -- Хранитель тайного
  if skillId == DEMON_FEAT_MASTER_OF_SECRETS then
    masterOfSecret(playerMainHero);
  end;
end;

-- Обработчик потери героем навыка
function handleHeroRemoveSkill(triggerHero, skill)
  print "handleHeroRemoveSkill"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  MENTOR_HELPER_REMOVED_SKILL[playerId] = skill;
  MENTOR_USAGE_COUNTER.iterate(playerId);
  mentorCashback(playerId, skill);

  -- Если не выбран главный герой, не производим никаких внутренних расчетов
  if mainHeroName == nil then
    return nil;
  end;

  local removedSkillId = getRemovedUnremovableSkillId(playerId);

  -- Проверяем, не скинул ли игрок нескидываемый навык
  if removedSkillId ~= nil then
    PLAYERS_GOLD_STORE[playerId] = GetPlayerResource(playerId, GOLD)
    SetPlayerResource(playerId, GOLD, 0);
    return nil
  end;


  local skillWithStats = getSkillWithStatsDataById(skill);

  -- Если навык, дающий статы
  if skillWithStats ~= nil then
    for _, statId in { STAT_ATTACK, STAT_DEFENCE, STAT_SPELL_POWER, STAT_KNOWLEDGE } do
      if skillWithStats[statId] ~= nil then
        changeMainHeroStatsForSkills(playerId, statId, -skillWithStats[statId]);
      end;
    end;
  end;

  -- если образование
  if skill == SKILL_LEARNING or skill == HERO_SKILL_BARBARIAN_LEARNING then
    removePlayerMainHeroLearningStats(playerId);
  end;

  -- Если трофеи
  if skill == WIZARD_FEAT_SPOILS_OF_WAR then
    Trigger(OBJECT_TOUCH_TRIGGER, MAP_MERCHANT_ON_PLAYER[playerId], 'noop');
  end;

  local customAbility = MAP_SKILL_ON_CUSTOM_ABILITY[skill];

  -- Если это навык, привязанный к CUSTOM_ABILITY_2 (разведка и бесшумный)
--  if (
--    customAbility ~= nil
--    and (
--      skill == PERK_FORTUNATE_ADVENTURER
--      or (skill == PERK_SCOUTING and HasHeroSkill(mainHeroName, RANGER_FEAT_DISGUISE_AND_RECKON) == nil)
--      or (skill == RANGER_FEAT_DISGUISE_AND_RECKON and HasHeroSkill(mainHeroName, PERK_SCOUTING) == nil)
--    )
--  )then
--    ControlHeroCustomAbility(triggerHero, customAbility, CUSTOM_ABILITY_DISABLED);
--  end;

  -- Выпускник
  if skill == KNIGHT_FEAT_STUDENT_AWARD then
    SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) - STUDENT_AWARD_GOLD));
  end;

  -- Логистика
  if skill == SKILL_LOGISTICS then
    local resultGold = GetPlayerResource (playerId, GOLD) - LOGISTIC_BONUS;

    if resultGold < 0 then
      PLAYERS_LOGISTICS_DEBT[playerId] = PLAYERS_LOGISTICS_DEBT[playerId] + LOGISTIC_BONUS;
    end;

    if resultGold >= 0 then
      SetPlayerResource(playerId, GOLD, resultGold);
    end;
  end;

    -- Казна
  if skill == PERK_ESTATES then
    local resultGold = GetPlayerResource (playerId, GOLD) - ESTATES_BONUS;

    if resultGold < 0 then
      PLAYERS_ESTATES_DEBT[playerId] = PLAYERS_ESTATES_DEBT[playerId] + ESTATES_BONUS;
    end;

    if resultGold >= 0 then
      SetPlayerResource(playerId, GOLD, resultGold);
    end;
  end;

  -- Тайное преимущество
  if skill == KNIGHT_FEAT_CASTER_CERTIFICATE then
    changeMainHeroStatsForSkills(playerId, STAT_KNOWLEDGE, -PLAYERS_COUNT_STATS_FROM_CASTER_CERTIFICATE[playerId]);
  end;

  -- Хранитель тайного
  if skill == DEMON_FEAT_MASTER_OF_SECRETS then
    changeMainHeroStatsForSkills(playerId, STAT_SPELL_POWER, -PLAYERS_COUNT_STATS_FROM_MASTER_OF_SECRET[playerId]);
  end;
end;

-- Установка триггеров для активации Трофеев
function setSpoilsTrigger(playerId)
  print "setSpoilsTrigger"

  Trigger(OBJECT_TOUCH_TRIGGER, MAP_MERCHANT_ON_PLAYER[playerId], 'handleTouchArtifactMerchant');
  startThread(spoilsOfWarThread, playerId);
end;

-- Установка слежки за трофеями, если их не используют до 4 дня
function spoilsOfWarThread(strPlayerId)
  print "spoilsOfWarThread"

  local playerId =strPlayerId + 0;

  while not PLAYERS_USE_SPOILS_STATUS[playerId] do
    if GetDate(DAY) == 4 and HasHeroSkill(playerMainHero, WIZARD_FEAT_SPOILS_OF_WAR) then
      spoilsOfWar(playerId);

      PLAYERS_USE_SPOILS_STATUS[playerId] = not nil;
    end;

    sleep(20);
  end;
end;

-- Обработчик касания героя с лавкой
function handleTouchArtifactMerchant(triggerHero)
  print "handleTouchArtifactMerchant"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));

  if PLAYERS_USE_SPOILS_STATUS[playerId] ~= nil then
    return nil;
  end;

  QuestionBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."question_use_spoils.txt", 'spoilsOfWar', 'noop');
end;

-- Активация трофеев
function spoilsOfWar(strPlayerId)
  print "spoilsOfWar"

  local playerId = strPlayerId + 0;
  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  -- Формируем список слотов, которые заняты у героя текущими артами
  -- Список занятых слотов
  local havingItemPositionList = {};

  for _, art in ALL_ARTS_LIST do
    if HasArtefact(playerMainHeroProps.name, art.id) then
      local slotIsNotAdded = not nil; -- Ору с этого, почему то адекватный true тут не существует :)

      for _, position in havingItemPositionList do
        if position == art.position then
          slotIsNotAdded = nil;
        end;
      end;

      if slotIsNotAdded then
        havingItemPositionList[length(havingItemPositionList)] = art.position;
      end;
    end;
  end;

  -- На основе списка занятых слотов формируем список артефактов мажорных артов в доступные слоты
  -- Список возможных для выдачи артефактов
  local allowedItemIdList = {};

  for _, art in ALL_ARTS_LIST do
    if art.level == ARTS_LEVELS.MAJOR then
      local isAllowedPosition = not nil;

      for _, position in havingItemPositionList do
        if art.position == position then
          isAllowedPosition = nil;
        end;
      end;

      if isAllowedPosition then
        allowedItemIdList[length(allowedItemIdList)] = art.id;
      end;
    end;
  end;

  -- Теперь рандомим из этой кучи выдаваемый арт
  local randomIndexArt = random(length(allowedItemIdList));

  GiveArtefact(playerMainHeroProps.name, allowedItemIdList[randomIndexArt]);

  -- И запрещаем игроку больше использовать трофеи
  PLAYERS_USE_SPOILS_STATUS[playerId] = not nil;
end;

-- Функция возврата золота при сбросе навыков
function mentorCashback(playerId, removedSkillId)
  print("mentorCashback: Начало, skill = " .. removedSkillId)

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- Если нет героя — обычное поведение
  if mainHeroName == nil then
    local currentCountFirstLeveDiscount = PLAYERS_FIRST_LEVEL_DISCOUNT_ON_REMOVE_SKILLS[playerId];

    if currentCountFirstLeveDiscount > 0 then
      PLAYERS_FIRST_LEVEL_DISCOUNT_ON_REMOVE_SKILLS[playerId] = currentCountFirstLeveDiscount - 1;
      print("mentorCashback: Скидка на первый уровень, осталось: " .. PLAYERS_FIRST_LEVEL_DISCOUNT_ON_REMOVE_SKILLS[playerId])
      return nil;
    end;

    SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) - 2000);
    print("mentorCashback: Списано 2000 золота (нет героя)")
    return nil;
  end;

  local mainHeroLevel = GetHeroLevel(mainHeroName);

  -- Проверка на несбрасываемый навык
  local removedSkillIdCheck = getRemovedUnremovableSkillId(playerId);
  if removedSkillIdCheck ~= nil then
    print("mentorCashback: Несбрасываемый навык, возврат 2500 золота: " .. removedSkillId)
    if mainHeroLevel >= FREE_LEARNING_LEVEL then
      SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) + 2500);
      return nil;
    elseif mainHeroLevel > HALF_FREE_LEARNING_LEVEL then
      SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) + 1500);
      return nil;
    end;
  end;

  -- Если ниже уровня полного обучения — делаем обычную логику
--  if mainHeroLevel <= FREE_LEARNING_LEVEL then
--    if mainHeroLevel > HALF_FREE_LEARNING_LEVEL then
--      SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) - 1000);
--      print("mentorCashback: Списано 1000 золота (уровень " .. mainHeroLevel .. ")")
--    end;
--    return nil;
--  end;

  -- Проверка на повторный сброс того же самого навыка (после 18 уровня)
  if mainHeroLevel >= 18 and removedSkillId == MENTOR_LAST_SKILL[playerId] then
    print("mentorCashback: Повторный сброс навыка, кешбек 1250, skill = " .. MENTOR_LAST_SKILL[playerId])
    SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) + 1250);
    MENTOR_LAST_SKILL[playerId] = removedSkillId; -- Обновляем LAST_SKILL только при кешбеке
  else
    -- Первый сброс — бесплатно, только обновляем LAST_SKILL
    print("mentorCashback: Первый сброс, бесплатно")
    MENTOR_LAST_SKILL[playerId] = removedSkillId;
  end
end
-- Получает нескидываемый навык, если он был сброшен
function getRemovedUnremovableSkillId(playerId)
  print "getRemovedUnremovableSkillId"

  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
  if HasHeroSkill(playerMainHero, WIZARD_FEAT_SPOILS_OF_WAR) == nil and PLAYERS_USE_SPOILS_STATUS[playerId] ~= nil then
    return WIZARD_FEAT_SPOILS_OF_WAR;
  end;

  --старые навыки
  -- Если сбросил Разведку
--  if HasHeroSkill(playerMainHero, PERK_SCOUTING) == nil and PLAYER_USE_SCOUTING_STATUS[playerId] ~= nil then
--    return PERK_SCOUTING;
--  end;

  -- Если сбросил Бесшумного преследователя
--  if HasHeroSkill(playerMainHero, RANGER_FEAT_DISGUISE_AND_RECKON) == nil and PLAYER_USE_DISGUISE_STATUS[playerId] ~= nil then
--    return RANGER_FEAT_DISGUISE_AND_RECKON;
--  end;

  -- Если сбросил Удачу в пути
  if HasHeroSkill(playerMainHero, PERK_FORTUNATE_ADVENTURER) == nil and PLAYERS_USE_FORTUNARE_ADVENTURE_STATUS[playerId] ~= nil then
    return PERK_FORTUNATE_ADVENTURER;
  end;

  -- Казна
  if PLAYERS_ESTATES_DEBT[playerId] > 0 then
    PLAYERS_ESTATES_DEBT[playerId] = PLAYERS_ESTATES_DEBT[playerId] - ESTATES_BONUS;
    PLAYERS_COUNT_ESTATES_LEVEL_RETURNED[playerId] = PLAYERS_COUNT_ESTATES_LEVEL_RETURNED[playerId] + 1;

    return PERK_ESTATES;
  end;

  -- Военачальник
  if (GetTownRace(MAP_PLAYER_TO_TOWNNAME[playerId]) == RACES.HAVEN) then
    if (
      HasHeroSkill(playerMainHero, PERK_EXPERT_TRAINER) == nil
      and GetTownBuildingLevel(MAP_PLAYER_TO_TOWNNAME[playerId], TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES) == 1
    ) then
      return PERK_EXPERT_TRAINER;
    end;
  end;

  -- Логистика
  if PLAYERS_LOGISTICS_DEBT[playerId] > 0 then
    PLAYERS_LOGISTICS_DEBT[playerId] = PLAYERS_LOGISTICS_DEBT[playerId] - LOGISTIC_BONUS;
    PLAYERS_COUNT_LOGISTICS_LEVEL_RETURNED[playerId] = PLAYERS_COUNT_LOGISTICS_LEVEL_RETURNED[playerId] + 1;

    return SKILL_LOGISTICS;
  end;

  -- Навигация
  if HasHeroSkill(playerMainHero, PERK_NAVIGATION) == nil and PLAYERS_USE_NAVIGATION_STATUS[playerId] ~= nil then
    return PERK_NAVIGATION;
  end;

  -- Путь войны
  if HasHeroSkill(playerMainHero, HERO_SKILL_PATH_OF_WAR) == nil and PLAYERS_USE_PATH_OF_WAR_STATUS[playerId] ~= nil then
    return HERO_SKILL_PATH_OF_WAR;
  end;

  return nil;
end;

-- Удаление навыка у героя
-- Не предоставлено разработчиками, поэтому херачим свой метод с блекджеком и изабелькой
function removeHeroSkill(heroName, removeSkillId)
  print "removeHeroSkill"

  Trigger(HERO_ADD_SKILL_TRIGGER, heroName, 'noop');
  Trigger(HERO_REMOVE_SKILL_TRIGGER, heroName, 'noop');

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;

  -- Список текущих навыков героя { skillId, skillLevel }[]
  local heroSkillIdList = {};

  -- Мне очень влом делать список всех возможных скилов, поэтому я просто протыкаю все числа до максимально знакомого мне айдишника
  for checkSkillId = 1, 215 do
    if HasHeroSkill(heroName, checkSkillId) then
      heroSkillIdList[length(heroSkillIdList)] = {
        skillId = checkSkillId,
        skillLevel = GetHeroSkillMastery(heroName, checkSkillId),
      };
    end;
  end;

  -- Количество опыта, имеющееся у героя
  local hasHeroExpirience = TOTAL_EXPERIENCE_BY_LEVEL[GetHeroLevel(heroName)];

  TakeAwayHeroExp(heroName, hasHeroExpirience);
  WarpHeroExp(heroName, hasHeroExpirience);

  -- Сбрасываем 2 раз, потому что из-за стартовых навыков их количество на 2 больше чем уровень
  TakeAwayHeroExp(heroName, hasHeroExpirience);
  WarpHeroExp(heroName, hasHeroExpirience);

  -- Возвращаем все навыки и школы кроме того, который удаляем
  for _, savedSkill in heroSkillIdList do
    local maxSkillLevel = savedSkill.skillLevel;

    if removeSkillId == savedSkill.skillId then
      maxSkillLevel = maxSkillLevel - 1;
    end;

    if maxSkillLevel > 0 then
      local countReturnLevel = maxSkillLevel;

      -- Фракционный навык не снимается до нуля, поэтому убираем один уровень навыка
      if MAP_RACE_ON_RACE_SKILL[playerRaceId] == savedSkill.skillId then
        countReturnLevel = countReturnLevel - 1;
      end;

      for level = 1, countReturnLevel do
        GiveHeroSkill(heroName, savedSkill.skillId);
      end;
    end;
  end;

  -- Возвращаем обратно кастомные триггеры и статы
  Trigger(HERO_ADD_SKILL_TRIGGER, heroName, 'handleHeroAddSkill');
  Trigger(HERO_REMOVE_SKILL_TRIGGER, heroName, 'handleHeroRemoveSkill');

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));

  refreshMainHeroStats(playerId);
end;

-- Продажа стата игроком
function sellStat(strPlayerId, strStatId)
  print "sellStat"

  local playerId = strPlayerId + 0;
  local statId = strStatId + 0;

  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  playerMainHeroProps.stats[statId] = playerMainHeroProps.stats[statId] - 1;
  PLAYER_COUNT_ALLOW_SELL_STATS[playerId] = PLAYER_COUNT_ALLOW_SELL_STATS[playerId] - 1;

  SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) + SELL_STAT_PRICE));

  -- Обновляем статы ГГ
  refreshMainHeroStats(playerId);

  ShowFlyingSign({PATH_TO_START_LEARNING_MESSAGES.."n_goldback.txt"; eq = SELL_STAT_PRICE}, playerMainHeroProps.name, playerId, 2.0);
end;

-- Обработчик взаимодействия героя с объектом для продажи стата стата
function handleTouchSellStatObject(strPlayerId, strStatId)
  print "handleTouchSellStatObject"

  local playerId = strPlayerId + 0;
  local statId = strStatId + 0;

  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  -- Если игрок хочет превысить лимит по продаже статов
  if PLAYER_COUNT_ALLOW_SELL_STATS[playerId] == 0 then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."sell_maximum_stats.txt");

    return nil;
  end;

  -- Если значение параметра опустилось до своего минимума
  if playerMainHeroProps.stats[statId] <= MAP_STATS_ON_MINIMUM[statId] then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."sell_maximum_stat.txt");

    return nil;
  end;

  QuestionBoxForPlayers(playerId, MAP_BUY_STAT_ON_QUESTIONS[statId], 'sellStat("'..playerId..'", "'..statId..'")', 'noop');
end;

-- Установка триггеров на продажу статов
function setSellStatsTriggers(playerId)
  print "setSellStatsTriggers"

  for _, statId in ALL_MAIN_STATS_LIST do
    local object = BUY_STATS_OBJECTS_NAMES[playerId][statId];

    Trigger(OBJECT_TOUCH_TRIGGER, object.id, 'handleTouchSellStatObject("'..playerId..'", "'..statId..'")');
  end;
end;

-- Обработчик использования кастомной способности
function handleUseCustomAbility(triggerHero, ability)
  print "handleUseCustomAbility"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));

  -- если использовали абилку разведки или бесшумного
  if ability == CUSTOM_ABILITY_2 then
--    if HasHeroSkill(triggerHero, PERK_SCOUTING) and PLAYER_USE_SCOUTING_STATUS[playerId] == nil then
--      handleUseScouting(playerId)
--    end;

    if HasHeroSkill(triggerHero, RANGER_FEAT_DISGUISE_AND_RECKON) and PLAYER_USE_DISGUISE_STATUS[playerId] == nil then
      handleUseDisguise(playerId)
    end;
  end;

  -- если использовали "Удача в пути"
  if ability == CUSTOM_ABILITY_4 then
    handleUseFortunareAdventure(playerId);
  end;
end;

-- Обработка использования способности "Бесшумный преследователь"
function handleUseDisguise(playerId)
  print "handleUseDisguise"

  QuestionBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."question_use_disguise.txt", 'disguise("'..playerId..'")', 'noop');
end;

-- Применение "Бесшумный преследователь"
function disguise(strPlayerId)
  print "disguise"

  local playerId = strPlayerId + 0;

  if playerId == PLAYER_1 then
    OpenCircleFog(41, 23, 0, 5, playerId);
    MoveCameraForPlayers(playerId, 41, 23, 0, 20, 0, 3.14, 0, 0, 1);
  else
    OpenCircleFog(36, 88, 0, 5, playerId);
    MoveCameraForPlayers(playerId, 36, 86, 0, 20, 0, 0, 0, 0, 1);
  end;

  PLAYER_USE_DISGUISE_STATUS[playerId] = not nil;
end;

-- Обработка использования способности разведка
function handleUseScouting(playerId)
  print "handleUseScouting"

  -- Если разведка уже использована
  if PLAYER_SCOUTING_WAITING_STATUS[playerId] ~= nil then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."has_waiting_learning_opponent.txt" );

    return nil;
  end;

  QuestionBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."question_use_scouting.txt", 'scouting("'..playerId..'")', 'noop');
end;

-- Перемещаем камеру игрока на героев оппонента
function moveCameraOnEnemyHero(playerId)
  print "moveCameraOnEnemyHero"

  -- Ваще влом это делать универсально)
  -- Думаю, что все здесь понятно итак
  if playerId == PLAYER_1 then
    MoveCameraForPlayers(playerId, 31, 88, 0, 20, 0, 0, 0, 0, 1);
  else
    MoveCameraForPlayers(playerId, 44, 23, 0, 20, 0, 3.14, 0, 0, 1);
  end;
end;

-- Показываем набор героев, который выпал оппоненту
function showResultHeroList(enemyPlayerId, dictMainHeroName)
  print "showResultHeroList"

  local playerId = PLAYERS_OPPONENT[enemyPlayerId];

  local enemyHeroes = RESULT_HERO_LIST[enemyPlayerId].heroes;
  local enemyChoisedHeroes = RESULT_HERO_LIST[enemyPlayerId].choised_heroes;

  for _, heroName in enemyChoisedHeroes do
    if (
       (heroName ~= enemyHeroes[1] and heroName ~= enemyHeroes[2])
       or (dictMainHeroName ~= nil and heroName ~= dictMainHeroName)
    ) then
      local iconName = getHeroIconByHeroName(enemyPlayerId, heroName);

      SetObjectPosition(iconName, 1, 1, UNDERGROUND);
    end;
  end;

  moveCameraOnEnemyHero(playerId);
end;

-- Активация разведки
function scouting(strPlayerId)
  print "scouting"

  local playerId = strPlayerId + 0;
  local enemyPlayerId = PLAYERS_OPPONENT[playerId];
  local enemyMainHero = PLAYERS_MAIN_HERO_PROPS[enemyPlayerId].name;
  local enemyHeroes = RESULT_HERO_LIST[enemyPlayerId].heroes;
  local enemyChoisedHeroes = RESULT_HERO_LIST[enemyPlayerId].choised_heroes;

  PLAYER_USE_SCOUTING_STATUS[playerId] = not nil;

  -- Если оппонент еще не начал прокачку
  if enemyMainHero == nil then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."opponent_has_not_main_hero.txt" );

    showResultHeroList(enemyPlayerId);

    PLAYER_SCOUTING_WAITING_STATUS[playerId] = not nil;
    return nil;
  end;

  local dictMainHeroName = getDictionaryHeroName(enemyMainHero);

  -- Если герой из таверны
  if dictMainHeroName == enemyHeroes[3] then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."opponent_buy_hero.txt");

    showResultHeroList(enemyPlayerId);

    return nil;
  end;

  -- Показываем ГГ врага
  showResultHeroList(enemyPlayerId, dictMainHeroName);
end;


-- Обработчик использования "Удача в пути" в книге заклинаний
function handleUseFortunareAdventure(playerId)
  print "handleUseFortunareAdventure"

   local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;

   if HasHeroSkill(playerMainHero, PERK_FORTUNATE_ADVENTURER) then

  -- Если игрок еще не использовал этот навык - предупреждаем его о последствиях
  if PLAYERS_USE_FORTUNARE_ADVENTURE_STATUS[playerId] == nil then
    QuestionBoxForPlayers(
      playerId,
      PATH_TO_START_LEARNING_MESSAGES.."question_use_fortunare_adventure.txt",
      'fortunareAdventure("'..playerId..'")',
      'noop'
    );

    return nil;
  end;

  fortunareAdventure(playerId);
  else
    ShowFlyingSign({PATH_TO_START_LEARNING_MESSAGES.."dont_have_fortunare_adventure.txt"}, playerMainHero, playerId, 5);
  end;
end;

-- Активация удача в пути
function fortunareAdventure(strPlayerId)
  print "fortunareAdventure"

  local playerId = strPlayerId + 0;
  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  -- Соотношение дополнительных лавок к игрокам
  local MAP_ADDITIONAL_MERCHANT_ON_PLAYERS = {
    [PLAYER_1] = 'FortunateAdventure1',
    [PLAYER_2] = 'FortunateAdventure2',
  };

  PLAYERS_USE_FORTUNARE_ADVENTURE_STATUS[playerId] = not nil;

  moveAllMainHeroArtsToStorage(playerId);

  MakeHeroInteractWithObject(playerMainHero, MAP_ADDITIONAL_MERCHANT_ON_PLAYERS[playerId]);

  -- Без костылей подсчитать скидку можно только через колбек
  MessageBoxForPlayers(
    playerId,
    PATH_TO_START_LEARNING_MESSAGES.."fortunare_adventure_have_discount.txt",
    'applyFortunareAdventureDiscount'
  );
end;

-- Применение скидок для артефактов с Удачи в пути
function applyFortunareAdventureDiscount(strPlayerId)
  print "applyFortunareAdventureDiscount"

  local playerId = strPlayerId + 0;
  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  local discountCoefficient = 0.15;
  local discount = 0;

  for _, art in ALL_ARTS_LIST do
    if HasArtefact(playerMainHero, art.id) then
      discount = discount + (art.price * discountCoefficient) + 1;
    end;
  end;

  ShowFlyingSign({PATH_TO_START_LEARNING_MESSAGES.."n_goldback.txt"; eq = discount}, playerMainHero, playerId, 5);
  SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) + discount);

  getAllMainHeroArtsFromStorage(playerId);
end;

-- Генерация главному герою игрока статов образования
function removePlayerMainHeroLearningStats(playerId)
  print "removePlayerMainHeroLearningStats"

  local learning = PLAYERS_MAIN_HERO_PROPS[playerId].learning;
  local raceId = RESULT_HERO_LIST[playerId].raceId;

  local currentLearningLevel = PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level;

  PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level = currentLearningLevel - 1;

  refreshMainHeroStats(playerId);
end;

-- пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
function getIsMaxCountStat(playerId, statId)
  print "getIsMaxCountStat"

  -- пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅ 1 пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
  local MAXIMUM_STATS = 4;
  local learning = PLAYERS_MAIN_HERO_PROPS[playerId].learning;
  local count = 0;

  for level = 1, 3 do
    if learning[level] ~= nil then
      count = count + learning[level][statId];
    end;
  end;

  return count >= MAXIMUM_STATS;
end;

-- пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
function addPlayerMainHeroLearningStats(playerId)
  print "addPlayerMainHeroLearningStats"

  local learning = PLAYERS_MAIN_HERO_PROPS[playerId].learning;
  local raceId = RESULT_HERO_LIST[playerId].raceId;

  local nextLerningLevel = PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level + 1;

  if learning[nextLerningLevel] == nil then
    learning[nextLerningLevel] = {};

    -- пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ
    for _, statId in ALL_MAIN_STATS_LIST do
      learning[nextLerningLevel][statId] = 0;
    end;

    -- пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ 2 пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ
    for indexStat = 1, 2 do
      local allowStatIdList = {};

      if not getIsMaxCountStat(playerId, STAT_SPELL_POWER) then
        allowStatIdList[length(allowStatIdList) + 1] = STAT_SPELL_POWER;
      end;

      if not getIsMaxCountStat(playerId, STAT_KNOWLEDGE) then
        allowStatIdList[length(allowStatIdList) + 1] = STAT_KNOWLEDGE;
      end;

      randomGenerateStatId = getRandomStatByRace(raceId, allowStatIdList);

      learning[nextLerningLevel][randomGenerateStatId] = learning[nextLerningLevel][randomGenerateStatId] + 1;
    end;

    local allowStatIdList = {};

    for _, statId in { STAT_ATTACK, STAT_DEFENCE, STAT_SPELL_POWER, STAT_KNOWLEDGE } do
      if not getIsMaxCountStat(playerId, statId) then
        allowStatIdList[length(allowStatIdList) + 1] = statId;
      end;
    end;

    -- пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ 1 пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
    local randomGenerateStatId = getRandomStatByRace(raceId, allowStatIdList);
    learning[nextLerningLevel][randomGenerateStatId] = learning[nextLerningLevel][randomGenerateStatId] + 1;
  end;

  PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level = nextLerningLevel;

  refreshMainHeroStats(playerId);
end;

-- пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
function handleHeroLevelUp(triggerHero)
  print "handleHeroLevelUp"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;

  -- пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ
  local randomGenerateStatId = getRandomStatByRace(playerRaceId);

  changeMainHeroMainStat(playerId, randomGenerateStatId);
end;

-- пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
function getRandomStatByRace(raceId, allowStatList)
  print "getRandomStatByRace"

  local raceDropStatPercent = DROP_STAT_PERCENT_BY_RACE[raceId];

  -- пїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
  if allowStatList ~= nil then
    local summaryPersent = 0;
    local mapStatToField = {
      [STAT_ATTACK] = "attack",
      [STAT_DEFENCE] = "defence",
      [STAT_SPELL_POWER] = "spellpower",
      [STAT_KNOWLEDGE] = "knowledge",
    };

    for _, statId in allowStatList do
      summaryPersent = summaryPersent + raceDropStatPercent[mapStatToField[statId]];
    end;

    local randomFromSummary = random(summaryPersent);
    local new_summary = 0;

    for _, statId in allowStatList do
      new_summary = new_summary + raceDropStatPercent[mapStatToField[statId]];

      if new_summary > randomFromSummary then
        return statId;
      end;
    end;
  end;

  -- пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ
  local randomPercent = random(100);

  local maxAttackLimit = raceDropStatPercent.attack;

  -- пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅ
  if randomPercent < maxAttackLimit then
    return STAT_ATTACK;
  end;

  local maxDefenceLimit = maxAttackLimit + raceDropStatPercent.defence;

  -- пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
  if randomPercent < maxDefenceLimit then
    return STAT_DEFENCE;
  end;

  local maxSpellpowerLimit = maxDefenceLimit + raceDropStatPercent.spellpower;

  -- пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
  if randomPercent < maxSpellpowerLimit then
    return STAT_SPELL_POWER;
  end;

  local maxKnowledgeLimit = maxSpellpowerLimit + raceDropStatPercent.knowledge;

  -- пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
  if randomPercent < maxKnowledgeLimit then
    return STAT_KNOWLEDGE;
  end;
end;

start_learning_script();
