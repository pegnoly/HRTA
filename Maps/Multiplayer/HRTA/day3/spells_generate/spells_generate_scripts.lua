-- � ���� ����� ������� ������� ��� ������ � ������������

PATH_TO_SPELL_GENERATE_MODULE = GetMapDataPath().."day3/spells_generate/";
PATH_TO_SPELLS_NAMES = PATH_TO_SPELL_GENERATE_MODULE.."spells_names/";
PATH_TO_SPELLS_GENERATE_MESSAGES = PATH_TO_SPELL_GENERATE_MODULE.."messages/";

doFile(PATH_TO_SPELL_GENERATE_MODULE.."spells_generate_constants.lua");
sleep(1);

ACADEMY_AVAILABLE_MAGICK_TYPES = { TYPE_MAGICS.LIGHT, TYPE_MAGICS.DARK, TYPE_MAGICS.DESTRUCTIVE };

-- ������� ��������� ����� ��� ����
function getRandomAcademyMagicType()
  local randomValue = random(3) + 1;

  return ACADEMY_AVAILABLE_MAGICK_TYPES[randomValue];
end;

-- ��������� ����� ���� ��� ����� �������
PLAYERS_MAGE_TYPES = {
  [PLAYER_1] = getRandomAcademyMagicType(),
  [PLAYER_2] = getRandomAcademyMagicType(),
};

MAPPPING_RACE_TO_MAGIC = {
  [RACES.HAVEN]            = { TYPE_MAGICS.LIGHT, TYPE_MAGICS.DARK },
  [RACES.INFERNO]          = { TYPE_MAGICS.DARK, TYPE_MAGICS.DESTRUCTIVE },
  [RACES.NECROPOLIS]       = { TYPE_MAGICS.DARK, TYPE_MAGICS.SUMMON },
  [RACES.SYLVAN]           = { TYPE_MAGICS.LIGHT, TYPE_MAGICS.DESTRUCTIVE },
  [RACES.ACADEMY]          = { TYPE_MAGICS.SUMMON },
  [RACES.DUNGEON]          = { TYPE_MAGICS.DESTRUCTIVE, TYPE_MAGICS.SUMMON },
  [RACES.FORTRESS]         = { TYPE_MAGICS.LIGHT, TYPE_MAGICS.DESTRUCTIVE },
  [RACES.STRONGHOLD]       = { TYPE_MAGICS.WARCRIES },
};

-- ��������� ���������� ������ ���������� ��� ������
function generateRandomSpellSet()
  print "generateRandomSpellSet"
  
  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    
    local playerMagickList = MAPPPING_RACE_TO_MAGIC[raceId];

    if raceId == RACES.ACADEMY then
      playerMagickList[2] = PLAYERS_MAGE_TYPES[playerId];
    end;
    
    -- ��������� ���������� - ��������� �������
    generateStartedBonusSpells(playerId, playerMagickList);
    
    -- ��������� ������ ���������� ��� ������
    generateSpellByMagicType(playerId, raceId, playerMagickList);
    
    -- ���������� ������������� ������ ����������
    addResetSpellsObject(playerId);
  end;
end;

-- ��������� ���������� ���������� ������������� ���� �����, ������������� ������
function getRandomSpell(magicType, spellLevel)
  print "getRandomSpell"
  
  -- ������ ���������� ����������� ������
  local spellsByLevel = {};
  
  -- ��������� ������ ������������
  for indexSpell = 1, length(SPELLS[magicType]) do
    local spellData = SPELLS[magicType][indexSpell];

    if spellData.level == spellLevel then
      spellsByLevel[length(spellsByLevel) + 1] = spellData;
    end;
  end;
  
  -- �������� ��������� ���������� �� ������
  local randomSpellIndex = random(length(spellsByLevel)) + 1;

  return spellsByLevel[randomSpellIndex];
end;

-- ��������� ������ � ���������� �� �� ����������
function getSpellDataBySpellId(spellId)
  print "getSpellDataBySpellId"

  for magicTypeId = 0, length(SPELLS) - 1 do
    local magicTypeSpells = SPELLS[magicTypeId];
    
    for indexSpell = 1, length(magicTypeSpells) do
      local spellData = magicTypeSpells[indexSpell];
      
      if spellData.id == spellId then
        return spellData;
      end;
    end;
  end;
end;

-- ��������� �� ����� ����� �� �� ����������
function getMagicTypeIdBySpellId(spellId)
  print "getMagicTypeIdBySpellId"

  for magicTypeId = 0, length(SPELLS) - 1 do
    local magicTypeSpells = SPELLS[magicTypeId];

    for indexSpell = 1, length(magicTypeSpells) do
      local spellData = magicTypeSpells[indexSpell];

      if spellData.id == spellId then
        return magicTypeId;
      end;
    end;
  end;
end;

-- ��������� ������ ����������
function getSpellLevelBySpellId(spellId)
  print "getSpellLevelBySpellId"

  for magicTypeId = 0, length(SPELLS) - 1 do
    local magicTypeSpells = SPELLS[magicTypeId];

    for indexSpell = 1, length(magicTypeSpells) do
      local spellData = magicTypeSpells[indexSpell];

      if spellData.id == spellId then
        return spellData.level;
      end;
    end;
  end;
end;


