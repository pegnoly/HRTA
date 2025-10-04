
-- ����� ��������, ������� ��������� �������������
PLAYER_LEARNING_OBJECTS_NAMES = {
  [PLAYER_1] = 'arena',
  [PLAYER_2] = 'magiya',
};

-- ������� ��� ������ ��������
QUESTION_BY_RACE = {
  [RACES.HAVEN] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_haven.txt",
  [RACES.INFERNO] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_inferno.txt",
  [RACES.NECROPOLIS] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_necropolis.txt",
  [RACES.SYLVAN] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_sylvan.txt",
  [RACES.ACADEMY] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_academy.txt",
  [RACES.DUNGEON] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_dungeon.txt",
  [RACES.FORTRESS] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_fortress.txt",
  [RACES.STRONGHOLD] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_stronghold.txt",
};

-- ���� ������������ � �������� ��������
LEARNING_OBJECTS_NAME_AND_DESCRIPTION_MAP = {
  [PLAYER_LEARNING_OBJECTS_NAMES[PLAYER_1]] = {
    name = PATH_TO_START_LEARNING_MESSAGES..'arena_name.txt',
    description = PATH_TO_START_LEARNING_MESSAGES..'arena_description.txt',
  },
  [PLAYER_LEARNING_OBJECTS_NAMES[PLAYER_2]] = {
    name = PATH_TO_START_LEARNING_MESSAGES..'arena_name.txt',
    description = PATH_TO_START_LEARNING_MESSAGES..'arena_description.txt',
  },
}

-- ����������� ������� � ����, �� ������� ��� ����������
MAP_LEVEL_BY_PRICE = {
  [19] = 7500,
  [20] = 8000,
  [21] = 8500,
  [22] = 9000,
  [23] = 10000,
  [24] = 10500,
  [25] = 11000,
};

-- ������ �� �� �����������
LEVEL_DISCOUNT_BY_ENL = {
  [1] = 0,
  [2] = 0,
  [3] = 0,

};
-- ���������� �������, ��������������� ������ ��� �������� ���������
FREE_LEARNING_LEVEL = 18;

-- �������� ���������� �������, ��������������� ������ ��� �������� ���������
HALF_FREE_LEARNING_LEVEL = 8;

-- ���� ��������� ������ ��� ������ �������
DROP_STAT_PERCENT_BY_RACE = {
  [RACES.HAVEN] = {
    attack = 30,
    defence = 45,
    spellpower = 10,
    knowledge = 15,
  },
  [RACES.INFERNO] = {
    attack = 45,
    defence = 10,
    spellpower = 15,
    knowledge = 30,
  },
  [RACES.NECROPOLIS] = {
    attack = 10,
    defence = 30,
    spellpower = 45,
    knowledge = 15,
  },
  [RACES.SYLVAN] = {
    attack = 15,
    defence = 45,
    spellpower = 10,
    knowledge = 30,
  },
  [RACES.ACADEMY] = {
    attack = 10,
    defence = 15,
    spellpower = 30,
    knowledge = 45,
  },
  [RACES.DUNGEON] = {
    attack = 30,
    defence = 10,
    spellpower = 45,
    knowledge = 15,
  },
  [RACES.FORTRESS] = {
    attack = 20,
    defence = 30,
    spellpower = 30,
    knowledge = 20,
  },
  [RACES.STRONGHOLD] = {
    attack = 50,
    defence = 35,
    spellpower = 5,
    knowledge = 10,
  },
};

-- ������ ������ �� ����, ������� �� ������
MAP_SKILLS_TO_CHANGING_STATS = {
  [RANGER_FEAT_FOREST_GUARD_EMBLEM] = {
    [STAT_ATTACK] = 2,
  },
  [HERO_SKILL_BODYBUILDING] = {
    [STAT_DEFENCE] = 1,
  },
  [HERO_SKILL_DEFEND_US_ALL] = {
    [STAT_DEFENCE] = 2,
  },
  [WIZARD_FEAT_SEAL_OF_PROTECTION] = {
    [STAT_DEFENCE] = 0,
  },
  [HERO_SKILL_WARCRY_LEARNING] = {
    [STAT_KNOWLEDGE] = 2,
  },
  [WIZARD_FEAT_ACADEMY_AWARD] = {
    [STAT_SPELL_POWER] = 2,
  },
  [RANGER_FEAT_INSIGHTS] = {
    [STAT_SPELL_POWER] = 2,
  },
  [WARLOCK_FEAT_SECRETS_OF_DESTRUCTION] = {
    [STAT_KNOWLEDGE] = 2,
  },
  [KNIGHT_FEAT_STUDENT_AWARD] = {
    [STAT_KNOWLEDGE] = 2,
  },
  [NECROMANCER_FEAT_LORD_OF_UNDEAD] = {
    [STAT_KNOWLEDGE] = 1,
  },
};

