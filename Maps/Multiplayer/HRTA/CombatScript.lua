---------------------------------------------------------------------------------------------------
--  ������� �������
---------------------------------------------------------------------------------------------------

-- ������, ����� ������ --

---------------------------------------------------------------------------------------------------
--  ����� �������
---------------------------------------------------------------------------------------------------

-- consoleCmd('console_size 999')

doFile('/scripts/asha/combat_lib.lua')

START_ATB_MIN_VALUE = 0.00
START_ATB_MAX_VALUE = 0.05
QUICKNESS_OF_MIND_ATB_BONUS = 0.25
WYNGAAL_ATB_BONUS_PER_LEVEL = 0.008
PATH_OF_WAR_BONUS_PER_STEP = 4
LOGISTICS_BONUS_PER_LEVEL = 0
PATH_OF_WAR_BONUS = 0.1

LETHOS_WEIGHT_PER_LEVEL = 0.02

QUROQ_LAST_UNIT = nil

RITUAL_ENEMY_MANA_SPENT = 3
ALMEGIR_RITUAL_PER_LEVEL = 0.05
MYSTICISM_MANA_PER_TURN_REGENERATION = 2
AMMO_CART_REPAIR = 100
ASHA_ALLY_TARGETS = 4
ASHA_ENEMY_TARGETS = 0
ASHA_FREQUENCY = 2
NECRO_LORD_RAISE_PERCENT = 0.2

HERO_1_MANA = 0
HERO_2_MANA = 0
HERO_1_TURN = 0
HERO_2_TURN = 0

GUARDIAN_ANGEL_ACTIVATE = 0

-- ������ ��������� ����� �����
PLAYERS_KRAGH_STATUS = {
  [0] = nil,
  [1] = nil,
};

HEROES_INFO = parse(GetGameVar('heroes_info'))()

function shuffle(t)
	local n = getn(t)
	for i = 1, n - 1 do
		local j = random(i, n)
		t[i], t[j] = t[j], t[i]
	end
	return t
end

function GetAllUnits()
	local t = {}
	for side = 0, 1 do
		for unit_type = 0, 4 do
			extend(t, GetUnits(side, unit_type))
		end
	end
	return t
end


function WaitUntilTurnEnds(unit)
  time = 0
  while combatReadyPerson() == unit do
		sleep(1)
--		print(time)        -- 1 min = 4902 5100 4700 4800 5200
--		time = time + 1
--    print(TutorialActivateHint(ui_open_atb_bar))
	end
end

function EnemySide(side)
	return 1 - side
end

function GetFriendlyHero(unit)
	local hero = GetHero(GetUnitSide(unit))
	return hero
end

function GetEnemyHero(unit)
	local hero = GetHero(EnemySide(GetUnitSide(unit)))
	return hero
end

function GetFriendlyCreatures(unit)
	local t = GetCreatures(GetUnitSide(unit))
	return t
end

function GetEnemyCreatures(unit)
	local t = GetCreatures(EnemySide(GetUnitSide(unit)))
	return t
end

function GetRandomStartATBPosition()
	return START_ATB_MIN_VALUE + (START_ATB_MAX_VALUE - START_ATB_MIN_VALUE) * random()
end

function IsNamedHero(unit, hero_name)
	local name = GetHeroName(unit)
	return name == hero_name or name == hero_name .. '2'
end

function GetHeroSkillMastery(unit, skill)
	local hero = GetHeroName(unit)
  return HEROES_INFO[hero].skills[skill] or 0
end

function GetHeroLevel(unit)
	local hero = GetHeroName(unit)
	return HEROES_INFO[hero].level
end

function GetHeroLuck(unit)
	local hero = GetHeroName(unit)
	return HEROES_INFO[hero].luck
end

function GetHeroArtSet(unit, artset)
	local hero = GetHeroName(unit)
  return HEROES_INFO[hero].ArtSet[artset] or 0
end

function CheckDist(unit1, unit2)
  x1, y1 = pos(unit1)
--  if IsWarMachine(unit1) or GetCreatureSize(unit1) == 2 then
--    x1, y1 = x1 - 0.5, y1 - 0.5
--  end
  x2, y2 = pos(unit2)
--  if IsWarMachine(unit2) or GetCreatureSize(unit2) == 2 then
--    x2, y2 = x2 - 0.5, y2 - 0.5
--  end
  local dist1 = x2 - x1
  local dist2 = y2 - y1
  local answer = sqrt(dist1 * dist1 + dist2 * dist2)
  return ceil(answer)
end

function GetCreatureSize(creature)
  local answer = CREATURE_INFO[GetCreatureType(creature)].size --or GetCreatureSize(GetCreatureType(creature))
  return answer
end

function SafePos()
	local arena = {}
	for x = 0, 14 do
		arena[x] = {}
		for y = -1, 11 do
			arena[x][y] = 0
		end
	end
	for side = 0, 1 do
		for i, unit in GetCreatures(side) do
			local x, y = pos(unit)
			for dx = x - 2, x + 1 do
				for dy = y - 2, y + 1 do
					arena[dx][dy] = 1
				end
			end
		end
	end
	for x = 2, 13 do
		for y = 1, 10 do
			if arena[x][y] == 0 then
				return x, y
			end
		end
	end
	return 7, 1
