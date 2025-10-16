while not astrology_core do
    sleep()
end

astrology_nargott_mode = {
    gold_ranges = {
        { min = 80454, max = 90484 },
        { min = 165454, max = 175484 }
    },

    generated_gold = -1,

    Init = 
    function ()
        local range = Random.FromTable(astrology_nargott_mode.gold_ranges)
        local gold_amount = random(range.max - range.min) + range.min
        astrology_nargott_mode.generated_gold = gold_amount
    end
}

NewDayEvent.AddListener("HRTA_astrology_nargott_mode_init_listener", 
function (day)
    if day == astrology_core.start_day and game_modes_core.current_mode == GAME_MODE_ASTROLOGY and astrology_core.current_week == ASTROLOGY_WEEK_NARGOTT then
        startThread(astrology_nargott_mode.Init)
        while astrology_nargott_mode.generated_gold == -1 do
            sleep()
        end
        for player = PLAYER_1, PLAYER_2 do
            local selected_msg = astrology_core.week_was_hand_selected and astrology_core.path.."week_was_selected_by_player.txt" or "blank.txt"
            startThread(MCCS_MessageBoxForPlayers, player, {astrology_core.path.."nargott_week_desc.txt"; selected_by = selected_msg, gold_amount = astrology_nargott_mode.generated_gold})
        end
    end
end)