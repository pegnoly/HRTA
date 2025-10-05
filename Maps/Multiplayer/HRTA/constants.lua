-- Файл предназначен для хранение общеигровых фиксированных данных: например тип черка

-- ИД выбранной сложности игры
local DIFFICULTY = GetDifficulty();

-- NOTE: Почему то результат вычислений это 0 или 1, но при этом все равно корректно работает в условия
-- Маппинг сложности игры на черк
GAME_MODE = {
  -- Простой выбор (REKRUT)
  SIMPLE_CHOOSE = DIFFICULTY == DIFFICULTY_EASY,
  -- Черк матчапов (VOIN)
  MATCHUPS = DIFFICULTY == DIFFICULTY_NORMAL,
  -- Получерк (VETERAN)
  HALF = DIFFICULTY == DIFFICULTY_HARD,
  -- Микс черк (GEROI)
  MIX = DIFFICULTY == DIFFICULTY_HEROIC,
};

-- Выбран ли режим хотсит
HOTSEAT_STATUS = nil;


--Кастомные режимы игры
CUSTOM_GAME_MODE_NO_MENTOR = nil;
CUSTOM_GAME_MODE_AUCTION = nil;
CUSTOM_GAME_MODE_ONLY_CHERK_SINGLE_HEROES = nil;
CUSTOM_GAME_MODE_ONLY_MIRROR = nil;
CUSTOM_GAME_MODE_TROUBLED_TIME = nil;
CUSTOM_GAME_MODE_TROUBLED_TIME_TIER = nil;
-- Кастомное перечисление рас, за неимением такого по умолчанию
RACES = {
  -- Орден Порядка
  HAVEN = 0,
  -- Инферно
  INFERNO = 1,
  -- Некрополис
  NECROPOLIS = 2,
  -- Лесной Союз
  SYLVAN = 3,
  -- Акадения Волшебства
  ACADEMY = 4,
  -- Лига Теней
  DUNGEON = 5,
  -- Северные Кланы
  FORTRESS = 6,
  -- Великая Орда
  STRONGHOLD = 7,
  -- Нейтральные юниты
  NEUTRAL = 8,
};

-- Перечень типов школ магии
TYPE_MAGICS = {
  LIGHT = 0,
  DARK = 1,
  DESTRUCTIVE = 2,
  SUMMON = 3,
  RUNES = 4,
  WARCRIES = 5,
};

-- Перечень всех заклинаний
SPELLS = {
  [TYPE_MAGICS.LIGHT] = {
    { level = 1, id = 23  }, -- божественная сила
    { level = 1, id = 29  }, -- уклонение
    { level = 1, id = 280 }, -- регенерация
    { level = 2, id = 25  }, -- каменная кожа
    { level = 2, id = 24  }, -- ускорение
    { level = 3, id = 28  }, -- карающий удар
    { level = 3, id = 26  }, -- снятие чар
    { level = 4, id = 32  }, -- телепорт
    { level = 4, id = 31  }, -- антимагия
    --{ level = 4, id = 281 }, -- божественная месть
    { level = 5, id = 48  }, -- воскрешение
    --{ level = 5, id = 35  }, -- святое слово
  },
  [TYPE_MAGICS.DARK] = {
    { level = 1, id = 11  }, -- ослабление
    { level = 1, id = 12  }, -- замедление
    { level = 2, id = 13  }, -- разрушающий луч
    { level = 2, id = 14  }, -- чума
    { level = 3, id = 15  }, -- немощность
    { level = 3, id = 17  }, -- рассеяность
--    { level = 3, id = 277 }, -- скорбь
    { level = 4, id = 19  }, -- ослепление
    { level = 4, id = 278 }, -- вампиризм
    { level = 5, id = 18  }, -- берсерк
    { level = 5, id = 20  }, -- подчинение
    --{ level = 5, id = 21  }, -- нечестивое слово
  },
  [TYPE_MAGICS.DESTRUCTIVE] = {
    { level = 1, id = 237 }, -- каменные шипы
    { level = 1, id = 1   }, -- магическая стрела
    { level = 2, id = 4   }, -- ледяная глыба
    { level = 2, id = 3   }, -- молния
    { level = 2, id = 236 }, -- стена огня
    { level = 3, id = 6   }, -- кольцо холода
    { level = 3, id = 5   }, -- огненный шар
    { level = 4, id = 7   }, -- цепь молний
    { level = 4, id = 8   }, -- метеоритный дождь
    { level = 5, id = 279 }, -- останавливающий холод
    { level = 5, id = 9   }, -- шок земли
    { level = 5, id = 10  }, -- армагеддон
  },
  [TYPE_MAGICS.SUMMON] = {
    { level = 1, id = 2   }, -- волшебный кулак
    { level = 1, id = 38  }, -- огненная ловушка
    { level = 2, id = 39  }, -- призыв осиного роя
    { level = 2, id = 282 }, -- кристалл тайного
    { level = 3, id = 284 }, -- стена мечей
    { level = 3, id = 42  }, -- поднятие мертвых
    { level = 3, id = 40  }, -- создание фантома
    --{ level = 3, id = 41  }, -- землетрясение
    { level = 4, id = 43  }, -- призыв элементалей
    { level = 4, id = 283 }, -- призыв улья
    { level = 5, id = 235 }, -- призыв феникса
    { level = 5, id = 34  }, -- небесный щит
  },
  [TYPE_MAGICS.RUNES] = {
    { level = 1, id = 249 }, -- руна энергии
    { level = 1, id = 250 }, -- руна берсеркерства
    { level = 2, id = 251 }, -- руна магического надзора
    { level = 2, id = 252 }, -- руна экзорзизма
    { level = 3, id = 253 }, -- руна стихийной невосприимчивости
    { level = 3, id = 256 }, -- руна неосязаемости
    { level = 4, id = 254 }, -- руна громового раската
    { level = 4, id = 257 }, -- руна воскрешения
    { level = 5, id = 258 }, -- руна драконьего обличья
    { level = 5, id = 255 }, -- руна боевой ярости

  },
  [TYPE_MAGICS.WARCRIES] = {
    { level = 1, id = 290}, -- объединяющий клич
    { level = 1, id = 291}, -- зов крови
    { level = 2, id = 292}, -- слово вождя
    { level = 2, id = 293}, -- устрашающий рык
    { level = 3, id = 294}, -- боевой клич
    { level = 3, id = 295}, -- ярость орды
  }
};

------------------ ГЕРОИ, ИСПОЛЬЗУЮЩИЕСЯ В КАРТЕ ------------------------
HEROES_BY_RACE = {
  [RACES.HAVEN] = {
	  { name = "Orrin",           txt = "haven/heroDugal.txt",    dsc = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt",   [PLAYER_1] = {{ red_icon = "hero_1_1_1", blue_icon = "hero_1_1_2" },   { red_icon = "hero_1_1_5", blue_icon = "hero_1_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_1_1_3", blue_icon = "hero_1_1_4" },   { red_icon = "hero_1_1_7", blue_icon = "hero_1_1_8" }} },
	  { name = "Sarge",           txt = "haven/heroAksel.txt",    dsc = "/Text/Game/Heroes/Specializations/Haven/Jouster/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_2_1_1", blue_icon = "hero_2_1_2" },   { red_icon = "hero_2_1_5", blue_icon = "hero_2_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_2_1_3", blue_icon = "hero_2_1_4" },   { red_icon = "hero_2_1_7", blue_icon = "hero_2_1_8" }} },
	  { name = "Mardigo",         txt = "haven/heroLaslo.txt",    dsc = "/Text/Game/Heroes/Specializations/Haven/Infantry_Commander/Description.txt", [PLAYER_1] = {{ red_icon = "hero_3_1_1", blue_icon = "hero_3_1_2" },   { red_icon = "hero_3_1_5", blue_icon = "hero_3_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_3_1_3", blue_icon = "hero_3_1_4" },   { red_icon = "hero_3_1_7", blue_icon = "hero_3_1_8" }} },
--	  { name = "Brem",            txt = "haven/heroRutger.txt",   dsc = "/Text/Game/Heroes/Specializations/Haven/Wanderer/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_4_1_1", blue_icon = "hero_4_1_2" },   { red_icon = "hero_4_1_5", blue_icon = "hero_4_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_4_1_3", blue_icon = "hero_4_1_4" },   { red_icon = "hero_4_1_7", blue_icon = "hero_4_1_8" }} },
	  { name = "Maeve",           txt = "haven/heroMiv.txt",      dsc = "/Text/Game/Heroes/Specializations/Haven/Expediter/Description.txt",          [PLAYER_1] = {{ red_icon = "hero_5_1_1", blue_icon = "hero_5_1_2" },   { red_icon = "hero_5_1_5", blue_icon = "hero_5_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_5_1_3", blue_icon = "hero_5_1_4" },   { red_icon = "hero_5_1_7", blue_icon = "hero_5_1_8" }} },
	  { name = "Ving",            txt = "haven/heroAiris.txt",    dsc = "/Text/Game/Heroes/Specializations/Haven/Griffon_Commander/Description.txt",  [PLAYER_1] = {{ red_icon = "hero_6_1_1", blue_icon = "hero_6_1_2" },   { red_icon = "hero_6_1_5", blue_icon = "hero_6_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_6_1_3", blue_icon = "hero_6_1_4" },   { red_icon = "hero_6_1_7", blue_icon = "hero_6_1_8" }} },
	  { name = "Nathaniel",       txt = "haven/heroEllaina.txt",  dsc = "/Text/Game/Heroes/Specializations/Haven/Squire/Description.txt",             [PLAYER_1] = {{ red_icon = "hero_7_1_1", blue_icon = "hero_7_1_2" },   { red_icon = "hero_7_1_5", blue_icon = "hero_7_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_7_1_3", blue_icon = "hero_7_1_4" },   { red_icon = "hero_7_1_7", blue_icon = "hero_7_1_8" }} },
	  { name = "Christian",       txt = "haven/heroVittorio.txt", dsc = "/Text/Game/Heroes/Specializations/Haven/Artilleryman/Description.txt",       [PLAYER_1] = {{ red_icon = "hero_8_1_1", blue_icon = "hero_8_1_2" },   { red_icon = "hero_8_1_5", blue_icon = "hero_8_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_8_1_3", blue_icon = "hero_8_1_4" },   { red_icon = "hero_8_1_7", blue_icon = "hero_8_1_8" }} },
	  { name = "Godric",          txt = "haven/heroGodric.txt",   dsc = "/Text/Game/Heroes/Specializations/Haven/White_Knight/Description.txt",       [PLAYER_1] = {{ red_icon = "hero_9_1_1", blue_icon = "hero_9_1_2" },   { red_icon = "hero_9_1_5", blue_icon = "hero_9_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_9_1_3", blue_icon = "hero_9_1_4" },   { red_icon = "hero_9_1_7", blue_icon = "hero_9_1_8" }} },
    { name = "RedHeavenHero03", txt = "haven/heroValeria.txt",  dsc = "/Text/Game/Heroes/Specializations/Haven/SpecValeria/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_13_1_1", blue_icon = "hero_13_1_2" }, { red_icon = "hero_13_1_5", blue_icon = "hero_13_1_6" }},          [PLAYER_2] = {{ red_icon = "hero_13_1_3", blue_icon = "hero_13_1_4" }, { red_icon = "hero_13_1_7", blue_icon = "hero_13_1_8" }} },
--	  { name = "Isabell_A1",      txt = "haven/heroIsabel.txt",   p1 = "hero_11_1_1", p2 = "hero_11_1_2", p3 = "hero_11_1_3", p4 = "hero_11_1_4", dsc = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt"},
    { name = "Alaric",          txt = "haven/heroAlarik.txt",   dsc = "/Text/Game/Heroes/Specializations/Haven/SpecAlarik/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_11_1_1", blue_icon = "hero_11_1_2" }, { red_icon = "hero_11_1_5", blue_icon = "hero_11_1_6" }},          [PLAYER_2] = {{ red_icon = "hero_11_1_3", blue_icon = "hero_11_1_4" }, { red_icon = "hero_11_1_7", blue_icon = "hero_11_1_8" }} },