end

function GetCorpses(side)
	local t, n = {}, 0
	for i, creature in real_creatures[side] do
		if exist(creature) and GetCreatureNumber(creature) == 0 then
			local x, y = pos(creature)
			n = n + 1
			t[n] = {creature = creature, x = x, y = y}
		end
	end
	return t
end

function IsUnitUndead(unit)
	local id = GetCreatureType(unit)
	return
		(id >= CREATURE_SKELETON and id <= CREATURE_SHADOW_DRAGON) or
		(id >= CREATURE_SKELETON_WARRIOR and id <= CREATURE_HORROR_DRAGON) or
		id == CREATURE_DEATH_KNIGHT
end

function IsConstUnit(unit)
	return not (unit >= 'temp' and unit < 'temq')
end

function NumberSideToText(side)
  local text
  if side == 0 then text = 'attacker' end
  if side == 1 then text = 'defender' end
  return text
end


---------------------------------------------------------------------------------------------------
--  ���������� ����
---------------------------------------------------------------------------------------------------

quroq_creatures = {}
arghat_creatures = {}
arghat_spells = {SPELL_BLESS, SPELL_STONESKIN, SPELL_BLOODLUST, SPELL_DEFLECT_ARROWS, SPELL_HASTE, SPELL_ANTI_MAGIC}
level_rage_creature_prev = {}
level_rage_creature_current = {}
real_creatures = {}
init_real_creatures_numbers = {}
init_enemy_army = {}
war_machines = {}
war_machines_state = {}
creature_dead = {}


lord_of_undead = {}
--first_heroes = {Kragh = 1, Grok = 1}
--auto_move = {}
current_turn = {}
asha_turn = {[0] = 0; 0}
ritual_mana = {[0] = 0; 0}
djinn_casts = {}
guardian_angel_uses = {[0] = 0; 0}
num_turn = {0, 0, 0}   -- all, hero_att, hero_def
spellpower_bonus = { 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 14, 16, 19, 21, 24, 28, 32, 36, 41, 46, 52, 58, 66, 74, 83, 93, 104, 117, 131, 150}
zoltan_use = 0

-- ��������������� ���� �������
ASHA_COUNTER = {
  [0] = {miss = 0, triger = 0},
  [1] = {miss = 0, triger = 0},
};

-- ������� ��� ������������ �������� �������� �������������� ���� ��� ������� ������
MYSTICISM_MANA_PER_TURN_REGENERATION_COUNTER = {
  [0] = 2, -- ��������� �������� ��� ������� ������
  [1] = 2  -- ��������� �������� ��� ������� ������
}

-- ��� �� ����������� �����-���������
PLAYER_USE_GUARDIAN_ANGEL = {
  [0] = nil,
  [1] = nil,
};

------------------------------
-- START NEW COMBAT HANDLER --
------------------------------

-- ������ ��� ��� ����� ������������
COMBAT_DATA = {
  prev = {
    activeUnit = nil,
    heroMana = {
      [0] = 0,
      [1] = 0,
    },
  },
};

-- ������� ����� ���� � ������������ ����������� � ����� ����������
function fixMarkOfNecromancyWithResummonElem(prevActiveUnit)
  print "fixMarkOfNecromancyWithResummonElem"

  local playerSide = GetUnitSide(prevActiveUnit);
  local currentHeroMana = GetUnitManaPoints(GetHero(playerSide));
  print("COMBAT_DATA.prev.heroMana")
  print(COMBAT_DATA.prev.heroMana)
  print("currentHeroMana")
  print(currentHeroMana)
  print("COMBAT_DATA.prev_prev.heroMana")
  print(COMBAT_DATA.prev_prev.heroMana)

  local heroManaDiff = COMBAT_DATA.prev_prev.heroMana[playerSide] - COMBAT_DATA.prev.heroMana[playerSide];

  print(prevActiveUnit)
  print("prevActiveUnit")
  if GetHeroSkillMastery(prevActiveUnit, 61) > 0 then
    print("GetHeroSkillMastery(prevActiveUnit, 61) > 0 then")
    local addedMana = CheckIfSideResummonElem(real_creatures[playerSide], heroManaDiff, playerSide);
    print("addedMana")
    print(addedMana)
    if addedMana > 0 then
      SetUnitManaPoints(prevActiveUnit, COMBAT_DATA.prev_prev.heroMana[playerSide])
    end
  end;
end;

-- �������� ����� ���� ����������� ��������
function HandleAfterMove(currentTurnUnit)
  print "HandleAfterMove"

  local prevActiveUnit = COMBAT_DATA.prev.activeUnit;

  if prevActiveUnit == nil then
    return nil
  end;

--  if IsHero(prevActiveUnit) then
--    fixMarkOfNecromancyWithResummonElem(prevActiveUnit);
--  end;
end;

