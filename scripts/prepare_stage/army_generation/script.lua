army_generation = {
    distribution = {
        [TOWN_HEAVEN] = {
            [CREATURE_PEASANT] = 338,
            [CREATURE_ARCHER] = 144,
            [CREATURE_FOOTMAN] = 100,
            [CREATURE_GRIFFIN] = 45,
            [CREATURE_PRIEST] = 24,
            [CREATURE_CAVALIER] = 14,
            [CREATURE_ANGEL] = 6
        },
        [TOWN_INFERNO] = {
            [CREATURE_FAMILIAR] = 224,
            [CREATURE_DEMON] = 188,
            [CREATURE_HELL_HOUND] = 80,
            [CREATURE_SUCCUBUS] = 45,
            [CREATURE_NIGHTMARE] = 27,
            [CREATURE_PIT_FIEND] = 14,
            [CREATURE_DEVIL] = 6
        },
        [TOWN_NECROMANCY] = {
            [CREATURE_SKELETON] = 304,
            [CREATURE_WALKING_DEAD] = 180,
            [CREATURE_MANES] = 90,
            [CREATURE_VAMPIRE] = 45,
            [CREATURE_LICH] = 24,
            [CREATURE_WIGHT] = 14,
            [CREATURE_BONE_DRAGON] = 8
        },
        [TOWN_PRESERVE] = {
            [CREATURE_PIXIE] = 170,
            [CREATURE_BLADE_JUGGLER] = 108,
            [CREATURE_WOOD_ELF] = 70,
            [CREATURE_DRUID] = 36,
            [CREATURE_UNICORN] = 24,
            [CREATURE_TREANT] = 16,
            [CREATURE_GREEN_DRAGON] = 6
        },
        [TOWN_ACADEMY] = {
            [CREATURE_GREMLIN] = 280,
            [CREATURE_STONE_GARGOYLE] = 168,
            [CREATURE_IRON_GOLEM] = 90,
            [CREATURE_MAGI] = 45,
            [CREATURE_GENIE] = 30,
            [CREATURE_RAKSHASA] = 14,
            [CREATURE_GIANT] = 5
        },
        [TOWN_DUNGEON] = {
            [CREATURE_SCOUT] = 126,
            [CREATURE_WITCH] = 85,
            [CREATURE_MINOTAUR] = 72,
            [CREATURE_RIDER] = 38,
            [CREATURE_HYDRA] = 24,
            [CREATURE_MATRON] = 14,
            [CREATURE_DEEP_DRAGON] = 6
        },
        [TOWN_FORTRESS] = {
            [CREATURE_DEFENDER] = 252,
            [CREATURE_AXE_FIGHTER] = 168,
            [CREATURE_BEAR_RIDER] = 70,
            [CREATURE_BROWLER] = 66,
            [CREATURE_RUNE_MAGE] = 27,
            [CREATURE_THANE] = 14,
            [CREATURE_FIRE_DRAGON] = 6
        },
        [TOWN_STRONGHOLD] = {
            [CREATURE_GOBLIN] = 374,
            [CREATURE_CENTAUR] = 168,
            [CREATURE_ORC_WARRIOR] = 110,
            [CREATURE_SHAMAN] = 45,
            [CREATURE_ORCCHIEF_BUTCHER] = 40,
            [CREATURE_WYVERN] = 14,
            [CREATURE_CYCLOP] = 6
        }
    },

    Setup = 
    function ()
        for player = PLAYER_1, PLAYER_2 do
            local town = "player_"..player.."_main_town"
            local race = GetTownRace(town)
            for unit, count in army_generation.distribution[race] do
                SetObjectDwellingCreatures(town, unit, count)
            end
        end
    end
}