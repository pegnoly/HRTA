while not astrology_core do
    sleep()
end

astrology_sithis_mode = {

}

NewDayEvent.AddListener("HRTA_astrology_sithis_mode_show_selected_listener",
function (day)
    if day == astrology_core.start_day and game_modes_core.current_mode == GAME_MODE_ASTROLOGY and astrology_core.current_week == ASTROLOGY_WEEK_SITHIS  then
        for player = PLAYER_1, PLAYER_2 do
            local selected_msg = astrology_core.week_was_hand_selected and astrology_core.path.."week_was_selected_by_player.txt" or "blank.txt"
            startThread(MCCS_MessageBoxForPlayers, player, {astrology_core.path.."sithis_week_desc.txt"; selected_by = selected_msg})
        end
    end
end)