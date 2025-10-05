
function day6_scripts()
  print "day6_scripts"
  
  removeHeroMovePoints(Biara);
  removeHeroMovePoints(Djovanni);
  
  if needPostponeBattle() then
    startBattle();
  end;
end;

day6_scripts();