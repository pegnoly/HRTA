--- Мейн скрипт настройки зданий в городах игроков

towns_setup = {
    -- Здания, которые необходимо построить в городах конкретных фрак, кроме двеллов
    ---@type table<TownType, table<TownBuildingType, number>>
    additional_buildings_to_upgrade = {
        [TOWN_ACADEMY] = {
            [TOWN_BUILDING_ACADEMY_ARTIFACT_MERCHANT] = 1,
            [TOWN_BUILDING_ACADEMY_LIBRARY] = 1,
            [TOWN_BUILDING_ACADEMY_TREASURE_CAVE] = 1
        },
        [TOWN_DUNGEON] = {
            [TOWN_BUILDING_DUNGEON_TRADE_GUILD] = 1,
        },
        [TOWN_HEAVEN] = {
            [TOWN_BUILDING_HAVEN_FARMS] = 1,
        },
        [TOWN_PRESERVE] = {
            [TOWN_BUILDING_PRESERVE_BLOOMING_GROVE] = 1,
            [TOWN_BUILDING_PRESERVE_TREANT_SAMPLING] = 1
        },
        [TOWN_INFERNO] = {
            [TOWN_BUILDING_INFERNO_HALLS_OF_HORROR] = 1,
            [TOWN_BUILDING_SPECIAL_2] = 1 -- nival 
        },
        [TOWN_NECROMANCY] = {
            [TOWN_BUILDING_NECROMANCY_UNEARHED_GRAVES] = 1,
            [TOWN_BUILDING_NECROMANCY_DRAGON_TOMBSTONE] = 1
        },
        [TOWN_FORTRESS] = {
            [TOWN_BUILDING_FORTRESS_ARENA] = 1,
            [TOWN_BUILDING_FORTRESS_RUNIC_ACADEMY] = 1
        },
        [TOWN_STRONGHOLD] = {
            [TOWN_BUILDING_STRONGHOLD_GARBAGE_PILE] = 1
        }
    },

    -- Здания, которые необходимо запретить в городах
    ---@type table<TownType | 'common', table<TownBuildingType, number>>
    additional_buildings_to_set_limit = {
        common = {
            [TOWN_BUILDING_TOWN_HALL] = 1,
            [TOWN_BUILDING_FORT] = 0,
            [TOWN_BUILDING_MARKETPLACE] = 0,
            [TOWN_BUILDING_SHIPYARD] = 0,
            [TOWN_BUILDING_TAVERN] = 0,
            [TOWN_BUILDING_BLACKSMITH] = 0,
            [TOWN_BUILDING_MAGIC_GUILD] = 0,
            [TOWN_BUILDING_GRAIL] = 0
        },
        [TOWN_HEAVEN] = {
            [TOWN_BUILDING_HAVEN_TRAINING_GROUNDS] = 0,
            [TOWN_BUILDING_HAVEN_FARMS] = 0,
            [TOWN_BUILDING_HAVEN_STABLE] = 0
        },
        [TOWN_INFERNO] = {
            [TOWN_BUILDING_INFERNO_INFERNAL_LOOM] = 0,
            [TOWN_BUILDING_INFERNO_SACRIFICIAL_PIT] = 0
        },
        [TOWN_NECROMANCY] = {
            [TOWN_BUILDING_NECROMANCY_AMPLIFIER] = 0,
            [TOWN_BUILDING_NECROMANCY_SHROUD_OF_DARKNESS] = 0,
            [TOWN_BUILDING_NECROMANCY_UNHOLY_TEMPLE] = 0
        },
        [TOWN_PRESERVE] = {
            [TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD] = 0,
            [TOWN_BUILDING_PRESERVE_MYSTIC_POND] = 0
        },
        [TOWN_DUNGEON] = {
            [TOWN_BUILDING_SPECIAL_3] = 0, -- nival 2
            [TOWN_BUILDING_DUNGEON_HALL_OF_INTRIGUE] = 0,
            [TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS] = 0
        },
        [TOWN_ACADEMY] = {
            [TOWN_BUILDING_ACADEMY_ARCANE_FORGE] = 0,
            [TOWN_BUILDING_ACADEMY_ELEMENTAL_ENCLAVE] = 0,
        },
        [TOWN_FORTRESS] = {
            [TOWN_BUILDING_FORTRESS_GUARDPOST] = 0,
            [TOWN_BUILDING_FORTRESS_RUNIC_SHRINE] = 0,
            [TOWN_BUILDING_FORTRESS_RUNIC_STONEWORKS] = 0
        },
        [TOWN_STRONGHOLD] = {
            [TOWN_BUILDING_STRONGHOLD_HALL_OF_TRIAL] = 0,
            [TOWN_BUILDING_STRONGHOLD_PILE_OF_OUR_FOES] = 0,
            [TOWN_BUILDING_STRONGHOLD_SLAVE_MARKET] = 0,
            [TOWN_BUILDING_STRONGHOLD_TRAVELLERS_SHELTER] = 0
        }
    },

    Init =
    --- Входная точка настройки городов
    function ()
        for player = PLAYER_1, PLAYER_2 do
            local town = "player_"..player.."_main_town"
            local race = players_utils.GetPlayerSelectedRace(player)
            startThread(towns_setup.SetupTown, town, race)
        end
    end,

    SetupTown = 
    --- Настраивает постройки в конкретном городе
    ---@param town string Скриптовое имя города
    ---@param race TownType Фракция города
    function (town, race)
        if GetTownRace(town) ~= race then
            TransformTown(town, race)
            while GetTownRace(town) ~= race do
                sleep()
            end
        end
        --
        for dwelling = TOWN_BUILDING_DWELLING_1, TOWN_BUILDING_DWELLING_7 do
            for _ = 1, 2 do
                UpgradeTownBuilding(town, dwelling)
            end
        end
        sleep()
        for building, level in towns_setup.additional_buildings_to_upgrade[race] do
            for _ = 1, level do
                UpgradeTownBuilding(town, building)
            end
        end
        sleep()
        for building, level in towns_setup.additional_buildings_to_set_limit.common do
            SetTownBuildingLimitLevel(town, building, level)
        end
        sleep()
        for building, level in towns_setup.additional_buildings_to_set_limit[race] do
            SetTownBuildingLimitLevel(town, building, level)
        end
    end
}