-- �������� �� ���� ��������
function HandleBeforeMove(currentTurnUnit)
  print "HandleBeforeMove"

end;

-- �������� �� ���� ��������
function PopulateCombatData(currentTurnUnit)
  print "PopulateCombatData"


  COMBAT_DATA.prev_prev = COMBAT_DATA.prev
  COMBAT_DATA.prev = {
      activeUnit = currentTurnUnit,
      heroMana = {
        [0] = GetUnitManaPoints(GetHero(0)),
        [1] = GetUnitManaPoints(GetHero(1)),
      },
    };

end;

-- ����� ���������� �������� ������ � ���
function NewUnitMoveHandler(currentTurnUnit)
  print "NewUnitMoveHandler"

  HandleAfterMove(currentTurnUnit);
  HandleBeforeMove(currentTurnUnit);
  PopulateCombatData(currentTurnUnit);
end;

----------------------------
-- END NEW COMBAT HANDLER --
----------------------------

function OnPrepare()

  combatSetPause(1)
  --EnableDynamicBattleMode(3)


end

function OnStart()
  -- print "OnStart"

  -- consoleCmd('game_writelog 1')

  rage_sum_prev = 0
  for side = 0, 1 do
		real_creatures[side] = extend({}, GetCreatures(side))
		for i, creature in real_creatures[side] do
			init_real_creatures_numbers[creature] = GetCreatureNumber(creature)
		end
		war_machines[side] = extend({}, GetWarMachines(side))
		for i, wm in war_machines[side] do
			war_machines_state[wm] = 1
		end
	end
	local disable_auto_finish = nil


	for side, hero in {[0]=GetHero(0); GetHero(1)} do
		HandleHeroesOnStart(hero, side)
	end


  for side, hero in {[0]=GetHero(0); GetHero(1)} do

    if ( IsNamedHero(hero, 'Rolf') or IsNamedHero(hero, 'Rolf2') ) then
      RolfSpec(side, hero)
    end

 -- ����������� ������
  if GetHeroSkillMastery(hero, 176) > 0 then
      local countCastersHero = 1
      local countCastersEnemyhero = 1
      local c1 = 'temp-buff'..side
      local x, y = SafePos()
      AddCreature(side, 900, countCastersHero, x, y, 1, c1)
      repeat sleep() until exist(c1)
      displace(c1, 9, 50)
      pcall(UnitCastGlobalSpell, c1, SPELL_MASS_STONESKIN)
      pcall(UnitCastGlobalSpell, c1, SPELL_MASS_DEFLECT_ARROWS)
      removeUnit(c1)

      repeat sleep() until not exist(c1)

      AddCreature(1-side, 900, countCastersEnemyhero, x, y, 1, c1)
      repeat sleep() until exist(c1)
      displace(c1, 9, 50)
      pcall(UnitCastGlobalSpell, c1, SPELL_MASS_WEAKNESS)
      removeUnit(c1)
  end
  end
	local init_atb = {}
	for i, unit in GetAllUnits() do
		local atb = GetUnitInitialATB(unit)
		init_atb[unit] = atb
    if IsCreature(unit) then
      local type = GetCreatureType(unit)
      if type == 166 or type == 93 then
        pcall(commandDoSpecial, unit, 317, pos(unit))
      end
    end
	end
	for unit, atb in init_atb do
	  if not (IsHero(unit) and IsNamedHero(unit, 'Hero1')) then
      SetATB(unit, atb)
    end;
	end

	combatSetPause(nil)
	startThread(ReadyUnitThread)
	startThread(CombatFinishManualControl)
  startThread(SummonATB)
  startThread(mineDeathATB)



end

function WarMachineDead(wm)
  local we = GetUnitSide(wm)
  if war_machines_state[wm] == 1 then
		war_machines_state[wm] = 0
	end
end

function getHasBeenGuardianAngel()
  -- print "getHasBeenGuardianAngel"

  for _, hasBeen in HAS_BEEN_GUARDIAN_ANGEL do
    if hasBeen then
      return not nil;
    end;
  end;

  return nil;
end;

function CreatureDead(unit)
	creature_dead[unit] = 1

  local type = GetCreatureType(unit)
  for side, hero in {[0]=GetHero(0); GetHero(1)} do
    if GetHeroSkillMastery(hero, 170) > 0 and GetHeroSkillMastery(hero, 15) > 0 and type < 900 and (GetUnitSide(unit) ~= GetUnitSide(hero))  then
      combatSetPause(1)

      local creatures_necro = GetCreatures(side)
      local unit_get_move = random(length(creatures_necro) + 1) - 1

      if unit_get_move == (length(creatures_necro)) then
        SetATB(hero, 1)
      else
        SetATB(creatures_necro[unit_get_move], 1)
      end
      combatSetPause(nil)
  	end
	end



  if IsNamedHero(GetFriendlyHero(unit), 'AberrarDelete') then
    local zoltan_side = GetUnitSide(unit)
    local zoltan_creatures_sum = 0
    repeat sleep() until GetCreatureNumber(unit) == 0
    for i, creature in real_creatures[zoltan_side] do
  		if GetCreatureNumber(creature) > 0 then
        zoltan_creatures_sum = zoltan_creatures_sum + 1
      end
    end
    if zoltan_creatures_sum == 1 and zoltan_use == 0 then
      local x, y = SafePos()
      AddCreature(zoltan_side, 901, 1000, x, y, 1, 'spellpower-unit')
      repeat sleep() until exist('spellpower-unit')
      displace('spellpower-unit', 9, 50)
      pcall(commandDoSpecial, 'spellpower-unit', 333, pos(GetHero(zoltan_side)))
      removeUnit('spellpower-unit')
      repeat sleep() until combatReadyPerson()
      local next_creature = combatReadyPerson()
      SetATB(GetHero(zoltan_side), 999)
      SetATB(next_creature, 0.999)
	    zoltan_use = 1
    end
  end