-- ��������� ���������� ���������� ���������� � ��������������� ������
function getCountIdentityGeneratedSpells(playerId, spellSet, spellId)
  print "getCountIdentityGeneratedSpells"
  
  local playerAllSpells = PLAYERS_GENERATED_SPELLS[playerId];
  local countIdentitySpell = 0;
  
  -- �������� � �������� ��������������� �����������
  for _, spell in spellSet do
    if spell.id == spellId then
      countIdentitySpell = countIdentitySpell + 1;
    end;
  end;
  
  -- �������� � �������� ����������� (�������� ��������� �������)
  for _, bonusSpell in playerAllSpells.bonus_spells do
    if bonusSpell.id == spellId then
      countIdentitySpell = countIdentitySpell + 1;
    end;
  end;
  
  return countIdentitySpell;
end

-- ��������� ���������� ���������� � ��� ������������
function getCountIdentityAdditionalSpell(spellId)
  print "getCountIdentityAdditionalSpell"

  local countIdentity = 0;

  for _, additionalSpell in ONLY_ADDITIONAL_SPELL_ID_LIST do
    if additionalSpell == spellId then
      countIdentity = countIdentity + 1;
    end;
  end;
  
  return countIdentity;
end;

-- ��������� ���������� ���������� ���� � ���������� ������
function getCountIdentityMagicType(magicTypeList, inputMagicType)
  print "getCountIdentityMagicType"
  
  local count = 0;
  
  for _, magicType in magicTypeList do
    if magicType == inputMagicType then
      count = count + 1;
    end;
  end;
  
  return count;
end;

-- ��������� ���������� ���� ����� �����, �� ���������� ��������
function getRandomNotBasicMagicType(magicTypeList)
  print "getRandomNotBasicMagicType"

  local randomMagicType, countIdentityMagicType;

  repeat
    randomMagicType = random(4);
    countIdentityMagicType = getCountIdentityMagicType(magicTypeList, randomMagicType);
  until countIdentityMagicType == 0;
  
  return randomMagicType;
end;

-- ��������� ���������� ���������� �������� �������
function getRandomUniqueSpellByMagicType(playerId, spellSet, magicType, spellLevel)
  print "getRandomUniqueSpellByMagicType"
  
  local countIdentityGeneratedSpells, randomSpellCurrentLevel;
  
  repeat
    randomSpellCurrentLevel = getRandomSpell(magicType, spellLevel);

    -- ��� ���������� 3 ������ ���������, ����� � �������� ������� �� ������ ��� ����� (��������� (33))
    if spellLevel == 33 then
      local countIdentity = getCountIdentityAdditionalSpell(randomSpellCurrentLevel.id);

      while countIdentity > 0 do
        randomSpellCurrentLevel = getRandomSpell(magicType, spellLevel);
        countIdentity = getCountIdentityAdditionalSpell(randomSpellCurrentLevel.id);
      end;
    end;

    countIdentityGeneratedSpells = getCountIdentityGeneratedSpells(playerId, spellSet, randomSpellCurrentLevel.id);
  until countIdentityGeneratedSpells == 0
  
  return randomSpellCurrentLevel;
end;

-- ��������� ���������� ����������, �� ������������ �� ��������� ��� ��� ��������� ��� nil
function getRandomAvailableSpellByMagicType(playerId, spellSet, magicType, spellLevel)
  print "getRandomAvailableSpellByMagicType"
  
  local availableSpells = {};

  for _, spellData in SPELLS[magicType] do
    if spellData.level == spellLevel then
      local hasSpell = nil;
      
      -- �������� �� ������� � ���������
      for _, bonusSpellData in PLAYERS_GENERATED_SPELLS[playerId].bonus_spells do
        if bonusSpellData.id == spellData.id then
          hasSpell = not nil;
        end;
      end;
      
      -- �������� �� ������� � ������ ������
      for _, playerSpellData in spellSet do
        if playerSpellData.id == spellData.id then
          hasSpell = not nil;
        end;
      end;
      
      -- �������� �� ���������� � ��������������� ������������
--      for _, addSpellId in ONLY_ADDITIONAL_SPELL_ID_LIST do
--        if addSpellId == spellData.id then
--          hasSpell = not nil;
--        end;
--      end;
      
      if not hasSpell then
        availableSpells[length(availableSpells)] = spellData;
      end;
    end;
  end;
  
  if length(availableSpells) == 0 then
    return nil;
  end;

  return availableSpells[random(length(availableSpells))];
end;

-- ��������� ����������, ��� ���������� ������
function getStartedBonusSpell(playerId, magicType)
  print "getStartedBonusSpell"
  
  local bonusSpellLevel = magicType == TYPE_MAGICS.WARCRIES and 1 or random(2) + 1;
  local randomSpell = getRandomSpell(magicType, bonusSpellLevel);

  return randomSpell;
end;

-- ��������� �������������� ������� ���������� ��� �������� ���������� ��� ����������� ������� �����
function generateAcademyAdditionalSpells(playerId, spellSet, magicTypeList)
  print "generateAcademyAdditionalSpells"

  -- �������� ���� ��������� �����, �������� �� ��������
  local thirdMagicType = getRandomNotBasicMagicType(magicTypeList);

  -- ���������� ������ ������� ���������� 1-5 ������� ��� ���� �����
  for levelSpell = 1, 5 do
    spellSet[length(spellSet) + 1] = getRandomUniqueSpellByMagicType(playerId, spellSet, thirdMagicType, levelSpell);
  end;