--    { name = "Duncan",          txt = "haven/heroDuncan.txt",   dsc = "/Text/Game/Heroes/Specializations/Haven/SpecValeria/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_12_1_1", blue_icon = "hero_12_1_2" }, { red_icon = "hero_12_1_5", blue_icon = "hero_12_1_6" }},          [PLAYER_2] = {{ red_icon = "hero_12_1_3", blue_icon = "hero_12_1_4" }, { red_icon = "hero_12_1_7", blue_icon = "hero_12_1_8" }} },
--    { name = "Nicolai",         txt = "haven/heroNicolai.txt",  p1 = "hero_10_1_1", p2 = "hero_10_1_2", p3 = "hero_10_1_3", p4 = "hero_10_1_4", dsc = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt"}
--    { name = "Alaric",          txt = "haven/heroAlarik.txt",   dsc = "/Text/Game/Heroes/Specializations/Haven/SpecAlarik/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_14_1_1", blue_icon = "hero_14_1_2" }, { red_icon = "hero_14_1_5", blue_icon = "hero_14_1_6" }},          [PLAYER_2] = {{ red_icon = "hero_14_1_3", blue_icon = "hero_14_1_4" }, { red_icon = "hero_14_1_7", blue_icon = "hero_14_1_8" }} },
--    { name = "Freyda",          txt = "haven/heroFreyda.txt",   dsc = "/Text/Game/Heroes/Specializations/Haven/SpecAlarik/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_15_1_1", blue_icon = "hero_15_1_2" }, { red_icon = "hero_15_1_5", blue_icon = "hero_15_1_6" }},          [PLAYER_2] = {{ red_icon = "hero_15_1_3", blue_icon = "hero_15_1_4" }, { red_icon = "hero_15_1_7", blue_icon = "hero_15_1_8" }} },
  },
  [RACES.INFERNO] = {
	  { name = "Grok",        txt = "inferno/heroGrok.txt",       dsc = "/Text/Game/Heroes/Specializations/Inferno/Beater/Description.txt",                [PLAYER_1] = {{ red_icon = "hero_1_2_1", blue_icon = "hero_1_2_2" },   { red_icon = "hero_1_2_5", blue_icon = "hero_1_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_1_2_3", blue_icon = "hero_1_2_4" },   { red_icon = "hero_1_2_7", blue_icon = "hero_1_2_8" }} },
	  { name = "Oddrema",     txt = "inferno/heroDgezebet.txt",   dsc = "/Text/Game/Heroes/Specializations/Inferno/Temptress/Description.txt",             [PLAYER_1] = {{ red_icon = "hero_2_2_1", blue_icon = "hero_2_2_2" },   { red_icon = "hero_2_2_5", blue_icon = "hero_2_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_2_2_3", blue_icon = "hero_2_2_4" },   { red_icon = "hero_2_2_7", blue_icon = "hero_2_2_8" }} },
    { name = "Marder",      txt = "inferno/heroMarbas.txt",     dsc = "/Text/Game/Heroes/Specializations/Inferno/Impregnable/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_3_2_1", blue_icon = "hero_3_2_2" },   { red_icon = "hero_3_2_5", blue_icon = "hero_3_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_3_2_3", blue_icon = "hero_3_2_4" },   { red_icon = "hero_3_2_7", blue_icon = "hero_3_2_8" }} },
	  { name = "Jazaz",       txt = "inferno/heroNibros.txt",     dsc = "/Text/Game/Heroes/Specializations/Inferno/Flagbearer_of_Darkness/Description.txt",[PLAYER_1] = {{ red_icon = "hero_4_2_1", blue_icon = "hero_4_2_2" },   { red_icon = "hero_4_2_5", blue_icon = "hero_4_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_4_2_3", blue_icon = "hero_4_2_4" },   { red_icon = "hero_4_2_7", blue_icon = "hero_4_2_8" }} },
	  { name = "Efion",       txt = "inferno/heroAlastor.txt",    dsc = "/Text/Game/Heroes/Specializations/Inferno/Hypnotist/Description.txt",             [PLAYER_1] = {{ red_icon = "hero_5_2_1", blue_icon = "hero_5_2_2" },   { red_icon = "hero_5_2_5", blue_icon = "hero_5_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_5_2_3", blue_icon = "hero_5_2_4" },   { red_icon = "hero_5_2_7", blue_icon = "hero_5_2_8" }} },
	  { name = "Deleb",       txt = "inferno/heroDeleb.txt",      dsc = "/Text/Game/Heroes/Specializations/Inferno/Bombardier/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_6_2_1", blue_icon = "hero_6_2_2" },   { red_icon = "hero_6_2_5", blue_icon = "hero_6_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_6_2_3", blue_icon = "hero_6_2_4" },   { red_icon = "hero_6_2_7", blue_icon = "hero_6_2_8" }} },
	  { name = "Calid",       txt = "inferno/heroGrol.txt",       dsc = "/Text/Game/Heroes/Specializations/Inferno/Breeder/Description.txt",               [PLAYER_1] = {{ red_icon = "hero_7_2_1", blue_icon = "hero_7_2_2" },   { red_icon = "hero_7_2_5", blue_icon = "hero_7_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_7_2_3", blue_icon = "hero_7_2_4" },   { red_icon = "hero_7_2_7", blue_icon = "hero_7_2_8" }} },
	  { name = "Nymus",       txt = "inferno/heroNimus.txt",      dsc = "/Text/Game/Heroes/Specializations/Inferno/Gate_Keeper/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_8_2_1", blue_icon = "hero_8_2_2" },   { red_icon = "hero_8_2_5", blue_icon = "hero_8_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_8_2_3", blue_icon = "hero_8_2_4" },   { red_icon = "hero_8_2_7", blue_icon = "hero_8_2_8" }} },
	  { name = "Orlando",     txt = "inferno/heroOrlando.txt",    dsc = "/Text/Game/Heroes/Specializations/Inferno/SpecOrlando/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_9_2_1", blue_icon = "hero_9_2_2" },   { red_icon = "hero_9_2_5", blue_icon = "hero_9_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_9_2_3", blue_icon = "hero_9_2_4" },   { red_icon = "hero_9_2_7", blue_icon = "hero_9_2_8" }} },
	  { name = "Agrael",      txt = "inferno/heroAgrail.txt",     dsc = "/Text/Game/Heroes/Specializations/Inferno/SpecAgrael/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_10_2_1", blue_icon = "hero_10_2_2" }, { red_icon = "hero_10_2_5", blue_icon = "hero_10_2_6" }},          [PLAYER_2] = {{ red_icon = "hero_10_2_3", blue_icon = "hero_10_2_4" }, { red_icon = "hero_10_2_7", blue_icon = "hero_10_2_8" }} },
--	  { name = "Kha-Beleth",  txt = "inferno/heroVlastelin.txt",  dsc = "/Text/Game/Heroes/Specializations/Inferno/Beater/Description.txt",                [PLAYER_1] = {{ red_icon = "hero_11_2_1", blue_icon = "hero_11_2_2" },  { red_icon = "hero_11_2_5", blue_icon = "hero_11_2_6" }},          [PLAYER_2] = {{ red_icon = "hero_11_2_3", blue_icon = "hero_11_2_4" },  { red_icon = "hero_11_2_7", blue_icon = "hero_11_2_8" }} },
  },
  [RACES.NECROPOLIS] = {
	  { name = "Nemor",       txt = "necropolis/heroDeidra.txt",     dsc = "/Text/Game/Heroes/Specializations/Necropolis/Dark_Emissary/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_1_3_1", blue_icon = "hero_1_3_2" },   { red_icon = "hero_1_3_5", blue_icon = "hero_1_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_1_3_3", blue_icon = "hero_1_3_4" },   { red_icon = "hero_1_3_7", blue_icon = "hero_1_3_8" }} },
	  { name = "Tamika",      txt = "necropolis/heroLukrecia.txt",   dsc = "/Text/Game/Heroes/Specializations/Necropolis/Vamipre_Princess/Description.txt",  [PLAYER_1] = {{ red_icon = "hero_2_3_1", blue_icon = "hero_2_3_2" },   { red_icon = "hero_2_3_5", blue_icon = "hero_2_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_2_3_3", blue_icon = "hero_2_3_4" },   { red_icon = "hero_2_3_7", blue_icon = "hero_2_3_8" }} },
	  { name = "Muscip",      txt = "necropolis/heroNaadir.txt",     dsc = "/Text/Game/Heroes/Specializations/Necropolis/Soulhunter/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_3_3_1", blue_icon = "hero_3_3_2" },   { red_icon = "hero_3_3_5", blue_icon = "hero_3_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_3_3_3", blue_icon = "hero_3_3_4" },   { red_icon = "hero_3_3_7", blue_icon = "hero_3_3_8" }} },
	  { name = "Aberrar",     txt = "necropolis/heroZoltan.txt",     dsc = "/Text/Game/Heroes/Specializations/Necropolis/Mind_Cleaner/Description.txt",      [PLAYER_1] = {{ red_icon = "hero_4_3_1", blue_icon = "hero_4_3_2" },   { red_icon = "hero_4_3_5", blue_icon = "hero_4_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_4_3_3", blue_icon = "hero_4_3_4" },   { red_icon = "hero_4_3_7", blue_icon = "hero_4_3_8" }} },
	  { name = "Straker",     txt = "necropolis/heroOrson.txt",      dsc = "/Text/Game/Heroes/Specializations/Necropolis/Zombie_Leader/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_5_3_1", blue_icon = "hero_5_3_2" },   { red_icon = "hero_5_3_5", blue_icon = "hero_5_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_5_3_3", blue_icon = "hero_5_3_4" },   { red_icon = "hero_5_3_7", blue_icon = "hero_5_3_8" }} },
	  { name = "Effig",       txt = "necropolis/heroRavenna.txt",    dsc = "/Text/Game/Heroes/Specializations/Necropolis/Maledictor/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_6_3_1", blue_icon = "hero_6_3_2" },   { red_icon = "hero_6_3_5", blue_icon = "hero_6_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_6_3_3", blue_icon = "hero_6_3_4" },   { red_icon = "hero_6_3_7", blue_icon = "hero_6_3_8" }} },
	  { name = "Pelt",        txt = "necropolis/heroVlad.txt",       dsc = "/Text/Game/Heroes/Specializations/Necropolis/Reanimator/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_7_3_1", blue_icon = "hero_7_3_2" },   { red_icon = "hero_7_3_5", blue_icon = "hero_7_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_7_3_3", blue_icon = "hero_7_3_4" },   { red_icon = "hero_7_3_7", blue_icon = "hero_7_3_8" }} },
	  { name = "Gles",        txt = "necropolis/heroKaspar.txt",     dsc = "/Text/Game/Heroes/Specializations/Necropolis/Empiric/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_8_3_1", blue_icon = "hero_8_3_2" },   { red_icon = "hero_8_3_5", blue_icon = "hero_8_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_8_3_3", blue_icon = "hero_8_3_4" },   { red_icon = "hero_8_3_7", blue_icon = "hero_8_3_8" }} },
	  { name = "Arantir",     txt = "necropolis/heroArantir.txt",    dsc = "/Text/Game/Heroes/Specializations/Necropolis/AvatarOfDeath/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_9_3_1", blue_icon = "hero_9_3_2" },   { red_icon = "hero_9_3_5", blue_icon = "hero_9_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_9_3_3", blue_icon = "hero_9_3_4" },   { red_icon = "hero_9_3_7", blue_icon = "hero_9_3_8" }} },
	  { name = "OrnellaNecro",txt = "necropolis/heroOrnella.txt",    dsc = "/Text/Game/Heroes/Specializations/Necropolis/SpecOrnella/Description.txt",       [PLAYER_1] = {{ red_icon = "hero_10_3_1", blue_icon = "hero_10_3_2" }, { red_icon = "hero_10_3_5", blue_icon = "hero_10_3_6" }}, [PLAYER_2] = {{ red_icon = "hero_10_3_3", blue_icon = "hero_10_3_4" }, { red_icon = "hero_10_3_7", blue_icon = "hero_10_3_8" }} },
    { name = "Berein",      txt = "necropolis/heroMarkel.txt",     dsc = "/Text/Game/Heroes/Specializations/Necropolis/Heir_of_Undeath/Berein.txt",        [PLAYER_1] = {{ red_icon = "hero_11_3_1", blue_icon = "hero_11_3_2" }, { red_icon = "hero_11_3_5", blue_icon = "hero_11_3_6" }}, [PLAYER_2] = {{ red_icon = "hero_11_3_3", blue_icon = "hero_11_3_4" }, { red_icon = "hero_11_3_7", blue_icon = "hero_11_3_8" }} },
    { name = "Nikolas",     txt = "necropolis/heroNikolas.txt",    dsc = "/Text/Game/Heroes/Specializations/Necropolis/SpecNikolas/Description.txt",       [PLAYER_1] = {{ red_icon = "hero_12_3_1", blue_icon = "hero_12_3_2" }, { red_icon = "hero_12_3_5", blue_icon = "hero_12_3_6" }}, [PLAYER_2] = {{ red_icon = "hero_12_3_3", blue_icon = "hero_12_3_4" }, { red_icon = "hero_12_3_7", blue_icon = "hero_12_3_8" }} }
  },
  [RACES.SYLVAN] = {
	  { name = "Metlirn",     txt = "sylvan/heroAnven.txt",      dsc = "/Text/Game/Heroes/Specializations/Preserve/Forest_Guardian/Description.txt",  [PLAYER_1] = {{ red_icon = "hero_1_4_1", blue_icon = "hero_1_4_2" },   { red_icon = "hero_1_4_5", blue_icon = "hero_1_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_1_4_3", blue_icon = "hero_1_4_4" },   { red_icon = "hero_1_4_7", blue_icon = "hero_1_4_8" }} },
	  { name = "Gillion",     txt = "sylvan/heroGilraen.txt",    dsc = "/Text/Game/Heroes/Specializations/Preserve/Blade_Master/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_2_4_1", blue_icon = "hero_2_4_2" },   { red_icon = "hero_2_4_5", blue_icon = "hero_2_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_2_4_3", blue_icon = "hero_2_4_4" },   { red_icon = "hero_2_4_7", blue_icon = "hero_2_4_8" }}  },
	  { name = "Nadaur",      txt = "sylvan/heroTalanar.txt",    dsc = "/Text/Game/Heroes/Specializations/Preserve/Elven_Fury/Description.txt",       [PLAYER_1] = {{ red_icon = "hero_3_4_1", blue_icon = "hero_3_4_2" },   { red_icon = "hero_3_4_5", blue_icon = "hero_3_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_3_4_3", blue_icon = "hero_3_4_4" },   { red_icon = "hero_3_4_7", blue_icon = "hero_3_4_8" }}  },
	  { name = "Diraya",      txt = "sylvan/heroDirael.txt",     dsc = "/Text/Game/Heroes/Specializations/Preserve/Call_of_the_Wasp/Description.txt", [PLAYER_1] = {{ red_icon = "hero_4_4_1", blue_icon = "hero_4_4_2" },   { red_icon = "hero_4_4_5", blue_icon = "hero_4_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_4_4_3", blue_icon = "hero_4_4_4" },   { red_icon = "hero_4_4_7", blue_icon = "hero_4_4_8" }}  },
	  { name = "Ossir",       txt = "sylvan/heroOssir.txt",      dsc = "/Text/Game/Heroes/Specializations/Preserve/Hunter/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_5_4_1", blue_icon = "hero_5_4_2" },   { red_icon = "hero_5_4_5", blue_icon = "hero_5_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_5_4_3", blue_icon = "hero_5_4_4" },   { red_icon = "hero_5_4_7", blue_icon = "hero_5_4_8" }}  },
	  { name = "Itil",        txt = "sylvan/heroIlfina.txt",     dsc = "/Text/Game/Heroes/Specializations/Preserve/Unicorn_Trainer/Description.txt",  [PLAYER_1] = {{ red_icon = "hero_6_4_1", blue_icon = "hero_6_4_2" },   { red_icon = "hero_6_4_5", blue_icon = "hero_6_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_6_4_3", blue_icon = "hero_6_4_4" },   { red_icon = "hero_6_4_7", blue_icon = "hero_6_4_8" }}  },
	  { name = "Elleshar",    txt = "sylvan/heroVinrael.txt",    dsc = "/Text/Game/Heroes/Specializations/Preserve/Talented_Warrior/Description.txt", [PLAYER_1] = {{ red_icon = "hero_7_4_1", blue_icon = "hero_7_4_2" },   { red_icon = "hero_7_4_5", blue_icon = "hero_7_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_7_4_3", blue_icon = "hero_7_4_4" },   { red_icon = "hero_7_4_7", blue_icon = "hero_7_4_8" }}  },
	  { name = "Linaas",      txt = "sylvan/heroVingael.txt",    dsc = "/Text/Game/Heroes/Specializations/Preserve/Waylayer/Description.txt",         [PLAYER_1] = {{ red_icon = "hero_8_4_1", blue_icon = "hero_8_4_2" },   { red_icon = "hero_8_4_5", blue_icon = "hero_8_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_8_4_3", blue_icon = "hero_8_4_4" },   { red_icon = "hero_8_4_7", blue_icon = "hero_8_4_8" }}  },
	  { name = "Heam",        txt = "sylvan/heroFaidaen.txt",    dsc = "/Text/Game/Heroes/Specializations/Preserve/Elven_Volley/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_9_4_1", blue_icon = "hero_9_4_2" },   { red_icon = "hero_9_4_5", blue_icon = "hero_9_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_9_4_3", blue_icon = "hero_9_4_4" },   { red_icon = "hero_9_4_7", blue_icon = "hero_9_4_8" }}  },
	  { name = "Ildar",       txt = "sylvan/heroAlaron.txt",     dsc = "/Text/Game/Heroes/Specializations/Preserve/SpecIldar/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_10_4_1", blue_icon = "hero_10_4_2" }, { red_icon = "hero_10_4_5", blue_icon = "hero_10_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_10_4_3", blue_icon = "hero_10_4_4" }, { red_icon = "hero_10_4_7", blue_icon = "hero_10_4_8" }} },
