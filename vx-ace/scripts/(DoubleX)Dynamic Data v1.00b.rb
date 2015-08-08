#==============================================================================|
#  ** Script Info                                                              |
#------------------------------------------------------------------------------|
#  * Script Name                                                               |
#    DoubleX RMVXA Dynamic Data                                                |
#------------------------------------------------------------------------------|
#  * Functions                                                                 |
#    Stores the changes to the database done by users during game executions   |
#    Can't be used with data having contents that can't be serialized          |
#    Can't be used with data read from the database files upon use             |
#------------------------------------------------------------------------------|
#  * Terms Of Use                                                              |
#    You shall keep this script's Script Info part's contents intact           |
#    You shalln't claim that this script is written by anyone other than       |
#    DoubleX or his aliases                                                    |
#    None of the above applies to DoubleX or his aliases                       |
#------------------------------------------------------------------------------|
#  * Prerequisites                                                             |
#    Abilities:                                                                |
#    1. Decent RGSS3 scripting proficiency to fully utilize this script        |
#    2. Custom script comprehensions to edit that script's used data stored in |
#       RPG::BaseItem and/or its subclasses                                    |
#------------------------------------------------------------------------------|
#  * Instructions                                                              |
#    1. Open the script editor and put this script into an open slot between   |
#       Materials and Main, save to take effect.                               |
#------------------------------------------------------------------------------|
#  * Links                                                                     |
#    Script Usage 101:                                                         |
#    1. forums.rpgmakerweb.com/index.php?/topic/32752-rmvxa-script-usage-101/  |
#    2. rpgmakervxace.net/topic/27475-rmvxa-script-usage-101/                  |
#    This script:                                                              |
#    1. http://pastebin.com/upEe5FZQ                                           |
#------------------------------------------------------------------------------|
#  * Authors                                                                   |
#    DoubleX                                                                   |
#------------------------------------------------------------------------------|
#  * Changelog                                                                 |
#    v1.00b(GMT 0600 8-8-2015):                                                |
#    1. Fixed using edited data bug when starting new game without closing it  |
#    2. Increased this script's compatibility, efficiency and readability      |
#    v1.00a(GMT 0400 16-5-2015):                                               |
#    1. 1st version of this script finished                                    |
#==============================================================================|

($doublex_rmvxa ||= {})[:Dynamic_Data] = "v1.00b"

#==============================================================================|
#  ** Script Implementations                                                   |
#     You need not edit this part as it's about how this script works          |
#------------------------------------------------------------------------------|
#  * Script Support Info:                                                      |
#    1. Prerequisites                                                          |
#       - Some RGSS3 scripting proficiency to fully comprehend this script     |
#    2. Method documentation                                                   |
#       - The 1st part describes why this method's rewritten/aliased for       |
#         rewritten/aliased methods or what the method does for new methods    |
#       - The 2nd part describes what the arguments of the method are          |
#       - The 3rd part informs which version rewritten, aliased or created this|
#         method                                                               |
#       - The 4th part informs whether the method's rewritten or new           |
#       - The 5th part describes how this method works for new methods only,   |
#         and describes the parts added, removed or rewritten for rewritten or |
#         aliased methods only                                                 |
#       Example:                                                               |
# #--------------------------------------------------------------------------| |
# #  Why rewrite/alias/What this method does                                 | |
# #--------------------------------------------------------------------------| |
# # *argv: What these variables are                                            |
# # &argb: What this block is                                                  |
# def def_name(*argv, &argb) # Version X+; Rewrite/New                         |
#   # Added/Removed/Rewritten to do something/How this method works            |
#   def_name_code                                                              |
#   #                                                                          |
# end # def_name                                                               |
#------------------------------------------------------------------------------|

class << DataManager # Edit

  #----------------------------------------------------------------------------|
  #  Stores the modified database parts to the save files as well              |
  #----------------------------------------------------------------------------|
  alias save_game_without_rescue_dynamic_data save_game_without_rescue
  def save_game_without_rescue(index, &argb)
    # Added
    ["actors", "classes", "skills", "items", "weapons", "armors", "enemies", 
     "troops", "states", "animations", "tilesets", "common_events", 
     "system"].each { |t| $game_system.send(:"data_#{t}=", eval("$data_#{t}")) }
    #
    save_game_without_rescue_dynamic_data(index, &argb)
  end # save_game_without_rescue

  #----------------------------------------------------------------------------|
  #  Retrieves the modified database parts from the save files as well         |
  #----------------------------------------------------------------------------|
  alias extract_save_contents_dynamic_data extract_save_contents
  def extract_save_contents(contents, &argb)
    extract_save_contents_dynamic_data(contents, &argb)
    # Added
    ["actors", "classes", "skills", "items", "weapons", "armors", "enemies", 
     "troops", "states", "animations", "tilesets", "common_events", 
     "system"].each { |type| eval("$data_#{type} = $game_system.data_#{type}") }
    #
  end # extract_save_contents

end # DataManager

class Game_System # Edit

  #----------------------------------------------------------------------------|
  #  New public instance variables                                             |
  #----------------------------------------------------------------------------|
  # The modified database parts to be stored to/retrieved from save files
  ["actors", "classes", "skills", "items", "weapons", "armors", "enemies", 
   "troops", "states", "animations", "tilesets", "common_events", 
   "system"].each { |type| attr_accessor eval(":data_#{type}") }

end # Game_System

class Scene_Title < Scene_Base # v1.00b+; Edit

  #----------------------------------------------------------------------------|
  #  Resets the database for starting a new game without closing it as well    |
  #----------------------------------------------------------------------------|
  alias start_dynamic_data start
  def start(*argv, &argb)
    start_dynamic_data(*argv, &argb)
    DataManager.load_database # Added
  end # start

end # Scene_Title

#------------------------------------------------------------------------------|

#==============================================================================|