end;

-- ��������� �������������� ������� ���������� ��� ���� �����
function generateDungeonAdditionalSpells(playerId, spellSet)
    print "generateDungeonAdditionalSpells"

    -- ���������� ���������� 1, 2 � 3 ������
    for levelSpell = 1, 3 do
        local randomSpellCurrentLevel, countIdentityGeneratedSpell;

        repeat
            local randomMagicType = random(4);
            randomSpellCurrentLevel = getRandomSpell(randomMagicType, levelSpell);
            countIdentityGeneratedSpell = getCountIdentityGeneratedSpells(playerId, spellSet, randomSpellCurrentLevel.id);
        until countIdentityGeneratedSpell == 0;

        -- ���������� ���������� � ������ ���������� �����
        spellSet[length(spellSet) + 1] = randomSpellCurrentLevel;
    end;
end;

-- ��������� ��� ��� ������
function generateFortressRunes(playerId)
  print "generateFortressRunes"
  
  local runes = PLAYERS_GENERATED_SPELLS[playerId].runes;

  for indexRuneSet = 1, length(runes) do
    local runeSet = runes[indexRuneSet];
    
    for runeLevel = 1, 5 do
      runeSet[length(runeSet) + 1] = getRandomSpell(TYPE_MAGICS.RUNES, runeLevel);
    end;
  end;
end;

-- ��������� �������� ���������� ����������, ���� ��������� ����� - ����
function generateStartedBonusSpells(playerId, magicTypeList)
  print "generateStartedBonusSpells"
  
  local startedBonus = getCalculatedStartedBonus(playerId);
  
  if startedBonus == STARTED_BONUSES.SPELL then
    local bonus_spells = PLAYERS_GENERATED_SPELLS[playerId].bonus_spells;

    -- ��������� ��������������� ���������� ������ �������� �����
    for _, magicType in magicTypeList do
      local test = getStartedBonusSpell(playerId, magicType);
    
      bonus_spells[length(bonus_spells) + 1] = test;
    end;
    
    -- ������ ��������� ������ ������
    setHeroesStartedBonusSpells(playerId)
  end;
end;

-- ������ ������ ������ ��������� �������� ����������
function setHeroesStartedBonusSpells(playerId)
  print "setHeroesStartedBonusSpells"
  
  local heroes = RESULT_HERO_LIST[playerId].heroes;
  local bonus_spells = PLAYERS_GENERATED_SPELLS[playerId].bonus_spells;

  for _, heroName in heroes do
    local reservedHeroName = getReservedHeroName(playerId, heroName);
    
    for indexSpell = 1, length(bonus_spells) do
      local bonusSpell = bonus_spells[indexSpell];

      TeachHeroSpell(reservedHeroName, bonusSpell.id);
    end;
  end;
end;

-- ��������� ���������� �� ���� ����� �����
function generateSpellByMagicType(playerId, raceId, magicTypeList)
  print "generateSpellByMagicType"
  
  local spells = PLAYERS_GENERATED_SPELLS[playerId].spells;
  
  -- ���������� 1� ����� �����������
    local spellSet = spells[1];

    -- ��������� ���������� �������� ����
    for _, magicType in magicTypeList do
      -- ��������� �������� ������� ����������
      for spellLevel = 1, 5 do
        if raceId == RACES.STRONGHOLD and spellLevel > 3 then
          break;
        end;

        spellSet[length(spellSet) + 1] = getRandomUniqueSpellByMagicType(playerId, spellSet, magicType, spellLevel);
      end;
    end;
    
    -- ��������� ��� ������ ��� ���������� ������ �����
    if raceId ~= RACES.STRONGHOLD and raceId ~= RACES.ACADEMY then
      -- ��������� �������������� ���������� � 1 �� 3 ������� �� �������� ���� �����
      for spellLevel = 1, 3 do
        local randomNotBasicMagicType = getRandomNotBasicMagicType(magicTypeList);

        spellSet[length(spellSet) + 1] = getRandomUniqueSpellByMagicType(playerId, spellSet, randomNotBasicMagicType, spellLevel);
      end;

    end;
    
    -- ��������� �������������� ������� ��������� ���������� ��� �������� ����������
    if raceId == RACES.ACADEMY then
      generateAcademyAdditionalSpells(playerId, spellSet, magicTypeList);
    end;
    
    -- ��������� �������������� ������� ��������� ���������� ��� ���� �����
    if raceId == RACES.DUNGEON then
      generateDungeonAdditionalSpells(playerId, spellSet);
    end;

  
  -- ��������� ��� ��� ������
  if raceId == RACES.FORTRESS then
    generateFortressRunes(playerId);
  end;
  
  -- ���������� 2� ����� ����������
  local spellSet2 = spells[2];
  
  -- �������� ���������� spells[1] � spellSet2
  for index, item in spells[1] do
      spellSet2[index] = item
  end

  -- ��� �������
  if raceId == RACES.STRONGHOLD then
    local indexesBarbarianList = {1, 2, 3}
    local resultBarbarianRandomList = getRandomElements(indexesBarbarianList, 2);

    -- ���������� ���� � �������� �������� ��� �������� �� resultRandomList
    for i = 1, length(resultBarbarianRandomList) do
        local item = resultBarbarianRandomList[i]
        if item ~= nil then

            local spellLevel = getSpellLevelBySpellId(spells[1][item].id)
            local magicTypeId = getMagicTypeIdBySpellId(spells[1][item].id);
            local newSpell = getRandomAvailableSpellByMagicType(playerId, spellSet2, magicTypeId, spellLevel)

            if newSpell then

              spellSet2[item] = newSpell
            end
        end
    end
  end;

  if raceId ~= RACES.STRONGHOLD then
  -- ��� �������� ������ �����
    --  local indexesList = {3, 4, 5, 8, 9, 10}
    local indexesList = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    local resultRandomList = getRandomElements(indexesList, 6);

    -- ���������� ���� � �������� �������� ��� �������� �� resultRandomList
    for i = 1, length(resultRandomList) do
        local item = resultRandomList[i]
        if item ~= nil then

            local spellLevel = getSpellLevelBySpellId(spells[1][item].id)
            local magicTypeId = getMagicTypeIdBySpellId(spells[1][item].id);
            local newSpell = getRandomAvailableSpellByMagicType(playerId, spellSet2, magicTypeId, spellLevel)

            if newSpell then

              spellSet2[item] = newSpell
            end
        end
    end