--	  { name = "GhostFSLord", txt = "sylvan/heroPrizrak.txt",    dsc = "/Text/Game/Heroes/Specializations/Preserve/Forest_Guardian/Description.txt",  [PLAYER_1] = {{ red_icon = "hero_11_4_1", blue_icon = "hero_11_4_2" }, { red_icon = "hero_11_4_5", blue_icon = "hero_11_4_6" }},  [PLAYER_2] = {{ red_icon = "hero_11_4_3", blue_icon = "hero_11_4_4" } , { red_icon = "hero_11_4_7", blue_icon = "hero_11_4_8" }} },
  },
  [RACES.ACADEMY] = {
	  { name = "Faiz",        txt = "academy/heroFaiz.txt",       dsc = "/Text/Game/Heroes/Specializations/Academy/Disrupter/Description.txt",          [PLAYER_1] = {{ red_icon = "hero_1_5_1", blue_icon = "hero_1_5_2" },   { red_icon = "hero_1_5_5", blue_icon = "hero_1_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_1_5_3", blue_icon = "hero_1_5_4" }, { red_icon = "hero_1_5_7", blue_icon = "hero_1_5_8" }} },
	  { name = "Havez",       txt = "academy/heroHafiz.txt",      dsc = "/Text/Game/Heroes/Specializations/Academy/Artisan/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_2_5_1", blue_icon = "hero_2_5_2" },   { red_icon = "hero_2_5_5", blue_icon = "hero_2_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_2_5_3", blue_icon = "hero_2_5_4" }, { red_icon = "hero_2_5_7", blue_icon = "hero_2_5_8" }} },
	  { name = "Nur",         txt = "academy/heroNazir.txt",      dsc = "/Text/Game/Heroes/Specializations/Academy/Weilder_of_Fire/Description.txt",    [PLAYER_1] = {{ red_icon = "hero_3_5_1", blue_icon = "hero_3_5_2" },   { red_icon = "hero_3_5_5", blue_icon = "hero_3_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_3_5_3", blue_icon = "hero_3_5_4" }, { red_icon = "hero_3_5_7", blue_icon = "hero_3_5_8" }} },
	  { name = "Astral",      txt = "academy/heroNura.txt",       dsc = "/Text/Game/Heroes/Specializations/Academy/Inexhaustible/Description.txt",      [PLAYER_1] = {{ red_icon = "hero_4_5_1", blue_icon = "hero_4_5_2" },   { red_icon = "hero_4_5_5", blue_icon = "hero_4_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_4_5_3", blue_icon = "hero_4_5_4" }, { red_icon = "hero_4_5_7", blue_icon = "hero_4_5_8" }} },
	  { name = "Sufi",        txt = "academy/heroOra.txt",        dsc = "/Text/Game/Heroes/Specializations/Academy/Feather_Mage/Description.txt",       [PLAYER_1] = {{ red_icon = "hero_5_5_1", blue_icon = "hero_5_5_2" },   { red_icon = "hero_5_5_5", blue_icon = "hero_5_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_5_5_3", blue_icon = "hero_5_5_4" }, { red_icon = "hero_5_5_7", blue_icon = "hero_5_5_8" }} },
	  { name = "Razzak",      txt = "academy/heroNarhiz.txt",     dsc = "/Text/Game/Heroes/Specializations/Academy/Mentor/Description.txt",             [PLAYER_1] = {{ red_icon = "hero_6_5_1", blue_icon = "hero_6_5_2" },   { red_icon = "hero_6_5_5", blue_icon = "hero_6_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_6_5_3", blue_icon = "hero_6_5_4" }, { red_icon = "hero_6_5_7", blue_icon = "hero_6_5_8" }} },
	  { name = "Tan",         txt = "academy/heroDgalib.txt",     dsc = "/Text/Game/Heroes/Specializations/Academy/Radiant/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_7_5_1", blue_icon = "hero_7_5_2" },   { red_icon = "hero_7_5_5", blue_icon = "hero_7_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_7_5_3", blue_icon = "hero_7_5_4" }, { red_icon = "hero_7_5_7", blue_icon = "hero_7_5_8" }} },
	  { name = "Isher",       txt = "academy/heroRazzak.txt",     dsc = "/Text/Game/Heroes/Specializations/Academy/Machinist/Description.txt",          [PLAYER_1] = {{ red_icon = "hero_8_5_1", blue_icon = "hero_8_5_2" },   { red_icon = "hero_8_5_5", blue_icon = "hero_8_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_8_5_3", blue_icon = "hero_8_5_4" }, { red_icon = "hero_8_5_7", blue_icon = "hero_8_5_8" }} },
	  { name = "Zehir",       txt = "academy/heroZehir.txt",      dsc = "/Text/Game/Heroes/Specializations/Academy/Master_of_Elements/Description.txt", [PLAYER_1] = {{ red_icon = "hero_9_5_1", blue_icon = "hero_9_5_2" },   { red_icon = "hero_9_5_5", blue_icon = "hero_9_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_9_5_3", blue_icon = "hero_9_5_4" }, { red_icon = "hero_9_5_7", blue_icon = "hero_9_5_8" }} },
	  { name = "Maahir",      txt = "academy/heroMaahir.txt",     dsc = "/Text/Game/Heroes/Specializations/Academy/SpecMaahir/Description.txt",         [PLAYER_1] = {{ red_icon = "hero_10_5_1", blue_icon = "hero_10_5_2" }, { red_icon = "hero_10_5_5", blue_icon = "hero_10_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_10_5_3", blue_icon = "hero_10_5_4" }, { red_icon = "hero_10_5_7", blue_icon = "hero_10_5_8" }} },
--	  { name = "Cyrus",       txt = "academy/heroSairus.txt",     dsc = "/Text/Game/Heroes/Specializations/Academy/SpecCyrus/Description.txt",          [PLAYER_1] = {{ red_icon = "hero_11_5_1", blue_icon = "hero_11_5_2" },  { red_icon = "hero_11_5_5", blue_icon = "hero_11_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_11_5_3", blue_icon = "hero_11_5_4" }, { red_icon = "hero_11_5_7", blue_icon = "hero_11_5_8" }} },
  },
  [RACES.DUNGEON] = {
	  { name = "Eruina",      txt = "dungeon/heroErin.txt",       dsc = "/Text/Game/Heroes/Specializations/Dungeon/Matron_Salvo/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_1_6_1", blue_icon = "hero_1_6_2" }, { red_icon = "hero_1_6_5", blue_icon = "hero_1_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_1_6_3", blue_icon = "hero_1_6_4" }, { red_icon = "hero_1_6_7", blue_icon = "hero_1_6_8" }} },
	  { name = "Inagost",     txt = "dungeon/heroSinitar.txt",    dsc = "/Text/Game/Heroes/Specializations/Dungeon/Power_Bargain/Description.txt",          [PLAYER_1] = {{ red_icon = "hero_2_6_1", blue_icon = "hero_2_6_2" }, { red_icon = "hero_2_6_5", blue_icon = "hero_2_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_2_6_3", blue_icon = "hero_2_6_4" }, { red_icon = "hero_2_6_7", blue_icon = "hero_2_6_8" }} },
	  { name = "Urunir",      txt = "dungeon/heroIranna.txt",     dsc = "/Text/Game/Heroes/Specializations/Dungeon/Seducer/Description.txt",                [PLAYER_1] = {{ red_icon = "hero_3_6_1", blue_icon = "hero_3_6_2" }, { red_icon = "hero_3_6_5", blue_icon = "hero_3_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_3_6_3", blue_icon = "hero_3_6_4" }, { red_icon = "hero_3_6_7", blue_icon = "hero_3_6_8" }} },
	  { name = "Almegir",     txt = "dungeon/heroIrbet.txt",      dsc = "/Text/Game/Heroes/Specializations/Dungeon/Dark_Acolyte/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_4_6_1", blue_icon = "hero_4_6_2" }, { red_icon = "hero_4_6_5", blue_icon = "hero_4_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_4_6_3", blue_icon = "hero_4_6_4" }, { red_icon = "hero_4_6_7", blue_icon = "hero_4_6_8" }} },
	  { name = "Menel",       txt = "dungeon/heroKifra.txt",      dsc = "/Text/Game/Heroes/Specializations/Dungeon/Slaveholder/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_5_6_1", blue_icon = "hero_5_6_2" }, { red_icon = "hero_5_6_5", blue_icon = "hero_5_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_5_6_3", blue_icon = "hero_5_6_4" }, { red_icon = "hero_5_6_7", blue_icon = "hero_5_6_8" }} },
	  { name = "Dalom",       txt = "dungeon/heroLetos.txt",      dsc = "/Text/Game/Heroes/Specializations/Dungeon/Poisoner/Description.txt",               [PLAYER_1] = {{ red_icon = "hero_6_6_1", blue_icon = "hero_6_6_2" }, { red_icon = "hero_6_6_5", blue_icon = "hero_6_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_6_6_3", blue_icon = "hero_6_6_4" }, { red_icon = "hero_6_6_7", blue_icon = "hero_6_6_8" }} },
	  { name = "Ferigl",      txt = "dungeon/heroSorgal.txt",     dsc = "/Text/Game/Heroes/Specializations/Dungeon/Lizard_Breeder/Description.txt",         [PLAYER_1] = {{ red_icon = "hero_7_6_1", blue_icon = "hero_7_6_2" }, { red_icon = "hero_7_6_5", blue_icon = "hero_7_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_7_6_3", blue_icon = "hero_7_6_4" }, { red_icon = "hero_7_6_7", blue_icon = "hero_7_6_8" }} },
	  { name = "Ohtarig",     txt = "dungeon/heroVaishan.txt",    dsc = "/Text/Game/Heroes/Specializations/Dungeon/Savage/Description.txt",                 [PLAYER_1] = {{ red_icon = "hero_8_6_1", blue_icon = "hero_8_6_2" }, { red_icon = "hero_8_6_5", blue_icon = "hero_8_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_8_6_3", blue_icon = "hero_8_6_4" }, { red_icon = "hero_8_6_7", blue_icon = "hero_8_6_8" }} },
