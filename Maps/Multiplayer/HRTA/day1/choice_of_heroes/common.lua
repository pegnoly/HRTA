-- √енерим по еще 1 случайному герою из общего списка героев
function getRandomHeroFromAll()
  print "getRandomHeroFromAll"
  
  for _, playerId in { PLAYER_1, PLAYER_2 } do
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    local allHeroesByRace = HEROES_BY_RACE[raceId];

    local resultHeroes = RESULT_HERO_LIST[playerId].heroes;
    local opponentResultHeroes = RESULT_HERO_LIST[PLAYERS_OPPONENT[playerId]].heroes;

    local filteredHeroList = {};

    for _, heroData in allHeroesByRace do
      local isExist = nil;

      for _, disallowHeroName in resultHeroes do
        if heroData.name == disallowHeroName then
          isExist = not nil;
        end;
      end;

      for _, disallowHeroName in opponentResultHeroes do
        if heroData.name == disallowHeroName then
          isExist = not nil;
        end;
      end;

      if not isExist then
        filteredHeroList[length(filteredHeroList) + 1] = heroData.name;
      end;
    end;

    -- –андомим геро€ в таверне
    local randomHeroIndex = random(length(filteredHeroList)) + 1;

    local randomHero = filteredHeroList[randomHeroIndex];

    resultHeroes[length(resultHeroes) + 1] = randomHero;
  end;
end;

-- ¬ыбор случайных 2 героев из переданного списка и 1 рандомным
function setRandomHeroFromHeroList()
  print "setRandomHeroFromHeroList"

  -- √енерим 2 случайных героев из выбранных наборов
  for _, playerId in { PLAYER_1, PLAYER_2 } do
    local resultHeroes = RESULT_HERO_LIST[playerId].heroes;
    local opponentResultHeroes = RESULT_HERO_LIST[PLAYERS_OPPONENT[playerId]].heroes;
    local heroList = RESULT_HERO_LIST[playerId].choised_heroes;

    local filteredHeroList = {};

    -- ”бираем из списка возможных героев, выбранных героев оппонента
    for _, posibleHeroName in heroList do
      local isExist = nil;

      for _, disallowHeroname in opponentResultHeroes do
        if posibleHeroName == disallowHeroname then
          isExist = not nil;
        end;
      end

      if not isExist then
        filteredHeroList[length(filteredHeroList) + 1] = posibleHeroName;
      end;
    end;

    local resultHeroMaxIndex = (RESULT_HERO_LIST[PLAYER_1].raceId == RESULT_HERO_LIST[PLAYER_2].raceId) and 2 or 3
    
    for resultHeroIndex = 1, resultHeroMaxIndex do
      -- –андомим основного геро€
      

      

      local randomHeroIndex = random(length(filteredHeroList)) + 1;

      local randomHero = filteredHeroList[randomHeroIndex];

      resultHeroes[resultHeroIndex] = randomHero;

      -- ќбновл€ем список возможных героев
      local heroListWORandomHero = {};

      for _, heroName in filteredHeroList do
        if heroName ~= randomHero then
          heroListWORandomHero[length(heroListWORandomHero) + 1] = heroName;
        end;
      end;

      filteredHeroList = heroListWORandomHero;
    end;
  end;

  -- √енерим по еще 1 случайному герою из общего списка героев
  -- getRandomHeroFromAll();
end;