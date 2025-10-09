while not astrology_core do
    sleep()
end

astrology_auotor_mode = {

}

NewDayEvent.AddListener("HRTA_astrology_auotor_mode_show_selected_listener",
function (day)
    if day == astrology_core.start_day and game_modes_core.current_mode == GAME_MODE_ASTROLOGY and astrology_core.current_week == ASTROLOGY_WEEK_AUOTOR  then
        for player = PLAYER_1, PLAYER_2 do
           startThread(MCCS_MessageBoxForPlayers, player, astrology_core.path.."auotor_week_desc.txt")
        end
    end
end)