--	  { name = "Raelag_A1",   txt = "dungeon/heroRailag.txt",     dsc = "/Text/Game/Heroes/Specializations/Dungeon/MasterOfInitiative/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_9_6_1", blue_icon = "hero_9_6_2" }, { red_icon = "hero_9_6_5", blue_icon = "hero_9_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_9_6_3", blue_icon = "hero_9_6_4" }, { red_icon = "hero_9_6_7", blue_icon = "hero_9_6_8" }} },
	  { name = "Kelodin",     txt = "dungeon/heroShadia.txt",     dsc = "/Text/Game/Heroes/Specializations/Dungeon/Evasive/Description.txt",                [PLAYER_1] = {{ red_icon = "hero_10_6_1", blue_icon = "hero_10_6_2" }, { red_icon = "hero_10_6_5", blue_icon = "hero_10_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_10_6_3", blue_icon = "hero_10_6_4" }, { red_icon = "hero_10_6_7", blue_icon = "hero_10_6_8" }} },
	  { name = "Shadwyn",     txt = "dungeon/heroIlaiya.txt",     dsc = "/Text/Game/Heroes/Specializations/Dungeon/SpecShadwyn/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_11_6_1", blue_icon = "hero_11_6_2" }, { red_icon = "hero_11_6_5", blue_icon = "hero_11_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_11_6_3", blue_icon = "hero_11_6_4" }, { red_icon = "hero_11_6_7", blue_icon = "hero_11_6_8" }} },
--	  { name = "Thralsai",    txt = "dungeon/heroTralsai.txt",    dsc = "/Text/Game/Heroes/Specializations/Dungeon/SpecThralsai/Description.txt",           [PLAYER_1] = { red_icon = "hero_12_6_1", blue_icon = "hero_12_6_2" }, [PLAYER_2] = { red_icon = "hero_12_6_3", blue_icon = "hero_12_6_4" } }
  },
  [RACES.FORTRESS] = {
 	  { name = "Brand",       txt = "fortress/heroBrand.txt",      dsc = "/Text/Game/Heroes/Specializations/Fortress/Economist/Description.txt",    [PLAYER_1] = {{ red_icon = "hero_1_7_1", blue_icon = "hero_1_7_2" }, { red_icon = "hero_1_7_5", blue_icon = "hero_1_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_1_7_3", blue_icon = "hero_1_7_4" }, { red_icon = "hero_1_7_7", blue_icon = "hero_1_7_8" }} },
	  { name = "Bersy",       txt = "fortress/heroIbba.txt",       dsc = "/Text/Game/Heroes/Specializations/Fortress/Rider/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_2_7_1", blue_icon = "hero_2_7_2" }, { red_icon = "hero_2_7_5", blue_icon = "hero_2_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_2_7_3", blue_icon = "hero_2_7_4" }, { red_icon = "hero_2_7_7", blue_icon = "hero_2_7_8" }} },
	  { name = "Egil",        txt = "fortress/heroErling.txt",     dsc = "/Text/Game/Heroes/Specializations/Fortress/Magister/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_3_7_1", blue_icon = "hero_3_7_2" }, { red_icon = "hero_3_7_5", blue_icon = "hero_3_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_3_7_3", blue_icon = "hero_3_7_4" }, { red_icon = "hero_3_7_7", blue_icon = "hero_3_7_8" }} },
	  { name = "Ottar",       txt = "fortress/heroHelmar.txt",     dsc = "/Text/Game/Heroes/Specializations/Fortress/Sacred_Hammer/Description.txt",[PLAYER_1] = {{ red_icon = "hero_4_7_1", blue_icon = "hero_4_7_2" }, { red_icon = "hero_4_7_5", blue_icon = "hero_4_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_4_7_3", blue_icon = "hero_4_7_4" }, { red_icon = "hero_4_7_7", blue_icon = "hero_4_7_8" }} },
	  { name = "Una",         txt = "fortress/heroInga.txt",       dsc = "/Text/Game/Heroes/Specializations/Fortress/Researcher/Description.txt",   [PLAYER_1] = {{ red_icon = "hero_5_7_1", blue_icon = "hero_5_7_2" }, { red_icon = "hero_5_7_5", blue_icon = "hero_5_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_5_7_3", blue_icon = "hero_5_7_4" }, { red_icon = "hero_5_7_7", blue_icon = "hero_5_7_8" }} },
	  { name = "Ingvar",      txt = "fortress/heroIngvar.txt",     dsc = "/Text/Game/Heroes/Specializations/Fortress/Defender/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_6_7_1", blue_icon = "hero_6_7_2" }, { red_icon = "hero_6_7_5", blue_icon = "hero_6_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_6_7_3", blue_icon = "hero_6_7_4" }, { red_icon = "hero_6_7_7", blue_icon = "hero_6_7_8" }} },
	  { name = "Vegeyr",      txt = "fortress/heroSveya.txt",      dsc = "/Text/Game/Heroes/Specializations/Fortress/Stormcaller/Description.txt",  [PLAYER_1] = {{ red_icon = "hero_7_7_1", blue_icon = "hero_7_7_2" }, { red_icon = "hero_7_7_5", blue_icon = "hero_7_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_7_7_3", blue_icon = "hero_7_7_4" }, { red_icon = "hero_7_7_7", blue_icon = "hero_7_7_8" }} },
	  { name = "Skeggy",      txt = "fortress/heroKarli.txt",      dsc = "/Text/Game/Heroes/Specializations/Fortress/Axe_Master/Description.txt",   [PLAYER_1] = {{ red_icon = "hero_8_7_1", blue_icon = "hero_8_7_2" }, { red_icon = "hero_8_7_5", blue_icon = "hero_8_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_8_7_3", blue_icon = "hero_8_7_4" }, { red_icon = "hero_8_7_7", blue_icon = "hero_8_7_8" }} },
--	  { name = "KingTolghar", txt = "fortress/heroTolgar.txt",     dsc = "/Text/Game/Heroes/Specializations/Fortress/Mountain_King/Description.txt",[PLAYER_1] = { red_icon = "hero_9_7_1", blue_icon = "hero_9_7_2" }, [PLAYER_2] = { red_icon = "hero_9_7_3", blue_icon = "hero_9_7_4" } },
	  { name = "Wulfstan",    txt = "fortress/heroVulfsten.txt",   dsc = "/Text/Game/Heroes/Specializations/Fortress/SpecWulfstan/Description.txt", [PLAYER_1] = {{ red_icon = "hero_10_7_1", blue_icon = "hero_10_7_2" }, { red_icon = "hero_10_7_5", blue_icon = "hero_10_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_10_7_3", blue_icon = "hero_10_7_4" }, { red_icon = "hero_10_7_7", blue_icon = "hero_10_7_8" }} },
	  { name = "Rolf",        txt = "fortress/heroRolf.txt",       dsc = "/Text/Game/Heroes/Specializations/Fortress/SpecRolf/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_11_7_1", blue_icon = "hero_11_7_2" }, { red_icon = "hero_11_7_5", blue_icon = "hero_11_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_11_7_3", blue_icon = "hero_11_7_4" }, { red_icon = "hero_11_7_7", blue_icon = "hero_11_7_8" }} }
  },
  [RACES.STRONGHOLD] = {
--	  { name = "Hero2",       txt = "stronghold/heroArgat.txt",      dsc = "/Text/Game/Heroes/Specializations/Stronghold/SpecArgat/Description.txt",                  [PLAYER_1] = { red_icon = "hero_1_8_1", blue_icon = "hero_1_8_2" }, [PLAYER_2] = { red_icon = "hero_1_8_3", blue_icon = "hero_1_8_4" } },
	  { name = "Hero3",       txt = "stronghold/heroGaruna.txt",     dsc = "/Text/Game/Heroes/Specializations/Stronghold/Blooddrinker/Description.txt",               [PLAYER_1] = {{ red_icon = "hero_2_8_1", blue_icon = "hero_2_8_2" }, { red_icon = "hero_2_8_5", blue_icon = "hero_2_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_2_8_3", blue_icon = "hero_2_8_4" }, { red_icon = "hero_2_8_7", blue_icon = "hero_2_8_8" }} },
	  { name = "Hero6",       txt = "stronghold/heroShakKarukat.txt",dsc = "/Text/Game/Heroes/Specializations/Stronghold/SpecShak/Description.txt",                   [PLAYER_1] = {{ red_icon = "hero_3_8_1", blue_icon = "hero_3_8_2" }, { red_icon = "hero_3_8_5", blue_icon = "hero_3_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_3_8_3", blue_icon = "hero_3_8_4" }, { red_icon = "hero_3_8_7", blue_icon = "hero_3_8_8" }} },
	  { name = "Hero8",       txt = "stronghold/heroTilsek.txt",     dsc = "/Text/Game/Heroes/Specializations/Stronghold/GrimFighter/Description.txt",                [PLAYER_1] = {{ red_icon = "hero_4_8_1", blue_icon = "hero_4_8_2" }, { red_icon = "hero_4_8_5", blue_icon = "hero_4_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_4_8_3", blue_icon = "hero_4_8_4" }, { red_icon = "hero_4_8_7", blue_icon = "hero_4_8_8" }} },
	  { name = "Hero7",       txt = "stronghold/heroHaggesh.txt",    dsc = "/Text/Game/Heroes/Specializations/Stronghold/CentaurMistress/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_5_8_1", blue_icon = "hero_5_8_2" }, { red_icon = "hero_5_8_5", blue_icon = "hero_5_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_5_8_3", blue_icon = "hero_5_8_4" }, { red_icon = "hero_5_8_7", blue_icon = "hero_5_8_8" }} },
 	  { name = "Hero1",       txt = "stronghold/heroKrag.txt",       dsc = "/Text/Game/Heroes/Specializations/Stronghold/Offender/Description.txt",                   [PLAYER_1] = {{ red_icon = "hero_6_8_1", blue_icon = "hero_6_8_2" }, { red_icon = "hero_6_8_5", blue_icon = "hero_6_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_6_8_3", blue_icon = "hero_6_8_4" }, { red_icon = "hero_6_8_7", blue_icon = "hero_6_8_8" }} },
 	  { name = "Hero9",       txt = "stronghold/heroKigan.txt",      dsc = "/Text/Game/Heroes/Specializations/Stronghold/GoblinKing/Description.txt",                 [PLAYER_1] = {{ red_icon = "hero_7_8_1", blue_icon = "hero_7_8_2" }, { red_icon = "hero_7_8_5", blue_icon = "hero_7_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_7_8_3", blue_icon = "hero_7_8_4" }, { red_icon = "hero_7_8_7", blue_icon = "hero_7_8_8" }} },
	  { name = "Hero4",       txt = "stronghold/heroGoshak.txt",     dsc = "/Text/Game/Heroes/Specializations/Stronghold/OrcElder/Description.txt",                   [PLAYER_1] = {{ red_icon = "hero_8_8_1", blue_icon = "hero_8_8_2" }, { red_icon = "hero_8_8_5", blue_icon = "hero_8_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_8_8_3", blue_icon = "hero_8_8_4" }, { red_icon = "hero_8_8_7", blue_icon = "hero_8_8_8" }} },
	  { name = "Kujin",       txt = "stronghold/heroKudgin.txt",     dsc = "/Text/Game/Heroes/Specializations/Stronghold/SpecKujin/Description.txt",                  [PLAYER_1] = {{ red_icon = "hero_9_8_1", blue_icon = "hero_9_8_2" }, { red_icon = "hero_9_8_5", blue_icon = "hero_9_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_9_8_3", blue_icon = "hero_9_8_4" }, { red_icon = "hero_9_8_7", blue_icon = "hero_9_8_8" }} },
	  { name = "Gottai",      txt = "stronghold/heroGotai.txt",      dsc = "/Text/Game/Heroes/Specializations/Stronghold/WarLeader/Description.txt",                  [PLAYER_1] = {{ red_icon = "hero_10_8_1", blue_icon = "hero_10_8_2" }, { red_icon = "hero_10_8_5", blue_icon = "hero_10_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_10_8_3", blue_icon = "hero_10_8_4" }, { red_icon = "hero_10_8_7", blue_icon = "hero_10_8_8" }} },
	  { name = "Quroq",       txt = "stronghold/heroKurak.txt",      dsc = "/Text/Game/Heroes/Specializations/Stronghold/SpecQuroq/Description.txt",                  [PLAYER_1] = {{ red_icon = "hero_11_8_1", blue_icon = "hero_11_8_2" }, { red_icon = "hero_11_8_5", blue_icon = "hero_11_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_11_8_3", blue_icon = "hero_11_8_4" }, { red_icon = "hero_11_8_7", blue_icon = "hero_11_8_8" }} }
  }
};