-- ��� �������������� ����� (����� ��������)
    if raceId ~= RACES.ACADEMY then
      local additionalIndexesList = {11, 12, 13}
      local additionalResultRandomList = getRandomElements(additionalIndexesList, 2);
      for i = 1, length(additionalResultRandomList) do
        local item = additionalResultRandomList[i]
        if item ~= nil then
          local spellLevel = getSpellLevelBySpellId(spells[1][item].id)
          local magicTypeId = getRandomNotBasicMagicType(magicTypeList);
          local newSpell = getRandomAvailableSpellByMagicType(playerId, spellSet2, magicTypeId, spellLevel)
          if newSpell then
            spellSet2[item] = newSpell
          end
        end
      end
    end
  end
  
-- ��������� �������������� ������� ��������� ���������� ��� �������� ����������
if raceId == RACES.ACADEMY then
  local additionalAcademyIndexesList = {11, 12, 13, 14, 15} -- ������� ������� �������
  local additionalAcademyResultRandomList = getRandomElements(additionalAcademyIndexesList, 3);

  -- ���������� ���� � �������� �������� ��� �������� �� additionalResultRandomList
  for i = 1, length(additionalAcademyResultRandomList) do
    local item = additionalAcademyResultRandomList[i]
    if item ~= nil then
      local spellLevel = getSpellLevelBySpellId(spells[1][item].id)
      local magicTypeId = getMagicTypeIdBySpellId(spells[1][item].id); -- ��������� ����� ������� �������
      local newSpell = getRandomAvailableSpellByMagicType(playerId, spellSet2, magicTypeId, spellLevel)
      if newSpell then
        spellSet2[item] = newSpell
      end
    end
  end
end;
  
  -- ��������� �������������� ������� ��������� ���������� ��� ���� �����
  if raceId == RACES.DUNGEON then
      local additionalDungeonIndexesList = {14, 15, 16}
      local additionalDungeonResultRandomList = getRandomElements(additionalDungeonIndexesList, 2);

      for i = 1, length(additionalDungeonResultRandomList) do
          local item = additionalDungeonResultRandomList[i]
          if item ~= nil then
            local spellLevel = getSpellLevelBySpellId(spells[1][item].id)
            local magicTypeId = getRandomNotBasicMagicType(magicTypeList);
            local newSpell = getRandomAvailableSpellByMagicType(playerId, spellSet2, magicTypeId, spellLevel)
              if newSpell then
                spellSet2[item] = newSpell
              end
          end
      end
  end;
  
    -- ��������� ��� ��� ������
  if raceId == RACES.FORTRESS then
      local runes = PLAYERS_GENERATED_SPELLS[playerId].runes;
      -- ���������� 2� ����� ����������
      local runesSet2 = runes[2];

      -- �������� ���������� spells[1] � spellSet2
      for index, item in runes[1] do
          runesSet2[index] = item
      end
    
      local additionalRunesIndexesList = {1, 2, 3, 4, 5}
      local additionalRunesResultRandomList = getRandomElements(additionalRunesIndexesList, 3);

      -- ���������� ���� � �������� �������� ��� �������� �� additionalResultRandomList
      for i = 1, length(additionalRunesResultRandomList) do
          local item = additionalRunesResultRandomList[i]
          if item ~= nil then
            local spellLevel = getSpellLevelBySpellId(runes[1][item].id)
            local magicTypeId = TYPE_MAGICS.RUNES
            local newSpell = getRandomAvailableSpellByMagicType(playerId, runesSet2, magicTypeId, spellLevel)
              if newSpell then

                runesSet2[item] = newSpell
              end
          end
      end
    
  end;

  -- ����������� ��������������� ���������� �� �����
  showPlayerAllSpellsOnMap(playerId, raceId)

end;

