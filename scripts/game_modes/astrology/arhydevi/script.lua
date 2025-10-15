while not astrology_core do
    sleep()
end

astrology_arhydevi_mode = {}

NewDayEvent.AddListener("HRTA_astrology_arhydevi_mode_show_selected_listener",
function (day)
    if day == astrology_core.start_day and game_modes_core.current_mode == GAME_MODE_ASTROLOGY and astrology_core.current_week == ASTROLOGY_WEEK_ARHYDEVI  then
        for player = PLAYER_1, PLAYER_2 do
           startThread(MCCS_MessageBoxForPlayers, player, astrology_core.path.."arhydevi_week_desc.txt")
        end
    end
end)