-- ������ ���� �������� ���������
ALL_MAIN_STATS_LIST = { STAT_ATTACK, STAT_DEFENCE, STAT_SPELL_POWER, STAT_KNOWLEDGE };

-- ���������� ������� ������ ��� ����� ������� �� 1 ������
PLAYERS_FIRST_LEVEL_DISCOUNT_ON_REMOVE_SKILLS = {
  [PLAYER_1] = 2,
  [PLAYER_2] = 2,
};

-- ������ ��������, � ������� ����� ������ ����
BUY_SKILL_OBJECTS_NAME = {
  [PLAYER_1] = 'skill1',
  [PLAYER_2] = 'skill2',
};

-- ������ ���� ��������� �� ������� �������
ALL_NOT_RACES_SKILL_LIST = {
  SKILL_LOGISTICS,
  SKILL_WAR_MACHINES,
  SKILL_LEARNING,
  SKILL_LEADERSHIP,
  SKILL_LUCK,
  SKILL_OFFENCE,
  SKILL_DEFENCE,
  SKILL_SORCERY,
  SKILL_DESTRUCTIVE_MAGIC,
  SKILL_DARK_MAGIC,
  SKILL_LIGHT_MAGIC,
  SKILL_SUMMONING_MAGIC,
};

-- ������������� �������� ��� ������� � �������
BUY_SKILL_QUESTIONS = {
  [SKILL_LOGISTICS] = "question_buy_logistic.txt",
  [SKILL_WAR_MACHINES] = "question_buy_war_machines.txt",
  [SKILL_LEARNING] = "question_buy_learning.txt",
  [SKILL_LEADERSHIP] = "question_buy_leadership.txt",
  [SKILL_LUCK] = "question_buy_luck.txt",
  [SKILL_OFFENCE] = "question_buy_offence.txt",
  [SKILL_DEFENCE] = "question_buy_deffence.txt",
  [SKILL_SORCERY] = "question_buy_sorcery.txt",
  [SKILL_DESTRUCTIVE_MAGIC] = "question_buy_destructive_magic.txt",
  [SKILL_DARK_MAGIC] = "question_buy_dark.txt",
  [SKILL_LIGHT_MAGIC] = "question_buy_light_magic.txt",
  [SKILL_SUMMONING_MAGIC] = "question_buy_summoning_magic.txt",
  [HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC] = "question_buy_shatter_destructive_magic.txt",
  [HERO_SKILL_SHATTER_DARK_MAGIC] = "question_buy_shatter_dark_magic.txt",
  [HERO_SKILL_SHATTER_LIGHT_MAGIC] = "question_buy_shatter_light_magic.txt",
  [HERO_SKILL_SHATTER_SUMMONING_MAGIC] = "question_buy_shatter_summoning_magic.txt",
};