-- ��������� ���� ��������� ����������� ������
function getRandomElements(indexesList, count)
print "getRandomElements"
    local resultRandomList = {}
    local remainingIndexes = {} -- ����� ��������� ������

    -- ������� ����� ��������� ������
    for i = 1, length(indexesList) do
        remainingIndexes[i] = indexesList[i]
    end

    for curRandom = 1, count do
        if length(remainingIndexes) == 0 then
            break -- ���� �� �������� ���������, ��������� ����
        end

        -- ���������� ��������� ������ �� ���������� ���������
        local randomIndex = random(length(remainingIndexes)) + 1

        -- ��������� ��������� ������� � �������������� ������
        resultRandomList[curRandom] = remainingIndexes[randomIndex]

        -- ������� ��������� ������� �� ���������� ���������
        
        local newIndexesList = {}
        for i = 1, length(remainingIndexes) do
          if i ~= randomIndex then
            newIndexesList[length(newIndexesList) + 1] = remainingIndexes[i]
          end
        end
        remainingIndexes = newIndexesList
    end

    return resultRandomList
end


-- ����������� ���������� ���������� �� �����
function showSpellListIconsOnMap(playerId, spells, placeSpells)
  print "showSpellListIconsOnMap"
  
  for spellIndex = 1, length(spells) do
    local spellData = spells[spellIndex];
    local spellName = MAPPING_SPELLS_ON_ICONS[spellData.id].text;
    local spellIcon = MAPPING_SPELLS_ON_ICONS[spellData.id].icons[playerId];
    local spellPlace = placeSpells[spellIndex];

    SetObjectPosition(spellIcon, spellPlace.x, spellPlace.y, GROUND);

    -- ��������� ����������� �������������� � ���������
    SetObjectEnabled(spellIcon, nil);

    -- ������ �������� ��������� ����������
    OverrideObjectTooltipNameAndDescription(spellIcon, PATH_TO_SPELLS_NAMES..spellName, GetMapDataPath().."notext.txt");
  end;
end;

-- ����������� ������ ������ ����������/������ � ������
function showPlayerSpellList(playerId, raceId)
  print "showPlayerSpellList"

  local spells = getCurrentPlayerSpellSet(playerId);
  local placeSpells;

  if raceId == RACES.STRONGHOLD then
    placeSpells = PLACE_GENERATED_SPELLS[playerId].WARCRIES -- ���������� ����� ��� ����
  elseif raceId == RACES.ACADEMY then
    placeSpells = PLACE_GENERATED_SPELLS[playerId].ACADEMY_SPELLS -- ���������� ����� ����� ��� ��������
  else
    placeSpells = PLACE_GENERATED_SPELLS[playerId].SPELLS -- ���������� ����� ����� ��� ����
  end;

  showSpellListIconsOnMap(playerId, spells, placeSpells);
end;

-- ����������� ������ ������ ��� � ������
function showPlayerRunesList(playerId)
  print "showPlayerRunesList"

  local runes = getCurrentPlayerRuneSet(playerId);
  local placeRunes = PLACE_GENERATED_SPELLS[playerId].RUNES;

  showSpellListIconsOnMap(playerId, runes, placeRunes);
end;

-- ����������� ��������������� ���������� �� �����
function showPlayerAllSpellsOnMap(playerId, raceId)
  print "showPlayerAllSpellsOnMap"

  -- ���������� ����� ������/������
  showPlayerSpellList(playerId, raceId);
  
  -- ����� ���������� ����
  if raceId == RACES.FORTRESS then
    showPlayerRunesList(playerId);
  end;
end;

-- ��������� �������� ������ ���������� ������
function getCurrentPlayerSpellSet(playerId)
  print "getCurrentPlayerSpellSet"
  
  local countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells;
  local tier_spells_reroll = PLAYERS_GENERATED_SPELLS[playerId].tier_spells_reroll;
  local indexSpellList = mod(countResetSpells, 2) + 1
  return PLAYERS_GENERATED_SPELLS[playerId].spells[indexSpellList];
end;

-- ��������� �������� ������ ��� ������
function getCurrentPlayerRuneSet(playerId)
  print "getCurrentPlayerRuneSet"
  
  local countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes;
  local indexSpellList = mod(countResetRunes, 2) + 1
  
  return PLAYERS_GENERATED_SPELLS[playerId].runes[indexSpellList];
end;

-- ���������� �������� ������� ��� ������������� ������ ����������
function addResetSpellsObject(playerId)
  print "addResetSpellsObject"
  
  local SPELL_RESET_OBJECTS = {
    [PLAYER_1] = { name = "spell_nabor1", x = 35, y = 86 },
    [PLAYER_2] = { name = "spell_nabor2", x = 42, y = 23 },
  }
  
  local object = SPELL_RESET_OBJECTS[playerId];

  SetObjectPosition(object.name, object.x, object.y, GROUND);
  SetObjectEnabled (object.name, nil);
  Trigger(OBJECT_TOUCH_TRIGGER, object.name, 'questionSpellReset');
  OverrideObjectTooltipNameAndDescription (
    object.name,
    PATH_TO_SPELLS_GENERATE_MESSAGES.."altar_of_spells.txt",
    PATH_TO_SPELLS_GENERATE_MESSAGES.."altar_of_spells_description.txt"
  );
end;

