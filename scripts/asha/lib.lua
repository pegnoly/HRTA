
DEBUG = 0

-- Необходимо передавать между значетельными участками времени
-- Поэтому вынесена в глобал
COMBAT_ID = '';

SKILL_LIST = {
  SKILL_NECROMANCY,
  SKILL_AVENGER,
  HERO_SKILL_RUNELORE,
  SKILL_INVOCATION,
  SKILL_ARTIFICIER,
  SKILL_OFFENCE,
  SKILL_DARK_MAGIC,
  SKILL_DEFENCE,
  SKILL_DESTRUCTIVE_MAGIC,
  SKILL_LEARNING,
  HERO_SKILL_BARBARIAN_LEARNING,
  SKILL_LEADERSHIP,
  SKILL_LIGHT_MAGIC,
  SKILL_LOGISTICS,
  SKILL_LUCK,
  HERO_SKILL_SHATTER_DARK_MAGIC,
  HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC,
  SKILL_TRAINING,
  SKILL_GATING,
  HERO_SKILL_DEMONIC_RAGE,
  SKILL_SORCERY,
  SKILL_SUMMONING_MAGIC,
  SKILL_WAR_MACHINES,
  HERO_SKILL_SHATTER_SUMMONING_MAGIC,
  HERO_SKILL_VOICE,
  HERO_SKILL_SHATTER_LIGHT_MAGIC,
}

-- Проверка вхождения в таблицу
function includes(table, item)
	for _, element in table do
		if element == item then
			return not nil
		end
	end

	return nil
end

function trace(message, ...)
  if DEBUG == 1 then
    local data = '';

    for i = 1, arg.n do
		  data = data..', '..arg[i]
    end;

    print(message..': '..data);
  end;
end;

-- Исторически так сложилось
MAP_PLAYER_TO_ASHA_INDEX = {
  [PLAYER_1] = 1,
  [PLAYER_2] = 2,
}

-- Безопасный сбор списка доступных сущностей
-- Т.к. мудрые разработчики решили выкидывать из скрипта с ошибкой
-- приходится каждую проверку оборачивать в отдельный тред
-- NOTE: Все равно будет спамить в консоль ошибками при отсутствии используемых сущностей
function safetyGetEntityList(hero, func, maxId)
  trace('safetyGetEntityList', hero, maxId)

  local checkedEntityList = {};

  for id = 1, maxId do
    startThread(function()
      %checkedEntityList[%id] = 0

      if %func(%hero, %id) then
        %checkedEntityList[%id] = 1
      end
    end)
  end;

  while checkedEntityList[maxId] == nil do sleep() end;

  local resultList = {}

  for entityId, heroHasEntity in checkedEntityList do
    if heroHasEntity == 1 then
      resultList[length(resultList)] = entityId;
    end;
  end;

  return resultList;
end;

function getHasCreaturesList(hero, func, maxId)
  trace('getHasCreaturesList', hero, maxId)
  
  local checkedEntityList = {};

  for id = 1, maxId do
    startThread(function()
      %checkedEntityList[%id] = 0

      if %func(%hero, %id) ~= 0 then
        %checkedEntityList[%id] = 1
      end
    end)
  end;

  while checkedEntityList[maxId] == nil do sleep() end;

  local resultList = {}

  for entityId, heroHasEntity in checkedEntityList do
    if heroHasEntity == 1 then
      resultList[length(resultList)] = entityId;
    end;
  end;

  return resultList;
end;

THIRD_PART_REPORT = {}

-- Собираем итоговую информацию и запускаем отчет
function composeDataAfterBattle(combatIndex)
  trace('composeDataAfterBattle', combatIndex);

  local winnerHero = GetSavedCombatArmyHero(combatIndex, 1);

  local ArmyRemainder = '';

  if IsHeroAlive(winnerHero) then
    for creatureIndex = 0, GetSavedCombatArmyCreaturesCount(combatIndex, 1) - 1 do
      local creatureId, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 1, creatureIndex);

      ArmyRemainder = ArmyRemainder..creatureId..' = '..(count-died)..', ';
    end;
  end;

  local winnerPlayerId = GetSavedCombatArmyPlayer(combatIndex, 1)
  local looserPlayerId = GetSavedCombatArmyPlayer(combatIndex, 0)

  local composedData = {
    ["EqualityBattle"] = 100,
    ["ArmyRemainder"] = ArmyRemainder,
    ["Winner"] = 'Player_'..MAP_PLAYER_TO_ASHA_INDEX[winnerPlayerId],
  }

  local looserPlayerLeave = GetPlayerHeroes(looserPlayerId)[0] == nil;

  -- Если игрок покинул игру во время боя, кидаем победителю модалку по поводу разрыва соединения
  if looserPlayerLeave then
    composedData["wasDisconnect"] = 'True';
    QuestionBoxForPlayers(GetPlayerFilter(winnerPlayerId), "/scripts/asha/disconnect_question.txt", 'sendFourPartReport("False")', 'sendFourPartReport("True")');
  end;

  for name, value in composedData do
    THIRD_PART_REPORT[name] = value;
  end;
  
  sendThirdPartReport();
  sendFourPartReport('False');
end;

-- Результаты сражения
function sendThirdPartReport()
  trace('sendFirstPartReport');

  consoleCmd('game_writelog 1')
  sleep(5)
  
  for field, value in THIRD_PART_REPORT do
    print(field..': '..(value and value or ''));
  end;
  
  print('Finish');

  consoleCmd('game_writelog 0')
end;

-------------------------------

-- Ответ на вопрос о дисконнекте
function sendFourPartReport(answer)
  trace('sendFourPartReport', answer);

  consoleCmd('game_writelog 1')
  sleep(5)
  print('IsDisconnect:'..answer..':CombatID:'..COMBAT_ID);
  consoleCmd('game_writelog 0')