end

function mineDeathATB()
  -- print "mineDeathATB"

  if (GetHeroSkillMastery(GetHero(0), 93) or 0) <= 0 and (GetHeroSkillMastery(GetHero(1), 93) or 0) <= 0 then
      return nil;
  end;


  local N = 0
  repeat
    local allUnits_1 = GetAllUnits()

    repeat sleep() until length(allUnits_1) ~= lengthAllUnits()
    local allUnits_2 = GetAllUnits()
    local allUnits_3 = {}

    for i = 1, length(allUnits_2) do
      local status = nil
      for j = 1, length(allUnits_1) do
        if allUnits_2[i] == allUnits_1[j] then
          status = not nil
        end
      end

      if status == nil then
        allUnits_3[length(allUnits_3)+1] = allUnits_2[i]
      end
    end
    for _, unit in allUnits_3 do
      if IsCreature(unit) then
        local unitId = (GetCreatureType(unit))
        if GetHeroSkillMastery(GetFriendlyHero(unit), 93) > 0 then
          -- print("���� �����")

          for key, value in init_real_creatures_numbers do
            if unit == key then
              local side = GetUnitSide(unit)

              combatSetPause(1)
              SetATB(unit, 0.5)
              local c1 = 'temp-buff'..side
              local x, y = SafePos()
              AddCreature(side, 900, 1, x, y, 1, c1)
              repeat sleep() until exist(c1)
              displace(c1, 9, 50)
              removeUnit(c1)
              print("mineDeathATB")
            end
          end
        end
      end
    end
    sleep(1)
    combatSetPause(nil)

  until N ~= 0
end


function CheckIfNewElemAdd(allUnits_1)
--  print "CheckIfNewElemAdd"

  local allUnitsInRealMoment = GetAllUnits();

  local newInits = {};
  local newElemUnits = {}

  for i = 1, length(allUnitsInRealMoment) do
    local status = nil
    for j = 1, length(allUnits_1) do
      if allUnitsInRealMoment[i] == allUnits_1[j] then
        status = not nil
      end
    end

    if status == nil then
      newInits[length(newInits)+1] = allUnitsInRealMoment[i]
    end
  end

  for _, unit in newInits do
    if IsCreature(unit) then
      local unitId = (GetCreatureType(unit))

      if unitId == 88 or unitId == 87 or unitId == 86 or unitId == 85 then
        newElemUnits[length(newElemUnits)+1] = unit
      end;

    end;
  end;


  return newElemUnits
end

function CheckIfElemDelete(allUnits_1)
  -- print("CheckIfElemDelete")

  local allUnitsInRealMoment = GetAllUnits();

  local deleteUnits = {};
  local deletedElemUnits = {}

  for i = 1, length(allUnits_1) do
    local status = nil
    for j = 1, length(allUnitsInRealMoment) do
      if allUnits_1[i] == allUnitsInRealMoment[j] then
        status = not nil
      end
    end

    if status == nil then
      deleteUnits[length(deleteUnits)+1] = allUnits_1[i]
    end
  end

  for _, unit in deleteUnits do
    if IsCreature(unit) then
      local unitId = (GetCreatureType(unit))

      if unitId == 88 or unitId == 87 or unitId == 86 or unitId == 85 then
        deletedElemUnits[length(deletedElemUnits)+1] = unit
      end;

    end;
  end;


  return deletedElemUnits

end;

function refreshATB(side)
  -- print "refreshATB"

  combatSetPause(1)
  local c1 = 'temp-buff'..side

  AddCreature(side, 900, 1, -1, -1, 1, c1)
  repeat sleep() until exist(c1)
  removeUnit(c1)
  repeat sleep() until not exist(c1)
  combatSetPause(nil)
end


function CheckIfSideResummonElem(allUnitsLastTurn, prevHeroMana, side)
  -- print "CheckIfSideResummonElem"

  local newElemList = CheckIfNewElemAdd(allUnitsLastTurn);
  local deletedElemList = CheckIfElemDelete(allUnitsLastTurn);

  local addedMana = GetUnitManaPoints(GetHero(side)) - prevHeroMana;

  if length(newElemList) == length(deletedElemList) then
    return addedMana;

  end;

  return 0


end;



