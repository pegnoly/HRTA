
PATH_TO_DAY5_SCRIPTS = GetMapDataPath().."day5/";
PATH_TO_DAY5_MESSAGES = PATH_TO_DAY5_SCRIPTS.."messages/";

doFile(PATH_TO_DAY5_SCRIPTS.."day5_constants.lua");
sleep(1);

-- Точка старта
function day5_scripts()
  print "day5_scripts"
  
  removeHeroMovePoints(Biara);
  removeHeroMovePoints(Djovanni);

  if needPostponeBattle() then
    -- Отправляем на выбор поляны
    selectBattlefield();
  else
    startBattle();
  end;
end;

day5_scripts();