-- ������ ������ �� ����� ������ ����������
function questionSpellReset(triggerHero)
  print "questionSpellReset"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells;
  local countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes;
  local spellResetCost = raceId == RACES.STRONGHOLD and 5000 or 6000;

  if game_modes_core.current_mode == GAME_MODE_ASTROLOGY and astrology_core.current_week == ASTROLOGY_WEEK_ARHYDEVI then
    spellResetCost = 0
  end
  
  if raceId == RACES.FORTRESS then
    if countResetSpells == 0 then
      QuestionBoxForPlayers(
        playerId,
        {PATH_TO_SPELLS_GENERATE_MESSAGES.."question_change_spells.txt"; eq = spellResetCost},
        'toogleSpellList("'..playerId..'")',
        'questionRunesReset("'..playerId..'")'
      );
      return nil
      
    end;
    
    QuestionBoxForPlayers(
      playerId,
      PATH_TO_SPELLS_GENERATE_MESSAGES.."question_get_prev_spells.txt",
      'toogleSpellList("'..playerId..'")',
      'questionRunesReset("'..playerId..'")'
    );
    return nil
  
  end;

  if countResetSpells == 0 then
    QuestionBoxForPlayers(
      playerId,
      {PATH_TO_SPELLS_GENERATE_MESSAGES.."question_change_spells.txt"; eq = spellResetCost},
         'toogleSpellList("'..playerId..'")',
      noop
    );
  
  else
    toogleSpellList(playerId)
  end;

  
end;
    
-- ������ �� ����� ���������� �������� ������
function questionSpellLevelReset(strPlayerId, strSpellLevel)
  print "questionSpellLevelReset"

  local playerId = strPlayerId + 0;
  local spellLevel = strSpellLevel + 0;
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local maxSpellLevel = raceId == RACES.STRONGHOLD and 3 or 5;
  local spellResetCost = raceId == RACES.STRONGHOLD and MAPPPING_PRICE_RESET_LEVEL_WARCRIES[spellLevel] or MAPPPING_PRICE_RESET_LEVEL[spellLevel];

  if spellLevel > maxSpellLevel then
    return nil;
  end
  
  local hasChaos = MAPPPING_RACE_TO_MAGIC[raceId][1] == TYPE_MAGICS.DESTRUCTIVE or MAPPPING_RACE_TO_MAGIC[raceId][2] == TYPE_MAGICS.DESTRUCTIVE

  QuestionBoxForPlayers(
    playerId,
    {PATH_TO_SPELLS_GENERATE_MESSAGES.."question_spell_regenerate.txt"; lvl = spellLevel, eq = spellResetCost},
    hasChaos and spellLevel == 5 and 'checkChaosMaxTierSpell("'..playerId..'")' or 'regenerateSpellLevel("'..playerId..'", "'..spellLevel..'")',
    'questionSpellLevelReset("'..playerId..'", "'..(spellLevel + 1)..'")'
  );
end;

--������ �� ����� ���������� ����� 5 ������
function questionSpellResetChaosMaxTierSpell(strPlayerId, notHasMaxTierChaosSpellList)
  print "questionSpellResetChaosMaxTierSpell"
  
  local playerId = strPlayerId + 0;

  chaosNameSpells = {
  [SPELL_ARMAGEDDON] = PATH_TO_SPELLS_GENERATE_MESSAGES.."ARMAGEDDON.txt",
  [SPELL_IMPLOSION] = PATH_TO_SPELLS_GENERATE_MESSAGES.."IMPLOSION.txt",
  [SPELL_DEEP_FREEZE] = PATH_TO_SPELLS_GENERATE_MESSAGES.."DEEP_FREEZE.txt",
 }
 
  QuestionBoxForPlayers(
    playerId,
    {PATH_TO_SPELLS_GENERATE_MESSAGES.."question_chaos_spell_regenerate.txt"; chaos0 = chaosNameSpells[notHasMaxTierChaosSpellList[0]], chaos1 = chaosNameSpells[notHasMaxTierChaosSpellList[1]]},
    'regenerateSpellLevel("'..playerId..'", "5", "'..notHasMaxTierChaosSpellList[0]..'")',
    'regenerateSpellLevel("'..playerId..'", "5", "'..notHasMaxTierChaosSpellList[1]..'")'
  );

end;

--�������� ��� 5 ���������� ����� - ����� ���� � ������
function checkChaosMaxTierSpell(strPlayerId)
  print "checkChaosMaxTierSpell"
  local playerId = strPlayerId + 0;
  local maxTierChaosSpellList = {};
  for _,spellData in SPELLS[TYPE_MAGICS.DESTRUCTIVE] do
    if spellData.level == 5 then
      maxTierChaosSpellList[length(maxTierChaosSpellList)] = spellData.id
    end;
  end;
  
  local allPlayerSpells = PLAYERS_GENERATED_SPELLS[playerId].spells[1];
  local hasChaosSpellMaxTier = nil

  for _,spellData in allPlayerSpells do
    local magicTypeId = getMagicTypeIdBySpellId(spellData.id);
    if spellData.level == 5 and magicTypeId == TYPE_MAGICS.DESTRUCTIVE then
      hasChaosSpellMaxTier = spellData.id
    end;
  end;
  
  local notHasMaxTierChaosSpellList = {};
  for _,spellId in maxTierChaosSpellList do
    if spellId ~= hasChaosSpellMaxTier then
      notHasMaxTierChaosSpellList[length(notHasMaxTierChaosSpellList)] = spellId
    end;
  end;
  questionSpellResetChaosMaxTierSpell(playerId, notHasMaxTierChaosSpellList)
