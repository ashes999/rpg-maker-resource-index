#==============================================================================
# ** Miscellaneous Scripts
#	 By: ashes999 (ashes999@yahoo.com)
#    Ver: 1.0
#------------------------------------------------------------------------------
#  * Description:
#  A collection of various scripts used in Quest for the Royal Jelly
# (http://deengames.com/download/quest-for-the-royal-jelly/)
#==============================================================================
class Game_Interpreter
  def get_hp
    $game_party.members[0].hp
  end
  
  def collidePlayer(id)
    player = get_character(-1)
    character = get_character(id)
    return player.x == character.x && player.y == character.y
  end
  
  def collideEvent(id1, id2)
    character2 = get_character(id2)
    character = get_character(id1)
    return character2.x == character.x && character2.y == character.y
  end
  
  def getTerrainTag
    player = get_character(-1)
    return $game_map.terrain_tag(player.x, player.y)
  end
  
end