-- Биара (герой красного)
Biara = GetPlayerHeroes(PLAYER_1)[0]
-- Джованни (герой синего)
Djovanni = GetPlayerHeroes(PLAYER_2)[0]

-- Итоговый список расы и героев для игры
-- Служит для передачи значения для начала прокачки
RESULT_HERO_LIST = {
  [PLAYER_1] = {
    raceId = nil,
    -- Список героев, выданных игроку (3)
    heroes = {},
    -- Список героев после черков (5)
    choised_heroes = {},
  },
  [PLAYER_2] = {
    raceId = nil,
    -- Список героев, выданных игроку (3)
    heroes = {},
    -- Список героев после черков (5)
    choised_heroes = {},
  },
};

-- Все свойства главных героев игроков
-- Заполняется на этапе обучения героев
PLAYERS_MAIN_HERO_PROPS = {
  [PLAYER_1] = {
    name = nil,
    -- Список снимаемых артефактов на моменты изменения статов
    removedHeroArtIdList = {},
    -- Стартовые статы героя (до прокачки)
    start_stats = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Статы, полученные за уровни с рассовым распределением
    stats = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Статы, которые были получены за навыки
    stats_for_skills = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Дополнительные статы с образования разделенные на уровни
    -- разбил на уровни для удобства отката
    learning = {
      [1] = nil,
      [2] = nil,
      [3] = nil,
    },
    -- текущий уровень образования
    current_learning_level = 0,
    -- Покупаемые статы
    buy_stats = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Количество купленных статов
    count_buy_stats = 0,
  },
  [PLAYER_2] = {
    name = nil,
    -- Список снимаемых артефактов на моменты изменения статов
    removedHeroArtIdList = {},
    -- Стартовые статы героя (до прокачки)
    start_stats = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Статы, полученные за уровни с рассовым распределением
    stats = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Статы, которые были получены за навыки
    stats_for_skills = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Дополнительные статы с образования разделенные на уровни
    -- разбил на уровни для удобства отката
    learning = {
      [1] = nil,
      [2] = nil,
      [3] = nil,
    },
    -- текущий уровень образования
    current_learning_level = 0,
    -- Покупаемые статы
    buy_stats = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Количество купленных статов
    count_buy_stats = 0,
  },
};

-- Таблица ИД всех игроков
PLAYER_ID_TABLE = { PLAYER_1, PLAYER_2 };

-- Соотношение ИД игрока к ИД его соперника
PLAYERS_OPPONENT = {
  [PLAYER_1] = PLAYER_2,
  [PLAYER_2] = PLAYER_1,
};

-- Список начальных навыков и/или школ для каждого героя
INITIAL_HERO_SKILLS = {
  Orrin = { SKILL_OFFENCE, PERK_ARCHERY },
  Sarge = { SKILL_OFFENCE, PERK_HOLY_CHARGE },
  Mardigo = { SKILL_DEFENCE, PERK_TOUGHNESS },
  Brem = { SKILL_TRAINING, SKILL_TRAINING },
  Maeve = { SKILL_LIGHT_MAGIC, PERK_MASTER_OF_WRATH },
  Ving = { SKILL_LUCK, PERK_RESISTANCE },
  Nathaniel = { SKILL_LEADERSHIP, PERK_RECRUITMENT },
  Christian = { SKILL_WAR_MACHINES, PERK_BALLISTA },
  Godric = { SKILL_LIGHT_MAGIC, PERK_PRAYER },
  RedHeavenHero03 = { SKILL_SORCERY, SKILL_DARK_MAGIC },
  Alaric = {SKILL_LIGHT_MAGIC, SKILL_DARK_MAGIC },
  Freyda = {SKILL_LIGHT_MAGIC, SKILL_SORCERY},
  Isabell_A1 = { SKILL_LIGHT_MAGIC, SKILL_LIGHT_MAGIC },
  Duncan = { SKILL_OFFENCE, PERK_TACTICS },
  Nicolai = { SKILL_TRAINING, SKILL_TRAINING },
  Grok = { SKILL_LOGISTICS, PERK_PATHFINDING },
  Oddrema = { SKILL_SORCERY, PERK_WISDOM },
  Marder = { SKILL_DEFENCE, PERK_PROTECTION },
  Jazaz = { SKILL_OFFENCE, PERK_TACTICS },
  Efion = { SKILL_DARK_MAGIC, PERK_MASTER_OF_MIND },
  Deleb = { SKILL_WAR_MACHINES, PERK_BALLISTA },
  Calid = { SKILL_DESTRUCTIVE_MAGIC, PERK_DEMONIC_FIRE },
  Nymus = { SKILL_LUCK, PERK_RESISTANCE },
  Orlando = { SKILL_LEADERSHIP, PERK_DEMONIC_STRIKE },
  Agrael = { SKILL_OFFENCE, PERK_FRENZY },
  ["Kha-Beleth"] = { SKILL_DARK_MAGIC, PERK_DEMONIC_FIRE },
  Nemor = { SKILL_DARK_MAGIC, PERK_DEATH_SCREAM },
  Tamika = { SKILL_SORCERY, PERK_ARCANE_TRAINING },
  Muscip = { SKILL_SUMMONING_MAGIC, SKILL_DARK_MAGIC },
  Aberrar = { SKILL_LEARNING, PERK_INTELLIGENCE },
  Straker = { SKILL_DEFENCE, PERK_TOUGHNESS },
  Effig = { SKILL_DARK_MAGIC, PERK_MASTER_OF_CURSES },
  Pelt = { SKILL_SUMMONING_MAGIC, PERK_MASTER_OF_ANIMATION },
  Gles = { SKILL_WAR_MACHINES, PERK_FIRST_AID },
  Arantir = { SKILL_SUMMONING_MAGIC, NECROMANCER_FEAT_SPIRIT_LINK },
  OrnellaNecro = { SKILL_LEARNING, PERK_NO_REST_FOR_THE_WICKED },
  Berein = { SKILL_NECROMANCY, SKILL_NECROMANCY },
  Nikolas = { SKILL_OFFENCE, PERK_TACTICS },
  Metlirn = { SKILL_AVENGER, SKILL_AVENGER },
  Gillion = { SKILL_DEFENCE, PERK_TOUGHNESS },
  Nadaur = { SKILL_LEADERSHIP, PERK_RECRUITMENT },
  Diraya = { SKILL_SUMMONING_MAGIC, PERK_MASTER_OF_CREATURES },
  Ossir = { SKILL_LUCK, PERK_RESISTANCE },
  Itil = { SKILL_LIGHT_MAGIC, PERK_MASTER_OF_BLESSING },
  Elleshar = { SKILL_LEARNING, PERK_INTELLIGENCE },
  Linaas = { SKILL_OFFENCE, PERK_TACTICS },
  Heam = { SKILL_OFFENCE, PERK_ARCHERY },
  Ildar = { SKILL_LIGHT_MAGIC, SKILL_LIGHT_MAGIC },
  GhostFSLord = { SKILL_LEARNING, SKILL_SUMMONING_MAGIC },
  Faiz = { SKILL_DARK_MAGIC, PERK_MASTER_OF_SICKNESS },
  Havez = { SKILL_WAR_MACHINES, PERK_MELT_ARTIFACT },
  Nur = { SKILL_DESTRUCTIVE_MAGIC, PERK_MASTER_OF_FIRE },
  Astral = { SKILL_SORCERY, PERK_MAGIC_BOND },
  Sufi = { SKILL_SORCERY, PERK_ARCANE_TRAINING },
  Razzak = { SKILL_LEARNING, PERK_INTELLIGENCE },
  Tan = { SKILL_LUCK, PERK_MAGIC_MIRROR },
  Isher = { SKILL_LEADERSHIP, PERK_RECRUITMENT },
  Zehir = { SKILL_SUMMONING_MAGIC, PERK_MASTER_OF_CREATURES },
  Maahir = { SKILL_ARTIFICIER, SKILL_ARTIFICIER },
  Cyrus = { SKILL_SORCERY, SKILL_SORCERY },
  Eruina = { SKILL_OFFENCE, SKILL_DESTRUCTIVE_MAGIC },
  Inagost = { SKILL_DESTRUCTIVE_MAGIC, PERK_EMPOWERED_SPELLS },
  Urunir = { SKILL_LEARNING, PERK_INTELLIGENCE },
  Almegir = { SKILL_DARK_MAGIC, PERK_DARK_RITUAL },
  Menel = { SKILL_LEADERSHIP, PERK_ESTATES },
  Dalom = { SKILL_DARK_MAGIC, PERK_MASTER_OF_SICKNESS },
  Ferigl = { SKILL_OFFENCE, PERK_FRENZY },
  Ohtarig = { SKILL_LUCK, SKILL_LUCK },
  Raelag_A1 = { SKILL_LOGISTICS, SKILL_INVOCATION },
  Kelodin = { SKILL_DEFENCE, PERK_EVASION },
  Shadwyn = { SKILL_INVOCATION, NECROMANCER_FEAT_ABSOLUTE_FEAR },
  Thralsai = { SKILL_LEARNING,  SKILL_LEARNING },
  Brand = { HERO_SKILL_RUNELORE, HERO_SKILL_FINE_RUNE },
  Bersy = { SKILL_OFFENCE, PERK_TACTICS },
  Egil = { SKILL_SORCERY, SKILL_SORCERY },
  Ottar = { SKILL_LIGHT_MAGIC, SKILL_LIGHT_MAGIC },
  Una = { SKILL_LEARNING, PERK_SCHOLAR },
  Ingvar = { SKILL_DEFENCE, PERK_TOUGHNESS },
  Vegeyr = { SKILL_DESTRUCTIVE_MAGIC, SKILL_SORCERY },
  Skeggy = { SKILL_LUCK, PERK_LUCKY_STRIKE },
  KingTolghar = { HERO_SKILL_RUNELORE, HERO_SKILL_RUNELORE },
  Wulfstan = { SKILL_LOGISTICS, PERK_PATHFINDING },
  Rolf = { SKILL_SUMMONING_MAGIC, PERK_MASTER_OF_CREATURES },
  Hero2 = { SKILL_WAR_MACHINES, PERK_FIRST_AID },
  Hero3 = { SKILL_OFFENCE, PERK_FRENZY },
  Hero6 = { SKILL_DEFENCE, PERK_TOUGHNESS },
  Hero8 = { SKILL_OFFENCE, SKILL_DEFENCE },
  Hero7 = { SKILL_OFFENCE, PERK_ARCHERY },
  Hero1 = { SKILL_OFFENCE, HERO_SKILL_POWERFULL_BLOW },
  Hero9 = { SKILL_LEADERSHIP, PERK_RECRUITMENT },
  Hero4 = { HERO_SKILL_DEMONIC_RAGE, HERO_SKILL_POWERFULL_BLOW },
  Kujin = { HERO_SKILL_BARBARIAN_LEARNING, HERO_SKILL_MEMORY_OF_OUR_BLOOD },
  Gottai = { HERO_SKILL_DEMONIC_RAGE, HERO_SKILL_VOICE },
  Quroq = { HERO_SKILL_VOICE, HERO_SKILL_VOICE_OF_RAGE },
};

