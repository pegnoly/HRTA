-- Типы линеек спеллов
---@alias MagicLineType
---|`FIRST_MAIN_LINE` 
---|`SECOND_MAIN_LINE`
---|`THIRD_MAIN_LINE`
---|`FIRST_ADDITIONAL_LINE`
---|`SECOND_ADDITIONAL_LINE`
---|`THIRD_ADDITIONAL_LINE`
FIRST_MAIN_LINE = 1
SECOND_MAIN_LINE = 2
THIRD_MAIN_LINE = 3
FIRST_ADDITIONAL_LINE = 4
SECOND_ADDITIONAL_LINE = 5
THIRD_ADDITIONAL_LINE = 6

-- Дефолтный минимальный уровень спеллов в доп линейке
ADDITIONAL_LINE_DEFAULT_MIN_LEVEL = 1
-- Дефолтный максимальный уровень спеллов в доп линейке
ADDITIONAL_LINE_DEFAULT_MAX_LEVEL = 3

spells_generation_core = {
    ---@type table<SpellSchoolType, number[]>
    -- Доступные для генерации спеллы
    allowed_spells = {
        [MAGIC_SCHOOL_DESTRUCTIVE] = {
            SPELL_MAGIC_ARROW, SPELL_STONE_SPIKES,
            SPELL_ICE_BOLT, SPELL_LIGHTNING_BOLT, SPELL_FIREWALL,
            SPELL_FIREBALL, SPELL_FROST_RING,
            SPELL_METEOR_SHOWER, SPELL_CHAIN_LIGHTNING,
            SPELL_ARMAGEDDON, SPELL_IMPLOSION, SPELL_DEEP_FREEZE
        },
        [MAGIC_SCHOOL_LIGHT] = {
            SPELL_BLESS, SPELL_REGENERATION, SPELL_HASTE,
            SPELL_DEFLECT_ARROWS, SPELL_STONESKIN, SPELL_DISPEL,
            SPELL_BLOODLUST, SPELL_ANTI_MAGIC,
            SPELL_TELEPORT, SPELL_RESURRECT
        },
        [MAGIC_SCHOOL_DARK] = {
            SPELL_SLOW, SPELL_CURSE, SPELL_DISRUPTING_RAY,
            SPELL_WEAKNESS, SPELL_FORGETFULNESS, SPELL_PLAGUE,
            SPELL_BERSERK, SPELL_HYPNOTIZE,
            SPELL_VAMPIRISM, SPELL_BLIND
        },
        [MAGIC_SCHOOL_SUMMONING] = {
            SPELL_WASP_SWARM, SPELL_LAND_MINE, SPELL_MAGIC_FIST,
            SPELL_ARCANE_CRYSTAL, SPELL_SUMMON_ELEMENTALS,
            SPELL_PHANTOM, SPELL_BLADE_BARRIER,
            SPELL_SUMMON_HIVE, SPELL_CONJURE_PHOENIX,
            SPELL_CELESTIAL_SHIELD
        },
        [MAGIC_SCHOOL_RUNIC] = range_generator.FromTop(SPELL_RUNE_OF_CHARGE, SPELL_RUNE_OF_DRAGONFORM),
        [MAGIC_SCHOOL_WARCRIES] = range_generator.FromTop(SPELL_WARCRY_RALLING_CRY, SPELL_WARCRY_SHOUT_OF_MANY)
    },

    ---@type table<MagicLineType, table<PlayerID, Position>>
    -- Позиции на карте, с которых начинается генерация эффектов линеек спеллов
    lines_positions = {
        [FIRST_MAIN_LINE] = {
            [PLAYER_1] = { x = 33, y = 87 },
            [PLAYER_2] = { x = 44, y = 22 }
        },
        [SECOND_MAIN_LINE] = {
            [PLAYER_1] = { x = 33, y = 88 },
            [PLAYER_2] = { x = 44, y = 21 }
        },
        [THIRD_MAIN_LINE] = {
            [PLAYER_1] = { x = 33, y = 89 },
            [PLAYER_2] = { x = 44, y = 20 },
        },
        [FIRST_ADDITIONAL_LINE] = {
            [PLAYER_1] = { x = 38, y = 87 },
            [PLAYER_2] = { x = 39, y = 22 }
        },
        [SECOND_ADDITIONAL_LINE] = {
            [PLAYER_1] = { x = 38, y = 88 },
            [PLAYER_2] = { x = 39, y = 21 }
        },
        [THIRD_ADDITIONAL_LINE] = {
            [PLAYER_1] = { x = 33, y = 89 },
            [PLAYER_2] = { x = 44, y = 20 }
        }
    },

    ---@type table<TownType, table<MagicLineType, MagicLineModel>>
    lines_by_races = {
        [TOWN_HEAVEN] = {
            [FIRST_MAIN_LINE] = { school = MAGIC_SCHOOL_LIGHT, count = 5 },
            [SECOND_MAIN_LINE] = { school = MAGIC_SCHOOL_DARK, count = 5 },
            [FIRST_ADDITIONAL_LINE] = { schools = {MAGIC_SCHOOL_SUMMONING, MAGIC_SCHOOL_DESTRUCTIVE}, count = 2 },
            [SECOND_ADDITIONAL_LINE] = { schools = {MAGIC_SCHOOL_SUMMONING, MAGIC_SCHOOL_DESTRUCTIVE}, count = 1 },
        },
        [TOWN_INFERNO] = {
            [FIRST_MAIN_LINE] = { school = MAGIC_SCHOOL_DARK, count = 5 },
            [SECOND_MAIN_LINE] = { school = MAGIC_SCHOOL_DESTRUCTIVE, count = 5 },
            [FIRST_ADDITIONAL_LINE] = { schools = {MAGIC_SCHOOL_SUMMONING, MAGIC_SCHOOL_LIGHT}, count = 2 },
            [SECOND_ADDITIONAL_LINE] = { schools = {MAGIC_SCHOOL_SUMMONING, MAGIC_SCHOOL_LIGHT}, count = 1 },
        },
        [TOWN_NECROMANCY] = {
            [FIRST_MAIN_LINE] = { school = MAGIC_SCHOOL_DARK, count = 5 },
            [SECOND_MAIN_LINE] = { school = MAGIC_SCHOOL_SUMMONING, count = 5 },
            [FIRST_ADDITIONAL_LINE] = { schools = {MAGIC_SCHOOL_LIGHT, MAGIC_SCHOOL_DESTRUCTIVE}, count = 2 },
            [SECOND_ADDITIONAL_LINE] = { schools = {MAGIC_SCHOOL_LIGHT, MAGIC_SCHOOL_DESTRUCTIVE}, count = 1 },
        },
        [TOWN_PRESERVE] = {
            [FIRST_MAIN_LINE] = { school = MAGIC_SCHOOL_LIGHT, count = 5 },
            [SECOND_MAIN_LINE] = { school = MAGIC_SCHOOL_DESTRUCTIVE, count = 5 },
            [FIRST_ADDITIONAL_LINE] = { schools = {MAGIC_SCHOOL_SUMMONING, MAGIC_SCHOOL_DARK}, count = 2 },
            [SECOND_ADDITIONAL_LINE] = { schools = {MAGIC_SCHOOL_SUMMONING, MAGIC_SCHOOL_DARK}, count = 1 },
        },
        [TOWN_DUNGEON] = {
            [FIRST_MAIN_LINE] = { school = MAGIC_SCHOOL_DESTRUCTIVE, count = 5 },
            [SECOND_MAIN_LINE] = { school = MAGIC_SCHOOL_SUMMONING, count = 5 },
            [FIRST_ADDITIONAL_LINE] = { schools = {MAGIC_SCHOOL_SUMMONING, MAGIC_SCHOOL_DARK}, count = 2 },
            [SECOND_ADDITIONAL_LINE] = { schools = {MAGIC_SCHOOL_SUMMONING, MAGIC_SCHOOL_DARK}, count = 1 },
            [THIRD_ADDITIONAL_LINE] = { schools = {MAGIC_SCHOOL_SUMMONING, MAGIC_SCHOOL_DARK, MAGIC_SCHOOL_DESTRUCTIVE, MAGIC_SCHOOL_LIGHT}, count = 3 },
        },
        [TOWN_ACADEMY] = {
            [FIRST_MAIN_LINE] = { school = MAGIC_SCHOOL_SUMMONING, count = 5},
        },
        [TOWN_FORTRESS] = {
            [FIRST_MAIN_LINE] = { school = MAGIC_SCHOOL_LIGHT, count = 5 },
            [SECOND_MAIN_LINE] = { school = MAGIC_SCHOOL_DESTRUCTIVE, count = 5 },
            [THIRD_MAIN_LINE] = { school = MAGIC_SCHOOL_RUNIC, count = 5},
            [FIRST_ADDITIONAL_LINE] = { schools = {MAGIC_SCHOOL_SUMMONING, MAGIC_SCHOOL_DARK}, count = 2 },
            [SECOND_ADDITIONAL_LINE] = { schools = {MAGIC_SCHOOL_SUMMONING, MAGIC_SCHOOL_DARK}, count = 1 },
        },
        [TOWN_STRONGHOLD] = {
            [FIRST_MAIN_LINE] = { school = MAGIC_SCHOOL_WARCRIES, count = 3, space = 2}
        }
    },

    CreateSpellsPool =
    -- Производит список спеллов для генерации
    ---@param model MagicLineModel Модель данных о линейке спеллов
    ---@return table pool
    function (model)
        local pool = {}
        if model.schools then
            for _, school in model.schools do
                pool = list_iterator.Join(pool, spells_generation_core.allowed_spells[school])
            end
        else
            pool = spells_generation_core.allowed_spells[model.school]
            print("<color=red>Pool for model ", model, " is ", pool)
        end
        return pool
    end,

    GetRandomUnusedSpellOfLevel = 
    -- Генерирует случайный, еще не задействованный спелл указанного уровня
    ---@param player PlayerID Id игрока, для которого генерируется спелл
    ---@param spells_pool number[] Спеллы, из которых совершается выбор при генерации
    ---@param level number Уровень спелла для генерации
    ---@param used_spells number [] Спеллы, уже задействованные в генерации
    ---@return number spell
    function (player, spells_pool, level, used_spells)
        local possible_spells = list_iterator.Filter(spells_pool, function (s)
            local l = %level
            local sp = %used_spells
            if Spell.Params.Level(s) == l and (not contains(sp, s)) then
                return 1
            end
            return nil
        end)
        local spell = Random.FromTable(possible_spells)
        return spell
    end,

    GetRandomUnusedSpellFromLevelRange = 
    -- Генерирует случайный, еще не задействованный спелл из диапазона уровней
    ---@param player PlayerID Id игрока, для которого генерируется спелл
    ---@param spells_pool number [] Спеллы, из которых совершается выбор при генерации
    ---@param min_level number Минимальный уровень спеллов для генерации
    ---@param max_level number Максимальный уровень спеллов для генерации
    ---@param used_spells number [] Спеллы, уже задействованные в генерации
    ---@return number spell
    function (player, spells_pool, min_level, max_level, used_spells)
        local possible_spells = list_iterator.Filter(spells_pool, function (s)
            local min_lvl = %min_level
            local max_lvl = %max_level
            local sp = %used_spells
            local lvl = Spell.Params.Level(s)
            if (lvl >= min_lvl and lvl <= max_lvl) and (not contains(sp, s)) then
                return 1
            end
            return nil
        end)
        local spell = Random.FromTable(possible_spells)
        return spell
    end,

    Init = 
    function ()
        local academy_additional_schools = {MAGIC_SCHOOL_DARK, MAGIC_SCHOOL_LIGHT, MAGIC_SCHOOL_DESTRUCTIVE}
        local academy_second_school = Random.FromTable(academy_additional_schools)
        academy_additional_schools = list_iterator.Filter(academy_additional_schools, function (s)
            local as = %academy_second_school
            if s == as then
                return nil
            end
            return 1
        end)
        local academy_third_school = Random.FromTable(academy_additional_schools)
        spells_generation_core.lines_by_races[TOWN_ACADEMY][SECOND_MAIN_LINE] = { school = academy_second_school, count = 5 }
        spells_generation_core.lines_by_races[TOWN_ACADEMY][THIRD_MAIN_LINE] = { school = academy_third_school, count = 5 }
    end
}