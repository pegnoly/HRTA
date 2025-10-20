elleshar_spec = {
    ---@type string[]
    heroes = { "Elleshar", "Elleshar1", "Elleshar2" },

    ---@type number
    level_cost_discount = 2200,

    UpdateLevelCost =
    ---comment
    ---@param hero string
    ---@param cost number
    ---@return number
    function (hero, cost)
        if contains(elleshar_spec.heroes, hero) then
            return cost - elleshar_spec.level_cost_discount
        end
        return cost
    end
}

AddHeroEvent.AddListener("HRTA_elleshar_add_hero_listener",
function (hero)
    if contains(elleshar_spec.heroes, hero) and not leveling.level_cost_modifiers["elleshar_modifier"] then
        leveling.level_cost_modifiers["elleshar_modifier"] = elleshar_spec.UpdateLevelCost
    end
end)