-- ������ ����������� ��� ������� ������� �� �����
ALLOW_BUY_SKILL_LIST_BY_RACE = {
  [RACES.HAVEN] = {
    SKILL_LOGISTICS,
    SKILL_WAR_MACHINES,
    SKILL_LEADERSHIP,
    SKILL_LUCK,
    SKILL_OFFENCE,
    SKILL_DEFENCE,
    SKILL_DARK_MAGIC,
    SKILL_LIGHT_MAGIC,
  },
  [RACES.INFERNO] = {
    SKILL_LOGISTICS,
    SKILL_WAR_MACHINES,
    SKILL_LUCK,
    SKILL_OFFENCE,
    SKILL_DEFENCE,
    SKILL_SORCERY,
    SKILL_DARK_MAGIC,
    SKILL_DESTRUCTIVE_MAGIC,
  },
  [RACES.NECROPOLIS] = {
    SKILL_LOGISTICS,
    SKILL_LEARNING,
    SKILL_OFFENCE,
    SKILL_DEFENCE,
    SKILL_SORCERY,
    SKILL_DARK_MAGIC,
    SKILL_DESTRUCTIVE_MAGIC,
    SKILL_SUMMONING_MAGIC,
  },
  [RACES.SYLVAN] = {
    SKILL_LOGISTICS,
    SKILL_LEARNING,
    SKILL_LEADERSHIP,
    SKILL_OFFENCE,
    SKILL_DEFENCE,
    SKILL_LUCK,
    SKILL_LIGHT_MAGIC,
    SKILL_DESTRUCTIVE_MAGIC,
  },
  [RACES.ACADEMY] = {
    SKILL_WAR_MACHINES,
    SKILL_LEARNING,
    SKILL_LUCK,
    SKILL_SORCERY,
    SKILL_LIGHT_MAGIC,
    SKILL_DARK_MAGIC,
    SKILL_DESTRUCTIVE_MAGIC,
    SKILL_SUMMONING_MAGIC,
  },
  [RACES.DUNGEON] = {
    SKILL_LOGISTICS,
    SKILL_WAR_MACHINES,
    SKILL_LEARNING,
    SKILL_LUCK,
    SKILL_OFFENCE,
    SKILL_SORCERY,
    SKILL_DESTRUCTIVE_MAGIC,
    SKILL_SUMMONING_MAGIC,
  },
  [RACES.FORTRESS] = {
    SKILL_WAR_MACHINES,
    SKILL_LEARNING,
    SKILL_LEADERSHIP,
    SKILL_LUCK,
    SKILL_OFFENCE,
    SKILL_DEFENCE,
    SKILL_LIGHT_MAGIC,
    SKILL_DESTRUCTIVE_MAGIC,
  },
  [RACES.STRONGHOLD] = {
    SKILL_LOGISTICS,
    SKILL_WAR_MACHINES,
    SKILL_LEADERSHIP,
    SKILL_LUCK,
    SKILL_OFFENCE,
    SKILL_DEFENCE,
    HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC,
    HERO_SKILL_SHATTER_DARK_MAGIC,
    HERO_SKILL_SHATTER_LIGHT_MAGIC,
    HERO_SKILL_SHATTER_SUMMONING_MAGIC,
  },
};

BUY_STATS_OBJECTS_NAMES = {
  [PLAYER_1] = {
    [STAT_ATTACK] = {
      id = 'napadenie1',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_attack_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_attack_stat_desc.txt",
    },
    [STAT_DEFENCE] = {
      id = 'zashchita1',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_defence_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_defence_stat_desc.txt",
    },
    [STAT_SPELL_POWER] = {
      id = 'koldovstvo1',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_spell_power_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_spell_power_stat_desc.txt",
    },
    [STAT_KNOWLEDGE] = {
      id = 'znanie1',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_knowledge_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_knowledge_stat_desc.txt",
    },
  },
  [PLAYER_2] = {
    [STAT_ATTACK] = {
      id = 'napadenie2',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_attack_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_attack_stat_desc.txt",
    },
    [STAT_DEFENCE] = {
      id = 'zashchita2',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_defence_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_defence_stat_desc.txt",
    },
    [STAT_SPELL_POWER] = {
      id = 'koldovstvo2',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_spell_power_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_spell_power_stat_desc.txt",
    },
    [STAT_KNOWLEDGE] = {
      id = 'znanie2',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_knowledge_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_knowledge_stat_desc.txt",
    },
  },
};

MAP_BUY_STAT_ON_QUESTIONS = {
  [STAT_ATTACK] = PATH_TO_START_LEARNING_MESSAGES.."question_buy_attack_stat.txt",
  [STAT_DEFENCE] = PATH_TO_START_LEARNING_MESSAGES.."question_buy_defence_stat.txt",
  [STAT_SPELL_POWER] = PATH_TO_START_LEARNING_MESSAGES.."question_buy_spell_power_stat.txt",
  [STAT_KNOWLEDGE] = PATH_TO_START_LEARNING_MESSAGES.."question_buy_knowledge_stat.txt",
};

MAP_STAT_ON_ADDING_MESSAGE = {
  [STAT_ATTACK] = PATH_TO_START_LEARNING_MESSAGES.."getting_attack_stat.txt",
  [STAT_DEFENCE] = PATH_TO_START_LEARNING_MESSAGES.."getting_defence_stat.txt",
  [STAT_SPELL_POWER] = PATH_TO_START_LEARNING_MESSAGES.."getting_spell_power_stat.txt",
  [STAT_KNOWLEDGE] = PATH_TO_START_LEARNING_MESSAGES.."getting_knowledge_stat.txt",
};

