doFile(GetMapDataPath().."day3/town_building/town_building_constants.lua");
sleep(1);

-- ������� ���������� �� ��������� ������� ������� � ����������� ��
function buildingTown()
  print "buildingTown"

  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
    transformPlayersTown(townName, raceId);

    setTownMaximumLevel(townName, raceId);
    -- #6 в моде Аутора города не должны настраиваться по дефолту
    if not (game_modes_core.current_mode == GAME_MODE_ASTROLOGY and astrology_core.current_week == ASTROLOGY_WEEK_AUOTOR) then
      SetObjectOwner(townName, playerId);
      setArmyIntoTown(townName, raceId, playerId);
    end 
  end;
end;

-- ��������� ����������� ������ �� ����� ���������� ����
function transformPlayersTown(townName, raceId)
  print "transformPlayersTown"

  -- ����������� ���� � �� ������
  local MAP_RACE_TO_TOWN = {
    [RACES.HAVEN] = TOWN_HEAVEN,
    [RACES.INFERNO] = TOWN_INFERNO,
    [RACES.NECROPOLIS] = TOWN_NECROMANCY,
    [RACES.SYLVAN] = TOWN_PRESERVE,
    [RACES.ACADEMY] = TOWN_ACADEMY,
    [RACES.DUNGEON] = TOWN_DUNGEON,
    [RACES.FORTRESS] = TOWN_FORTRESS,
    [RACES.STRONGHOLD] = TOWN_STRONGHOLD,
  };

  TransformTown(townName, MAP_RACE_TO_TOWN[raceId]);
end;

-- ��������� ������������� lvl ��� ������
function setTownMaximumLevel(townName, raceId)
  print "setTownMaximumLevel"

  local allTownCreatureList = {
    TOWN_BUILDING_DWELLING_1,
    TOWN_BUILDING_DWELLING_2,
    TOWN_BUILDING_DWELLING_3,
    TOWN_BUILDING_DWELLING_4,
    TOWN_BUILDING_DWELLING_5,
    TOWN_BUILDING_DWELLING_6,
    TOWN_BUILDING_DWELLING_7
  };

  for _, dwelling in allTownCreatureList do
    UpgradeTownBuilding(townName, dwelling);
    SetTownBuildingLimitLevel(townName, dwelling, 2);
    UpgradeTownBuilding(townName, dwelling);
  end;

  if raceId == RACES.HAVEN then
    SetTownBuildingLimitLevel(townName, TOWN_BUILDING_HAVEN_TRAINING_GROUNDS, 0);
  end;

  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_TOWN_HALL, 1);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_FORT, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_MARKETPLACE, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_SHIPYARD, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_TAVERN, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_BLACKSMITH, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_MAGIC_GUILD, 0);

  if raceId == RACES.ACADEMY then
    UpgradeTownBuilding(townName, TOWN_BUILDING_ACADEMY_ARTIFACT_MERCHANT);
  end;
  if raceId == RACES.DUNGEON then
    UpgradeTownBuilding(townName, TOWN_BUILDING_DUNGEON_TRADE_GUILD);
    SetTownBuildingLimitLevel(townName, TOWN_BUILDING_DUNGEON_HALL_OF_INTRIGUE, 0);
    SetTownBuildingLimitLevel(townName, TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS, 0);
  end;
end;

-- ��������� ����� � ������ ������
function setArmyIntoTown(townName, raceId, playerId)
  print "setArmyIntoTown"

  -- ��������� �����
  generateArmy(playerId, raceId);
  
  -- ���������� ������ ��������
  pushArmyToTown(townName, playerId, raceId);
end;

-- ��������� ����� � �����
function pushArmyToTown(townName, playerId, raceId)
  print "pushArmyToTown"

  for unitLevel = 1, 7 do
    local unit = RESULT_ARMY_INTO_TOWN[playerId][unitLevel];

    --���������� ��� ������� �����

    if CUSTOM_GAME_MODE_TROUBLED_TIME == 1 then
      if unitLevel == CUSTOM_GAME_MODE_TROUBLED_TIME_TIER then
        unit.count = 0;
      end;
    end;
    
    SetObjectDwellingCreatures(townName, unit.id, unit.count);
  end;
end;

function tierUnitDelete()

end;

-- ��������� ���������� �������� -1 ��� 1
function getRandomPlusOrMinusOne()
  return random(2) == 0 and -1 or 1;
end;

-- ��������� ���������� ������
function getCountUnitByLevel(playerId, raceId, unitLevel)
  print "getCountUnitByLevel"

  local count = UNITS[raceId][unitLevel].kol;

