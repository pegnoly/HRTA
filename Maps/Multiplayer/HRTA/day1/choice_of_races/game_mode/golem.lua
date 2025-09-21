-- Устанавливаем голема и навешиваем триггер
function showGolem()
  print "showGolem"

  SetObjectEnabled('golem', nil);
  SetObjectPosition('red10', 1, 1, UNDERGROUND);
  SetObjectPosition('golem', 35, 83);
  SetDisabledObjectMode('golem', DISABLED_INTERACT);
  Trigger(OBJECT_TOUCH_TRIGGER, 'golem', 'questionAuctionMode');
end;

-- Вопрос выбора нового режима - Торги
function questionAuctionMode()
  print "questionAuctionMode"


  QuestionBoxForPlayers(GetPlayerFilter(PLAYER_1), PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/question_auction_mode.txt", 'prepareForAuctionMode', 'questionPickHeroOnlyMode');
end;

-- Вопрос выбора режима выбора только героя
function questionPickHeroOnlyMode()
  print "questionPickHeroOnlyMode"

  QuestionBoxForPlayers(GetPlayerFilter(PLAYER_1), PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/question_enable_game_mode_only_pick_hero.txt", 'prepareForPickHeroOnlyMode', 'questionTroubledTime');
end;

-- Вопрос выбора режима Смутного времени
function questionTroubledTime()
  print "questionTroubledTime"

  QuestionBoxForPlayers(GetPlayerFilter(PLAYER_1), PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/question_troubled_time_mode.txt", 'prepareForTroubledTimeVar2', 'questionRandomPickHeroModeNoMentor');
end;

-- Вопрос выбора режима случайного выбора героя без наставника
function questionRandomPickHeroModeNoMentor()
  print "questionRandomPickHeroModeNoMentor"

  QuestionBoxForPlayers(GetPlayerFilter(PLAYER_1), PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/question_enable_random_pickHero_no_mentor.txt", 'prepareForRandomPickHeroMode', 'noop');
end;



-- Подготовка к режиму Аукцион
function prepareForAuctionMode()
  print "prepareForAuctionMode"

  prepareForRandomChoise();
 -- SetObjectPosition('golem', 19, 45);
 -- SetObjectPosition('red10', 35, 83, GROUND);
  CUSTOM_GAME_MODE_AUCTION = 1;
 -- CUSTOM_GAME_MODE_ONLY_PICK_SINGLE_HERO = 1;

end;

-- Подготовка к моду Смутное время
function prepareForTroubledTime()
  print "prepareForTroubledTime"

  SetObjectPosition('golem', 19, 45);
  SetObjectPosition('red10', 35, 83, GROUND);

  -- Установка настройки для нового режима
  CUSTOM_GAME_MODE_TROUBLED_TIME = 2;  -- Смещение номера на 2
  CUSTOM_GAME_MODE_TROUBLED_TIME_TIER = 1 + random(7);
  CUSTOM_GAME_MODE_ONLY_CHERK_SINGLE_HEROES = 1;

  SetObjectPosition(Biara, 35, 87);
  SetObjectPosition(Djovanni, 42, 22);

  MessageBoxForPlayers(playerId, {PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/message_troubled_time.txt"; eq = CUSTOM_GAME_MODE_TROUBLED_TIME_TIER }, 'showFlyingTroubledTime');

  RemoveObject('mumiya');
--  moveDelimetersToRandomChoise();
  deleteAllRacesUnit();
  doFile(PATH_TO_DAY1_MODULE.."choice_of_races/matchups.lua");

end;

function showFlyingTroubledTime()
  print "showFlyingTroubledTime"
  ShowFlyingSign(PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/activate_cherk_ma.txt", Biara, PLAYER_1, 7.0);
  ShowFlyingSign(PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/activate_cherk_ma.txt", Djovanni, PLAYER_2, 7.0);

end;

-- Подготовка к моду Смутное время (вариант 2)
function prepareForTroubledTimeVar2()
  print "prepareForTroubledTimeVar2"

  SetObjectPosition('golem', 19, 45);
  SetObjectPosition('red10', 35, 83, GROUND);

  -- Установка настройки для нового режима
  CUSTOM_GAME_MODE_TROUBLED_TIME = 2;  -- Смещение номера на 2
  CUSTOM_GAME_MODE_TROUBLED_TIME_TIER = 1 + random(7);
  CUSTOM_GAME_MODE_ONLY_CHERK_SINGLE_HEROES = 1;

  SetObjectPosition(Biara, 35, 87);
  SetObjectPosition(Djovanni, 42, 22);

  MessageBoxForPlayers(playerId, {PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/message_troubled_time.txt"; eq = CUSTOM_GAME_MODE_TROUBLED_TIME_TIER }, 'showFlyingTroubledTimeVar2');

  RemoveObject('mumiya');
--  moveDelimetersToRandomChoise();
  deleteAllRacesUnit();

  SetObjectPosition('blue3', 39, 85, GROUND);
  SetObjectPosition('blue6', 39, 87, GROUND);
  SetObjectPosition('blue9', 39, 89, GROUND);

  doFile(PATH_TO_DAY1_MODULE.."choice_of_races/half.lua");

end;

function showFlyingTroubledTimeVar2()
  print "showFlyingTroubledTimeVar2"
--  ShowFlyingSign(PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/activate_cherk_ma.txt", Biara, PLAYER_1, 7.0);
--  ShowFlyingSign(PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/activate_cherk_ma.txt", Djovanni, PLAYER_2, 7.0);

end;

-- Подготовка к режиму случайного выбора героя без ментора
function prepareForRandomPickHeroMode()
  print "prepareForRandomPickHeroMode"

  SetObjectPosition('golem', 19, 45);
  SetObjectPosition('red10', 35, 83, GROUND);
  CUSTOM_GAME_MODE_NO_MENTOR = 3;
  CUSTOM_GAME_MODE_ONLY_CHERK_SINGLE_HEROES = 1;
end;

-- Подготовка к режиму выбора только героя
function prepareForPickHeroOnlyMode()
  print "prepareForPickHeroOnlyMode"

  SetObjectPosition('golem', 19, 45);
  SetObjectPosition('red10', 35, 83, GROUND);
  CUSTOM_GAME_MODE_ONLY_CHERK_SINGLE_HEROES = 1;
  ShowFlyingSign(PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/onlySingleCherkHero.txt", Biara, PLAYER_1, 5.0);
  ShowFlyingSign(PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/onlySingleCherkHero.txt", Djovanni, PLAYER_2, 5.0);
end;

-- Перемещение магов и грелина для режима Без ментора
function moveDelimetersToFirstMode()
  print "moveDelimetersToFirstMode"

  SetObjectPosition('mage1', 54, 87);
  SetObjectPosition('mage2', 60, 87);
  SetObjectPosition('mage3', 51, 9);
  SetObjectPosition('mage4', 57, 9);

  SetObjectPosition('gremlin1', 58, 80);
  SetObjectPosition('gremlin2', 58, 14);
end;

showGolem()
