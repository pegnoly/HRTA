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

ADDITIONAL_LINE_DEFAULT_MIN_LEVEL = 1
ADDITIONAL_LINE_DEFAULT_MAX_LEVEL = 3

spells_generation_core = {
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
            [PLAYER_2] = { x = 44, y = 20 }
        },
        [SECOND_ADDITIONAL_LINE] = {
            [PLAYER_1] = { x = 38, y = 88 },
            [PLAYER_2] = { x = 39, y = 22 }
        },
        [THIRD_ADDITIONAL_LINE] = {
            [PLAYER_1] = { x = 33, y = 89 },
            [PLAYER_2] = { x = 44, y = 20 }
        }
    },

    current_placeholder_in_use = {[PLAYER_1] = 0, [PLAYER_2] = 0},
    
    spells_already_in_use = {[PLAYER_1] = {}, [PLAYER_2] = {}},

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
            [SECOND_MAIN_LINE] = { school = MAGIC_SCHOOL_DESTRUCTIVE, count = 5 },
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
            [FIRST_MAIN_LINE] = { school = MAGIC_SCHOOL_WARCRIES, count = 3}
        }
    },

    ---@type table<PlayerID, MagicLineEntry[]>
    generated_entries = {[PLAYER_1] = {}, [PLAYER_2] = {}},

    GetSpellsPool =
    ---comment
    ---@param model MagicLineModel
    ---@return table pool
    function (model)
        local pool = {}
        if model.schools then
            for _, school in model.schools do
                pool = list_iterator.Join(pool, spells_generation_core.allowed_spells[school])
            end
        else
            pool = spells_generation_core.allowed_spells[model.school] 
        end
        return pool
    end,

    GetRandomUnusedSpellOfLevel = 
    -- Генерирует случайный, еще не задействованный спелл указанного уровня
    ---@param player PlayerID
    ---@param spells number[]
    ---@param level number
    ---@return number spell
    function (player, spells, level)
        local possible_spells = list_iterator.Filter(spells, function (s)
            local l = %level
            local p = %player
            if Spell.Params.Level(s) == l and (not contains(spells_generation_core.spells_already_in_use[p], s)) then
                return 1
            end
            return nil
        end)
        local spell = Random.FromTable(possible_spells)
        return spell
    end,

    GetRandomUnusedSpellFromLevelRange = 
    -- Генерирует случайный, еще не задействованный спелл из диапазона уровней
    ---@param player PlayerID
    ---@param spells number []
    ---@param min_level number
    ---@param max_level number
    ---@return number spell
    function (player, spells, min_level, max_level)
        local possible_spells = list_iterator.Filter(spells, function (s)
            local min_lvl = %min_level
            local max_lvl = %max_level
            local p = %player
            local lvl = Spell.Params.Level(s)
            if (lvl >= min_lvl and lvl <= max_lvl) and (not contains(spells_generation_core.spells_already_in_use[p], s)) then
                return 1
            end
            return nil
        end)
        local spell = Random.FromTable(possible_spells)
        return spell
    end,

    ConfigureSpellEntry = 
    ---comment
    ---@param player PlayerID
    ---@param line MagicLineType
    ---@param spell number
    ---@param index number
    function (player, line, spell, index)
        spells_generation_core.current_placeholder_in_use[player] = spells_generation_core.current_placeholder_in_use[player] + 1
        local placeholder_name = "placeholder_spell_"..player..""..spells_generation_core.current_placeholder_in_use[player]
        local base_pos = spells_generation_core.lines_positions[line][player]
        ---@type MagicLineEntry
        local entry_data = {
            placeholder = placeholder_name,
            spell = spell,
            position = {
                x = base_pos.x + ((index - 1) * (player == PLAYER_1 and 1 or -1)),
                y = base_pos.y
            }
        }
        table.push(spells_generation_core.generated_entries[player], entry_data)
    end,

    GenerateMainMagicLine =
    ---comment
    ---@param player PlayerID
    ---@param line MagicLineType
    ---@param model MagicLineModel
    function (player, line, model)
        local pool = spells_generation_core.GetSpellsPool(model)
        local current_level = 1
        for index = 1, model.count do
            local spell = spells_generation_core.GetRandomUnusedSpellOfLevel(player, pool, current_level)
            table.push(spells_generation_core.spells_already_in_use[player], spell)
            spells_generation_core.ConfigureSpellEntry(player, line, spell, index)
            current_level = current_level + 1
        end
    end,

    GenerateAdditionalMagicLine =
    ---comment
    ---@param player PlayerID
    ---@param line MagicLineType
    ---@param model MagicLineModel
    function (player, line, model)
        local pool = spells_generation_core.GetSpellsPool(model)
        local min_level = model.min_lvl or ADDITIONAL_LINE_DEFAULT_MIN_LEVEL
        local max_level = model.max_lvl or ADDITIONAL_LINE_DEFAULT_MAX_LEVEL
        for index = 1, model.count do
            local spell = spells_generation_core.GetRandomUnusedSpellFromLevelRange(player, pool, min_level, max_level)
            table.push(spells_generation_core.spells_already_in_use[player], spell)
            spells_generation_core.ConfigureSpellEntry(player, line, spell, index)
        end
    end,

    PregenerateSpells = 
    function ()
        for player = PLAYER_1, PLAYER_2 do
            local race = players_utils.GetPlayerSelectedRace(player)
            ---@param line MagicLineType
            ---@param model MagicLineModel
            for line, model in spells_generation_core.lines_by_races[race] do
                if line >= FIRST_MAIN_LINE and line <= THIRD_MAIN_LINE then
                    spells_generation_core.GenerateMainMagicLine(player, line, model)
                else
                    spells_generation_core.GenerateAdditionalMagicLine(player, line, model)
                end
            end
        end
        print(spells_generation_core.generated_entries[PLAYER_1])
    end,

    PlaceSpells = 
    function ()
        for player = PLAYER_1, PLAYER_2 do
            startThread(spells_generation_core.PlaceSpellsPool, player)
        end
    end,

    PlaceSpellsPool =
    function (player)
        ---@param entry MagicLineEntry
        for _, entry in spells_generation_core.generated_entries[player] do
            startThread(spells_generation_core.PlaceSpellEntry, entry)
        end
    end,

    PlaceSpellEntry =
    ---comment
    ---@param entry MagicLineEntry
    function (entry)
        local effect = "/Effects/Spells/"..entry.spell.."/active.(Effect).xdb#xpointer(/Effect)"
        SetObjectPosition(entry.placeholder, entry.position.x, entry.position.y, GROUND)
        PlayVisualEffect(effect, entry.placeholder)
    end
}