
-- У.к. боевые скрипты запускаютс§ только у красного игрока,
-- по ним узнаем номер текущего игрока
function sendSecondPartReport()
  consoleCmd('game_writelog 1');
  sleep(5)
  print('Red_player');

  consoleCmd('game_writelog 0');
end;

sendSecondPartReport()