MAP_SELL_STAT_ON_QUESTIONS = {
  [STAT_ATTACK] = PATH_TO_START_LEARNING_MESSAGES.."question_sell_attack_stat.txt",
  [STAT_DEFENCE] = PATH_TO_START_LEARNING_MESSAGES.."question_sell_defence_stat.txt",
  [STAT_SPELL_POWER] = PATH_TO_START_LEARNING_MESSAGES.."question_sell_spell_power_stat.txt",
  [STAT_KNOWLEDGE] = PATH_TO_START_LEARNING_MESSAGES.."question_sell_knowledge_stat.txt",
};

-- ��������� ������������� �������������
COST_RE_GENERATION_STATS = 4000;

-- ������ ������������ ������
CUSTOM_WEEKS = {
  ATTACK = 20,
  DEFENCE = 23,
  SPELL_POWER = 15,
  KNOWLEDGE = 3,
  EQUAL = 18,
};

-- ����������� ������ � ������, ������� ��� ���� (����������)
MAP_WEEK_ON_ASTROLOGY_STATS = {
  [CUSTOM_WEEKS.ATTACK] = {
    [STAT_ATTACK] = 3,
    [STAT_DEFENCE] = 0,
    [STAT_SPELL_POWER] = 0,
    [STAT_KNOWLEDGE] = 0
  },
  [CUSTOM_WEEKS.DEFENCE] = {
    [STAT_ATTACK] = 0,
    [STAT_DEFENCE] = 3,
    [STAT_SPELL_POWER] = 0,
    [STAT_KNOWLEDGE] = 0
  },
  [CUSTOM_WEEKS.SPELL_POWER] = {
    [STAT_ATTACK] = 0,
    [STAT_DEFENCE] = 0,
    [STAT_SPELL_POWER] = 3,
    [STAT_KNOWLEDGE] = 0
  },
  [CUSTOM_WEEKS.KNOWLEDGE] = {
    [STAT_ATTACK] = 0,
    [STAT_DEFENCE] = 0,
    [STAT_SPELL_POWER] = 0,
    [STAT_KNOWLEDGE] = 3
  },
  [CUSTOM_WEEKS.EQUAL] = {
    [STAT_ATTACK] = 1,
    [STAT_DEFENCE] = 1,
    [STAT_SPELL_POWER] = 1,
    [STAT_KNOWLEDGE] = 1
  },
};

-- ����������� ������ � ����������� �����������, ����������� � ����� ����������
MAP_SKILL_ON_CUSTOM_ABILITY = {
--  [PERK_SCOUTING] = CUSTOM_ABILITY_2,
--  [RANGER_FEAT_DISGUISE_AND_RECKON] = CUSTOM_ABILITY_2,
--  [PERK_ESTATES] = CUSTOM_ABILITY_3,
  [PERK_FORTUNATE_ADVENTURER] = CUSTOM_ABILITY_4,
}

-- ������ ������������� �������� �������
PLAYER_USE_SPOILS_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- ������ ������������� �������� ��������
PLAYER_USE_SCOUTING_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
}

-- ������ �������� �������� �������� ���������
PLAYER_SCOUTING_WAITING_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- ������� ���������� �������� ������ "��������� ��������������"
PLAYER_USE_DISGUISE_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- ����������� ����� ���������� � �������
MAP_MERCHANT_ON_PLAYER = {
  [PLAYER_1] = 'lavka1',
  [PLAYER_2] = 'lavka2',
}

-- ������ ������������� ������� � ����� �������
PLAYERS_USE_SPOILS_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- ������ ������������� "����� � ����" ��������
PLAYERS_USE_FORTUNARE_ADVENTURE_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- ���������� ����������� ��� ������� ���������
PLAYER_COUNT_ALLOW_SELL_STATS = {
  [PLAYER_1] = 6,
  [PLAYER_2] = 6,
};

-- ����������� ��������� � ������ ������������ ��������
MAP_STATS_ON_MINIMUM = {
  [STAT_ATTACK] = 0,
  [STAT_DEFENCE] = 0,
  [STAT_SPELL_POWER] = 1,
  [STAT_KNOWLEDGE] = 1
};

-- ��������� ������� ���������
SELL_STAT_PRICE = 2500;

-- ������ �� ������� ������� ��� ��������
ELLESHAR_DISCOUNT = 2500;

-- ���������� ������������� ������ �� ������� �������� ��� �������
ELLAINA_DISCOUNT = 12;

