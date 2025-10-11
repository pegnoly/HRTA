while not astrology_core do
    sleep()
end

astrology_auotor_mode = {

    start_gold = 25000,

    town_initial_positions = {},

    town_move_positions = {
        ["RANDOMTOWN1"] = { x = 16, y = 54, f = GROUND},
        ["RANDOMTOWN2"] = { x = 5, y = 52, f = GROUND}
    },

    creature_boxes_positions = {
        [PLAYER_1] = {
            { x = 44, y = 87},
            { x = 46, y = 87},
            { x = 48, y = 87},
            { x = 43, y = 89},
            { x = 45, y = 89},
            { x = 47, y = 89},
            { x = 49, y = 89},
        },
        [PLAYER_2] = {
            { x = 45, y = 7},
            { x = 43, y = 7},
            { x = 41, y = 7},
            { x = 46, y = 5},
            { x = 44, y = 5},
            { x = 42, y = 5},
            { x = 40, y = 5},
        }
    },

    artifact_boxes_positions = {
        [PLAYER_1] = {
            { x = 50, y = 81 },
            { x = 51, y = 81 },
            { x = 52, y = 81 }
        },
        [PLAYER_2] = {
            { x = 39, y = 12 },
            { x = 38, y = 12 },
            { x = 37, y = 12 }
        }
    },

    actual_creatures_to_give = {
        [TOWN_HEAVEN] = {
            [1] = {CREATURE_PEASANT, CREATURE_LANDLORD},
            [2] = {CREATURE_ARCHER, CREATURE_LONGBOWMAN},
            [3] = {CREATURE_FOOTMAN, CREATURE_VINDICATOR},
            [4] = {CREATURE_GRIFFIN, CREATURE_BATTLE_GRIFFIN},
            [5] = {CREATURE_PRIEST, CREATURE_ZEALOT},
            [6] = {CREATURE_CAVALIER, CREATURE_CHAMPION},
            [7] = {CREATURE_ANGEL, CREATURE_SERAPH},
        },
        [TOWN_PRESERVE] = {
            [1] = {CREATURE_PIXIE, CREATURE_DRYAD},
            [2] = {CREATURE_BLADE_JUGGLER, CREATURE_BLADE_SINGER},
            [3] = {CREATURE_WOOD_ELF, CREATURE_SHARP_SHOOTER},
            [4] = {CREATURE_DRUID, CREATURE_HIGH_DRUID},
            [5] = {CREATURE_UNICORN, CREATURE_WHITE_UNICORN},
            [6] = {CREATURE_TREANT, CREATURE_ANGER_TREANT},
            [7] = {CREATURE_GREEN_DRAGON, CREATURE_RAINBOW_DRAGON},
        },
        [TOWN_ACADEMY] = {
            [1] = {CREATURE_GREMLIN, CREATURE_GREMLIN_SABOTEUR},
            [2] = {CREATURE_STONE_GARGOYLE, CREATURE_MARBLE_GARGOYLE},
            [3] = {CREATURE_IRON_GOLEM, CREATURE_OBSIDIAN_GOLEM},
            [4] = {CREATURE_MAGI, CREATURE_COMBAT_MAGE},
            [5] = {CREATURE_GENIE, CREATURE_DJINN_VIZIER},
            [6] = {CREATURE_RAKSHASA, CREATURE_RAKSHASA_KSHATRI},
            [7] = {CREATURE_GIANT, CREATURE_STORM_LORD},
        },
        [TOWN_DUNGEON] = {
            [1] = {CREATURE_DEFENDER, CREATURE_STONE_DEFENDER},
            [2] = {CREATURE_WITCH, CREATURE_BLOOD_WITCH_2},
            [3] = {CREATURE_MINOTAUR, CREATURE_MINOTAUR_CAPTAIN},
            [4] = {CREATURE_RIDER, CREATURE_BLACK_RIDER},
            [5] = {CREATURE_HYDRA, CREATURE_ACIDIC_HYDRA},
            [6] = {CREATURE_MATRON, CREATURE_SHADOW_MISTRESS},
            [7] = {CREATURE_DEEP_DRAGON, CREATURE_RED_DRAGON},
        },
        [TOWN_NECROMANCY] = {
            [1] = {CREATURE_SKELETON, CREATURE_SKELETON_WARRIOR},
            [2] = {CREATURE_WALKING_DEAD, CREATURE_DISEASE_ZOMBIE},
            [3] = {CREATURE_GHOST, CREATURE_POLTERGEIST},
            [4] = {CREATURE_VAMPIRE, CREATURE_NOSFERATU},
            [5] = {CREATURE_LICH, CREATURE_LICH_MASTER},
            [6] = {CREATURE_WIGHT, CREATURE_BANSHEE},
            [7] = {CREATURE_BONE_DRAGON, CREATURE_HORROR_DRAGON},
        },
        [TOWN_INFERNO] = {
            [1] = {CREATURE_FAMILIAR, CREATURE_QUASIT},
            [2] = {CREATURE_DEMON, CREATURE_HORNED_LEAPER},
            [3] = {CREATURE_HELL_HOUND, CREATURE_FIREBREATHER_HOUND},
            [4] = {CREATURE_SUCCUBUS, CREATURE_SUCCUBUS_SEDUCER},
            [5] = {CREATURE_NIGHTMARE, CREATURE_HELLMARE},
            [6] = {CREATURE_PIT_FIEND, CREATURE_PIT_SPAWN},
            [7] = {CREATURE_DEVIL, CREATURE_ARCH_DEMON},
        },
        [TOWN_FORTRESS] = {
            [1] = {CREATURE_SCOUT, CREATURE_STALKER},
            [2] = {CREATURE_AXE_FIGHTER, CREATURE_HARPOONER},
            [3] = {CREATURE_BEAR_RIDER, CREATURE_WHITE_BEAR_RIDER},
            [4] = {CREATURE_BROWLER, CREATURE_BATTLE_RAGER},
            [5] = {CREATURE_RUNE_MAGE, CREATURE_FLAME_KEEPER},
            [6] = {CREATURE_THANE, CREATURE_THUNDER_THANE},
            [7] = {CREATURE_MAGMA_DRAGON, CREATURE_LAVA_DRAGON},
        },
        [TOWN_STRONGHOLD] = {
            [1] = {CREATURE_GOBLIN, CREATURE_GOBLIN_DEFILER},
            [2] = {CREATURE_CENTAUR, CREATURE_CENTAUR_MARADEUR},
            [3] = {CREATURE_ORC_WARRIOR, CREATURE_ORC_WARMONGER},
            [4] = {CREATURE_SHAMAN, CREATURE_SHAMAN_HAG},
            [5] = {CREATURE_ORCCHIEF_BUTCHER, CREATURE_ORCCHIEF_CHIEFTAIN},
            [6] = {CREATURE_WYVERN, CREATURE_WYVERN_PAOKAI},
            [7] = {CREATURE_CYCLOP, CREATURE_CYCLOP_BLOODEYED},
        }
    },

    heroes_coordinates = {
        [PLAYER_1] = {},
        [PLAYER_2] = {},
    },

    special_day_transfer_status = {
        [PLAYER_1] = nil,
        [PLAYER_2] = nil
    },

    Init = 
    function ()
        for _, town in {"RANDOMTOWN1", "RANDOMTOWN2"} do
            MakeTownMovable(town)
            local x, y, f = GetObjectPosition(town)
            astrology_auotor_mode.town_initial_positions[town] = { x = x, y = y, f = f}
            local pos_to_move = astrology_auotor_mode.town_move_positions[town]
            SetObjectPosition(town, pos_to_move.x, pos_to_move.y, pos_to_move.f)
        end

        for player = PLAYER_1, PLAYER_2 do
            for tier = 1, 7 do
                local name_path = "auotor_creature_t"..tier..".txt"
                local desc_path = "auotor_creature_t"..tier.."_desc.txt"
                local box_name = "auotor_creature_p"..player.."t"..tier
                Touch.DisableObject(box_name, DISABLED_DEFAULT, astrology_core.path..name_path, astrology_core.path..desc_path)
                Touch.SetFunction(box_name, "_touch", 
                function (hero, object)
                    local tier = %tier
                    startThread(astrology_auotor_mode.GiveCreatures, hero, object, tier)
                end)
            end

            for class = ARTF_CLASS_MINOR, ARTF_CLASS_RELIC do
                local name_path = "auotor_art_t"..class..".txt"
                local desc_path = "auotor_art_t"..class.."_desc.txt"
                local box_name = "auotor_art_p"..player.."t"..class
                Touch.DisableObject(box_name, DISABLED_DEFAULT, astrology_core.path..name_path, astrology_core.path..desc_path)
                Touch.SetFunction(box_name, "_touch", 
                function (hero, object)
                    local class = %class
                    startThread(astrology_auotor_mode.GiveArtifact, hero, object, class)
                end)
            end
        end
    end,

    SpawnCreatureBoxes =
    function (player)
        for tier = 1, 7 do
            startThread(astrology_auotor_mode.SpawnCreatureBox, player, tier)
        end
    end,

    SpawnCreatureBox = 
    function (player, tier)
        local box_name = "auotor_creature_p"..player.."t"..tier
        local pos = astrology_auotor_mode.creature_boxes_positions[player][tier]
        SetObjectPosition(box_name, pos.x, pos.y, GROUND)
        if player == PLAYER_2 then
            SetObjectRotation(box_name, 180)
        end
    end,

    SpawnArtifactBoxes = 
    function (player)
        for class = ARTF_CLASS_MINOR, ARTF_CLASS_RELIC do
            startThread(astrology_auotor_mode.SpawnArtifactBox, player, class)
        end
    end,

    SpawnArtifactBox = 
    function (player, class)
        local box_name = "auotor_art_p"..player.."t"..class
        local pos = astrology_auotor_mode.artifact_boxes_positions[player][class]
        SetObjectPosition(box_name, pos.x, pos.y, GROUND)
        if player == PLAYER_2 then
            SetObjectRotation(box_name, 180)
        end
    end,

    GiveCreatures = 
    function (hero, object, tier)
        local race = Random.FromTable(range_generator.FromTop(TOWN_HEAVEN, TOWN_STRONGHOLD))
        local creature = Random.FromTable(astrology_auotor_mode.actual_creatures_to_give[race][tier])
        local count
        for _, race_data in UNITS do
            for _, unit_data in race_data do
                if unit_data.id == creature then
                    count = unit_data.kol
                    break
                end
            end
        end

        if count then
            if creature == CREATURE_DEFENDER or creature == CREATURE_STONE_DEFENDER then
                count = 126
            end
            RemoveObject(object)
            Hero.CreatureInfo.Add(hero, creature, count)
        end
    end,

    GiveArtifact =
    function (hero, object, class)
        local level = class - 1
        local possible_arts = list_iterator.FilterMap(ALL_ARTS_LIST, function (data)
            local level = %level
            if (data.level == level) then
                return data.id
            end
            return nil
        end)
        local art_to_give = Random.FromTable(possible_arts)
        RemoveObject(object)
        Art.Distribution.Give(hero, art_to_give, 1)
    end,

    TransferToSpecialDay = 
    function (player)
        astrology_auotor_mode.RemoveUnusedBoxes(player)
        astrology_auotor_mode.ReturnTown(player)
    end,

    RemoveUnusedBoxes = 
    function (player)
        for tier = 1, 7 do
            local box_name = "auotor_creature_p"..player.."t"..tier
            if IsObjectExists(box_name) then
                RemoveObject(box_name)
            end
        end

        for class = ARTF_CLASS_MINOR, ARTF_CLASS_RELIC do
            local box_name = "auotor_art_p"..player.."t"..class
            if IsObjectExists(box_name) then
                RemoveObject(box_name)
            end
        end
    end,

    ReturnTown = 
    function (player)
        for i, hero in GetPlayerHeroes(player) do
            if astrology_auotor_mode.heroes_coordinates[player][hero] then
                local pos = astrology_auotor_mode.heroes_coordinates[player][hero]
                SetObjectPosition(hero, pos.x, pos.y, GROUND)
            end
        end
        local town = player == PLAYER_1 and "RANDOMTOWN1" or "RANDOMTOWN2"
        MakeTownMovable(town) -- nival)
        local pos = astrology_auotor_mode.town_initial_positions[town]
        SetObjectPosition(town, pos.x, pos.y, GROUND)
        sleep()
        SetObjectOwner(town, player)
        sleep()
        astrology_auotor_mode.special_day_transfer_status[player] = 1
    end
}

