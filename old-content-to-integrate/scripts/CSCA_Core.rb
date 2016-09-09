=begin
CSCA Core Script
version: 1.0.7
Created by: Casper Gaming (http://www.caspergaming.com/)

Scripts that REQUIRE this script to work:
CSCA Colosseum
CSCA Dungeon Tools
CSCA Achievements
CSCA Encyclopedia
CSCA Treasure Maps
CSCA Menu MOD
CSCA SaveFile Plus
CSCA Vehicle System
CSCA Sidequests
CSCA Professions

Version History:
1.0.1 - Adds CSCA_Item class, used by scripts to get information about an item.
1.0.2 - Adds CSCA_Fish class, used by Vehicle System to get fishing data.
1.0.3 - Adds Window_HorzCommand fix to allow unlimited horizontal commands.
1.0.4 - Adds CSCA_Core class, used for csca script data that needs to be saved.
1.0.5 - Adds shorter access to variables/switches in Event script command.
1.0.6 - Adds troubleshooting error/warning reports.
1.0.7 - Adds vowel detection for strings.

COMPATIBILITY
PLACE THIS SCRIPT ABOVE ALL OTHER CSCA SCRIPTS!
Compatible only for VXAce.
IMPORTANT: ALL CSCA Scripts should be compatible with each other unless
otherwise noted.

FFEATURES
This script includes classes and functions used by other CSCA Scripts.

SETUP
Plug n play. Make sure this script is ABOVE all other CSCA Scripts.

CREDIT:
Free to use in noncommercial games if credit is given to:
Casper Gaming (http://www.caspergaming.com/)

To use in a commercial game, please purchase a license here:
http://www.caspergaming.com/licenses.html

TERMS:
http://www.caspergaming.com/terms_of_use.html
=end
$imported = {} if $imported.nil?
$imported["CSCA-Core"] = true
#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
# Handles csca class data.
# Aliases: make_save_contents, create_game_objects, extract_save_contents
#==============================================================================
module DataManager
  #--------------------------------------------------------------------------
  # alias method
  #--------------------------------------------------------------------------
  class <<self; alias csca_core_create_game_objects create_game_objects; end
  def self.create_game_objects
    csca_core_create_game_objects
    $csca = CSCA_Core.new
  end
  #--------------------------------------------------------------------------
  # overwrite method
  #--------------------------------------------------------------------------
  class <<self; alias csca_core_save_contents make_save_contents; end
  def self.make_save_contents
    contents = csca_core_save_contents
    contents[:csca] = $csca
    contents
  end
  #--------------------------------------------------------------------------
  # alias method
  #--------------------------------------------------------------------------
  class <<self; alias csca_core_extract_save_contents extract_save_contents; end
  def self.extract_save_contents(contents)
    csca_core_extract_save_contents(contents)
    $csca = contents[:csca]
  end
end
#==============================================================================
# ** CSCA_Window_Header
#------------------------------------------------------------------------------
# This window displays the header window, used by many CSCA Scripts.
#==============================================================================
class CSCA_Window_Header < Window_Base
  #--------------------------------------------------------------------------
  # Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width = Graphics.width, height = line_height*2, text)
    super(x, y, width, height)
    refresh(text)
  end
  #--------------------------------------------------------------------------
  # Refresh
  #--------------------------------------------------------------------------
  def refresh(text)
    contents.clear
    draw_text(0, 0, contents.width, line_height, text, 1)
  end
end
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
# Easy csca access to the map's note.
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # Get Map Note
  #--------------------------------------------------------------------------
  def csca_map_note; @map.note; end
end
#==============================================================================
# ** Window_HorzCommand
#------------------------------------------------------------------------------
# Allow unlimited horizontal commands.
# Overwrites: top_col=
#==============================================================================
class Window_HorzCommand < Window_Command
  #--------------------------------------------------------------------------
  # Overwrite Method
  #--------------------------------------------------------------------------
  def top_col=(col)
    col = 0 if col < 0
    self.ox = col * (item_width + spacing)
  end
end
#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  Shorter access to variables and switches.
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # Get variables
  #--------------------------------------------------------------------------
  def csca_v(var)
    $game_variables[var]
  end
  #--------------------------------------------------------------------------
  # Get switches
  #--------------------------------------------------------------------------
  def csca_s(swi)
    $game_switches[swi]
  end
end
#==============================================================================
# ** CSCA_Item
#------------------------------------------------------------------------------
# CSCA Items, used as rewards/wagers in various scripts.
#==============================================================================
class CSCA_Item
  attr_reader :id
  attr_reader :amount
  attr_reader :type
  #--------------------------------------------------------------------------
  # Initialize
  #--------------------------------------------------------------------------
  def initialize(amount,id,type)
    @id = id
    @amount = amount
    @type = type
  end
end
#==============================================================================
# ** CSCA_Fish
#------------------------------------------------------------------------------
# CSCA Fish, used to specify data about fish.
#==============================================================================
class CSCA_Fish
  attr_reader :item_id
  attr_reader :water_type
  attr_reader :weight
  attr_reader :region
  #--------------------------------------------------------------------------
  # Initialize
  #--------------------------------------------------------------------------
  def initialize(id, water, weight, region = 0)
    @item_id = id
    @water_type = water
    @weight = weight
    @region = region
  end
end
#==============================================================================
# ** CSCA_Core
#------------------------------------------------------------------------------
# Used to provide global methods for csca scripts. Data is included in save.
#==============================================================================
class CSCA_Core
  #--------------------------------------------------------------------------
  # Initialize
  #--------------------------------------------------------------------------
  def initialize
  end
  #--------------------------------------------------------------------------
  # Report wrong setup
  #--------------------------------------------------------------------------
  def report_error(error, script, suggestion, warning = false)
    string1 = warning ? "Warning: " : "Error: "
    msgbox(string1 + error + "\nOccurred in: " + script + "\nRecommended fix: " + suggestion)
  end
  #--------------------------------------------------------------------------
  # Split number into millions, thousands, hundreds
  #--------------------------------------------------------------------------
  def split_number(start)
    number = []
    number[0] = start / 1000 / 1000
    number[1] = start / 1000 % 1000
    number[2] = start % 1000
    return number
  end
  #--------------------------------------------------------------------------
  # Split number into hours, minutes, seconds
  #--------------------------------------------------------------------------
  def split_playtime(start)
    number = []
    number[0] = start / 60 / 60
    number[1] = start / 60 % 60
    number[2] = start % 60
    return number
  end
  #--------------------------------------------------------------------------
  # Determine if letter is a vowel or not
  #--------------------------------------------------------------------------
  def is_a_vowel(letter, space = false)
    letter.upcase
    return letter == "A" || letter == "E" || letter == "I" || letter == "O" || letter == "U" || (letter == "X" && space == true)
  end
end