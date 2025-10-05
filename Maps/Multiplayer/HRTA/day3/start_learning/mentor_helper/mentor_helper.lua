
doFile(PATH_TO_START_LEARNING_MODULE..'mentor_helper/mentor_helper_constants.lua');
sleep();

-- Статус активации
MENTOR_HELPER_ACTIVE = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
}

-- Навык, сброшенный последним
MENTOR_HELPER_REMOVED_SKILL = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
}

-- Навык, сброшенный последним
MENTOR_HELPER_OBJECT = {
  [PLAYER_1] = 'mentor_helper_1',
  [PLAYER_2] = 'mentor_helper_2',
}

for playerId, objectName in MENTOR_HELPER_OBJECT do
  SetObjectEnabled(objectName, nil);
  OverrideObjectTooltipNameAndDescription(objectName, PATH_TO_START_LEARNING_MODULE..'mentor_helper/'.."mentor_helper_name.txt", PATH_TO_START_LEARNING_MODULE..'mentor_helper/'.."mentor_helper_desc.txt");
  Trigger(OBJECT_TOUCH_TRIGGER, objectName, 'handleTouchMentorHelper');
end;

-- Обработчик касания объекта
function handleTouchMentorHelper(triggerHero)
  print "handleTouchMentorHelper"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local message = MENTOR_HELPER_ACTIVE[playerId] and "question_inactive_mentor_helper.txt" or "question_active_mentor_helper.txt";
  
  QuestionBoxForPlayers(playerId, PATH_TO_START_LEARNING_MODULE..'mentor_helper/'..message, "useMentorHelper("..playerId..")", 'noop');
end;

function useMentorHelper(strPlayerId)
  print "useMentorHelper"

  local playerId = strPlayerId + 0;

  MENTOR_HELPER_ACTIVE[playerId] = not MENTOR_HELPER_ACTIVE[playerId];
end;

-- Проверка, разрешено ли брать навык с активированным помошником
function getReturnedSkillByMentorHelper(playerId, skillId)
  print "getReturnedSkillByMentorHelper"
  
  if not MENTOR_HELPER_ACTIVE[playerId] then
    return nil;
  end;
  
  if skillId == MENTOR_HELPER_REMOVED_SKILL[playerId] then
    MENTOR_HELPER_REMOVED_SKILL[playerId] = nil;
--    SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) + 2500));
    return nil;
  end;

  local raceId = RESULT_HERO_LIST[playerId].raceId;

  for _, t1 in MENTOR_HELPER_SUPPORT_PERK_LIST[raceId] do
    local countSkillInBranch = 0;

    for _, t2 in t1 do
      -- ветка со сброшенным навыком
      if t2 == MENTOR_HELPER_REMOVED_SKILL[playerId] then
        countSkillInBranch = countSkillInBranch + 1;
      end;
      -- ветка с полученным навыком
      if t2 == skillId then
        countSkillInBranch = countSkillInBranch + 1;
      end;
    end;

    -- Если сброшенный и взятый навык от одного родителя - разрешаем его брать
    if countSkillInBranch == 2 then
      return nil;
    end;
  end;

  -- Костыльно отнимаем 2500, чтобы не дублировался кешбек
--  SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) - 2500));
  -- Если при активированном помошнике не нашлось одного родителя со сброшенным навыком - возвращаем его
  return MENTOR_HELPER_REMOVED_SKILL[playerId];
end;
