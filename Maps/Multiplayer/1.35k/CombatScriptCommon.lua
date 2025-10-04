---------------------------------------------------------------------------------------------------
--  Условие запуска
---------------------------------------------------------------------------------------------------

if GetHost(DEFENDER) == 1 then
	return
end

---------------------------------------------------------------------------------------------------
--  Общие функции
---------------------------------------------------------------------------------------------------

print('<color=FF008000>Combat script execution started')

DIFF = GetDifficulty() + 1
PATH = '/' .. GetMapDataPath()

doFile(PATH .. 'common.lua')
sleep()

function InitRandom()
	local seed = parse(GetGameVar('combat_prng_seed'))()
	local state
	random, state = NewPRNG(seed)
	local sd = GetPRNGSeed(state)
	print('<color=blue>PRNG seed = '
		.. hex(sd[1]) .. ':'
		.. hex(sd[2]) .. ':'
		.. hex(sd[3]) .. ':'
		.. hex(sd[4]) .. ':'
		.. hex(sd[5]) .. ':'
		.. hex(sd[6]))
end

function InitScripts()
  print "InitScripts"

	doFile(PATH .. 'CombatScript.lua')
end

function CommonDefaults()
	consoleCmd('combat_time_factor 3')
	SetControlMode(ATTACKER, MODE_MANUAL)
	SetControlMode(DEFENDER, MODE_MANUAL)
end

NewHandler = append

function CallHandlers(table, param, ret)
	for i=1,table.n do
		ret = table[i](param) or ret
	end
	return ret
end

HANDLERS = {
	PREPARE = {n=0},
	START = {n=0},
	MOVE = {
		n = 0,
		HERO = {n=0}, CREATURE = {n=0}, WAR_MACHINE = {n=0}, BUILDING = {n=0},
		ATTACKER = {n = 0, HERO = {n=0}, CREATURE = {n=0}, WAR_MACHINE = {n=0}, BUILDING = {n=0}},
		DEFENDER = {n = 0, HERO = {n=0}, CREATURE = {n=0}, WAR_MACHINE = {n=0}, BUILDING = {n=0}},
	},
	DEATH = {
		n = 0,
		HERO = {n=0}, CREATURE = {n=0}, WAR_MACHINE = {n=0}, BUILDING = {n=0},
		ATTACKER = {n = 0, HERO = {n=0}, CREATURE = {n=0}, WAR_MACHINE = {n=0}, SPELL_SPAWN = {n=0}, BUILDING = {n=0}},
		DEFENDER = {n = 0, HERO = {n=0}, CREATURE = {n=0}, WAR_MACHINE = {n=0}, SPELL_SPAWN = {n=0}, BUILDING = {n=0}},
	},
}

DefaultCallback = Callback
function Callback(i, skip)
	--print('<color=FF008000>i = ', i, '<color=FF008000>; skip = ', skip)
	DefaultCallback(i, skip)
end

function SetATB(unit, atb)
	print('<color=FF4080FF>' .. unit .. ' moved to position ' .. atb .. ' on ATB') 
	setATB(unit, atb)
end

function Prepare()
	CallHandlers(HANDLERS.PREPARE)
end

function Start()
	CallHandlers(HANDLERS.START)
end