--  if unitLevel == 6 then
--    count = random(3) + count - 1;
--  end;

  if unitLevel < 6 and unitLevel > 1 then
    local plusOrMinusOne = getRandomPlusOrMinusOne();

    count = plusOrMinusOne * random(count * 0.05) + count;
  end;

  if unitLevel == 1 then
    local priceAllButFirst = getAllPriceButFirst(playerId, raceId);

    count = count - priceAllButFirst/UNITS[raceId][unitLevel].price1;
  end;

  return intg(count);
end;

-- ��������� ������� ����������� �����
function getPriceUnitByLevel(raceId, unitLevel, countUnits)
  print "getPriceUnitByLevel"

  local oneUnitPrice = UNITS[raceId][unitLevel].price1;
  local defaultUnitCount = UNITS[raceId][unitLevel].kol;

  if unitLevel == 1 then
    return oneUnitPrice * defaultUnitCount * 0.05;
  end;
  
  return countUnits * oneUnitPrice - defaultUnitCount * oneUnitPrice;
end;

-- ������������� ���������� �����
function adjustmentArmyCount(playerId, raceId)
  print "adjustmentArmyCount"

  local tenPercentFullPriceFirstLvlUnit = getPriceUnitByLevel(raceId, 1);
  local priceAllButFirst = getAllPriceButFirst(playerId, raceId);
  local unitLevel = 7;

  -- ���� ��������������� ������� ����� �����,
  -- ��������� �� ���������� �� ��������� ����� 5% �� ������� ����
  if priceAllButFirst > tenPercentFullPriceFirstLvlUnit then
    while unitLevel > 1 do
      local unit = RESULT_ARMY_INTO_TOWN[playerId][unitLevel];
      
      local priceCurrentLvl = getPriceUnitByLevel(raceId, unitLevel, unit.count);

      if priceCurrentLvl > 0 then
        unit.count = unit.count - 1;
      end;

      unitLevel = unitLevel - 1;

      -- ���� �� ��� ������ �����, ����
      if unitLevel == 1 then
        unitLevel = 6;
      end;

      priceAllButFirst = getAllPriceButFirst(playerId, raceId);

      -- ��������� ������������, ���� �������� �������
      if priceAllButFirst < tenPercentFullPriceFirstLvlUnit then
        unitLevel = 1;
      end;
    end;
  end;

  -- ���� ��������������� ������� ���� �����,
  -- ����������� �� ���������� �� ��������� ����� 5% �� ������� ����
  if priceAllButFirst < (-tenPercentFullPriceFirstLvlUnit) then
    while unitLevel > 1 do
      local unit = RESULT_ARMY_INTO_TOWN[playerId][unitLevel];
    
      local priceCurrentLvl = getPriceUnitByLevel(raceId, unitLevel, unit.count);

      if priceCurrentLvl < 0 then
        unit.count = unit.count + 1;
      end;

      unitLevel = unitLevel - 1;

      -- ���� �� ��� ������ �����, ����
      if unitLevel == 1 then
        unitLevel = 6;
      end;

      priceAllButFirst = getAllPriceButFirst(playerId, raceId);

      -- ��������� ������������, ���� �������� �������
      if priceAllButFirst < (-tenPercentFullPriceFirstLvlUnit) then
        unitLevel = 1;
      end;
    end;
  end;
end;

-- ��������� ����� ������������ ���� ������, ����� ������� ����
function getAllPriceButFirst(playerId, raceId)
  print "getAllPriceButFirst"

  local price = 0;

  for levelUnit = 7, 2, -1 do
    price = getPriceUnitByLevel(raceId, levelUnit, RESULT_ARMY_INTO_TOWN[playerId][levelUnit].count);
  end;

  return price;
end;

-- ��������� ��������� �����
function getResultUnit(playerId, raceId, unitLevel)
  print "getResultUnit"
  
  return {
    id = SUCCESS_UNITS_ID[raceId][unitLevel],
    count = getCountUnitByLevel(playerId, raceId, unitLevel),
  };
end;

-- ��������� ������������� ���������� ������� � �����
function generateArmy(playerId, raceId)
  print "generateArmy"

  for unitLevel = 7, 1, -1 do
    if unitLevel == 1 then
      -- ������������ ���������� �����
      adjustmentArmyCount(playerId, raceId);
    end;

    RESULT_ARMY_INTO_TOWN[playerId][unitLevel] = getResultUnit(playerId, raceId, unitLevel);
  end;
end;

-- ����� �����
buildingTown();
