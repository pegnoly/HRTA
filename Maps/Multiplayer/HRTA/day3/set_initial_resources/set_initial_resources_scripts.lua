-- Скрипты установки начальных значений ресурсов для игроков

-- Путь до сообщений этого модуля
PATH_TO_SET_INIT_RESOURCES_MESSAGES = GetMapDataPath().."day3/set_initial_resources/messages/"

doFile(GetMapDataPath().."day3/set_initial_resources/set_initial_resources_constants.lua");
sleep(1);

-- Точка входа
function setInitialResources()
  print "setInitialResources"

  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    local bonus = getCalculatedStartedBonus(playerId);
    local secondHero = GetPlayerHeroes(playerId)[1];

    local resValue
    for resourceId, resourceValue in INITIAL_RESOURCES[raceId] do
      resValue = resourceValue;

      -- Для золота учитываем стартовый бонус и изменения от торгов
      if resourceId == GOLD then
        if bonus == STARTED_BONUSES.GOLD then
          local randomStartGold = 4000;
          resValue = resValue + randomStartGold;

          ShowFlyingSign({PATH_TO_SET_INIT_RESOURCES_MESSAGES.."start_gold.txt"; eq = randomStartGold}, secondHero, playerId, 5.0);
        end;

        if CUSTOM_GAME_MODE_AUCTION == 1 then
        -- Устанавливаем золото с учетом торгов
          if playerId == PLAYER_1 then
            resValue = resValue - PLAYER_1_GOLD
          elseif playerId == PLAYER_2 then
            resValue = resValue - PLAYER_2_GOLD
          end
        end;
      end;

      SetPlayerResource(playerId, resourceId, resValue);
    end;
  end;
end;

-- Точка входа
setInitialResources();
