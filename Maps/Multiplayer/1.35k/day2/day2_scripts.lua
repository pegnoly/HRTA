-- Путь до текущей папки
local MODULE_PATH = GetMapDataPath().."day2/";
-- Путь до папки с текстом уведомлений
local PATH_TO_MODULE_MESSAGES = MODULE_PATH.."messages/";

-- Биара (герой красного)
local Biara = GetPlayerHeroes(PLAYER_1)[0]
-- Джованни (негой синего)
local Djovanni = GetPlayerHeroes(PLAYER_2)[0]

-- черк матчапов
if GAME_MODE.MATCHUPS then
   addHeroMovePoints(Biara);
   addHeroMovePoints(Djovanni);

   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."cherk_matchups.txt", Biara, 1, 5.0);
   ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."cherk_matchups.txt", Djovanni, 2, 5.0);
end;

--
if GAME_MODE.HALF then
  addHeroMovePoints(Biara);
  removeHeroMovePoints(Djovanni);

  ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."choose_race.txt", Biara, 1, 5.0);
end;

-- получерк
if GAME_MODE.MIX then
  addHeroMovePoints(Biara);
  addHeroMovePoints(Djovanni);

  --ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."start_cherk.txt", Djovanni, 1, 5.0);

--  doFile(PATH_TO_DAY1_MODULE.."choice_of_races/mix.lua");
end;

-- простой выбор
if GAME_MODE.SIMPLE_CHOOSE then
  addHeroMovePoints(Biara);
  addHeroMovePoints(Djovanni);

  ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."simple_choose_race.txt", Biara, 1, 7.0);
  ShowFlyingSign(PATH_TO_MODULE_MESSAGES.."simple_choose_race.txt", Djovanni, 2, 7.0);
end;
