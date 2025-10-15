---@alias MagicLineType
---|`FIRST_MAIN_LINE`
---|`SECOND_MAIN_LINE`
---|`THIRD_MAIN_LINE`
---|`RUNES_LINE`
---|`WARCRIES_LINE`
---|`FIRST_ADDITIONAL_LINE`
---|`SECOND_ADDITIONAL_LINE`
---|`THIRD_ADDITIONAL_LINE`
FIRST_MAIN_LINE = 1
SECOND_MAIN_LINE = 2
THIRD_MAIN_LINE = 3
RUNES_LINE = 4
WARCRIES_LINE = 5
FIRST_ADDITIONAL_LINE = 6
SECOND_ADDITIONAL_LINE = 7
THIRD_ADDITIONAL_LINE = 8

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

    lines_data = {
        [FIRST_MAIN_LINE] = {
            [PLAYER_1] = {
                x = 37,
                y = 88,
            },
            [PLAYER_2] = {

            },
            count = 5
        }
    },

    ---@type table<TownType, table<MagicLineType, SpellSchoolType>>
    lines_by_races = {
    },


    GenerateMainMagicLine = 
    function (race, line_type)
        
    end,

    GenerateAdditionalMagicLine =
    function (line_type, spells_count)
        
    end
}