-- Соотношение словарного названия героя с названия героев, выданных игрокам
MAPPING_HERO_NAME_TO_PLAYERS_HERO_NAME = {
    { dictName = "Orrin", reservedNames = { "Orrin", "Orrin2" } },
    { dictName = "Sarge", reservedNames = { "Sarge", "Sarge2" } },
    { dictName = "Mardigo", reservedNames = { "Mardigo", "Mardigo2" } },
    { dictName = "Brem", reservedNames = { "Brem", "Brem2" } },
    { dictName = "Maeve", reservedNames = { "Maeve", "Maeve2" } },
    { dictName = "Ving", reservedNames = { "Ving", "Ving2" } },
    { dictName = "Nathaniel", reservedNames = { "Nathaniel", "Nathaniel2" } },
    { dictName = "Christian", reservedNames = { "Christian", "Christian2" } },
    { dictName = "Godric", reservedNames = { "Godric", "Godric2" } },
    { dictName = "RedHeavenHero03", reservedNames = { "RedHeavenHero03", "RedHeavenHero032" } },
    { dictName = "Alaric", reservedNames = { "Alaric", "Alaric2" } },
    { dictName = "Freyda", reservedNames = { "Freyda", "Freyda2" } },
    { dictName = "Isabell_A1", reservedNames = { "Isabell_A1", "Isabell_A12" } },
    { dictName = "Duncan", reservedNames = { "Duncan", "Duncan2" } },
    { dictName = "Nicolai", reservedNames = { "Nicolai", "Nicolai2" } },
    { dictName = "Grok", reservedNames = { "Grok", "Grok2" } },
    { dictName = "Oddrema", reservedNames = {"Oddrema", "Oddrema2" } },
    { dictName = "Marder", reservedNames = { "Marder", "Marder2" } },
    { dictName = "Jazaz", reservedNames = { "Jazaz", "Jazaz2" } },
    { dictName = "Efion", reservedNames = { "Efion", "Efion2" } },
    { dictName = "Deleb", reservedNames = { "Deleb", "Deleb2" } },
    { dictName = "Calid", reservedNames = { "Calid", "Calid2" } },
    { dictName = "Nymus", reservedNames = { "Nymus", "Nymus2" } },
    { dictName = "Orlando", reservedNames = { "Orlando", "Orlando2" } },
    { dictName = "Agrael", reservedNames = { "Agrael", "Agrael2" } },
    { dictName = "Kha-Beleth", reservedNames = { "Kha-Beleth", "Kha-Beleth2" } },
    { dictName = "Nemor", reservedNames = { "Nemor", "Nemor2" } },
    { dictName = "Tamika", reservedNames = { "Tamika", "Tamika2" } },
    { dictName = "Muscip", reservedNames = { "Muscip", "Muscip2" } },
    { dictName = "Aberrar", reservedNames = { "Aberrar", "Aberrar2" } },
    { dictName = "Straker", reservedNames = { "Straker", "Straker2" } },
    { dictName = "Effig", reservedNames = { "Effig", "Effig2" } },
    { dictName = "Pelt", reservedNames = { "Pelt", "Pelt2" } },
    { dictName = "Gles", reservedNames = { "Gles", "Gles2" } },
    { dictName = "Arantir", reservedNames = { "Arantir", "Arantir2" } },
    { dictName = "OrnellaNecro", reservedNames = { "OrnellaNecro", "OrnellaNecro2" } },
    { dictName = "Berein", reservedNames = { "Berein", "Berein2" } },
    { dictName = "Nikolas", reservedNames = { "Nikolas", "Nikolas2" } },
    { dictName = "Metlirn", reservedNames = { "Metlirn", "Metlirn2" } },
    { dictName = "Gillion", reservedNames = { "Gillion", "Gillion2" } },
    { dictName = "Nadaur", reservedNames = { "Nadaur", "Nadaur2" } },
    { dictName = "Diraya", reservedNames = { "Diraya", "Diraya2" } },
    { dictName = "Ossir", reservedNames = { "Ossir", "Ossir2" } },
    { dictName = "Itil", reservedNames = { "Itil", "Itil2" } },
    { dictName = "Elleshar", reservedNames = { "Elleshar", "Elleshar2" } },
    { dictName = "Linaas", reservedNames = { "Linaas", "Linaas2" } },
    { dictName = "Heam", reservedNames = { "Heam", "Heam2" } },
    { dictName = "Ildar", reservedNames = { "Ildar", "Ildar2" } },
    { dictName = "GhostFSLord", reservedNames = { "GhostFSLord", "GhostFSLord2" } },
    { dictName = "Faiz", reservedNames = { "Faiz", "Faiz2" } },
    { dictName = "Havez", reservedNames = { "Havez", "Havez2" } },
    { dictName = "Nur", reservedNames = { "Nur", "Nur2" } },
    { dictName = "Astral", reservedNames = { "Astral", "Astral2" } },
    { dictName = "Sufi", reservedNames = { "Sufi", "Sufi2" } },
    { dictName = "Razzak", reservedNames = { "Razzak", "Razzak2" } },
    { dictName = "Tan", reservedNames = { "Tan", "Tan2" } },
    { dictName = "Isher", reservedNames = { "Isher", "Isher2" } },
    { dictName = "Zehir", reservedNames = { "Zehir", "Zehir2" } },
    { dictName = "Maahir", reservedNames = { "Maahir", "Maahir2" } },
    { dictName = "Cyrus", reservedNames = { "Cyrus", "Cyrus2" } },
    { dictName = "Eruina", reservedNames = { "Eruina", "Eruina2" } },
    { dictName = "Inagost", reservedNames = { "Inagost", "Inagost2" } },
    { dictName = "Urunir", reservedNames = { "Urunir", "Urunir2" } },
    { dictName = "Almegir", reservedNames = { "Almegir", "Almegir2" } },
    { dictName = "Menel", reservedNames = { "Menel", "Menel2" } },
    { dictName = "Dalom", reservedNames = { "Dalom", "Dalom2" } },
    { dictName = "Ferigl", reservedNames = { "Ferigl", "Ferigl2" } },
    { dictName = "Ohtarig", reservedNames = { "Ohtarig", "Ohtarig2" } },
    { dictName = "Raelag_A1", reservedNames = { "Raelag_A1", "Raelag_A12" } },
    { dictName = "Kelodin", reservedNames = { "Kelodin", "Kelodin2" } },
    { dictName = "Shadwyn", reservedNames = { "Shadwyn", "Shadwyn2" } },
    { dictName = "Thralsai", reservedNames = { "Thralsai", "Thralsai2" } },
    { dictName = "Ohtarig", reservedNames = { "Ohtarig", "Ohtarig2" } },
    { dictName = "Brand", reservedNames = { "Brand", "Brand2" } },
    { dictName = "Bersy", reservedNames = { "Bersy", "Bersy2" } },
    { dictName = "Egil", reservedNames = { "Egil", "Egil2" } },
    { dictName = "Ottar", reservedNames = { "Ottar", "Ottar2" } },
    { dictName = "Una", reservedNames = { "Una", "Una2" } },
    { dictName = "Ingvar", reservedNames = { "Ingvar", "Ingvar2" } },
    { dictName = "Vegeyr", reservedNames = { "Vegeyr", "Vegeyr2" } },
    { dictName = "Skeggy", reservedNames = { "Skeggy", "Skeggy2" } },
    { dictName = "KingTolghar", reservedNames = { "KingTolghar", "KingTolghar2" } },
    { dictName = "Wulfstan", reservedNames = { "Wulfstan", "Wulfstan2" } },
    { dictName = "Rolf", reservedNames = { "Rolf", "Rolf2" } },
    { dictName = "Hero2", reservedNames = { "Hero2", "Hero22" } },
    { dictName = "Hero3", reservedNames = { "Hero3", "Hero32" } },
    { dictName = "Hero6", reservedNames = { "Hero6", "Hero62" } },
    { dictName = "Hero8", reservedNames = { "Hero8", "Hero82" } },
    { dictName = "Hero7", reservedNames = { "Hero7", "Hero72" } },
    { dictName = "Hero1", reservedNames = { "Hero1", "Hero12" } },
    { dictName = "Hero9", reservedNames = { "Hero9", "Hero92" } },
    { dictName = "Hero4", reservedNames = { "Hero4", "Hero42" } },
    { dictName = "Kujin", reservedNames = { "Kujin", "Kujin2" } },
    { dictName = "Gottai", reservedNames = { "Gottai", "Gottai2" } },
    { dictName = "Quroq", reservedNames = { "Quroq", "Quroq2" } },
};

-- Уровни ценности артефактов (Потом, наверно, пригодится)
ARTS_LEVELS = {
  MINOR = 0,
  MAJOR = 1,
  RELIC = 2
};

-- Позиция артефакта в инвентаре
ART_POSITION = {
  RING = 1,
  HEAD = 2,
  NECK = 3,
  BODY = 4,
  SHILD = 5,
  BAG = 6,
  WEAPON = 7,
  BOOTS = 8,
  BACK = 9,
};