end;

-- ������ ��������������� ����� ����������
function toogleSpellList(strPlayerId)
  print "toogleSpellList"

  local playerId = strPlayerId + 0;
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local spellResetCost = raceId == RACES.STRONGHOLD and 5000 or 6000;
  local countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells;
  local playerGold = GetPlayerResource(playerId, GOLD);
  
  if game_modes_core.current_mode == GAME_MODE_ASTROLOGY and astrology_core.current_week == ASTROLOGY_WEEK_ARHYDEVI then
    spellResetCost = 0
  end

  if countResetSpells == 0 then
    if spellResetCost > playerGold then
      MessageBoxForPlayers(playerId, {PATH_TO_SPELLS_GENERATE_MESSAGES.."no_money.txt"; eq = spellResetCost - playerGold});
      return nil;
    else
      SetPlayerResource(playerId, GOLD, (playerGold - spellResetCost));
    end;
  end;
  
  -- �������� ������� ����� ����������
  local spellSet = getCurrentPlayerSpellSet(playerId);
  hideCurrentSpellOrRunesSet(playerId, spellSet);

  PLAYERS_GENERATED_SPELLS[playerId].countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells + 1;

  -- ���������� ����� �����
  showPlayerSpellList(playerId, raceId);
end;

--������������� ���������� ������������� ������ (�-�� ��������, �������������� ��� ���������� ������� �������)
function regenerateSpellLevel(strPlayerId, strSpellLevel, strSpellId)
  print "regenerateSpellLevel"

  local playerId = strPlayerId + 0;
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local spellLevel = strSpellLevel + 0;
  local playerGold = GetPlayerResource(playerId, GOLD);
  local countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells;
  local spellResetCost = raceId == RACES.STRONGHOLD and MAPPPING_PRICE_RESET_LEVEL_WARCRIES[spellLevel] or MAPPPING_PRICE_RESET_LEVEL[spellLevel];
  local spellId = strSpellId ~= nil and strSpellId + 0 or nil
  
  -- �������������� ����� ���������� ������ ���� ���
  if countResetSpells == 0 then
    if spellResetCost > playerGold then
      MessageBoxForPlayers(playerId, {PATH_TO_SPELLS_GENERATE_MESSAGES.."no_money.txt"; eq = spellResetCost - playerGold});
      return nil;
    else
      SetPlayerResource(playerId, GOLD, (playerGold - spellResetCost));
    end;
  end;

  -- �������� ������� ����� ����������
  local spellSet = getCurrentPlayerSpellSet(playerId);
  hideCurrentSpellOrRunesSet(playerId, spellSet);

  PLAYERS_GENERATED_SPELLS[playerId].countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells + 1;
  changeGeneratedSpells(playerId, spellLevel, spellId)

  -- ���������� ����� �����
  showPlayerSpellList(playerId, raceId);
end;

-- ���������� ������ ���������� � ������ ������ ������ (�-�� ��������, �������������� ��� ���������� ������� �������)
function changeGeneratedSpells(playerId, spellLevel, spellId)
  print "changeGeneratedSpells"

  local countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells;
  for indexSpell, spell in PLAYERS_GENERATED_SPELLS[playerId].spells[1] do
    if countResetSpells > 0 and spell.level == spellLevel and indexSpell < 11 then
      local magicTypeId = getMagicTypeIdBySpellId(spell.id);
      if spellId ~= nil and TYPE_MAGICS.DESTRUCTIVE == magicTypeId and spell.level == 5 then
        PLAYERS_GENERATED_SPELLS[playerId].spells[1][indexSpell] = {level = 5, id = spellId}
      elseif not (TYPE_MAGICS.LIGHT == magicTypeId and spell.level == 5) then
        local newSpell = getRandomAvailableSpellByMagicType(playerId, PLAYERS_GENERATED_SPELLS[playerId].spells[1], magicTypeId, spellLevel);
        
        if newSpell then
          PLAYERS_GENERATED_SPELLS[playerId].spells[1][indexSpell] = newSpell;
        end;
      end;
    end;
  end;
end;


-- ��������� ���������� ���� �� ������ � ����� �� �������������� ����������
function getRandomSpellSameLevel(playerId, spellId, spellSet)
  print "getRandomSpellSameLevel"
  

  local magicTypeId = getMagicTypeIdBySpellId(spellId);
  local spellLevel = getSpellLevelBySpellId(spellId);
  local newSpell = getRandomAvailableSpellByMagicType(playerId, spellSet, magicTypeId, spellLevel);

  if newSpell then

    return newSpell
  end;

end;


-- ������ �� ����� ������ ���
function questionRunesReset(strPlayerId)
  print "questionRunesReset"

  local playerId = strPlayerId + 0;
  local countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes;
  local countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells;
    
  if countResetRunes > 0 then
    toogleRuneList(playerId)
    return nil;
  end;

  local message = "question_change_runes.txt"
  if game_modes_core.current_mode == GAME_MODE_ASTROLOGY and astrology_core.current_week == ASTROLOGY_WEEK_ARHYDEVI then
    message = "question_change_runes_arhydevi.txt"
  end
  if PLAYERS_MAIN_HERO_PROPS[playerId] then
      local hero = PLAYERS_MAIN_HERO_PROPS[playerId].name
      if hero and HasHeroSkill(hero, HERO_SKILL_REFRESH_RUNE) then
        message = "change_rune_with_refresh.txt"
      end
  end

  QuestionBoxForPlayers(
    playerId,
    PATH_TO_SPELLS_GENERATE_MESSAGES..message,
    'toogleRuneList("'..playerId..'")',
    'noop'
  );
