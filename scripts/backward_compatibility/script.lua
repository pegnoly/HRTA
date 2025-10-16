backward_compatibility = {

    map_town_to_race = {
        [TOWN_HEAVEN] = RACES.HAVEN,
        [TOWN_INFERNO] = RACES.INFERNO,
        [TOWN_NECROMANCY] = RACES.NECROPOLIS,
        [TOWN_PRESERVE] = RACES.SYLVAN,
        [TOWN_ACADEMY] = RACES.ACADEMY,
        [TOWN_DUNGEON] = RACES.DUNGEON,
        [TOWN_FORTRESS] = RACES.FORTRESS,
        [TOWN_STRONGHOLD] = RACES.STRONGHOLD
    },

    MapTownToHRTARace =
    ---
    ---@param town TownType
    function (town)
        local result = backward_compatibility.map_town_to_race[town]
        return result
    end
}