NewDayEvent.AddListener("HRTA_astrology_auotor_mode_show_selected_listener",
function (day)
    if day == astrology_core.start_day and game_modes_core.current_mode == GAME_MODE_ASTROLOGY and astrology_core.current_week == ASTROLOGY_WEEK_AUOTOR  then
        startThread(astrology_auotor_mode.Init)
        for player = PLAYER_1, PLAYER_2 do
           startThread(MCCS_MessageBoxForPlayers, player, astrology_core.path.."auotor_week_desc.txt")
        end
    end
end)

NewDayEvent.AddListener("HRTA_astrology_auotor_mode_prefight_day_listener",
function (day)
    if day == 3 and game_modes_core.current_mode == GAME_MODE_ASTROLOGY and astrology_core.current_week == ASTROLOGY_WEEK_AUOTOR then
        for player = PLAYER_1, PLAYER_2 do
            startThread(astrology_auotor_mode.SpawnCreatureBoxes, player)
            startThread(astrology_auotor_mode.SpawnArtifactBoxes, player)
        end
    end
end)

NewDayEvent.AddListener("HRTA_astrology_auotor_mode_special_day_listener",
function (day)
    if day == 4 and game_modes_core.current_mode == GAME_MODE_ASTROLOGY and astrology_core.current_week == ASTROLOGY_WEEK_AUOTOR then
        for player = PLAYER_1, PLAYER_2 do
            startThread(astrology_auotor_mode.TransferToSpecialDay, player)
        end
    end
end)