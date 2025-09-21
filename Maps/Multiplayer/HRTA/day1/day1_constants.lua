-- Путь до папки с сообщениями
PATH_TO_DAY1_MESSAGES = PATH_TO_DAY1_MODULE.."messages/";
-- Путь до папки с наименованиями героев
PATH_TO_HERO_NAMES = PATH_TO_DAY1_MODULE.."hero_names/";
-- Путь до папки с наименованиями рас
PATH_TO_RACE_NAMES = PATH_TO_DAY1_MODULE.."race_names/";

-- Таблица ИД выбранных рас для
-- Служит для конкретизации переменной для передачи параметров между черком рас и героев
-- 1 значение первого игрока (красного), 2 - второго (синего)
SELECTED_RACE_ID_TABLE = {};

-- Маппинг ИД расы на ее наименование
MAP_RACE_ID_TO_RACE_NAME = {
  [RACES.HAVEN] = PATH_TO_RACE_NAMES.."haven.txt",
  [RACES.INFERNO] = PATH_TO_RACE_NAMES.."inferno.txt",
  [RACES.NECROPOLIS] = PATH_TO_RACE_NAMES.."necropolis.txt",
  [RACES.SYLVAN] = PATH_TO_RACE_NAMES.."sylvan.txt",
  [RACES.ACADEMY] = PATH_TO_RACE_NAMES.."academy.txt",
  [RACES.DUNGEON] = PATH_TO_RACE_NAMES.."dungeon.txt",
  [RACES.FORTRESS] = PATH_TO_RACE_NAMES.."fortress.txt",
  [RACES.STRONGHOLD] = PATH_TO_RACE_NAMES.."stronghold.txt",
}