-- Список всех доступных артефактов
ALL_ARTS_LIST = {
  { id = 1,  level = ARTS_LEVELS.MINOR, position = ART_POSITION.WEAPON,  price = 5000 }, --меч мощи
  { id = 90, level = ARTS_LEVELS.MINOR, position = ART_POSITION.WEAPON,  price = 6500 }, -- на грани равновесия
  { id = 8,  level = ARTS_LEVELS.MINOR, position = ART_POSITION.BAG,     price = 4000 }, -- клевер
  { id = 87, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BAG,     price = 6000 }, -- колода таро
  { id = 27, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BOOTS,   price = 5000 }, -- сапоги магической защиты
  -- { id = 34, level = ARTS_LEVELS.MINOR, position = ART_POSITION.HEAD, price = 6000 }, -- тюрбан просвещенности
  { id = 66, level = ARTS_LEVELS.MINOR, position = ART_POSITION.HEAD,    price = 6000 }, -- шлем хаоса
  { id = 64, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BODY,    price = 6000 }, -- туника из плоти
  { id = 14, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BODY,    price = 5000 }, -- нагрудник мощи
  { id = 80, level = ARTS_LEVELS.MINOR, position = ART_POSITION.WEAPON,  price = 5000 }, -- палочка новичка

  { id = 84, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BACK,    price = 4500 }, -- защитные покровы
  { id = 20, level = ARTS_LEVELS.MINOR, position = ART_POSITION.RING,    price = 6000 }, -- кольцо от молний
  { id = 60, level = ARTS_LEVELS.MINOR, position = ART_POSITION.RING,    price = 5000 }, -- пояс элементалей
  { id = 16, level = ARTS_LEVELS.MINOR, position = ART_POSITION.NECK,    price = 4000 }, -- ошейник льва
  { id = 55, level = ARTS_LEVELS.MINOR, position = ART_POSITION.HEAD,    price = 5000 }, -- шлем некроманта
  { id = 10, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BAG,     price = 5000 }, -- свиток маны
  { id = 56, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BODY,    price = 6000 }, -- доспех бесстрашия
  { id = 85, level = ARTS_LEVELS.MINOR, position = ART_POSITION.WEAPON,  price = 6000 }, -- гномий молот
  { id = 65, level = ARTS_LEVELS.MINOR, position = ART_POSITION.RING,    price = 7000 }, -- кольцо предостережения
  { id = 62, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BACK,    price = 7000 }, -- плащ силанны
  { id = 93, level = ARTS_LEVELS.MINOR, position = ART_POSITION.RING,    price = 6000 }, -- кольцо изгнания

  -- { id = 86, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BAG,  price = 6500 }, -- руна пламени
  -- { id = 61, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BOOTS,  price = 8000 }, -- изумрудные туфли
  -- { id = 32, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BACK,   price = 8000 }, -- накидка феникса
--  { id = 70, level = ARTS_LEVELS.MINOR, position = ART_POSITION.RING,    price = 4000 }, -- кольцо грешников

  { id = 31, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BACK,      price = 8000 }, -- накидка льва
  { id = 95, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BACK,      price = 8000 }, -- колчан единорога
  { id = 4,  level = ARTS_LEVELS.MAJOR, position = ART_POSITION.WEAPON,    price = 8000 }, -- лук единорога
  { id = 63, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.RING,      price = 8000 }, --кольцо неудачи (проклятое кольцо)
  { id = 21, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.RING,      price = 8000 }, -- кольцо жизненной силы
  { id = 25, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BAG,       price = 8000 }, -- золотая подкова
  { id = 58, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.SHILD,     price = 8000 }, -- лунный клинок

  -- { id = 35, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BODY,   price = 6500 }, -- кольчуга просвещенности
  { id = 9,  level = ARTS_LEVELS.MAJOR, position = ART_POSITION.SHILD,     price = 10000 }, -- ледяной щит
  { id = 88, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.HEAD,      price = 9000 }, -- корона лидерства
  { id = 41, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.HEAD,      price = 9500 }, -- шлем дракона
  { id = 39, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BACK,      price = 9500 }, -- мантия дракона
  { id = 5,  level = ARTS_LEVELS.MAJOR, position = ART_POSITION.WEAPON,    price = 9500 }, -- трезубец титанов
  { id = 18, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.NECK,      price = 9500 }, -- ледяной кулон
  
  { id = 81, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.WEAPON,    price = 10000 }, -- рунный топор
  { id = 2,  level = ARTS_LEVELS.MAJOR, position = ART_POSITION.WEAPON,    price = 11000 },  -- секира горного короля
  { id = 74, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.WEAPON,    price = 10000 }, -- дубина орка
  { id = 75, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.SHILD,     price = 10000 }, -- щит орка

  { id = 37, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.SHILD,     price = 10500 }, -- щит дракона
  { id = 38, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BOOTS,     price = 10500 }, -- поножи дракона
  { id = 82, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BODY,      price = 10000 }, -- рунная упряжь
  { id = 36, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BODY,      price = 10500 }, -- доспех дракона
  { id = 23, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.RING,      price = 10500 }, -- кольцо сломленного духа
  { id = 19, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.NECK,      price = 10000 }, -- ожерелье победы
  { id = 40, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.NECK,      price = 10500 }, -- ожерелье дракона
  { id = 45, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.WEAPON,    price = 10000 }, -- посох сар-иссы
  { id = 67, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.NECK,      price = 10000 }, -- кулон поглощения
  { id = 50, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.HEAD,      price = 11000 }, -- шлем гномов
  
  { id = 48, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BODY,      price = 12000 }, -- кираса гномов
  { id = 51, level = ARTS_LEVELS.RELIC, position = ART_POSITION.SHILD,     price = 12000 }, -- щит гномов
  { id = 42, level = ARTS_LEVELS.RELIC, position = ART_POSITION.RING,      price = 12000 }, -- кольцо дракона
  { id = 43, level = ARTS_LEVELS.RELIC, position = ART_POSITION.WEAPON,    price = 12500 }, -- меч дракона
  { id = 17, level = ARTS_LEVELS.RELIC, position = ART_POSITION.NECK,      price = 12000 }, -- ожерелье коготь
  { id = 59, level = ARTS_LEVELS.RELIC, position = ART_POSITION.RING,      price = 13000 }, -- кольцо стремительности
  { id = 57, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BOOTS,     price = 12500 }, -- сапоги скорости
  { id = 46, level = ARTS_LEVELS.RELIC, position = ART_POSITION.HEAD,      price = 12000 }, -- корона сар-иссы

  { id = 68, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BOOTS,     price = 13500 }, -- сандали святого
  { id = 49, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BOOTS,     price = 13500 }, -- поножи гномов
  { id = 11, level = ARTS_LEVELS.RELIC, position = ART_POSITION.HEAD,      price = 14000 }, -- корона льва
  { id = 47, level = ARTS_LEVELS.RELIC, position = ART_POSITION.RING,      price = 14000 }, -- кольцо сар-иссы
  { id = 7,  level = ARTS_LEVELS.RELIC, position = ART_POSITION.WEAPON,    price = 14000 }, -- посох преисподней (кандалы неизбежности)
  { id = 33, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BACK,      price = 17000 }, -- плащ смерти
  { id = 44, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BODY,      price = 17000 }, -- халат сар-иссы
  { id = 71, level = ARTS_LEVELS.RELIC, position = ART_POSITION.SHILD,     price = 17000 }, -- том силы (амулет некроманта)
  { id = 83, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BAG,       price = 18000 }, -- череп маркела
  { id = 76, level = ARTS_LEVELS.RELIC, position = ART_POSITION.SHILD,     price = 18000 }, -- том хаоса
  { id = 79, level = ARTS_LEVELS.RELIC, position = ART_POSITION.SHILD,     price = 18000 }, -- том призыва
  { id = 77, level = ARTS_LEVELS.RELIC, position = ART_POSITION.SHILD,     price = 18000 }, -- том света
  { id = 13, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BODY,      price = 22000 }, -- доспех забытого
  { id = 78, level = ARTS_LEVELS.RELIC, position = ART_POSITION.SHILD,     price = 24000 }, -- том тьмы
  -- { id = 91, level = ARTS_LEVELS.RELIC, position = ART_POSITION.RING,   price = 20000 }, -- кольцо машин
  -- { id = 15, level = ARTS_LEVELS.RELIC, position = ART_POSITION.NECK,   price = 15000 }, -- кулон мастерства
  -- { id = 6, level = ARTS_LEVELS.RELIC, position = ART_POSITION.WEAPON,  price = 35000 }, -- посох преисподней
  -- { id = 89, level = ARTS_LEVELS.RELIC, position = ART_POSITION.HEAD,   price = 26000 }, -- маска справедливости
  -- { id = 69, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BACK,   price = 16000 }, -- плащ сандро
  -- { id = 22, level = ARTS_LEVELS.RELIC, position = ART_POSITION.RING,   price = 30000 }, -- кольцо скорости
};

-- Перечисление всех героев
HEROES = {
  ELLESHAR = 'Elleshar',               -- Винраэль
  NATHANIEL = 'Nathaniel',             -- Эллайна
  UNA = 'Una',                         -- Инга
  DUNCAN ='Duncan',                    -- Дункан
  NIKOLAS = 'Nikolas',                 -- Николас
  ABERRAR = 'Aberrar',                 -- Золтан
  VEGEYR = 'Vegeyr',                   -- Свея
  RED_HEAVEN_HERO = 'RedHeavenHero03', -- Валерия
  ALARIC = 'Alaric',                   -- Аларик
  ROLF = 'Rolf',                       -- Ролф
  ALMEGIR = 'Almegir',                 -- Ирбет
  MAAHIR = 'Maahir',                   -- Маахир
  CYRUS = 'Cyrus',                     -- Сайрус
  BEREIN = 'Berein',                   -- Маркел
  TAN = 'Tan',                         -- Джалиб
  NARHIZ = 'Razzak',                   -- Нархиз
  ILDAR = 'Ildar',                     -- Аларон
  JAZAZ = 'Jazaz',                     -- Ниброс
  BREM = 'Brem',                       -- Рутгер
  SHADWYN = 'Shadwyn',                 -- Илайя
  KIGAN = 'Hero9',                     -- Киган
  ORLANDO = 'Orlando',                 -- Орландо
  BRAND = 'Brand',                     -- Бранд
  NADAUR = 'Nadaur',                   -- Таланар
  HEAM = 'Heam',                       -- Файдаэн
  ERUINA = 'Eruina',                   -- Эрин
  FERIGL = 'Ferigl',                   -- Соргал
  WULFSTAN = 'Wulfstan',               -- Вульфстен
  GROK = 'Grok',                       -- Грок
  MARDER = 'Marder',                   -- Марбас
  KUJIN = 'Kujin',                     -- Куджин
  VAYSHAN = 'Ohtarig',                 -- Вайшан
  QUROQ = 'Quroq'                      -- Курак
};


-- Соотношение игроков к подконтрольным им городам
MAP_PLAYER_TO_TOWNNAME = {
  [PLAYER_1] = 'RANDOMTOWN1',
  [PLAYER_2] = 'RANDOMTOWN2',
}

-- Сгенерированный набор заклинаний для
-- 2 Набора основных заклинаний для возможности покупки второго набора
PLAYERS_GENERATED_SPELLS = {
  [PLAYER_1] = {
    countResetSpells = 0,
    countResetRunes = 0,
    bonus_spells = {},
    tier_spells_reroll = 0,
    spells = {
      {},
      {},
    },
    runes = {
      {},
      {},
    },
  },
  [PLAYER_2] = {
    countResetSpells = 0,
    countResetRunes = 0,
    bonus_spells = {},
    tier_spells_reroll = 0,
    spells = {
      {},
      {},
    },
    runes = {
      {},
      {},
    },
  },
};

-- Список сгенерированных войск в городах игроков
-- Индекс юнита равен его уровню
RESULT_ARMY_INTO_TOWN = {
  [PLAYER_1] = {},
  [PLAYER_2] = {},
};