function SummonATB()
  -- print "SummonATB"

  if (GetHeroSkillMastery(GetHero(0), 114) or 0) <= 0 and (GetHeroSkillMastery(GetHero(1), 114) or 0) <= 0 then
    return nil;
  end;

  local N = 0
  repeat
    sleep()
    local allUnits_1 = GetAllUnits()

    local newElem

    repeat
      sleep()
      newElem = CheckIfNewElemAdd(allUnits_1)
    until length(newElem) > 0
    for _, unit in newElem do
      if GetHeroSkillMastery(GetFriendlyHero(unit), 114) > 0 then
        local side = GetUnitSide(unit)
        SetATB(unit, 0.4)
        refreshATB(side)
        print("SummonATB_end_function")
      end

    end


  until N ~= 0
end

function lengthAllUnits()
  local lengthAll = length(GetAllUnits())
  return lengthAll
end


function GetUnitInitialATB(unit)
	local atb = GetRandomStartATBPosition()
	if IsHero(unit) then
		-- if IsNamedHero(unit, 'Hero1') then
      -- pcall(commandDefend, unit)
    -- end
--      atb = 0.99999
--			auto_move[unit] = 1
--		elseif IsNamedHero(unit, 'Grok') then
--			atb = 1
--			auto_move[unit] = 1
		if GetHeroSkillMastery(unit, 155) > 0 then -- ������ ��
			atb = atb + QUICKNESS_OF_MIND_ATB_BONUS
		end

	elseif IsCreature(unit) then
		local hero = GetFriendlyHero(unit)
		local enemy_hero = GetEnemyHero(unit)
		if IsNamedHero(hero, 'Linaas') then
			atb = atb + GetHeroLevel(hero) * WYNGAAL_ATB_BONUS_PER_LEVEL
		end
--		if GetHeroSkillMastery(hero, 1) > 0 then -- ���������
--			atb = atb + LOGISTICS_BONUS_PER_LEVEL * GetHeroSkillMastery(hero, 1)
--		end
--		if GetHeroSkillMastery(hero, 177) > 0 then
		  --���� ����� (������)
  --    atb = atb + PATH_OF_WAR_BONUS
--      if atb <= 0 then
--        atb = 0.0001 * random(100)
--      end
--    end
	end
	return atb
end

function HandleHeroesOnStart(hero, side)

  -- ������
--  for i, creature in real_creatures[side] do
--    local type = GetCreatureType(creature)
--    if type == 166 then
--      pcall(commandDoSpecial, creature, 317, pos(creature))
--    end
--  end

end

function UnitMoveNonBlocking(unit)
  -- print "UnitMoveNonBlocking"

  if current_turn[unit] then
		if current_turn[unit] == 2 then
			current_turn[unit] = nil
		end
		return
	end
	local need_pause = nil
	if IsConstUnit(unit) then
		for unitx, x in current_turn do
			if x then
				current_turn[unitx] = nil
				need_pause = 1
			end
		end
	end
	if need_pause then
		combatSetPause(1)
		sleep(40)
    combatSetPause(nil)
		sleep(10)
	end

  num_turn[1] = num_turn[1] + 1;
  --print('<color=black>' .. unit .. ': <color=green>turn ' .. num_turn[1] .. ' start')
	current_turn[unit] = 1


	local we = GetUnitSide(unit)
	local enemy = EnemySide(we)
	local ally_hero = GetFriendlyHero(unit)
	local enemy_hero = GetEnemyHero(unit)
	local init_mana = GetUnitManaPoints(unit)
	local init_enemy_hero_mana = GetUnitManaPoints(enemy_hero)
	local init_spawns = GetSpellSpawns(we)
	last_turn_player = 0


	if creature_dead[unit] then
		creature_dead[unit] = nil
	end


  -- ������ ��� ������ ��������
	if num_turn[1] == 1 then
   -- �� + ������
	end;



	if IsHero(unit) then
    -- ���������� ����� ����� ������� ����� � ����� ���
   if IsNamedHero(unit, 'Hero1') then
     -- ���� � ��� ��
     local turnNumForSkip = GetHeroSkillMastery(enemy_hero, 176) > 0 and 2 or 1;

     if num_turn[1] == turnNumForSkip then
       WaitUntilTurnEnds(unit);

       setATB(unit, 0);
     end;
   end;

    --EnableDynamicBattleMode(nil)

    -- ���� ���� � ����� ������
		if init_mana < 0 then
			init_mana = 0
			SetUnitManaPoints(unit, 0)
		end



		-- ���������� �����
--    if GetHeroSkillMastery(GetFriendlyHero(unit), 176) > 0 then
--      local c = 'create-arcane-unit'..GetUnitSide(unit)
--      local x, y = SafePos()
--      AddCreature(we, 901, 1, x, y, 1, c)
--      repeat sleep() until exist(c)
--      x, y = SafePos()
--      pcall(UnitCastAreaSpell, c, SPELL_ARCANE_CRYSTAL, x, y)
--      repeat sleep() until exist('attacker-spawn-0-SPELL_ARCANE_CRYSTAL')
--      removeUnit(c)
--      x, y = SafePos()
--      displace('attacker-spawn-0-SPELL_ARCANE_CRYSTAL', x, y)


