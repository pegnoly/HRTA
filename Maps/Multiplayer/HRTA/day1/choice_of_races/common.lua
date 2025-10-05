-- Файл, описывающий общий функционал между черками рас

-- Выключение взаимодействия игроков с окружением
function disableAreaInteractive()
  print "disableAreaInteractive"

  SetObjectEnabled('red1', nil);  SetDisabledObjectMode('red1', DISABLED_BLOCKED);
  SetObjectEnabled('red2', nil);  SetDisabledObjectMode('red2', DISABLED_BLOCKED);
  SetObjectEnabled('red3', nil);  SetDisabledObjectMode('red3', DISABLED_BLOCKED);
  SetObjectEnabled('red4', nil);  SetDisabledObjectMode('red4', DISABLED_BLOCKED);
  SetObjectEnabled('red5', nil);  SetDisabledObjectMode('red5', DISABLED_BLOCKED);
  SetObjectEnabled('red6', nil);  SetDisabledObjectMode('red6', DISABLED_BLOCKED);
  SetObjectEnabled('red7', nil);  SetDisabledObjectMode('red7', DISABLED_BLOCKED);
  SetObjectEnabled('red8', nil);  SetDisabledObjectMode('red8', DISABLED_BLOCKED);
  SetObjectEnabled('red9', nil);  SetDisabledObjectMode('red9', DISABLED_BLOCKED);
  SetObjectEnabled('red10', nil); SetDisabledObjectMode('red10', DISABLED_BLOCKED);
  SetObjectEnabled('red12', nil); SetDisabledObjectMode('red12', DISABLED_BLOCKED);
  SetObjectEnabled('red13', nil); SetDisabledObjectMode('red13', DISABLED_BLOCKED);
  SetObjectEnabled('red14', nil); SetDisabledObjectMode('red14', DISABLED_BLOCKED);
  SetObjectEnabled('red15', nil); SetDisabledObjectMode('red15', DISABLED_BLOCKED);
  SetObjectEnabled('red16', nil); SetDisabledObjectMode('red16', DISABLED_BLOCKED);
  SetObjectEnabled('red17', nil); SetDisabledObjectMode('red17', DISABLED_BLOCKED);
  SetObjectEnabled('red18', nil); SetDisabledObjectMode('red18', DISABLED_BLOCKED);
  SetObjectEnabled('red19', nil); SetDisabledObjectMode('red19', DISABLED_BLOCKED);
  SetObjectEnabled('red20', nil); SetDisabledObjectMode('red20', DISABLED_BLOCKED);

  SetObjectEnabled('blue1', nil);  SetDisabledObjectMode('blue1', DISABLED_BLOCKED);
  SetObjectEnabled('blue2', nil);  SetDisabledObjectMode('blue2', DISABLED_BLOCKED);
  SetObjectEnabled('blue3', nil);  SetDisabledObjectMode('blue3', DISABLED_BLOCKED);
  SetObjectEnabled('blue4', nil);  SetDisabledObjectMode('blue4', DISABLED_BLOCKED);
  SetObjectEnabled('blue5', nil);  SetDisabledObjectMode('blue5', DISABLED_BLOCKED);
  SetObjectEnabled('blue6', nil);  SetDisabledObjectMode('blue6', DISABLED_BLOCKED);
  SetObjectEnabled('blue7', nil);  SetDisabledObjectMode('blue7', DISABLED_BLOCKED);
  SetObjectEnabled('blue8', nil);  SetDisabledObjectMode('blue8', DISABLED_BLOCKED);
  SetObjectEnabled('blue9', nil);  SetDisabledObjectMode('blue9', DISABLED_BLOCKED);
  SetObjectEnabled('blue10', nil); SetDisabledObjectMode('blue10', DISABLED_BLOCKED);
  SetObjectEnabled('blue11', nil); SetDisabledObjectMode('blue11', DISABLED_BLOCKED);
  SetObjectEnabled('blue12', nil); SetDisabledObjectMode('blue12', DISABLED_BLOCKED);
  SetObjectEnabled('blue13', nil); SetDisabledObjectMode('blue13', DISABLED_BLOCKED);
  SetObjectEnabled('blue14', nil); SetDisabledObjectMode('blue14', DISABLED_BLOCKED);
  SetObjectEnabled('blue15', nil); SetDisabledObjectMode('blue15', DISABLED_BLOCKED);
  SetObjectEnabled('blue16', nil); SetDisabledObjectMode('blue16', DISABLED_BLOCKED);
  SetObjectEnabled('blue17', nil); SetDisabledObjectMode('blue17', DISABLED_BLOCKED);
  SetObjectEnabled('blue18', nil); SetDisabledObjectMode('blue18', DISABLED_BLOCKED);
  SetObjectEnabled('blue19', nil); SetDisabledObjectMode('blue19', DISABLED_BLOCKED);
  SetObjectEnabled('blue20', nil); SetDisabledObjectMode('blue20', DISABLED_BLOCKED);

  SetObjectEnabled('human1', nil); SetDisabledObjectMode('human1', DISABLED_BLOCKED);
  SetObjectEnabled('human2', nil); SetDisabledObjectMode('human2', DISABLED_BLOCKED);
  SetObjectEnabled('demon1', nil); SetDisabledObjectMode('demon1', DISABLED_BLOCKED);
  SetObjectEnabled('demon2', nil); SetDisabledObjectMode('demon2', DISABLED_BLOCKED);
  SetObjectEnabled('nekr1', nil);  SetDisabledObjectMode('nekr1', DISABLED_BLOCKED);
  SetObjectEnabled('nekr2', nil);  SetDisabledObjectMode('nekr2', DISABLED_BLOCKED);
  SetObjectEnabled('elf1', nil);   SetDisabledObjectMode('elf1', DISABLED_BLOCKED);
  SetObjectEnabled('elf2', nil);   SetDisabledObjectMode('elf2', DISABLED_BLOCKED);
  SetObjectEnabled('mag1', nil);   SetDisabledObjectMode('mag1', DISABLED_BLOCKED);
  SetObjectEnabled('mag2', nil);   SetDisabledObjectMode('mag2', DISABLED_BLOCKED);
  SetObjectEnabled('liga1', nil);  SetDisabledObjectMode('liga1', DISABLED_BLOCKED);
  SetObjectEnabled('liga2', nil);  SetDisabledObjectMode('liga2', DISABLED_BLOCKED);
  SetObjectEnabled('gnom1', nil);  SetDisabledObjectMode('gnom1', DISABLED_BLOCKED);
  SetObjectEnabled('gnom2', nil);  SetDisabledObjectMode('gnom2', DISABLED_BLOCKED);
  SetObjectEnabled('ork1', nil);   SetDisabledObjectMode('ork1', DISABLED_BLOCKED);
  SetObjectEnabled('ork2', nil);   SetDisabledObjectMode('ork2', DISABLED_BLOCKED);

  SetObjectEnabled('human1vrag', nil); SetDisabledObjectMode('human1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('human2vrag', nil); SetDisabledObjectMode('human2vrag', DISABLED_BLOCKED);
  SetObjectEnabled('demon1vrag', nil); SetDisabledObjectMode('demon1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('demon2vrag', nil); SetDisabledObjectMode('demon2vrag', DISABLED_BLOCKED);
  SetObjectEnabled('nekr1vrag', nil);  SetDisabledObjectMode('nekr1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('nekr2vrag', nil);  SetDisabledObjectMode('nekr2vrag', DISABLED_BLOCKED);
  SetObjectEnabled('elf1vrag', nil);   SetDisabledObjectMode('elf1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('elf2vrag', nil);   SetDisabledObjectMode('elf2vrag', DISABLED_BLOCKED);
  SetObjectEnabled('mag1vrag', nil);   SetDisabledObjectMode('mag1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('mag2vrag', nil);   SetDisabledObjectMode('mag2vrag', DISABLED_BLOCKED);
  SetObjectEnabled('liga1vrag', nil);  SetDisabledObjectMode('liga1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('liga2vrag', nil);  SetDisabledObjectMode('liga2vrag', DISABLED_BLOCKED);
  SetObjectEnabled('gnom1vrag', nil);  SetDisabledObjectMode('gnom1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('gnom2vrag', nil);  SetDisabledObjectMode('gnom2vrag', DISABLED_BLOCKED);
  SetObjectEnabled('ork1vrag', nil);   SetDisabledObjectMode('ork1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('ork2vrag', nil);   SetDisabledObjectMode('ork2vrag', DISABLED_BLOCKED);
end;

-- Удаление всех перегородок
function deleteAllDelimeters()
  print "deleteAllDelimeters"

-- Устанавливаем позицию для всех объектов red1-red20
  SetObjectPosition('red1', 1, 1);
  SetObjectPosition('red2', 1, 1);
  SetObjectPosition('red3', 1, 1);
  SetObjectPosition('red4', 1, 1);
  SetObjectPosition('red5', 1, 1);
  SetObjectPosition('red6', 1, 1);
  SetObjectPosition('red7', 1, 1);
  SetObjectPosition('red8', 1, 1);
  SetObjectPosition('red9', 1, 1);
  SetObjectPosition('red12', 1, 1);
  SetObjectPosition('red13', 1, 1);
  SetObjectPosition('red14', 1, 1);
  SetObjectPosition('red15', 1, 1);
  SetObjectPosition('red16', 1, 1);
  SetObjectPosition('red17', 1, 1);
  SetObjectPosition('red18', 1, 1);
  SetObjectPosition('red19', 1, 1);
  SetObjectPosition('red20', 1, 1);

  -- Устанавливаем позицию для всех объектов blue1-blue20
  SetObjectPosition('blue1', 1, 1);
  SetObjectPosition('blue2', 1, 1);
  SetObjectPosition('blue3', 1, 1);
  SetObjectPosition('blue4', 1, 1);
  SetObjectPosition('blue5', 1, 1);
  SetObjectPosition('blue6', 1, 1);
  SetObjectPosition('blue7', 1, 1);
  SetObjectPosition('blue8', 1, 1);
  SetObjectPosition('blue9', 1, 1);
  SetObjectPosition('blue12', 1, 1);
  SetObjectPosition('blue13', 1, 1);
  SetObjectPosition('blue14', 1, 1);
  SetObjectPosition('blue15', 1, 1);
  SetObjectPosition('blue16', 1, 1);
  SetObjectPosition('blue17', 1, 1);
  SetObjectPosition('blue18', 1, 1);
  SetObjectPosition('blue19', 1, 1);
  SetObjectPosition('blue20', 1, 1);

end;

-- Перемещение всех перегородок
function moveDelimetersToRandomChoise()
  print "moveDelimetersToRandomChoise"

  SetObjectPosition('blue19', 38, 22);
  SetObjectPosition('red19', 46, 22);

  SetObjectPosition('red20', 31, 87);
  SetObjectPosition('blue20', 39, 87);

end;


-- соотношение расы с отображаемыми при черке существами
MAPPING_RACE_TO_CREATURES = {
  -- Орден Порядка - латник и ревнитель веры
  [RACES.HAVEN] = { ID1 = CREATURE_FOOTMAN, ID2 = CREATURE_VINDICATOR },
  -- Инферно - черт и дьяволенок
  [RACES.INFERNO] = { ID1 = CREATURE_IMP, ID2 = CREATURE_QUASIT },
  -- Некрополис - вампир и князья вампиров
  [RACES.NECROPOLIS] = { ID1 = CREATURE_VAMPIRE, ID2 = CREATURE_NOSFERATU },
  -- Лесной Союз - лучник и стрелок
  [RACES.SYLVAN] = { ID1 = CREATURE_WOOD_ELF, ID2 = CREATURE_SHARP_SHOOTER },
  -- Акадения Волшебства - маг и боевой маг
  [RACES.ACADEMY] = { ID1 = CREATURE_MAGI, ID2 = CREATURE_COMBAT_MAGE },
  -- Лига Теней - бестия и фурия
  [RACES.DUNGEON] = { ID1 = CREATURE_WITCH, ID2 = CREATURE_BLOOD_WITCH_2 },
  -- Дварфы - жрец рун и служитель огня
  [RACES.FORTRESS] = { ID1 = CREATURE_RUNE_MAGE, ID2 = CREATURE_FLAME_KEEPER },
  -- Орда - палач и вожак
  [RACES.STRONGHOLD] = { ID1 = CREATURE_ORCCHIEF_BUTCHER, ID2 = CREATURE_ORCCHIEF_CHIEFTAIN },
};

-- Получение ключа случайной расы
function getRandomRace()
  print "getRandomRace"

  return random(8);
end;

-- Список всех фракций с юнитами для обоих игроков и координатами их начальной постановки для простого черка
ALL_RACES_WITH_COORDINATES = {
  { raceId = RACES.HAVEN,       question = "question_play_haven.txt",          [PLAYER_1] = { unit = 'human1', x = 31, y = 88 }, [PLAYER_2] = { unit = 'human2vrag', x = 46, y = 23 } },
  { raceId = RACES.INFERNO,     question = "question_play_inferno.txt",        [PLAYER_1] = { unit = 'demon1', x = 31, y = 86 }, [PLAYER_2] = { unit = 'demon2vrag', x = 46, y = 21 } },
  { raceId = RACES.NECROPOLIS,  question = "question_play_necropolis.txt",     [PLAYER_1] = { unit = 'nekr1',  x = 31, y = 90 }, [PLAYER_2] = { unit = 'nekr2vrag',  x = 46, y = 25 } },
  { raceId = RACES.SYLVAN,      question = "question_play_sylvan.txt",         [PLAYER_1] = { unit = 'elf1',   x = 31, y = 84 }, [PLAYER_2] = { unit = 'elf2vrag',   x = 46, y = 19 } },
  { raceId = RACES.ACADEMY,     question = "question_play_academy.txt",        [PLAYER_1] = { unit = 'mag1',   x = 38, y = 23 }, [PLAYER_2] = { unit = 'mag2vrag',   x = 39, y = 88 } },
  { raceId = RACES.DUNGEON,     question = "question_play_dungeon.txt",        [PLAYER_1] = { unit = 'liga1',  x = 38, y = 21 }, [PLAYER_2] = { unit = 'liga2vrag',  x = 39, y = 86 } },
  { raceId = RACES.FORTRESS,    question = "question_play_fortress.txt",       [PLAYER_1] = { unit = 'gnom1',  x = 38, y = 25 }, [PLAYER_2] = { unit = 'gnom2vrag',  x = 39, y = 90 } },
  { raceId = RACES.STRONGHOLD,  question = "question_play_stronghold.txt",     [PLAYER_1] = { unit = 'ork1',   x = 38, y = 19 }, [PLAYER_2] = { unit = 'ork2vrag',   x = 39, y = 84 } },
};

-- Удаление всех юнитов, для выбора рас
function deleteAllRacesUnit()
  print "deleteAllRacesUnit"

  for indexRace = 1, length(ALL_RACES_WITH_COORDINATES) do
    local currentRace = ALL_RACES_WITH_COORDINATES[indexRace];

    SetObjectPosition(currentRace[PLAYER_1].unit, 1, 1, UNDERGROUND)
    SetObjectPosition(currentRace[PLAYER_2].unit, 1, 1, UNDERGROUND)
  end;
end;
  