-- Список юнитов, для генерации в городе
UNITS = {
  [RACES.NEUTRAL] = {
    { kol = 80, id =113, price1 =  150, power =  355, lvl = 1 },
    { kol = 50, id = 85, price1 =  400, power =  829, lvl = 4 },
    { kol = 50, id = 86, price1 =  400, power =  795, lvl = 4 },
    { kol = 50, id = 88, price1 =  400, power =  813, lvl = 4 },
    { kol = 50, id = 87, price1 =  400, power =  856, lvl = 4 },
    { kol = 30, id =116, price1 =  400, power = 1542, lvl = 5 },
    { kol = 18, id = 89, price1 = 1700, power = 2560, lvl = 6 },
    { kol = 18, id =115, price1 = 1700, power = 2523, lvl = 6 },
    { kol =  5, id = 91, price1 = 6000, power = 8576, lvl = 7 }
  },
  [RACES.HAVEN] = {
    { kol =338, id =  1, price1 =   35, power =   72, lvl = 1 },
    { kol =144, id =  3, price1 =  120, power =  199, lvl = 2 },
    { kol =100, id =  5, price1 =  160, power =  287, lvl = 3 },
    { kol = 45, id =  7, price1 =  400, power =  716, lvl = 4 },
    { kol = 24, id =  9, price1 =  650, power = 1487, lvl = 5 },
    { kol = 14, id = 11, price1 = 1350, power = 2520, lvl = 6 },
    { kol =  6, id = 13, price1 = 3200, power = 6003, lvl = 7 },
    { kol =338, id =  2, price1 =   35, power =   72, lvl = 1 },
    { kol =144, id =  4, price1 =  120, power =  199, lvl = 2 },
    { kol =100, id =  6, price1 =  160, power =  287, lvl = 3 },
    { kol = 45, id =  8, price1 =  400, power =  716, lvl = 4 },
    { kol = 24, id = 10, price1 =  650, power = 1487, lvl = 5 },
    { kol = 14, id = 12, price1 = 1350, power = 2520, lvl = 6 },
    { kol =  6, id = 14, price1 = 3200, power = 6003, lvl = 7 },
    { kol =338, id =106, price1 =   35, power =   72, lvl = 1 },
    { kol =144, id =107, price1 =  120, power =  199, lvl = 2 },
    { kol =100, id =108, price1 =  160, power =  287, lvl = 3 },
    { kol = 45, id =109, price1 =  400, power =  716, lvl = 4 },
    { kol = 24, id =110, price1 =  650, power = 1487, lvl = 5 },
    { kol = 14, id =111, price1 = 1350, power = 2520, lvl = 6 },
    { kol =  6, id =112, price1 = 3200, power = 6003, lvl = 7 }
  },
  [RACES.INFERNO] = {
    { kol =224, id = 15, price1 =   70, power =  124, lvl = 1 },
    { kol =188, id = 17, price1 =   90, power =  149, lvl = 2 },
    { kol = 80, id = 19, price1 =  200, power =  338, lvl = 3 },
    { kol = 45, id = 21, price1 =  400, power =  680, lvl = 4 },
    { kol = 27, id = 23, price1 =  800, power = 1415, lvl = 5 },
    { kol = 14, id = 25, price1 = 1300, power = 2360, lvl = 6 },
    { kol =  6, id = 27, price1 = 2666, power = 5850, lvl = 7 },
    { kol =224, id = 16, price1 =   70, power =  124, lvl = 1 },
    { kol =188, id = 18, price1 =   90, power =  149, lvl = 2 },
    { kol = 80, id = 20, price1 =  200, power =  338, lvl = 3 },
    { kol = 45, id = 22, price1 =  400, power =  680, lvl = 4 },
    { kol = 27, id = 24, price1 =  800, power = 1415, lvl = 5 },
    { kol = 14, id = 26, price1 = 1300, power = 2360, lvl = 6 },
    { kol =  6, id = 28, price1 = 2666, power = 5850, lvl = 7 },
    { kol =224, id =131, price1 =   70, power =  124, lvl = 1 },
    { kol =188, id =132, price1 =   90, power =  149, lvl = 2 },
    { kol = 80, id =133, price1 =  200, power =  338, lvl = 3 },
    { kol = 45, id =134, price1 =  400, power =  680, lvl = 4 },
    { kol = 27, id =135, price1 =  800, power = 1415, lvl = 5 },
    { kol = 14, id =136, price1 = 1300, power = 2360, lvl = 6 },
    { kol =  6, id =137, price1 = 2666, power = 5850, lvl = 7 }
  },
  [RACES.NECROPOLIS] = {
    { kol =304, id = 29, price1 =   60, power =   84, lvl = 1 },
    { kol =180, id = 31, price1 =   80, power =  145, lvl = 2 },
    { kol = 90, id = 33, price1 =  180, power =  327, lvl = 3 },
    { kol = 45, id = 35, price1 =  450, power =  739, lvl = 4 },
    { kol = 24, id = 37, price1 =  750, power = 1539, lvl = 5 },
    { kol = 14, id = 39, price1 = 1200, power = 2449, lvl = 6 },
    { kol =  8, id = 41, price1 = 2200, power = 3872, lvl = 7 },
    { kol =304, id = 30, price1 =   60, power =   84, lvl = 1 },
    { kol =180, id = 32, price1 =   80, power =  145, lvl = 2 },
    { kol = 90, id = 34, price1 =  180, power =  327, lvl = 3 },
    { kol = 45, id = 36, price1 =  450, power =  739, lvl = 4 },
    { kol = 24, id = 38, price1 =  750, power = 1539, lvl = 5 },
    { kol = 14, id = 40, price1 = 1200, power = 2449, lvl = 6 },
    { kol =  8, id = 42, price1 = 2200, power = 3872, lvl = 7 },
    { kol =304, id =152, price1 =   60, power =   84, lvl = 1 },
    { kol =180, id =153, price1 =   80, power =  145, lvl = 2 },
    { kol = 90, id =154, price1 =  180, power =  327, lvl = 3 },
    { kol = 45, id =155, price1 =  450, power =  739, lvl = 4 },
    { kol = 24, id =156, price1 =  750, power = 1539, lvl = 5 },
    { kol = 14, id =157, price1 = 1200, power = 2449, lvl = 6 },
    { kol =  8, id =158, price1 = 2200, power = 3872, lvl = 7 }
  },
  [RACES.SYLVAN] = {
    { kol =170, id = 43, price1 =   75, power =  169, lvl = 1 },
    { kol =108, id = 45, price1 =  150, power =  308, lvl = 2 },
    { kol = 70, id = 47, price1 =  280, power =  433, lvl = 3 },
    { kol = 36, id = 49, price1 =  440, power =  846, lvl = 4 },
    { kol = 24, id = 51, price1 =  750, power = 1441, lvl = 5 },
    { kol = 16, id = 53, price1 = 1150, power = 1993, lvl = 6 },
    { kol =  6, id = 55, price1 = 3200, power = 5905, lvl = 7 },
    { kol =170, id = 44, price1 =   75, power =  169, lvl = 1 },
    { kol =108, id = 46, price1 =  150, power =  308, lvl = 2 },
    { kol = 70, id = 48, price1 =  280, power =  433, lvl = 3 },
    { kol = 36, id = 50, price1 =  440, power =  846, lvl = 4 },
    { kol = 24, id = 52, price1 =  750, power = 1441, lvl = 5 },
    { kol = 16, id = 54, price1 = 1150, power = 1993, lvl = 6 },
    { kol =  6, id = 56, price1 = 3200, power = 5905, lvl = 7 },
    { kol =170, id =145, price1 =   75, power =  169, lvl = 1 },
    { kol =108, id =146, price1 =  150, power =  308, lvl = 2 },
    { kol = 70, id =147, price1 =  280, power =  433, lvl = 3 },
    { kol = 36, id =148, price1 =  440, power =  846, lvl = 4 },
    { kol = 24, id =149, price1 =  750, power = 1441, lvl = 5 },
    { kol = 16, id =150, price1 = 1150, power = 1993, lvl = 6 },
    { kol =  6, id =151, price1 = 3200, power = 5905, lvl = 7 }
  },
  [RACES.ACADEMY] = {
    { kol =280, id = 57, price1 =   55, power =  105, lvl = 1 },
    { kol =168, id = 59, price1 =  95, power =  172, lvl = 2 },
    { kol = 90, id = 61, price1 =  170, power =  355, lvl = 3 },
    { kol = 45, id = 63, price1 =  380, power =  642, lvl = 4 },
    { kol = 30, id = 65, price1 =  550, power = 1096, lvl = 5 },
    { kol = 14, id = 67, price1 = 1500, power = 2535, lvl = 6 },
    { kol =  6, id = 69, price1 = 3300, power = 6095, lvl = 7 },
    { kol =280, id = 58, price1 =   55, power =  105, lvl = 1 },
    { kol =168, id = 60, price1 =  95, power =  172, lvl = 2 },
    { kol = 90, id = 62, price1 =  170, power =  355, lvl = 3 },
    { kol = 45, id = 64, price1 =  380, power =  642, lvl = 4 },
    { kol = 30, id = 66, price1 =  550, power = 1096, lvl = 5 },
    { kol = 14, id = 68, price1 = 1500, power = 2535, lvl = 5 },
    { kol =  6, id = 70, price1 = 3300, power = 6095, lvl = 5 },
    { kol =280, id =159, price1 =   55, power =  105, lvl = 1 },
    { kol =168, id =160, price1 =  95, power =  172, lvl = 2 },
    { kol = 90, id =161, price1 =  170, power =  355, lvl = 3 },
    { kol = 45, id =162, price1 =  380, power =  642, lvl = 4 },
    { kol = 30, id =163, price1 =  550, power = 1096, lvl = 5 },
    { kol = 14, id =164, price1 = 1500, power = 2535, lvl = 6 },
    { kol =  6, id =165, price1 = 3300, power = 6095, lvl = 7 }
  },
  [RACES.DUNGEON] = {
    { kol = 126, id = 71, price1 =  130, power =  290, lvl = 1 },               --92
    { kol = 85, id = 73, price1 =  200, power =  477, lvl = 2 },
    { kol = 72, id = 75, price1 =  210, power =  474, lvl = 3 },
    { kol = 38, id = 77, price1 =  420, power =  812, lvl = 4 },
    { kol = 24, id = 79, price1 =  750, power = 1324, lvl = 5 },
    { kol = 14, id = 81, price1 = 1100, power = 2537, lvl = 6 },
    { kol =  6, id = 83, price1 = 3600, power = 6389, lvl = 7 },
    { kol = 126, id = 92, price1 =  130, power =  290, lvl = 1 },
    { kol = 85, id = 74, price1 =  200, power =  477, lvl = 2 },
    { kol = 72, id = 76, price1 =  210, power =  474, lvl = 3 },
    { kol = 38, id = 78, price1 =  420, power =  812, lvl = 4 },
    { kol = 24, id = 80, price1 =  750, power = 1324, lvl = 5 },
    { kol = 14, id = 82, price1 = 1100, power = 2537, lvl = 6 },
    { kol =  6, id = 84, price1 = 3600, power = 6389, lvl = 7 },
    { kol = 126, id =166, price1 =  130, power =  290, lvl = 1 },
    { kol = 85, id =139, price1 =  200, power =  477, lvl = 2 },
    { kol = 72, id =140, price1 =  210, power =  474, lvl = 3 },
    { kol = 38, id =141, price1 =  420, power =  812, lvl = 4 },
    { kol = 24, id =142, price1 =  750, power = 1324, lvl = 5 },
    { kol = 14, id =143, price1 = 1100, power = 2537, lvl = 6 },
    { kol =  6, id =144, price1 = 3600, power = 6389, lvl = 7 }
  },
  [RACES.FORTRESS] = {
    { kol =252, id = 92, price1 =   65, power =  115, lvl = 1 },
    { kol =168, id = 94, price1 =   90, power =  171, lvl = 2 },        --71
    { kol = 70, id = 96, price1 =  240, power =  419, lvl = 3 },        --138
    { kol = 66, id = 98, price1 =  250, power =  434, lvl = 4 },
    { kol = 27, id =100, price1 =  650, power = 1308, lvl = 5 },
    { kol = 14, id =102, price1 = 1400, power = 2437, lvl = 6 },
    { kol =  6, id =104, price1 = 3200, power = 6070, lvl = 7 },
    { kol =252, id = 71, price1 =   65, power =  115, lvl = 1 },        --93
    { kol =168, id = 95, price1 =   90, power =  171, lvl = 2 },
    { kol = 70, id = 97, price1 =  240, power =  419, lvl = 3 },
    { kol = 66, id = 99, price1 =  250, power =  434, lvl = 4 },
    { kol = 27, id =101, price1 =  650, power = 1308, lvl = 5 },
    { kol = 14, id =103, price1 = 1400, power = 2437, lvl = 6 },
    { kol =  6, id =105, price1 = 3200, power = 6070, lvl = 7 },
    { kol =252, id =138, price1 =   65, power =  115, lvl = 1 },        --166
    { kol =168, id =167, price1 =   90, power =  171, lvl = 2 },
    { kol = 70, id =168, price1 =  240, power =  419, lvl = 3 },
    { kol = 66, id =169, price1 =  250, power =  434, lvl = 4 },
    { kol = 27, id =170, price1 =  650, power = 1308, lvl = 5 },
    { kol = 14, id =171, price1 = 1400, power = 2437, lvl = 6 },
    { kol =  6, id =172, price1 = 3200, power = 6070, lvl = 7 }
  },
  [RACES.STRONGHOLD] = {
    { kol =374, id =117, price1 =   35, power =   66, lvl = 1 },
    { kol =168, id =119, price1 =  115, power =  174, lvl = 2 },
    { kol =110, id =121, price1 =  140, power =  254, lvl = 3 },
    { kol = 45, id =123, price1 =  400, power =  680, lvl = 4 },
    { kol = 40, id =125, price1 =  550, power =  895, lvl = 5 },
    { kol = 14, id =127, price1 = 1000, power = 2571, lvl = 6 },
    { kol =  6, id =129, price1 = 3000, power = 5937, lvl = 7 },
    { kol =374, id =118, price1 =   35, power =   66, lvl = 1 },
    { kol =168, id =120, price1 =  115, power =  174, lvl = 2 },
    { kol =110, id =122, price1 =  140, power =  254, lvl = 3 },
    { kol = 45, id =124, price1 =  400, power =  680, lvl = 4 },
    { kol = 40, id =126, price1 =  550, power =  895, lvl = 5 },
    { kol = 14, id =128, price1 = 1000, power = 2571, lvl = 6 },
    { kol =  6, id =130, price1 = 3000, power = 5937, lvl = 7 },
    { kol =374, id =173, price1 =   35, power =   66, lvl = 1 },
    { kol =168, id =174, price1 =  115, power =  174, lvl = 2 },
    { kol =110, id =175, price1 =  140, power =  254, lvl = 3 },
    { kol = 45, id =176, price1 =  400, power =  680, lvl = 4 },
    { kol = 40, id =177, price1 =  550, power =  895, lvl = 5 },
    { kol = 14, id =178, price1 = 1000, power = 2571, lvl = 6 },
    { kol =  6, id =179, price1 = 3000, power = 5937, lvl = 7 }
  }
};

-- Количество опыта, необходимое для достижения необходимого уровня от первого
-- Значения из мануала
TOTAL_EXPERIENCE_BY_LEVEL = {
  0,                      -- 1
  1000,                   -- 2
  2000,                   -- 3
  3200,                   -- 4
  4600,                   -- 5
  6200,                   -- 6
  8000,                   -- 7
  10000,                  -- 8
  12200,                  -- 9
  14700,                  -- 10
  17500,                  -- 11
  20600,                  -- 12
  24320,                  -- 13
  28784,                  -- 14
  34140,                  -- 15
  40567,                  -- 16
  48279,                  -- 17
  57533,                  -- 18
  68637,                  -- 19
  81961,                  -- 20
  97949,                  -- 21
  117134,                 -- 22
  140156,                 -- 23
  167782,                 -- 24
  200933,                 -- 25
  244029,                 -- 26
  304363,                 -- 27
  394864,                 -- 28
  539665,                 -- 29
  785826,                 -- 30
  1228915,                -- 31
  2070784,                -- 32
  3754522,                -- 33
  7290371,                -- 34
  15069240,               -- 35
  32960630,               -- 36
  75899970,               -- 37
  183258314,              -- 38
  462353978,              -- 39
  1215939194              -- 40
};

-- Количество использования ментора игроками
MENTOR_USAGE_COUNTER = {
  players_value = {
    [PLAYER_1] = 0,
    [PLAYER_2] = 0,
  },

  iterate = function(playerId)
    MENTOR_USAGE_COUNTER.players_value[playerId] = MENTOR_USAGE_COUNTER.players_value[playerId] + 1;
  end,
};

-- Список сгенерированных войск в городах игроков
-- Индекс юнита равен его уровню
RESULT_ARMY_INTO_TOWN = {
  [PLAYER_1] = {},
  [PLAYER_2] = {},
};

MENTOR_LAST_SKILL = {
  [PLAYER_1] = {},
  [PLAYER_2] = {},
}