map_utils = {
    drafts_place_crystals_count = 20,
    player_mark_crystal_id = 10,

    RemoveDraftsPlaceCrystals = 
    function ()
        local crystals_ids_to_delete = range_generator.FromTop(1, map_utils.drafts_place_crystals_count, function (id)
            if id ~= map_utils.player_mark_crystal_id then
                return 1
            end
            return nil
        end)
        for _, id in crystals_ids_to_delete do
            if IsObjectExists("blue"..id) then
                RemoveObject("blue"..id)          
            end
            if IsObjectExists("red"..id) then
                RemoveObject("red"..id)
            end
        end
    end
}