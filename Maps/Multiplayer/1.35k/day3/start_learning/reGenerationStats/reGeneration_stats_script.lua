-- Установка триггеров на покупку дополнительных статов
function setReGenerationStatTriggers()
  print "setReGenerationStatTriggers"

  -- Маппинг объектов для перегенерации статистик на игроков
  local MAP_RE_GENERATION_OBJECT_NAME_ON_PLAYER = {
    [PLAYER_1] = 'stat1',
    [PLAYER_2] = 'stat2',
  };

  for _, playerId in PLAYER_ID_TABLE do
    SetObjectEnabled(MAP_RE_GENERATION_OBJECT_NAME_ON_PLAYER[playerId], nil);
    OverrideObjectTooltipNameAndDescription(
      MAP_RE_GENERATION_OBJECT_NAME_ON_PLAYER[playerId],
      PATH_TO_START_LEARNING_MESSAGES.."re_generation_stats_object_name.txt",
      PATH_TO_START_LEARNING_MESSAGES.."re_generation_stats_object_desc.txt"
    );
    Trigger(OBJECT_TOUCH_TRIGGER, MAP_RE_GENERATION_OBJECT_NAME_ON_PLAYER[playerId], 'handleTouchReGenerationStatObject' );
  end;
end;

-- Обработка касания героем объекта для перегенерации статов
function handleTouchReGenerationStatObject(triggerHero)
  print "handleTouchReGenerationStatObject"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  if playerMainHeroProps.name == nil then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."need_main_hero.txt");

    return nil;
  end;

  if GetPlayerResource(playerId, GOLD) < COST_RE_GENERATION_STATS then
    MessageBoxForPlayers(GetPlayerFilter(playerId), {PATH_TO_START_LEARNING_MESSAGES.."not_enough_n_gold.txt"; eq=COST_RE_GENERATION_STATS});

    return nil;
  end;

  local differenceCharacteristics = reGenerationStats(playerId);

  QuestionBoxForPlayers(
    playerId,
    {PATH_TO_START_LEARNING_MESSAGES.."question_re_generation_stats.txt"; eq = COST_RE_GENERATION_STATS, attackValue = differenceCharacteristics[STAT_ATTACK], defValue = differenceCharacteristics[STAT_DEFENCE], spValue = differenceCharacteristics[STAT_SPELL_POWER], knowValue = differenceCharacteristics[STAT_KNOWLEDGE]},
    'changeStatHero("'..playerId..'")',
    'noop'
  );
end;

--Изменение характеристик героя на выбранные
function changeStatHero(strPlayerId)
  print "changeStatHero"
  
  local playerId = strPlayerId + 0;
  local differenceCharacteristics = reGenerationStats(playerId);
  local mainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];
  local mainHeroStats = mainHeroProps.stats;
  
  PLAYERS_MAIN_HERO_PROPS[playerId].stats = {
    [STAT_ATTACK] = mainHeroStats[STAT_ATTACK] + differenceCharacteristics[STAT_ATTACK],
    [STAT_DEFENCE] = mainHeroStats[STAT_DEFENCE] + differenceCharacteristics[STAT_DEFENCE],
    [STAT_SPELL_POWER] = mainHeroStats[STAT_SPELL_POWER] + differenceCharacteristics[STAT_SPELL_POWER],
    [STAT_KNOWLEDGE] = mainHeroStats[STAT_KNOWLEDGE] + differenceCharacteristics[STAT_KNOWLEDGE],
  }
  
  refreshMainHeroStats(playerId)
  
  SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) - COST_RE_GENERATION_STATS)
  local mainHeroX, mainHeroY = GetObjectPosition(mainHeroProps.name);
  Play2DSoundForPlayers(playerId, "/Sounds/_(Sound)/Interface/Ingame/Buy.xdb#xpointer(/Sound)", mainHeroX, mainHeroY, 0);
end;

-- Перегенерация статов у главного героя игрока
function reGenerationStats(strPlayerId)
  print "reGenerationStats"
  local playerId = strPlayerId + 0;
  local mainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];
  local mainHeroStats = mainHeroProps.stats;
  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;
  local raceDropStatPercent = DROP_STAT_PERCENT_BY_RACE[playerRaceId];
  local mainHeroLevel = GetHeroLevel(mainHeroProps.name);

  local countStats = mainHeroLevel - 1;

  --расчитываем статы с остатком
  local atk = countStats * raceDropStatPercent.attack;
  local def = countStats * raceDropStatPercent.defence;
  local know = countStats * raceDropStatPercent.knowledge;
  local sp = countStats * raceDropStatPercent.spellpower;
  
  --остаточный процент
  local atkRemainder = atk/100 - floor(atk/100);
  local defRemainder = def/100 - floor(def/100);
  local knowRemainder = know/100 - floor(know/100);
  local spRemainder = sp/100 - floor(sp/100);

  --количество статов в остаточных процентах
  local countUnsortedStat = ceil(atkRemainder + defRemainder + knowRemainder + spRemainder);
 
--  local levelEducation = GetHeroSkillMastery(mainHeroProps.name,SKILL_LEARNING)

  local tableStats = {
    [STAT_ATTACK] = atkRemainder,
    [STAT_DEFENCE] = defRemainder,
    [STAT_KNOWLEDGE] = knowRemainder,
    [STAT_SPELL_POWER] = spRemainder,
  }

  local resultStats = {
    [STAT_ATTACK] = 0,
    [STAT_DEFENCE] = 0,
    [STAT_KNOWLEDGE] = 0,
    [STAT_SPELL_POWER] = 0,
  }
  
  local counterWasFoundStats = 0;
  
  for statId, percentRemainder in tableStats do
    local counter = 0;
    
    for statId2, percentRemainder2 in tableStats do
      if percentRemainder >= percentRemainder2 then
        counter = counter + 1;
      end;
    end;
    
    if counter >= (4 - countUnsortedStat) and  counterWasFoundStats < countUnsortedStat then
      counterWasFoundStats = counterWasFoundStats + 1;
      resultStats[statId] = counter;
    end;
  end;
  
  local differenceStatsHero = {
    [STAT_ATTACK] = floor(atk/100) + (resultStats[STAT_ATTACK] == 0 and 0 or 1) - mainHeroStats[STAT_ATTACK],
    [STAT_DEFENCE] = floor(def/100) + (resultStats[STAT_DEFENCE] == 0 and 0 or 1) - mainHeroStats[STAT_DEFENCE],
    [STAT_KNOWLEDGE] = floor(know/100) + (resultStats[STAT_KNOWLEDGE] == 0 and 0 or 1) - mainHeroStats[STAT_KNOWLEDGE],
    [STAT_SPELL_POWER] = floor(sp/100) + (resultStats[STAT_SPELL_POWER] == 0 and 0 or 1) - mainHeroStats[STAT_SPELL_POWER],
  };

  return differenceStatsHero
end;


setReGenerationStatTriggers();
