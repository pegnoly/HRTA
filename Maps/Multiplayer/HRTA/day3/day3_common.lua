-- Скрипты, использующиеся во всем модуле

-- Высчитывание начального бонуса
function getCalculatedStartedBonus(playerId)
  print "getCalculatedStartedBonus"

  local bonus = STARTED_BONUSES.ART;

  if (
    GetPlayerResource(playerId, GOLD)~=10000
      and GetPlayerResource(playerId, GOLD)~=20000
      and GetPlayerResource(playerId, GOLD)~=30000
      and GetPlayerResource(playerId, GOLD)~=50000
  ) then
    bonus = STARTED_BONUSES.GOLD;
  end;

  if (
    mod(
      GetPlayerResource(playerId, WOOD)
        + GetPlayerResource(playerId, ORE)
        + GetPlayerResource(playerId, MERCURY)
        + GetPlayerResource(playerId, CRYSTAL)
        + GetPlayerResource(playerId, SULFUR)
        + GetPlayerResource(playerId, GEM),
      40
    ) ~= 0
  ) then
    bonus = STARTED_BONUSES.SPELL;
  end;

  return bonus;
end;

-- Получение иконки героя для игрока по герою
function getHeroIconByHeroName(playerId, heroName)
  print "getHeroIconByHeroName"

  local raceId = RESULT_HERO_LIST[playerId].raceId;

  for indexDictHero = 1, length(HEROES_BY_RACE[raceId]) do
    local dictHero = HEROES_BY_RACE[raceId][indexDictHero];

    if dictHero.name == heroName then
      return dictHero[playerId][1].red_icon;
    end;
  end;
end;