function UnitMove(unitName)
	local temp = CallHandlers(HANDLERS.MOVE, unitName)
	if IsHero(unitName) then
		temp = CallHandlers(HANDLERS.MOVE.HERO, unitName, temp)
	elseif IsCreature(unitName) then
		temp = CallHandlers(HANDLERS.MOVE.CREATURE, unitName, temp)
	elseif IsWarMachine(unitName) then
		temp = CallHandlers(HANDLERS.MOVE.WAR_MACHINE, unitName, temp)
	elseif IsBuilding(unitName) then
		temp = CallHandlers(HANDLERS.MOVE.BUILDING, unitName, temp)
	end
	if IsAttacker(unitName) then
		temp = CallHandlers(HANDLERS.MOVE.ATTACKER, unitName, temp)
		if IsHero(unitName) then
			temp = CallHandlers(HANDLERS.MOVE.ATTACKER.HERO, unitName, temp)
		elseif IsCreature(unitName) then
			temp = CallHandlers(HANDLERS.MOVE.ATTACKER.CREATURE, unitName, temp)
		elseif IsWarMachine(unitName) then
			temp = CallHandlers(HANDLERS.MOVE.ATTACKER.WAR_MACHINE, unitName, temp)
		elseif IsBuilding(unitName) then
			temp = CallHandlers(HANDLERS.MOVE.ATTACKER.BUILDING, unitName, temp)
		end
	elseif IsDefender(unitName) then
		temp = CallHandlers(HANDLERS.MOVE.DEFENDER, unitName, temp)
		if IsHero(unitName) then
			temp = CallHandlers(HANDLERS.MOVE.DEFENDER.HERO, unitName, temp)
		elseif IsCreature(unitName) then
			temp = CallHandlers(HANDLERS.MOVE.DEFENDER.CREATURE, unitName, temp)
		elseif IsWarMachine(unitName) then
			temp = CallHandlers(HANDLERS.MOVE.DEFENDER.WAR_MACHINE, unitName, temp)
		elseif IsBuilding(unitName) then
			temp = CallHandlers(HANDLERS.MOVE.DEFENDER.BUILDING, unitName, temp)
		end
	end
	return temp
end

function UnitDeath(unitName)
	CallHandlers(HANDLERS.DEATH, unitName)
	if IsHero(unitName) then
		CallHandlers(HANDLERS.DEATH.HERO, unitName)
	elseif IsCreature(unitName) then
		CallHandlers(HANDLERS.DEATH.CREATURE, unitName)
	elseif IsWarMachine(unitName) then
		CallHandlers(HANDLERS.DEATH.WAR_MACHINE, unitName)
	elseif IsBuilding(unitName) then
		CallHandlers(HANDLERS.DEATH.BUILDING, unitName)
	elseif IsSpellSpawn(unitName) then
		CallHandlers(HANDLERS.DEATH.SPELL_SPAWN, unitName)
	end
	if IsAttacker(unitName) then
		CallHandlers(HANDLERS.DEATH.ATTACKER, unitName)
		if IsHero(unitName) then
			CallHandlers(HANDLERS.DEATH.ATTACKER.HERO, unitName)
		elseif IsCreature(unitName) then
			CallHandlers(HANDLERS.DEATH.ATTACKER.CREATURE, unitName)
		elseif IsWarMachine(unitName) then
			CallHandlers(HANDLERS.DEATH.ATTACKER.WAR_MACHINE, unitName)
		elseif IsBuilding(unitName) then
			CallHandlers(HANDLERS.DEATH.ATTACKER.BUILDING, unitName)
		elseif IsSpellSpawn(unitName) then
			CallHandlers(HANDLERS.DEATH.ATTACKER.SPELL_SPAWN, unitName)
		end
	elseif IsDefender(unitName) then
		CallHandlers(HANDLERS.DEATH.DEFENDER, unitName)
		if IsHero(unitName) then
			CallHandlers(HANDLERS.DEATH.DEFENDER.HERO, unitName)
		elseif IsCreature(unitName) then
			CallHandlers(HANDLERS.DEATH.DEFENDER.CREATURE, unitName)
		elseif IsWarMachine(unitName) then
			CallHandlers(HANDLERS.DEATH.DEFENDER.WAR_MACHINE, unitName)
		elseif IsBuilding(unitName) then
			CallHandlers(HANDLERS.DEATH.DEFENDER.BUILDING, unitName)
		elseif IsSpellSpawn(unitName) then
			CallHandlers(HANDLERS.DEATH.DEFENDER.SPELL_SPAWN, unitName)
		end
	end
end


---------------------------------------------------------------------------------------------------
--  Управление боем
---------------------------------------------------------------------------------------------------

NewHandler(HANDLERS.START, CommonDefaults)

if GetGameVar('execution_thread') == '1' then
	startThread(InitScripts)
	NewHandler(HANDLERS.PREPARE, InitRandom)
end

---------------------------------------------------------------------------------------------------
--  Конец файла
---------------------------------------------------------------------------------------------------