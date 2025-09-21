PATH_TO_DAY5_SCRIPTS = GetMapDataPath().."day5/";
PATH_TO_DAY5_MESSAGES = PATH_TO_DAY5_SCRIPTS.."messages/";

-- Тут пока что бардак из-за отчетов.

-- Получение индекса героя
function getHeroIndex(playerId)
  print "getHeroIndex"

  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  for indexHero, heroData in HEROES_BY_RACE[raceId] do
    if dictHeroName == heroData.name then
      return indexHero;
    end;
  end;
end;

-- Кастомная утилита генерации ид встречи на основе свойств игроков
-- Используется не случайное сгенерированное значение, чтобы отслеживать возможность переигровки
-- TODO заманался писать. Сделаю, когда буду настраивать асху снова
function getCombatId()
  print "getCombatId"

  local result = 'CombatID:';

  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;

    result = result..raceId;

    local heroIndex = getHeroIndex(playerId);

    result = result..heroIndex;

    for _, statId in ALL_MAIN_STATS_LIST do
      result = result..GetHeroStat(mainHeroName, statId);
    end;
  end;

  result = result..random(100);

  return result;
end;

-- Запись последней части отчета в файл
function sendReport(playerId, tournamentId)
  print "sendReport"

  consoleCmd('game_writelog 1');
  sleep(1);

  -- Если ничего важного
  if tournament ~= 1 then
    print('Disconnect');
    consoleCmd('game_writelog 0');

    return nil;
  end;

  print('Winner: Player', playerId)
  consoleCmd('profile_name');
  sleep(1);

  local CombatID = getCombatId();

  print(CombatID);

  local REPORT_PLAYER_FIELDS = {
    Name = 'Name',
    Race = 'Race',
    Level = 'Level',
    Attack = 'Attack',
    Defence = 'Defence',
    Spellpower = 'Spellpower',
    Knowledge = 'Knowledge',
    Luck = 'Luck',
    Morale = 'Morale',
    Mana = 'Mana',
    StartBonus = 'StartBonus',
    Mentoring = 'Mentoring',
    Army = 'Army',
    Arts = 'Arts',
    Spells = 'Spells',
    Skills = 'Skills',
    Perks = 'Perks',
  };

  for _, playerId in PLAYER_ID_TABLE do
    for _, fieldName in REPORT_PLAYER_FIELDS do
      print(array_info[playerId][fieldName]);
    end;
  end;

  print(Info_Hero_ArmyRemainder);
  print('Finish');
  consoleCmd('game_writelog 0');
end;

-- Обогащаем отчет результатами боя
function enrichmentReportWithResultBattle(combatIndex)
  print "enrichmentReportWithResultBattle"

  local looserHeroName = GetSavedCombatArmyHero(combatIndex, 0);
  local looserPlayerId = GetPlayerFilter(GetObjectOwner(looserHeroName));

  Loose(looserPlayerId);

  local countWinnerPlayerArmy = GetSavedCombatArmyCreaturesCount(combatIndex, 1);

  local reportWinnerArmyRemainder = 'ArmyRemainder: ';

  for unitIndex = 0, countWinnerPlayerArmy - 1 do
    local unitId, countUnitBeforeBattle, countUnitDied = GetSavedCombatArmyCreatureInfo(combatIndex, 1, unitIndex);

    reportWinnerArmyRemainder = reportWinnerArmyRemainder .. 'ID' .. unitId .. ' = ' .. (countUnitBeforeBattle - countUnitDied) .. ', ';
  end;

  local winnerPlayerId = PLAYERS_OPPONENT[looserPlayerId];
  local winnerHeroName = PLAYERS_MAIN_HERO_PROPS[winnerPlayerId].name;

  local alivePlayerId, playerTexturePath;

  if IsHeroAlive(winnerHeroName) then
    alivePlayerId = winnerPlayerId;
    playerTexturePath = "/Textures/Icons/Heroes/Inferno/Inferno_Biara_128x128.(Texture).xdb#xpointer(/Texture)";
  end;
  if IsHeroAlive(winnerHeroName) then
    alivePlayerId = looserPlayerId;
    playerTexturePath = "/UI/H5A1/Icons/Heroes/Portrets128x128/Giovanni.(Texture).xdb#xpointer(/Texture)";
  end;

  TalkBoxForPlayers(
    alivePlayerId,
    playerTexturePath,
    PATH_TO_DAY5_MESSAGES.."report_desc.txt",
    nil,
    nil,
    'sendReport',
    0,
    PATH_TO_DAY5_MESSAGES.."report_title.txt",
    PATH_TO_DAY5_MESSAGES.."question_report.txt",
    nil,
    PATH_TO_DAY5_MESSAGES.."report_test_variable.txt"
  );
end;

PathFindingX = {} ;
PathFindingX = { 50, 56, 48, 50, 44, 44, 56, 51};

PathFindingY = {} ;
PathFindingY = { 45, 49, 52, 45, 48, 42, 41, 38};

function PathFinding(HeroWithPerk, HeroWithoutPerk, race)
  hodi1(HeroWithPerk);
  sleep(1);
  MoveHeroRealTime(HeroWithPerk, PathFindingX[race], PathFindingY[race]);
  sleep(10);

  InitCombatExecThread(HeroMax1)
  sleep(5)
  SaveHeroesInfoBeforeCombat{HeroMax1, HeroMax2}
  sleep(5)
  MakeHeroInteractWithObject (HeroWithoutPerk, HeroWithPerk);

  while IsHeroAlive(HeroWithoutPerk) and IsHeroAlive(HeroWithPerk) do
		MakeHeroInteractWithObject(HeroWithoutPerk, HeroWithPerk);
		sleep(10);
	end;
end;

-- Соотношение ид фракции к полю
RACE_ON_FIELD_POSITION = {
  [RACES.HAVEN] = { x = 50, y = 45 },
  [RACES.HAVEN] = { x = 56, y = 49 },
  [RACES.HAVEN] = { x = 48, y = 52 },
  [RACES.HAVEN] = { x = 50, y = 45 },
  [RACES.HAVEN] = { x = 44, y = 48 },
  [RACES.HAVEN] = { x = 44, y = 42 },
  [RACES.HAVEN] = { x = 56, y = 41 },
  [RACES.HAVEN] = { x = 51, y = 38 },
};