end;

-- Необходимо, чтобы на момент вызова город принадлежал игроку
function getHeroRace(hero)
  local playerId = GetObjectOwner(hero);

  for _, town in GetObjectNamesByType("TOWN_") do
    if GetObjectOwner(town) == playerId then
      local raceId = GetTownRace(town);

      return raceId;
    end;
  end;
end;

-- Геттеры для характеристик героя
function getterHeroStatValue(statId)
  local resultFunction = function(hero)
    local statCount = GetHeroStat(hero, %statId);

    return statCount
  end;

  return resultFunction;
end;

-- Поля с одинарным значением
HERO_HALF_FIELDS_WITH_SINGLE_VALUE = {
  ["_Name"] = function (hero) return hero end,
  ["_Race"] = getHeroRace,
  ["_Level"] = function (hero) local x = GetHeroLevel(hero); return x end,
  ["_Attack"] = getterHeroStatValue(STAT_ATTACK),
  ["_Defence"] = getterHeroStatValue(STAT_DEFENCE),
  ["_Spellpower"] = getterHeroStatValue(STAT_SPELL_POWER),
  ["_Knowledge"] = getterHeroStatValue(STAT_KNOWLEDGE),
  ["_Luck"] = getterHeroStatValue(STAT_LUCK),
  ["_Morale"] = getterHeroStatValue(STAT_MORALE),
  ["_Mana"] = getterHeroStatValue(STAT_MANA_POINTS),
};

-- Частично карируем функцию для универсальности
function getterMultiValues(checkerType, maxId)
  local resultFunction = function(hero)
    trace('getterMultiValues', hero, %checkerType, %maxId);

    local checkerType = %checkerType
    local maxId = %maxId

    local checker = {
      ['spell'] = KnowHeroSpell,
      ['skill'] = HasHeroSkill,
      ['perk'] = HasHeroSkill,
      ['art'] = HasArtefact,
      ['creature'] = GetHeroCreatures,
      ['machine'] = HasHeroWarMachine,
    }

    local entityListGetter = checkerType == 'creature' and getHasCreaturesList or safetyGetEntityList;
    local entityList = entityListGetter(hero, checker[checkerType], maxId);

    local resultList = '';

    for _, entityId in entityList do
      if checkerType == 'skill' and includes(SKILL_LIST, entityId) then
        resultList = resultList..entityId..' = '..GetHeroSkillMastery(hero, entityId)..', ';
      end;

      if checkerType == 'perk' and not includes(SKILL_LIST, entityId) then
        resultList = resultList..entityId..', ';
      end;

      if checkerType == 'creature' then
        resultList = resultList..entityId..' = '..GetHeroCreatures(hero, entityId)..', ';
      end;

      if (
         checkerType == 'spell'
         or checkerType == 'art'
         or checkerType == 'machine'
      ) then
        resultList = resultList..entityId..', ';
      end;
    end;

    return resultList;
  end;

  return resultFunction;
end;

HERO_HALF_FIELDS_WITH_MULTI_VALUES = {
  ["_Army"] = getterMultiValues('creature', 179),
  ["_Arts"] = getterMultiValues('art', 95),
  ["_Spells"] = getterMultiValues('spell', 295),
  ["_Skills"] = getterMultiValues('skill', 215),
  ["_Perks"] = getterMultiValues('perk', 215),
  ["_WarMachines"] = getterMultiValues('machine', 4),
};

-----------------------

FIRST_PART_REPORT = {}

-- Сбор данных героя до боя
function composeHeroesDataBeforeFight(redMainHero, blueMainHero)
  trace('composeHeroesDataBeforeFight', redMainHero, blueMainHero);

  for _, hero in { redMainHero, blueMainHero } do
    local playerIndex = MAP_PLAYER_TO_ASHA_INDEX[GetObjectOwner(hero)];

    for halfFieldName, getter in HERO_HALF_FIELDS_WITH_SINGLE_VALUE do
      local currentData = getter(hero);

      FIRST_PART_REPORT['Hero'..playerIndex..halfFieldName] = currentData;
    end;

    for halfFieldName, getter in HERO_HALF_FIELDS_WITH_MULTI_VALUES do
      local currentData = getter(hero);

      FIRST_PART_REPORT['Hero'..playerIndex..halfFieldName] = currentData;
    end;
  end;

  writeCombatId();
end;

-- Уникальности для каждой карты
function composeCustomData(composedData)
  for name, value in composedData do
    trace('composeCustomData', name, value);
    FIRST_PART_REPORT[name] = value;
  end;

  sendFirstPartReport();
end;

-- magic
function getTripleRandomNumber()
  return 'x'..random(1000);
end;

-- Создание идентификатора для объединения информации по игре
function writeCombatId()
  trace('writeCombatId');

  local fields = {
    "_Race",
    "_Attack",
    "_Defence",
    "_Spellpower",
    "_Knowledge"
  };

  local CombatID = '';

  for index = 1, 2 do
    for _, halfKey in fields do
      local key = 'Hero'..index..halfKey;

      CombatID = CombatID..FIRST_PART_REPORT[key]
    end;
  end;

  COMBAT_ID = CombatID..getTripleRandomNumber()..getTripleRandomNumber()..getTripleRandomNumber()..getTripleRandomNumber()..getTripleRandomNumber()
end;

-- Основные данные по игрокам
function sendFirstPartReport()
  trace('sendFirstPartReport');

  consoleCmd('game_writelog 1');
  sleep(5)
  print('StartReport');
  print('CombatID:'..COMBAT_ID);

  for field, value in FIRST_PART_REPORT do
    print(field..': '..(value and value or ''));
  end;

  consoleCmd('game_writelog 0');
end;