--      print(GetSpellSpawns(we))
--			local new_spawns = GetSpellSpawns(we)
--			for i, spawn in new_spawns do
--				if not contains(init_spawns, spawn) then
--					SetUnitManaPoints(unit, init_mana)
--					break
--				end
--			end
--		end


	elseif IsCreature(unit) then

    -- ���� ����� (�������)
--		if GetHeroSkillMastery(ally_hero, 177) > 0 then     --177
--      path_of_war_x1, path_of_war_y1 = pos(unit)
--		end


    -- ����� --Hero2
--    if IsNamedHero(ally_hero, 'Quroq') or IsNamedHero(enemy_hero, 'Quroq') then   --name Hero2
--      local arghat_side = 0
--      if (IsNamedHero(ally_hero, 'Quroq') and we == 0) or (IsNamedHero(enemy_hero, 'Quroq') and we == 1) then arghat_side = 0 else arghat_side = 1 end
--      if arghat_side == GetUnitSide(unit) then
--        arghat_creatures[arghat_side] = extend({}, GetCreatures(arghat_side))
--        level_rage_creature_current[unit] = GetRageLevel(unit)
--        if level_rage_creature_current[unit] > 0 then
--          local c = 'light-unit'
--          local x, y = SafePos()
--          AddCreature(arghat_side, 902 + level_rage_creature_current[unit], 1, x, y, 1, c)
--          repeat sleep() until exist(c)
--          pcall(UnitCastAimedSpell, c, arghat_spells[random(6)], unit)
--          removeUnit('light-unit')
--          current_turn[unit] = 2
--        end
--      end
--    end



	elseif IsWarMachine(unit) then


	end

	-- �������� ����� ���� �����
	while current_turn[unit] == 2 do
		sleep()
	end
	WaitUntilTurnEnds(unit)
	--print('<color=black>' .. unit .. ': <color=red>turn end')
	current_turn[unit] = nil

	local unit_mana_spent = init_mana - GetUnitManaPoints(unit)
	local cur_enemy_hero_mana = GetUnitManaPoints(enemy_hero)

  -- ����� --Hero2   ���� ������������� ��� ��������� ������ ������ �����
--  if IsNamedHero(ally_hero, 'Quroq') or IsNamedHero(enemy_hero, 'Quroq') then   --name Hero2
--    local arghat_side = 0
--    if (IsNamedHero(ally_hero, 'Quroq') and we == 0) or (IsNamedHero(enemy_hero, 'Quroq') and we == 1) then arghat_side = 0 else arghat_side = 1 end
--    arghat_creatures[arghat_side] = extend({}, GetCreatures(arghat_side))
--    if num_turn[1] == 1 then
--      for i, creature in arghat_creatures[arghat_side] do
--        level_rage_creature_prev[creature] = 0
--      end
--    end
--    for i, creature in arghat_creatures[arghat_side] do
--      level_rage_creature_current[creature] = GetRageLevel(creature)
--      if level_rage_creature_current[creature] > level_rage_creature_prev[creature] then
--        local c = 'light-unit'
--        local x, y = SafePos()
--        AddCreature(arghat_side, 902 + level_rage_creature_current[creature], 1, x, y, 1, c)
--        repeat sleep() until exist(c)
--        pcall(UnitCastAimedSpell, c, arghat_spells[random(6)], creature)
--        removeUnit('light-unit')
--        while exist(c) do sleep() end
--        level_rage_creature_prev[creature] = level_rage_creature_current[creature]
--      end
--    end
--  end

  if IsWarMachine(unit) then

	elseif IsCreature(unit) then


  local type = GetCreatureType(unit)


  -- ����� �������
  if type == CREATURE_OBSIDIAN_GARGOYLE or type == CREATURE_ARCH_MAGI then
    local currentMana = GetUnitManaPoints(unit)
    local manaRestory = 1 + (GetCreatureNumber(unit)/10)

