-- ������, ������������� ��� �������� ����� ����� ��, � ������ ����

-- ���� �� ������� �����
PATH_TO_DAY1_MODULE = GetMapDataPath().."day1/";
PATH_TO_DAY1_MESSAGES = PATH_TO_DAY1_MODULE.."messages/";

doFile(PATH_TO_DAY1_MODULE.."day1_constants.lua");
doFile(PATH_TO_DAY1_MODULE.."day1_utils.lua");
sleep(1)

-- ����������� ������ ������
function detectHotseatStatus()
  print "detectHotseatStatus"
  
  if GetTurnTimeLeft(PLAYER_2) <= 0 then
    HOTSEAT_STATUS = not nil;
  end;
end;



-- ����� ����� ��� ���������� �������� ������
function day1()
  print "day1"

  detectHotseatStatus();

  -- ��������
  if GAME_MODE.HALF then
    doFile(PATH_TO_DAY1_MODULE.."choice_of_races/half.lua");
  end;
  -- ������� �����
  if GAME_MODE.SIMPLE_CHOOSE then
    doFile(PATH_TO_DAY1_MODULE.."choice_of_races/simple.lua");
  end;
  -- ������� ����
  if GAME_MODE.MATCHUPS then
    doFile(PATH_TO_DAY1_MODULE.."choice_of_races/matchups.lua");
  end;
  -- ���� ����
  if GAME_MODE.MIX then
    removeHeroMovePoints(Biara);
    removeHeroMovePoints(Djovanni);
    doFile(PATH_TO_DAY1_MODULE.."choice_of_races/mix.lua");
  end;
  
  setAuthorMapsDescription();
  objectsWothInformation();
  
  -- ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."skip_day1.txt", Biara, 1, 5.0);
  -- ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."skip_day1.txt", Djovanni, 2, 5.0);
end;

-- ������ � ����������
function setAuthorMapsDescription()
  print "setAuthorMapsDescription"

  OverrideObjectTooltipNameAndDescription('bandit_map', PATH_TO_DAY1_MESSAGES.."bandit_name.txt", PATH_TO_DAY1_MESSAGES.."bandit_desc.txt");
  OverrideObjectTooltipNameAndDescription('mostovik_map', PATH_TO_DAY1_MESSAGES.."mostovik_name.txt", PATH_TO_DAY1_MESSAGES.."mostovik_desc.txt");
  OverrideObjectTooltipNameAndDescription('vsev_map', PATH_TO_DAY1_MESSAGES.."vsev_name.txt", PATH_TO_DAY1_MESSAGES.."vsev_desc.txt");
  OverrideObjectTooltipNameAndDescription('tari_map', PATH_TO_DAY1_MESSAGES.."tari_name.txt", PATH_TO_DAY1_MESSAGES.."tari_desc.txt");
end;

-- ���������� � ����������� ��������
function objectsWothInformation()
  print "objectsWothInformation"
  
  OverrideObjectTooltipNameAndDescription('Znamya1', PATH_TO_DAY1_MESSAGES.."winners.txt", PATH_TO_DAY1_MESSAGES.."winners_desc.txt");
  OverrideObjectTooltipNameAndDescription('Znamya2', PATH_TO_DAY1_MESSAGES.."winners.txt", PATH_TO_DAY1_MESSAGES.."winners_desc.txt");
  OverrideObjectTooltipNameAndDescription('Znamya3', PATH_TO_DAY1_MESSAGES.."winners.txt", PATH_TO_DAY1_MESSAGES.."winners_desc.txt");

end;

-- ����� ����� � ������
day1();
