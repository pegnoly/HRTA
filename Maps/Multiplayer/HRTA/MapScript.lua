-- �� ��������� �������, ���� � ���
consoleCmd('@nde = 1')

sleep(10)
if nde == 1 then
	return
end

-- ����������� ������ ����� ������ � �������
-- ��������� ������ � ����
consoleCmd('console_size 999')
consoleCmd('game_writelog 0')
sleep(1)

-- doFile(GetMapDataPath()..'common.lua');
-- doFile(GetMapDataPath()..'utils.lua');
-- doFile(GetMapDataPath()..'constants.lua');
-- doFile(GetMapDataPath()..'modules/modules.lua');

-- sleep(1)

-- -- if GetDifficulty() == DIFFICULTY_EASY then
-- --   removeHeroMovePoints(Djovanni);
-- -- else
-- --   removeHeroMovePoints(Biara);
-- --   removeHeroMovePoints(Djovanni);
-- -- end

-- -- -- ���������� ����������� ������ ���
-- function handleNewDay()
--   if GetDate(DAY) == 2 then
--     doFile(GetMapDataPath().."day2/day2_scripts.lua");
--   end;

--   if GetDate(DAY) == 3 then
--     if drafts_core.GetDraftType() ~= DRAFT_TYPE_FIVE then
--       sleep(5);
--       doFile(GetMapDataPath().."day3/day3_scripts.lua");
--     end
--   end;

--   if GetDate(DAY) == 4 then
--     if drafts_core.GetDraftType() ~= DRAFT_TYPE_FIVE then
--       for _, playerId in PLAYER_ID_TABLE do
--         SetPlayerResource (playerId, GOLD, 0);
--       end;

--       sleep(5);
--       doFile(GetMapDataPath().."day4/day4_scripts.lua");
--     end
--   end;

--   if GetDate(DAY) == 5 then
--     if drafts_core.GetDraftType() ~= DRAFT_TYPE_FIVE then
--       sleep(5);
--       doFile(GetMapDataPath().."day5/day5_scripts.lua");
--     end
--   end;

--   if GetDate(DAY) == 6 then
--     if drafts_core.GetDraftType() ~= DRAFT_TYPE_FIVE then
--       sleep(5);
--       doFile(GetMapDataPath().."day6/day6_scripts.lua");
--     end
--   end;

--   if GetDate(DAY) == PREPARE_STAGE_LEVELING_DAY then
--       sleep(5);
--       doFile(GetMapDataPath().."day3/day3_scripts.lua");
--   end

--   if GetDate(DAY) == PREPARE_STAGE_SPECIAL_DAY then
--       for _, playerId in PLAYER_ID_TABLE do
--         SetPlayerResource (playerId, GOLD, 0);
--       end;

--       sleep(5);
--       doFile(GetMapDataPath().."day4/day4_scripts.lua");
--   end

--   if GetDate(DAY) == PREPARE_STAGE_PREFIGHT_DAY then
--       print("<color=red>PREFIGHT DAY")
--       sleep(5);
--       doFile(GetMapDataPath().."day5/day5_scripts.lua");
--   end

--   if GetDate(DAY) == PREPARE_STAGE_FIGHT_DAY then
--       print("<color=red>FIGHT DAY")
--       sleep(5);
--       doFile(GetMapDataPath().."day6/day6_scripts.lua");
--   end
-- end;

-- -- �������� ��������
-- Trigger (NEW_DAY_TRIGGER, 'handleNewDay');

-- doFile(GetMapDataPath().."day1/day1_scripts.lua");