-- ����������� ������ �������� ������ �� ����������� ������ ���
MAP_RUNELORE_TO_ALLOW_RUNE_LEVELS = {
  [1] = 3,
  [2] = 4,
  [3] = 5
};

-- ����������� ������� � ������������ �� �������
MAP_PLAYERS_ON_DWELL_POSITION = {
  [PLAYER_1] = {
    x = 89,
    y = 82,
    rotate = 0,
  },
  [PLAYER_2] = {
    x = 81,
    y = 7,
    rotate = 3.14,
  },
};

-- ����������� ������� � ���������������� �������
MAP_PLAYERS_ON_DWELL_NAME = {
  [PLAYER_1] = 'Dwel1',
  [PLAYER_2] = 'Dwel2',
};

-- �������������� �� ���� "���������"
STUDENT_AWARD_GOLD = 1000;

-- ������ ��������� "������� ������" ��������
PLAYERS_GET_FOREST_GUARD_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- ������ ��������� "������ ��� ����" ��������
PLAYERS_GET_DEFEND_US_ALL_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- ���������� ������, ����������� � ���������
LOGISTIC_BONUS = 3500;

-- �������� ������������� � ������ ���������
PLAYERS_LOGISTICS_DEBT = {
  [PLAYER_1] = 0,
  [PLAYER_2] = 0,
};

-- ���������� �������, ������� ������� ��-�� ��������������
PLAYERS_COUNT_LOGISTICS_LEVEL_RETURNED = {
  [PLAYER_1] = 0,
  [PLAYER_2] = 0,
};


--

-- ���������� ������, ����������� � �����
ESTATES_BONUS = 6000;

-- �������� ������������� � ������ �����
PLAYERS_ESTATES_DEBT = {
  [PLAYER_1] = 0,
  [PLAYER_2] = 0,
};

-- ���������� �������, ������� ������� ��-�� �������������� �����
PLAYERS_COUNT_ESTATES_LEVEL_RETURNED = {
  [PLAYER_1] = 0,
  [PLAYER_2] = 0,
};

-- ����������� ������� �� ������, ������� ���������� ������� ��� ���������
PLAYERS_WALL_CELL_FOR_NAVIGATION = {
  [PLAYER_1] = 'red10',
  [PLAYER_2] = 'blue10',
};

-- ����������� ������� �� ������, ���� ����� ����������� ����� ��� �������� ��� ���������
MAP_POSITION_FOR_NAVIGATION = {
  [PLAYER_1] = { x = 22, y = 79 },
  [PLAYER_2] = { x = 42, y = 29 },
};