--    print((GetCreatureNumber(unit)/10))
--    print(ceil(GetCreatureNumber(unit)/10))
--    print(manaRestory)
    local newMana = currentMana + manaRestory
    local maxMana = 0

    if type == CREATURE_OBSIDIAN_GARGOYLE then
      maxMana = 12
    elseif type == CREATURE_ARCH_MAGI then
      maxMana = 16
    end

    if newMana > maxMana then
      newMana = maxMana
    end

   SetUnitManaPoints(unit, newMana)

  end

	elseif IsHero(unit) then

    -- ����� �������������
    if init_mana ~=  GetUnitManaPoints(unit) and ( IsNamedHero(ally_hero, 'Quroq') or IsNamedHero(ally_hero, 'Quroq2') ) then
      local creaturesWhoCanGetCallOfBlood = {}

      for i, creature in GetCreatures(GetUnitSide(unit)) do
        local type = GetCreatureType(creature)
        --�������� �� ������
        if type ~= 127 and  type ~= 128 and type ~= 178 and creature ~= QUROQ_LAST_UNIT then
          creaturesWhoCanGetCallOfBlood[length(creaturesWhoCanGetCallOfBlood)] = creature
        end;
      end

      local randomCreatureNum = random(length(creaturesWhoCanGetCallOfBlood))-1
      local randomCreature = creaturesWhoCanGetCallOfBlood[randomCreatureNum]

      if randomCreature ~= nil then
        local uniq_key = 'call_of_blood_creature';

        AddCreature(GetUnitSide(unit), 900, 1, -1, -1, nil, uniq_key);

        while not exist(uniq_key) do
          sleep()
        end

        pcall(UnitCastAimedSpell, uniq_key, SPELL_WARCRY_CALL_OF_BLOOD, randomCreature)

        removeUnit(uniq_key)

        QUROQ_LAST_UNIT = randomCreature

      end;
    end;


		-- ��������������� ����
		if GetHeroSkillMastery(ally_hero, 80) > 0 and unit_mana_spent > 0 then

      local chanceProc = random(2)
      local maxLuck = GetHeroLuck(unit) > 5 and 5 or GetHeroLuck(unit)
      local manaRecovery = ceil(unit_mana_spent *0.15 * maxLuck)

      if ASHA_COUNTER[GetUnitSide(unit)].triger == 2 then
        ASHA_COUNTER[GetUnitSide(unit)].triger = 0
        ASHA_COUNTER[GetUnitSide(unit)].miss = ASHA_COUNTER[GetUnitSide(unit)].miss + 1

      elseif ASHA_COUNTER[GetUnitSide(unit)].miss == 2 then
        ASHA_COUNTER[GetUnitSide(unit)].miss = 0
        ASHA_COUNTER[GetUnitSide(unit)].triger = ASHA_COUNTER[GetUnitSide(unit)].triger + 1
        SetUnitManaPoints(ally_hero, GetUnitManaPoints(unit) + manaRecovery)

      elseif chanceProc == 1 then
        SetUnitManaPoints(ally_hero, GetUnitManaPoints(unit) + manaRecovery)
        ASHA_COUNTER[GetUnitSide(unit)].triger =  ASHA_COUNTER[GetUnitSide(unit)].triger + 1
      else
        ASHA_COUNTER[GetUnitSide(unit)].miss =  ASHA_COUNTER[GetUnitSide(unit)].miss + 1

       end;
		end


    -- ����������� ����
    if GetHeroSkillMastery(unit, 40) > 0 or GetHeroSkillMastery(unit, 213) > 0 then
      local max_mana = GetUnitMaxManaPoints(unit)
      local side = GetUnitSide(unit) -- �������� ������� ����� (������)
      if GetUnitManaPoints(unit) < max_mana then
        -- ����������� ����� 2 � 3
        local new_mana = GetUnitManaPoints(unit) + MYSTICISM_MANA_PER_TURN_REGENERATION_COUNTER[side]
        if new_mana > max_mana then
            new_mana = max_mana
        end
        SetUnitManaPoints(unit, new_mana)
        init_mana = new_mana

        -- ������������ �������� �������������� ���� ��� �������� ������
        if MYSTICISM_MANA_PER_TURN_REGENERATION_COUNTER[side] == 2 then
            MYSTICISM_MANA_PER_TURN_REGENERATION_COUNTER[side] = 3
        else
            MYSTICISM_MANA_PER_TURN_REGENERATION_COUNTER[side] = 2
        end
      end
    end

    -- ������� � ������������
--    if GetHeroSkillMastery(ally_hero, 24) > 0  then
--      if index(GetWarMachines(we), NumberSideToText(we)..'-warmachine-WAR_MACHINE_AMMO_CART') then
--        local num = AMMO_CART_REPAIR / 5
--	  		local x, y = SafePos(we)
--	  		AddCreature(we, 902, num, x, y, 1, 'temp-catapult')
--        repeat sleep() until exist('temp-catapult')
--	  		displace('temp-catapult', 9, 50)
--        repeat sleep(); x1, y1 = pos('temp-catapult'); until y1 == y
--        pcall(commandDoSpecial, 'temp-catapult', 173, pos(NumberSideToText(we)..'-warmachine-WAR_MACHINE_FIRST_AID_TENT'))
--        pcall(commandDoSpecial, 'temp-catapult', 173, pos(NumberSideToText(we)..'-warmachine-WAR_MACHINE_BALLISTA'))
--        pcall(commandDoSpecial, 'temp-catapult', 173, pos(NumberSideToText(we)..'-warmachine-WAR_MACHINE_AMMO_CART'))
--        removeUnit('temp-catapult')
--      end
 --   end


    if GetUnitSide(unit) == 0 then
      HERO_1_MANA = GetUnitManaPoints(unit)
      HERO_1_TURN = HERO_1_TURN + 1
    end

    if GetUnitSide(unit) == 1 then
      HERO_2_MANA = GetUnitManaPoints(unit)
      HERO_2_TURN = HERO_2_TURN + 1
    end

