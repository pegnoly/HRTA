--

asha_helpers = {
    GetActualHeroName =
    function (hero)
        for _, hero_data in MAPPING_HERO_NAME_TO_PLAYERS_HERO_NAME do
            if contains(hero_data.reservedNames, hero) then
                return hero_data.dictName
            end
        end
    end,

    GetActualHeroRace = 
    function (hero)
        for race, data in HEROES_BY_RACE do
            for _, hero_data in data do
                if hero_data.name == hero then
                    return race
                end
            end
        end
    end
}

asha = {

    global_fields = {},

    player_fields = {
        [PLAYER_1] = {},
        [PLAYER_2] = {}
    },

    AddGlobalField = 
    function (field, value)
        asha.global_fields[field] = value
    end,

    CollectData = 
    function ()
        for _, player in {PLAYER_1, PLAYER_2} do
            local hero = PLAYERS_MAIN_HERO_PROPS[player].name
            -- машины
            asha.player_fields[player]["WarMachinesIds"] = "["..list_iterator.Concat(
                range_generator.FromTop(WAR_MACHINE_BALLISTA, WAR_MACHINE_AMMO_CART, function (machine)
                    local h = %hero
                    if HasHeroWarMachine(h, machine) then
                        return 1
                    end
                    return nil
                end),
                ","
            ).."],"
            -- стеки
            asha.player_fields[player]["Army"] = "["..list_iterator.Concat(
                list_iterator.FilterMap(range_generator.FromTop(0, 6), function (v)
                    local h = %hero
                    local creature, count = GetObjectArmySlotCreature(h, v)
                    if not (creature == 0 or count == 0) then
                        local result = '{'..'"Id": '..creature..', "Value": '..count..'}'
                        return result
                    else
                        return nil
                    end
                end),
                ","
            )
            -- скиллы
            asha.player_fields[player]["Skills"] = "["..list_iterator.Concat(
                list_iterator.FilterMap(BASE_SKILLS, function (v)
                    local h = %hero
                    local mastery = GetHeroSkillMastery(h, v)
                    if mastery > 0 then
                        local result = '{'..'"Id": '..v..', "Value": '..mastery..'}'
                        return result
                    else
                        return nil
                    end
                end),
                ","
            )
            -- артефакты
            asha.player_fields[player]["Artifacts"] = "["..list_iterator.Concat(
                range_generator.FromTop(ARTIFACT_SWORD_OF_RUINS, ARTIFACT_PRINCESS, function (artifact)
                    local h = %hero
                    if HasArtefact(h, artifact, 1) then
                        return 1
                    end
                    return nil
                end),
                ","
            )
            -- спеллы (295 = id ласт спелла, имеющего доступную для изучения школу)
            asha.player_fields[player]["Spells"] = "["..list_iterator.Concat(
                list_iterator.FilterMap(SPELLS_DETECTABLE_BY_ASHA, function (v)
                    local h = %hero
                    if KnowHeroSpell(h, v) then
                        return 1
                    end
                    return nil
                end),
                ","
            )
            -- перки
            asha.player_fields[player]["Perks"] = "["..list_iterator.Concat(
                range_generator.FromTop(0, 220, function (perk)
                    local h = %hero
                    if not contains(BASE_SKILLS, perk) and HasHeroSkill(h, perk) then
                        return 1
                    end
                    return nil
                end),
                ","
            )
            -- актуальное скриптовое имя и фракция
            local actual_name = asha_helpers.GetActualHeroName(hero)
            asha.player_fields[player]["ScriptName"] = actual_name
            asha.player_fields[player]["Race"] = asha_helpers.GetActualHeroRace(actual_name)
            -- статы
            asha.player_fields[player]["Attack"] = GetHeroStat(hero, STAT_ATTACK)
            asha.player_fields[player]["Defence"] = GetHeroStat(hero, STAT_DEFENCE)
            asha.player_fields[player]["Spellpower"] = GetHeroStat(hero, STAT_SPELL_POWER)
            asha.player_fields[player]["Knowledge"] = GetHeroStat(hero, STAT_KNOWLEDGE)
            asha.player_fields[player]["Morale"] = GetHeroStat(hero, STAT_MORALE)
            asha.player_fields[player]["Luck"] = GetHeroStat(hero, STAT_LUCK)
        end
    end,

    

    WriteData = 
    function ()
        consoleCmd("game_writelog 1")
        sleep(10)
        for player = PLAYER_1, PLAYER_2 do
            print('"'..player..'": {<br>')
            for field, data in asha.fields[player] do
                print('"'..field..'": '..data..'<br>')
            end
            print'},'
        end
    end
}