-- ������ ���� ���������� ��� ��������� � ������� ������
PLAYERS_ON_NAVIGATION_ARTS_TABLE = {
  [PLAYER_1] = { 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8', 'a9', 'a10', 'a11', 'a12', 'a13', 'a14', 'a15', 'a16', 'a17', 'a18', 'a19', 'a20', 'a21', 'a22' },
  [PLAYER_2] = { 'b1', 'b2', 'b3', 'b4', 'b5', 'b6', 'b7', 'b8', 'b9', 'b10', 'b11', 'b12', 'b13', 'b14', 'b15', 'b16', 'b17', 'b18', 'b19', 'b20', 'b21', 'b22' },
};

-- ������� ������ ������ ����� ������������� ���������
PLAYERS_POSITION_AFTER_USE_NAVIGATION = {
  [PLAYER_1] = { x = 35, y = 85 },
  [PLAYER_2] = { x = 42, y = 24 },
};

-- ������ ��������� ������ "���������"
PLAYERS_USE_NAVIGATION_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- ������ ��������� ������ "���� �����"
PLAYERS_USE_PATH_OF_WAR_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- ����� ������ "���� �����"
PLAYERS_USE_PATH_OF_WAR_BONUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- ���������� ������, ����������� �������� �� ����� "������ ������������"
PLAYERS_COUNT_STATS_FROM_CASTER_CERTIFICATE = {
  [PLAYER_1] = 0,
  [PLAYER_2] = 0,
};

-- ���������� ����������, ����������� �������� �� ����� "��������� �������"
PLAYERS_COUNT_STATS_FROM_MASTER_OF_SECRET = {
  [PLAYER_1] = 0,
  [PLAYER_2] = 0,
};

-- ����������� ������� � ������������ ������
MAP_RACE_ON_RACE_SKILL = {
  [RACES.HAVEN] = SKILL_TRAINING,
  [RACES.INFERNO] = SKILL_GATING,
  [RACES.NECROPOLIS] = SKILL_NECROMANCY,
  [RACES.SYLVAN] = SKILL_AVENGER,
  [RACES.ACADEMY] = SKILL_ARTIFICIER,
  [RACES.DUNGEON] = SKILL_INVOCATION,
  [RACES.FORTRESS] = HERO_SKILL_RUNELORE,
  [RACES.STRONGHOLD] = HERO_SKILL_DEMONIC_RAGE,
};

-- ����������� ����������� � ������� �������
PLAYERS_ALLOW_BUYING_LEVEL = {
  [PLAYER_1] = 6,
  [PLAYER_2] = 6,
};

-- ���������� ������������ ������ ������� ��� ������� �������, ������� ������ ����������
PLAYERS_GOLD_STORE = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- ����� ��� ������������ ����� ��� ���� �����
PLAYERS_TELEPORT_POW_POSITION = {
  [PLAYER_1] = { x = 86, y = 62 },
  [PLAYER_2] = { x = 90, y = 39 },
};

-- ����� ��� ������������ ����� ��� ���� ����� �������
PLAYERS_TELEPORT_POW_RETURN_POSITION = {
  [PLAYER_1] = { x = 44, y = 76 },
  [PLAYER_2] = { x = 48, y = 12 },
};

-- ���� ����� ��������
POW_OBJECTS_NAMES = {
  [PLAYER_1] = {
    ['POW1'] = {
      id = 'POW1Red',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW1_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW1_desc.txt",
    },
    ['POW2'] = {
      id = 'POW2Red',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW2_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW2_desc.txt",
    },
    ['POW3'] = {
      id = 'POW3Red',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW3_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW3_desc.txt",
    },
    ['POW4'] = {
      id = 'POW4Red',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW4_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW4_desc.txt",
    },
    ['POW5'] = {
      id = 'POW5Red',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW5_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW5_desc.txt",
    },
    ['POW6'] = {
      id = 'POW6Red',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW6_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW6_desc.txt",
    },
    ['POW_PORTAL_1'] = {
      id = 'tpPathOfwarRed1',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW_portal_1_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW_portal_1_desc.txt",
    },
    ['POW_PORTAL_2'] = {
      id = 'tpPathOfwarRed2',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW_portal_2_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW_portal_2_desc.txt",
    },
  },

  [PLAYER_2] = {
    ['POW1'] = {
      id = 'POW1Blue',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW1_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW1_desc.txt",
    },
    ['POW2'] = {
      id = 'POW2Blue',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW2_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW2_desc.txt",
    },
    ['POW3'] = {
      id = 'POW3Blue',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW3_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW3_desc.txt",
    },
    ['POW4'] = {
      id = 'POW4Blue',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW4_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW4_desc.txt",
    },
    ['POW5'] = {
      id = 'POW5Blue',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW5_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW5_desc.txt",
    },
    ['POW6'] = {
      id = 'POW6Blue',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW6_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW6_desc.txt",
    },
    ['POW_PORTAL_1'] = {
      id = 'tpPathOfwarBlue1',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW_portal_1_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW_portal_1_desc.txt",
    },
    ['POW_PORTAL_2'] = {
      id = 'tpPathOfwarBlue2',
      name = PATH_TO_START_LEARNING_MESSAGES.."POW_portal_2_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."POW_portal_2_desc.txt",
    },
  }
}

POW_OBJECTS_QUESTIONS = {
  ['POW1'] = PATH_TO_START_LEARNING_MESSAGES.."question_POW1.txt",
  ['POW2'] = PATH_TO_START_LEARNING_MESSAGES.."question_POW2.txt",
  ['POW3'] = PATH_TO_START_LEARNING_MESSAGES.."question_POW3.txt",
  ['POW4'] = PATH_TO_START_LEARNING_MESSAGES.."question_POW4.txt",
  ['POW5'] = PATH_TO_START_LEARNING_MESSAGES.."question_POW5.txt",
  ['POW6'] = PATH_TO_START_LEARNING_MESSAGES.."question_POW6.txt",
};

POW_OBJECTS_TAKE_NOT_MASSAGE = {
  ['POW3'] = PATH_TO_START_LEARNING_MESSAGES.."take_not_massage_POW1.txt",
  ['POW4'] = PATH_TO_START_LEARNING_MESSAGES.."take_not_massage_POW2.txt",
  ['POW6'] = PATH_TO_START_LEARNING_MESSAGES.."take_not_massage_POW6.txt",
};