--    print('mana player',GetUnitSide(unit),' = ',HERO_1_MANA)
--    consoleCmd([[@SetGameVar('hero1_mana', 'return {]] .. HERO_1_MANA .. [[}')]])

	end

	last_turn_player = GetUnitSide(unit)

end


--C���� ������ --

--������, �� ����������
function RaelagA1Spec(side, mainHeroName)
  -- print "RaelagA1Spec"

  local summoningLevel = GetHeroSkillMastery(mainHeroName, 12);

  local c1 = 'temp-buff'..side
  local x, y = SafePos()

  AddCreature(side, 901, 3 * summoningLevel, x, y, 1, c1)
  repeat sleep() until exist(c1)
 	displace(c1, 9, 50)
  pcall(UnitCastGlobalSpell, c1, SPELL_CELESTIAL_SHIELD)
  removeUnit(c1)                                         UnitCastAimedSpell()

  repeat sleep() until not exist(c1)

end;

-- ����� ������
function RolfSpec(side, mainHeroName)
  -- print "RolfSpec"

  local summoningLevel = GetHeroSkillMastery(mainHeroName, 12);

  -- ���������� �������: 7 (20) 27 (36), 60(48), 130(60)/ 66(50), 18 (30)
  numberSummon = {8, 19, 40, 90}

  local c1 = 'temp-buff'..side
  local x, y = SafePos()
  AddCreature(side, 901, numberSummon[summoningLevel+1], x, y, 1, c1)
  repeat sleep() until exist(c1)
 	displace(c1, 9, 50)
  pcall(UnitCastGlobalSpell, c1, SPELL_SUMMON_ELEMENTALS)
  removeUnit(c1)

  repeat sleep() until not exist(c1)

end;



function ReadyUnitThread()
  -- print "ReadyUnitThread"

	while 1 do
		repeat sleep() until combatReadyPerson()
		local unit = combatReadyPerson()
		startThread(NewUnitMoveHandler, unit)
		startThread(UnitMoveNonBlocking, unit)
		repeat sleep() until combatReadyPerson() ~= unit
	end
end

function CombatFinishManualControl()
--	print('<color=yellow>Automatic finish disabled')
--	EnableAutoFinish(nil)
  finish = 0
	while finish == 0 do
		local allow_finish = nil
		local looser = -1
		real_creatures_remained = {}
		real_creatures_remained[0] = nil
		real_creatures_remained[1] = nil
		for side = 0, 1 do
			for i, creature in real_creatures[side] do
				if exist(creature) and GetCreatureNumber(creature) > 0 then
          real_creatures_remained[side] = 1
          break
				end
			end
      sleep(1)
    end
    if real_creatures_remained[0] == nil then looser = 0 end
    if real_creatures_remained[1] == nil then looser = 1 end
    if real_creatures_remained[0] == nil and real_creatures_remained[1] == nil then
      print(last_turn_player)
      looser = 1 - last_turn_player
    end
    if looser >= 0 then
      -- consoleCmd('game_writelog 1')
		  -- sleep(3)
		  -- print('Hero1_ManaR: ', HERO_1_MANA)
		  -- print('Hero1_Turns: ', HERO_1_TURN)
		  -- print('Hero2_ManaR: ', HERO_2_MANA)
		  -- print('Hero2_Turns: ', HERO_2_TURN)
		  -- print('drop player ', looser)
		  -- consoleCmd('game_writelog 0')
		  --consoleCmd([[@SetGameVar('hero1_mana', 'return {]] .. HERO_1_MANA .. [[}')]])
		  finish = 1
    end

      --if not real_creatures_remained and guardian_angel_uses[side] <= 0 and not exist('temp-angel' .. side) then
			--	allow_finish = 1
			--end
			--local hero = GetHero(side)
			--if not real_creatures_remained and guardian_angel_uses[side] == 1 then
			--	guardian_angel_uses[side] = 0
			--	playAnimation(hero, 'buff')
			--	combatSetPause(1)
			--	sleep(100)
			--	local x, y = SafePos()
			--	local name = 'temp-angel' .. side
			--	AddCreature(side, 901, 10, x, y, 1, name)
			--	repeat sleep() until exist(name)
			--	displace(name, 7, 50)
			--	SetATB(name, 999)
			--	sleep(100)
			--	combatSetPause(nil)
			--	repeat sleep() until not exist(name)
			--end
		--end
		--if allow_finish then
		--	print('<color=yellow>Automatic finish enabled')
		--	EnableAutoFinish(1)
		--	break
		--end
		--sleep()
	end
end

---------------------------------------------------------------------------------------------------
--  ����������� �������
---------------------------------------------------------------------------------------------------

NewHandler(HANDLERS.PREPARE, OnPrepare)
NewHandler(HANDLERS.START, OnStart)
NewHandler(HANDLERS.DEATH.WAR_MACHINE, WarMachineDead)
NewHandler(HANDLERS.DEATH.CREATURE, CreatureDead)




---------------------------------------------------------------------------------------------------
--  ����� �����
---------------------------------------------------------------------------------------------------