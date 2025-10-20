while not ADDITIONAL_LINE_DEFAULT_MAX_LEVEL do
    sleep()
end

spells_generation = {
    ---@type table<PlayerID, number>
    -- Текущий id объекта для размещения спеллов
    current_placeholder_in_use = {[PLAYER_1] = 0, [PLAYER_2] = 0},
    
    ---@type table<PlayerID, number[]>
    -- Спеллы, уже задействованные в генерации
    spells_already_in_use = {[PLAYER_1] = {}, [PLAYER_2] = {}},

    ---@type table<PlayerID, MagicLineEntry[]>
    -- Спеллы, полностью сконфигурированные для визуализации линейки
    configured_entries = {[PLAYER_1] = {}, [PLAYER_2] = {}},

    ConfigureSpellEntry = 
    -- Настраивает сгенерированный спелл для его корректного размещения на карте
    ---@param player PlayerID Id игрока, для которого был сгенерирован спелл
    ---@param line MagicLineType Линейка, в которой был сгенерирован спелл
    ---@param spell number Id спелла
    ---@param index number Индекс спелла в линейке
    ---@param space number? 
    function (player, line, spell, index, space)
        spells_generation.current_placeholder_in_use[player] = spells_generation.current_placeholder_in_use[player] + 1
        local placeholder_name = "placeholder_spell_"..player..""..spells_generation.current_placeholder_in_use[player]
        local base_pos = spells_generation_core.lines_positions[line][player]
        local shift = space or 1
        ---@type MagicLineEntry
        local entry_data = {
            placeholder = placeholder_name,
            spell = spell,
            position = {
                x = base_pos.x + ((index - 1) * (player == PLAYER_1 and shift or -shift)),
                y = base_pos.y
            }
        }
        table.push(spells_generation.configured_entries[player], entry_data)
    end,

    GenerateMainMagicLine =
    -- Генерирует основную линейку спеллов
    ---@param player PlayerID Id игрока, для которого генерируется линейка
    ---@param line MagicLineType Тип линейки
    ---@param model MagicLineModel Модель данных о линейке
    function (player, line, model)
        local pool = spells_generation_core.CreateSpellsPool(model)
        local current_level = 1
        for index = 1, model.count do
            local spell = spells_generation_core.GetRandomUnusedSpellOfLevel(player, pool, current_level, spells_generation.spells_already_in_use[player])
            table.push(spells_generation.spells_already_in_use[player], spell)
            spells_generation.ConfigureSpellEntry(player, line, spell, index, model.space)
            current_level = current_level + 1
        end
    end,

    GenerateAdditionalMagicLine =
    -- Генерирует дополнительную линейку спеллов
    ---@param player PlayerID Id игрока, для которого генерируется линейка
    ---@param line MagicLineType Тип линейки
    ---@param model MagicLineModel Модель данных о линейке
    function (player, line, model)
        local pool = spells_generation_core.CreateSpellsPool(model)
        local min_level = model.min_lvl or ADDITIONAL_LINE_DEFAULT_MIN_LEVEL
        local max_level = model.max_lvl or ADDITIONAL_LINE_DEFAULT_MAX_LEVEL
        for index = 1, model.count do
            local spell = spells_generation_core.GetRandomUnusedSpellFromLevelRange(player, pool, min_level, max_level, spells_generation.spells_already_in_use[player])
            table.push(spells_generation.spells_already_in_use[player], spell)
            spells_generation.ConfigureSpellEntry(player, line, spell, index, model.space)
        end
    end,

    PregenerateSpells =
    -- Генерирует линейки спеллов для игроков
    function ()
        for player = PLAYER_1, PLAYER_2 do
            local race = players_utils.GetPlayerSelectedRace(player)
            ---@param line MagicLineType
            ---@param model MagicLineModel
            for line, model in spells_generation_core.lines_by_races[race] do
                if line >= FIRST_MAIN_LINE and line <= THIRD_MAIN_LINE then
                    spells_generation.GenerateMainMagicLine(player, line, model)
                else
                    spells_generation.GenerateAdditionalMagicLine(player, line, model)
                end
            end
        end
    end,

    PlaceSpells =
    function ()
        for player = PLAYER_1, PLAYER_2 do
            startThread(spells_generation.PlaceSpellsForPlayer, player)
        end
    end,

    PlaceSpellsForPlayer =
    -- Размещает спеллы игрока на карте
    ---@param player PlayerID 
    function (player)
        ---@param entry MagicLineEntry
        for _, entry in spells_generation.configured_entries[player] do
            startThread(spells_generation.PlaceSpellEntry, entry, player)
        end
    end,

    PlaceSpellEntry =
    -- Размещает конкретный спелл на карте
    ---@param entry MagicLineEntry
    ---@param player PlayerID
    function (entry, player)
        if player == PLAYER_2 then -- nival 
            SetObjectRotation(entry.placeholder, 180)
        end
        local effect = "/Effects/Spells/"..entry.spell.."/active.(Effect).xdb#xpointer(/Effect)"
        SetObjectPosition(entry.placeholder, entry.position.x, entry.position.y, GROUND)
        PlayVisualEffect(effect, entry.placeholder)
        Touch.DisableObject(entry.placeholder, DISABLED_DEFAULT, Spell.Params.Name(entry.spell))
    end,
}