end;

-- ������ �� ����� ���
function questionRuneLevelReset(strPlayerId, strSpellLevel)
  print "questionRuneLevelReset"

  local playerId = strPlayerId + 0;
  local spellLevel = strSpellLevel + 0;
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local maxSpellLevel = 5;
  local spellResetCost = MAPPPING_PRICE_RESET_LEVEL_RUNES[spellLevel];

  if spellLevel > maxSpellLevel then
    return nil;
  end

  QuestionBoxForPlayers(
    playerId,
    {PATH_TO_SPELLS_GENERATE_MESSAGES.."question_rune_regenerate.txt"; lvl = spellLevel, eq = spellResetCost},
    'changeRunesForPlayer("'..playerId..'", "'..spellLevel..'")',
    'questionRuneLevelReset("'..playerId..'", "'..(spellLevel + 1)..'")'
  );
end;

-- ���������� ������ ���������� � ������ ������ ������
function changeGeneratedRunes(playerId, spellLevel)
  print "changeGeneratedRunes"

 local countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes;
  for indexSpell, spell in PLAYERS_GENERATED_SPELLS[playerId].runes[1] do
    if countResetRunes > 0 and spell.level == spellLevel and indexSpell < 6 then
        PLAYERS_GENERATED_SPELLS[playerId].runes[1][indexSpell] = getRandomUniqueSpellByMagicType(playerId, PLAYERS_GENERATED_SPELLS[playerId].runes[1], TYPE_MAGICS.RUNES, spellLevel)
    end;
  end;

end;

--������������� ���� ���
function toogleRuneList(strPlayerId)
  print "toogleRuneList"
  local playerId = strPlayerId + 0;
  local playerGold = GetPlayerResource(playerId, GOLD);
  local spellResetCost = 5000
  if PLAYERS_MAIN_HERO_PROPS[playerId] then
    local hero = PLAYERS_MAIN_HERO_PROPS[playerId].name
    if hero and HasHeroSkill(hero, HERO_SKILL_REFRESH_RUNE) then
      spellResetCost = 0
    end
  end

  if game_modes_core.current_mode == GAME_MODE_ASTROLOGY and astrology_core.current_week == ASTROLOGY_WEEK_ARHYDEVI then
    spellResetCost = 0
  end
  
  local countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes;

  -- �������������� ����� ���������� ������ ���� ���
  if countResetRunes == 0 then
    if spellResetCost > playerGold then
      MessageBoxForPlayers(playerId, {PATH_TO_SPELLS_GENERATE_MESSAGES.."no_money.txt"; eq = spellResetCost - playerGold});
      return nil;
    else
      SetPlayerResource(playerId, GOLD, (playerGold - spellResetCost));
    end;
  end;

  -- �������� ������� ����� ���
  local runeSet = getCurrentPlayerRuneSet(playerId);
  hideCurrentSpellOrRunesSet(playerId, runeSet);

  PLAYERS_GENERATED_SPELLS[playerId].countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes + 1;

  PLAYERS_USE_REFRESH_RUNE_STATUS[playerId] = not nil;
  -- ���������� ����� �����
  showPlayerRunesList(playerId);

end;

--������������� ���������� ������������� ������
function changeRunesForPlayer(strPlayerId, strSpellLevel)
  print "changeRunesForPlayer"

  local playerId = strPlayerId + 0;
  local spellLevel = strSpellLevel + 0;
  local playerGold = GetPlayerResource(playerId, GOLD);
  local countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes;
  local spellResetCost = MAPPPING_PRICE_RESET_LEVEL_RUNES[spellLevel];

  -- �������������� ����� ���������� ������ ���� ���
  if countResetRunes == 0 then
    if spellResetCost > playerGold then
      MessageBoxForPlayers(playerId, {PATH_TO_SPELLS_GENERATE_MESSAGES.."no_money.txt"; eq = spellResetCost - playerGold});
      return nil;
    else
      SetPlayerResource(playerId, GOLD, (playerGold - spellResetCost));
    end;
  end;

  -- �������� ������� ����� ���
  local runeSet = getCurrentPlayerRuneSet(playerId);
  hideCurrentSpellOrRunesSet(playerId, runeSet);

  PLAYERS_GENERATED_SPELLS[playerId].countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes + 1;
  changeGeneratedRunes(playerId, spellLevel)

  -- ���������� ����� �����
  showPlayerRunesList(playerId);

end;

-- ������� �� ���� �������� ������ ���������� ��� ���
function hideCurrentSpellOrRunesSet(playerId, spellSet)
  print "hideCurrentSpellOrRunesSet"
  
  for indexSpell = 1, length(spellSet) do
    local spell = spellSet[indexSpell];
    local spellIcon = MAPPING_SPELLS_ON_ICONS[spell.id].icons[playerId];
    
    -- �� ����� ���������� ��� �������� � 1,1
    SetObjectPosition(spellIcon, 1, 1, UNDERGROUND);
  end;
end;




-- ����� �����
generateRandomSpellSet();
