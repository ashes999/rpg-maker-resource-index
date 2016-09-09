=begin
CSCA Achievements
version: 2.2.1
Created by: Casper Gaming (http://www.caspergaming.com/)

Compatibility:
Made for RPGVXAce
IMPORTANT: ALL CSCA Scripts should be compatible with each other unless
otherwise noted.
REQUIRES CSCA Core Script(v1.0.6+)
================================================================================
UPDATES:
version 1.1(September 6th, 2012)
- Optimized & Made more compatible

version 1.2(September 19th, 2012)
- Added support for encyclopedia completion % achievements

version 1.2.1(November 25th, 2012)
- Added score to achievements.

version 1.2.2(November 26th, 2012)
- Fixed bug with progress not tracking items, armors, and weapons properly.
- Added the ability to use different icons for each achievement.

version 1.2.3(March 18, 2013)
- Added support for CSCA Currency System

version 1.2.4(May 6, 2013)
- Fixed bug not allowing items to be a reward with currency system.

version 1.3.0(June 25, 2013)
- Added progress tracking for CSCA Professions' profession level.
- Added progress tracking for discovered recipe's of any type in CSCA Crafting.
- Added progress tracking for CSCA Gathering node and nodetype data.
- Achievemwent popup windows set to 1001 Z (above Toast Manager toasts).

version 2.0.0(June 30th, 2013)
- Complete re-write of the script. Setup is more user friendly now, and code is
a lot easier to understand/more flexible making future updates MUCH easier. Should
slightly improve performance as well.

version 2.1.0(July 13, 2013)
- Fixed bug when trying to display earned achievement with STOP_TRACK enabled.
- Added achievements for amount of achievements earned (and total points)! Now you
can earn achievements while you earn achievements!
- Achievement information window now displays how many Points the achievement is
worth.

version 2.1.1(July 14, 2013)
- Fixed bug with name_before_unlock not working.

version 2.1.2(July 15, 2013)
- Fixed bug with description_before_unlock not working.

version 2.2.0(July 21, 2013)
- Added achievements for total quests completed & specific quests completed.

version 2.2.1(July 25, 2013)
- Fixed bug with custom encyclopedia category achievements.
================================================================================
INTRODUCTION:
This script creates an achievement system in your game.

FEATURES:
-Achievements!
-Score system similar to gamerscore.
-Can assign a reward for each achievement
-Can display a progress bar for each achievement
-Automatically earn achievements when progress bar gets to 100%.
-Can play an SE when achievement is unlocked
-Popup window when achievement is earned
-Able to use custom graphic in place of achievement window(size is 248x72),
image will be resized if bigger or smaller.

SETUP
Setup required. Instructions below.

CREDIT:
Free to use in noncommercial games if credit is given to:
Casper Gaming (http://www.caspergaming.com/)

To use in a commercial game, please purchase a license here:
http://www.caspergaming.com/licenses.html

TERMS:
http://www.caspergaming.com/terms_of_use.html
=end
module CSCA
  module ACHIEVEMENTS
    ACHIEVEMENT  = []
    DESCRIPTION  = []
    PROGRESS     = []
    REWARD       = []
#==============================================================================
# ** Script Calls
#==============================================================================
# earn_achievement(symbol)
#
# Sets an achievement to earned. The symbol parameter is the achievement's symbol.
#==============================================================================
# ** Begin Setup
#==============================================================================
    #==========================================================================
    # Description Setup
    #==========================================================================
    #DESCRIPTION[x] = ["Descriptive Text","Seperate lines with commas!"]
    DESCRIPTION[0] = ["Open 10 Treasure Chests","to unlock."]
    DESCRIPTION[1] = ["You opened 10 Treasure","Chests!"]
    DESCRIPTION[2] = ["Obtain 150 Gold."]
    #==========================================================================
    # Progress Setup
    #==========================================================================
    #PROGRESS[x] = [id, upper bound, "describe numbers", :type]
    # The type can be either:
    # :var = amount stored in $game_variables[id]
    # :item = amount of $data_items[id]
    # :weapon = amount of $data_weapons[id]
    # :armor = amount of $data_armors[id]
    # (3) :gold = amount of gold, ignores id value
    # :step = amount of steps, ignores id value
    # :save = amount of saves, ignores id value
    # :battle = amount of battles, ignores id value
    # :playtime = playtime, ignores id value
    # :acht = achievement earned total, ignores id value.
    # :achpt = achievement point total, ignores id value.
    # (1) :loot = amount of gold looted, ignores id value
    # (1) :dtake = amount of damage taken, ignores id value
    # (1) :ddeal = amount of damage dealt, ignores id value
    # (1) :gspend = amount of gold spent at shops, ignores id value
    # (1) :gearn = amount of gold earned from selling to shops, ignores id value
    # (1) :iuse = amount of items used, ignores id value
    # (1) :ibuy = amount of items bought from shops, ignores id value
    # (1) :isell = amount of items sold to shops, ignores id value
    # (2)(*) :ebes = % of bestiary completed, ignores id value
    # (2)(*) :eitm = % of items completed, ignores id value
    # (2)(*) :ewep = % of weapons completed, ignores id value
    # (2)(*) :earm = % of armors completed, ignores id value
    # (2)(*) :eskl = % of skills completed, ignores id value
    # (2)(*) :esta = % of states completed, ignores id value
    # (2)(*) :etot = % of total encyclopedia completed, ignores id value
    # (2)(*) :ecst = % of custom encyclopedia category completed, use id value for
    #            the custom category's key value.
    # (4) :plvl = Profession level, use id value for the profession symbol.
    # (5) :rtda = Recipe Type Discovered Amount, use id value for recipe type.
    # (6) :nga = Node Gathered Amount, use id value for nodes symbol.
    # (6) :ntga = Nodetype Gathered Amount, use id value for nodetypes type.
    # (7) :qamt = Amount of quests completed, ignores id.
    # (7)(*) :sqc = Specific quests complete, use id value as an array of quest symbols.
    #
    # (1) Requires CSCA Extra Stats(1.1+) Get it here:
    # http://www.rpgmakervxace.net/topic/2030-csca-extra-stats/
    #
    # (2) Requires CSCA Encyclopedia(3.0+) Get it here:
    # http://www.rpgmakervxace.net/topic/2775-csca-encyclopedia-w-bestiary/
    #
    # (3) If using CSCA Currency System(http://www.rpgmakervxace.net/topic/13153-csca-currency-system/)
    # the ID value for gold will be the currency symbol.
    #
    # (4) Requires CSCA Professions(1.0.3+) Get it here:
    # http://www.rpgmakervxace.net/topic/14734-csca-professions/
    #
    # (5) Requires CSCA Crafting(v1.0.4+) Get it here:
    # http://www.rpgmakervxace.net/topic/15113-csca-crafting/
    #
    # (6) Requires CSCA Gathering(v1.0.0+) Get it here:
    # http://www.rpgmakervxace.net/topic/15806-csca-gathering/
    #
    # (7) Requires CSCA Quest System(v1.0.0+) Get it here:
    # http://www.rpgmakervxace.net/topic/16963-csca-quest-system/
    #
    # (*) May cause lag if too many entries.
    #
    PROGRESS[0] = [5, 10, "Treasures Opened", :var] # 10 max, tracks variable ID5.
    PROGRESS[1] = [0, 150, "Total Gold", :gold] # 150 max, tracks party's gold.
    #==========================================================================
    # Rewards Setup
    #==========================================================================
    #REWARD[x] = [amount, id, type]
    # The type can be either:
    # :item = amount of $data_items[id]
    # :weapon = amount of $data_weapons[id]
    # :armor = amount of $data_armors[id]
    # :gold = amount of gold, ignores id value*
    # * If using CSCA Currency System(http://www.rpgmakervxace.net/topic/13153-csca-currency-system/)
    # the ID value for gold will be the currency symbol.
    REWARD[0] = [100, 0, :gold] # 100 gold.
    REWARD[1] = [5, 1, :item] # 5 of item ID 1.
    #==========================================================================
    # Achievement Setup
    #==========================================================================
    #ACHIEVEMENT[x] = { The x should start at 0 and increase in sequential order.
    #:symbol => :achievement1       # Symbol used to refer to the achievement in script calls.
    #:name => "Treasure Hunter",    # The name of the achievement.
    #:name_before_unlock => "???",  #(optional) The name of the achievement before unlock.
    #:description => DESCRIPTION[0],# The Description of the achievement.
    #:description_before_unlock => DESCRIPTION[1], #(optional) Description before unlock.
    #progress => PROGRESS[0],  #(optional) The progress tracking of the achievement.
    #:reward => REWARD[0],     #(optional) The reward upon completing the achievement.
    #:graphic => nil,          #(optional) The graphic to display in the popup window.
    #:points => 5,             # The points associated with the achievement.
    #:complete_icon => 621,    # The icon to use when achievement has been earned.
    #:incomplete_icon => 622   # The icon to use when achievement is not earned.
    #}
    # If you are not using an optional feature, write: nil
    ACHIEVEMENT[0] = {
    :symbol => :thunter,
    :name => "Treasure Hunter",
    :name_before_unlock => "???",
    :description => DESCRIPTION[1],
    :description_before_unlock => DESCRIPTION[0],
    :progress => PROGRESS[0],
    :reward => REWARD[0],
    :graphic => nil,
    :points => 5,
    :complete_icon => 621,
    :incomplete_icon => 622
    }
    
    ACHIEVEMENT[1] = {
    :symbol => :thunter2,
    :name => "Treasure Hunter II",
    :name_before_unlock => nil,
    :description => DESCRIPTION[2],
    :description_before_unlock => nil,
    :progress => PROGRESS[1],
    :reward => nil,
    :graphic => "DarkSpace1",
    :points => 10,
    :complete_icon => 620,
    :incomplete_icon => 619
    }
    #==========================================================================
    # Misc. Setup
    #==========================================================================
    HEADER = "Achievements" # Text shown in the head window.
    TOTAL = "Total Achievements Unlocked: " # Text shown before total numbers.
    POINTS = "Score: " # Text shown before points numbers.
    USE_POINTS = true # Use the points system?
    PROGRESS = "Progress:" # Text above progress bar
    REWARD = "Reward: " # Text shown before the reward amount/name.
    UNLOCKED = "Achievement Unlocked!" # Text shown when achievement unlocked.
    
    NUMBERED = false # If true, numbers achieve list. If false, uses icons.
    CENTER = false # Center the description text ? True/false
    STOP_TRACK = true # Stop tracking achievement progress after earned?
    
    COLOR1 = 20 # Color1 of the progress gauge.
    COLOR2 = 21 # Color2 of the progress gauge.
    
    SOUND = "Applause1" # SE Played when an achievement is earned. Set to nil to disable.
    
    POP_ALIGN = :bottom # Alignment of Popup on map when achievement is earned.
    # :bottom = bottom center, :middle = middle of screen, :top = top center
    # Set to nil to disable the Popup Window.
    # Recommended top if using CSCA Toast Manager.
#==============================================================================
# ** End Setup
#==============================================================================
  end
end
$imported ||= {}
$imported["CSCA-Achievements"] = true
msgbox('Missing Script: CSCA Core Script! CSCA Achievements requires this
script to work properly.') if !$imported["CSCA-Core"]
#==============================================================================
# ** CSCA_Achievement
#------------------------------------------------------------------------------
# Stores achievement data.
#==============================================================================
class CSCA_Achievement
  attr_reader :earned, :symbol, :name, :name_before_unlock, :description
  attr_reader :description_before_unlock, :reward, :progress, :points
  attr_reader :incomplete_icon, :complete_icon, :graphic
  #--------------------------------------------------------------------------
  # Object Initialization
  #--------------------------------------------------------------------------
  def initialize(achievement)
    @symbol = achievement[:symbol]
    @name = achievement[:name]
    @name_before_unlock = achievement[:name_before_unlock]
    @description = achievement[:description]
    @description_before_unlock = achievement[:description_before_unlock]
    @reward = achievement[:reward].nil? ? nil : CSCA_Item.new(*achievement[:reward])
    @points = achievement[:points]
    @incomplete_icon = achievement[:incomplete_icon]
    @complete_icon = achievement[:complete_icon]
    @graphic = achievement[:graphic]
    @progress = achievement[:progress].nil? ? nil : CSCA_AchievementProgress.new(achievement[:progress])
    @earned = false
  end
  #--------------------------------------------------------------------------
  # Earn achievement processing
  #--------------------------------------------------------------------------
  def earn_achievement
    @earned = true
    $game_party.csca_achievement_reward(@reward) if @reward
    sound = CSCA::ACHIEVEMENTS::SOUND
    Audio.se_play("Audio/SE/" + sound, 80, 100) if sound
    $csca.achievements_earned += 1
    $csca.achievement_total_points += @points
  end
end
#==============================================================================
# ** CSCA_AchievementProgress
#------------------------------------------------------------------------------
# Stores achievement progress data.
#==============================================================================
class CSCA_AchievementProgress
  attr_reader :id, :upper_bound, :description, :type
  #--------------------------------------------------------------------------
  # Object Initialization
  #--------------------------------------------------------------------------
  def initialize(progress)
    @id = progress[0]
    @upper_bound = progress[1]
    @description = progress[2]
    @type = progress[3]
  end
end
#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  Addition of earn_achievement command.
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # Earn Achievement
  #--------------------------------------------------------------------------
  def earn_achievement(sym)
    achievement = $csca.get_achievement(sym)
    achievement.earn_achievement
    $game_map.ach_earned = true
    $game_map.ach_display = achievement
  end
end
#==============================================================================
# ** CSCA_Core
#------------------------------------------------------------------------------
# Added achievement handling.
#Aliases: initialize
#==============================================================================
class CSCA_Core
  attr_accessor :achievements_earned, :achievement_total_points
  attr_reader :achievements
  #--------------------------------------------------------------------------
  # Alias Method; Object Initialization
  #--------------------------------------------------------------------------
  alias :csca_achievement_initialize :initialize
  def initialize
    csca_achievement_initialize
    initialize_achievements
  end
  #--------------------------------------------------------------------------
  # Initialize Achievements
  #--------------------------------------------------------------------------
  def initialize_achievements
    @achievements = []
    @achievements_earned = 0
    @achievement_total_points = 0
    CSCA::ACHIEVEMENTS::ACHIEVEMENT.each do |achievement|
      @achievements.push(CSCA_Achievement.new(achievement))
    end
  end
  #--------------------------------------------------------------------------
  # Get achievement
  #--------------------------------------------------------------------------
  def get_achievement(symbol)
    @achievements.each do |achievement|
      return achievement if achievement.symbol == symbol
    end
  end
end
#==============================================================================
# ** CSCA_Scene_Achievements
#------------------------------------------------------------------------------
# This class performs the achievement screen processing.
#==============================================================================
class CSCA_Scene_Achievements < Scene_MenuBase
  #--------------------------------------------------------------------------
  # Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_head_window
    create_achievement_window
    create_selection_window
    create_totals_window
  end
  #--------------------------------------------------------------------------
  # Create Background
  #--------------------------------------------------------------------------
  def create_background
    super
    @background_sprite.tone.set(0, 0, 0, 128)
  end
  #--------------------------------------------------------------------------
  # Create Header Window
  #--------------------------------------------------------------------------
  def create_head_window
    @head_window = CSCA_Window_Header.new(0, 0, CSCA::ACHIEVEMENTS::HEADER)
    @head_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # Create Achievement Selection Window
  #--------------------------------------------------------------------------
  def create_selection_window
    @command_window = CSCA_Window_AchievementSelect.new(0,@head_window.height,
      Graphics.width/2,Graphics.height-@head_window.height-48)
    @command_window.viewport = @viewport
    @command_window.help_window = @achievement_window
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # Create Achievement Window
  #--------------------------------------------------------------------------
  def create_achievement_window
    @achievement_window = CSCA_Window_AchievementDisplay.new(Graphics.width/2,
      @head_window.height,Graphics.width/2,Graphics.height-@head_window.height-48)
    @achievement_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # Create Achievement Totals Window
  #--------------------------------------------------------------------------
  def create_totals_window
    @totals_window = CSCA_Window_AchievementTotals.new(0,@head_window.height+
      @achievement_window.height,Graphics.width,Graphics.height-@head_window.height-
      @achievement_window.height)
    @totals_window.viewport = @viewport
  end
end
#==============================================================================
# ** CSCA_Window_AchievementSelect
#------------------------------------------------------------------------------
# This window displays the achievement names, numbers, and icons.
#==============================================================================
class CSCA_Window_AchievementSelect < Window_Selectable
  #--------------------------------------------------------------------------
  # Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x,y,width,height)
    super
    @data = []
    refresh
    select(0)
  end
  #--------------------------------------------------------------------------
  # Get Item Max
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # Get Item
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # Populate item list
  #--------------------------------------------------------------------------
  def make_item_list
    @data = $csca.achievements
  end
  #--------------------------------------------------------------------------
  # Draw Items
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      CSCA::ACHIEVEMENTS::NUMBERED ? draw_item_id(rect, index) : draw_ach_icon(rect, item)
      name = (item.earned || item.name_before_unlock.nil?) ? item.name : item.name_before_unlock
      draw_text(rect.x + 32, rect.y, contents.width - 40, line_height, name)
    end
  end
  #--------------------------------------------------------------------------
  # Draw Numbers
  #--------------------------------------------------------------------------
  def draw_item_id(rect, index)
    draw_text(rect, sprintf("%2d.", index + 1))
  end
  #--------------------------------------------------------------------------
  # Draw Icons
  #--------------------------------------------------------------------------
  def draw_ach_icon(rect, item)
    icon = item.earned ? item.complete_icon : item.incomplete_icon
    draw_icon(icon,rect.x+5,rect.y)
  end
  #--------------------------------------------------------------------------
  # Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # Update Help Window
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
  end
end
#==============================================================================
# ** CSCA_Window_AchievementTotals
#------------------------------------------------------------------------------
# This window displays the achievement header window.
#==============================================================================
class CSCA_Window_AchievementTotals < Window_Base
  #--------------------------------------------------------------------------
  # Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, w, h)
    super(x, y, w, h)
    refresh
  end
  #--------------------------------------------------------------------------
  # Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    total_achieves = $csca.achievements.size
    total_points = 0
    points = 0
    unlocked = 0
    $csca.achievements.each do |achievement|
      if achievement.earned
        unlocked += 1
        points += achievement.points
      end
      total_points += achievement.points
    end
    string1 = CSCA::ACHIEVEMENTS::TOTAL + unlocked.to_s + "/" + total_achieves.to_s
    string2 = CSCA::ACHIEVEMENTS::POINTS + points.to_s + "/" + total_points.to_s
    string = CSCA::ACHIEVEMENTS::USE_POINTS ? string1 + "     " + string2 : string1
    draw_text(0,0,contents.width,line_height,string,1)
  end
end
#==============================================================================
# ** CSCA_Window_AchievementDisplay
#------------------------------------------------------------------------------
# This window displays the achievement descriptions.
#==============================================================================
class CSCA_Window_AchievementDisplay < Window_Base
  #--------------------------------------------------------------------------
  # Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x,y,w,h)
    super(x,y,w,h)
  end
  #--------------------------------------------------------------------------
  # Draw all info
  #--------------------------------------------------------------------------
  def set_item(achievement)
    contents.clear
    width = contents.width
    height = line_height
    draw_description(0, 0, width, height, achievement)
    draw_progress(0, height*8, width, height, achievement) if achievement.progress
    draw_points(0, height*11-12, width, height, achievement) if CSCA::ACHIEVEMENTS::USE_POINTS
    draw_reward(0, height*12-12, width, height, achievement) if achievement.reward
  end
  #--------------------------------------------------------------------------
  # Draw description
  #--------------------------------------------------------------------------
  def draw_description(x, y, w, h, achievement)
    desc = (achievement.earned || achievement.description_before_unlock.nil?) ? achievement.description :
      achievement.description_before_unlock
    desc.each do |string|
      draw_text(x, y, w, h, string, centered_text?)
      y += line_height
    end
  end
  #--------------------------------------------------------------------------
  # Get centered option
  #--------------------------------------------------------------------------
  def centered_text?
    CSCA::ACHIEVEMENTS::CENTER ? 1 : 0
  end
  #--------------------------------------------------------------------------
  # Draw Progress bar
  #--------------------------------------------------------------------------
  def draw_progress(x, y, w, h, achievement)
    color1 = text_color(CSCA::ACHIEVEMENTS::COLOR1)
    color2 = text_color(CSCA::ACHIEVEMENTS::COLOR2)
    contents.font.size = 20
    draw_text(x, y, w, h, CSCA::ACHIEVEMENTS::PROGRESS, 1)
    if achievement.earned && CSCA::ACHIEVEMENTS::STOP_TRACK
      draw_gauge(x, y + line_height - 8, w, 1/1, color1, color2)
      string = achievement.progress.upper_bound.to_s
      draw_text(x, y  +line_height - 4, w, h, string + "/" + string, 1)
    else
      draw_gauge(x, y+line_height-8, w, csca_get_rate(achievement), color1, color2)
      draw_gauge_numbers(x, y + line_height - 4, w, h, achievement)
    end
    draw_text(x,y+line_height*2-12,w,h,achievement.progress.description, 1)
    contents.font.size = 24
  end
  #--------------------------------------------------------------------------
  # Calculate Rate
  #--------------------------------------------------------------------------
  def csca_get_rate(achievement)
    csca_get_numerator(achievement).to_f/csca_get_denominator(achievement).to_f
  end
  #--------------------------------------------------------------------------
  # Get Numerator
  #--------------------------------------------------------------------------
  def csca_get_numerator(achievement)
    id = achievement.progress.id
    case achievement.progress.type
    when :var
      return $game_variables[id]
    when :item
      return $game_party.item_number($data_items[id])
    when :weapon
      return $game_party.item_number($data_weapons[id])
    when :armor
      return $game_party.item_number($data_armors[id])
    when :gold
      if $imported["CSCA-CurrencySystem"]
        return $game_party.get_csca_cs_currency(id)[:amount]
      end
      return $game_party.gold
    when :step
      return $game_party.steps
    when :save
      return $game_system.save_count
    when :battle
      return $game_system.battle_count
    when :playtime
      return Graphics.frame_count / Graphics.frame_rate
    when :loot
      return $game_variables[CSCA_EXTRA_STATS::LOOTED]
    when :dtake
      return $game_variables[CSCA_EXTRA_STATS::DAMAGE_TAKEN]
    when :ddeal
      return $game_variables[CSCA_EXTRA_STATS::DAMAGE_DEALT]
    when :gspend
      return $game_variables[CSCA_EXTRA_STATS::GOLDSPENT]
    when :gearn
      return $game_variables[CSCA_EXTRA_STATS::GOLDGAINED]
    when :iuse
      return $game_variables[CSCA_EXTRA_STATS::ITEMS_USED]
    when :ibuy
      return $game_variables[CSCA_EXTRA_STATS::ITEMSBOUGHT]
    when :isell
      return $game_variables[CSCA_EXTRA_STATS::ITEMSSOLD]
    when :ebes
      string = sprintf("%1.2f%%",$game_party.csca_completion_percentage_bestiary*100.00)
      return string
    when :eitm
      string = sprintf("%1.2f%%",$game_party.csca_completion_percentage_items*100.00)
      return string
    when :ewep
      string = sprintf("%1.2f%%",$game_party.csca_completion_percentage_weapons*100.00)
      return string
    when :earm
      string = sprintf("%1.2f%%",$game_party.csca_completion_percentage_armors*100.00)
      return string
    when :eskl
      string = sprintf("%1.2f%%",$game_party.csca_completion_percentage_skills*100.00)
      return string
    when :esta
      string = sprintf("%1.2f%%",$game_party.csca_completion_percentage_states*100.00)
      return string
    when :ecst
      string = sprintf("%1.2f%%",$game_party.csca_completion_percentage_cust(id)*100.00)
      return string
    when :etot
      string = sprintf("%1.2f%%",$game_party.csca_completion_percentage*100.00)
      return string
    when :plvl
      return $csca.profession_ach_cache[id]
    when :rtda
      return $csca.recipe_types[id][1]
    when :nga
      return $csca.gathered_nodes[id]
    when :ntga
      return $csca.gathered_nodetypes[id]
    when :acht
      return $csca.achievements_earned
    when :achpt
      return $csca.achievement_total_points
    when :qamt
      return $csca.quest_info.completed
    when :sqc
      number = 0
      id.each do |quest_symbol|
        number += 1 if $csca.quest_info.list[quest_symbol]
      end
      return number
    end
    error = "Inappropriate achievement progress type given"
    script = "CSCA Achievements"
    suggestion = "Check to make sure your progress types are all correct"
    $csca.report_error(error, script, suggestion)
  end
  #--------------------------------------------------------------------------
  # Get Denominator
  #--------------------------------------------------------------------------
  def csca_get_denominator(achievement)
    return achievement.progress.upper_bound
  end
  #--------------------------------------------------------------------------
  # Draw Gauge Values
  #--------------------------------------------------------------------------
  def draw_gauge_numbers(x, y, w, h, achievement)
    numerator = csca_get_numerator(achievement).to_s
    denominator = csca_get_denominator(achievement).to_s
    draw_text(x, y, w, h, numerator + "/" + denominator, 1)
  end
  #--------------------------------------------------------------------------
  # Draw Reward
  #--------------------------------------------------------------------------
  def draw_reward(x, y, w, h, achievement)
    reward = achievement.reward
    currency = $game_party.get_csca_cs_currency(reward.id) if $imported["CSCA-CurrencySystem"] && reward.type == :gold
    case reward.type
    when :gold; reward_s = $imported["CSCA-CurrencySystem"] ? currency[:currency_unit] : Vocab::currency_unit
    when :item;   reward_s = " " + $data_items[reward.id].name
    when :weapon; reward_s = " " + $data_weapons[reward.id].name
    when :armor;  reward_s = " " + $data_armors[reward.id].name
    end
    draw_text(x,y,w,h,CSCA::ACHIEVEMENTS::REWARD)
    off_x = text_size(CSCA::ACHIEVEMENTS::REWARD).width
    if $imported["CSCA-CurrencySystem"] && reward.type == :gold
      draw_icon(currency[:icon], x + off_x, y)
      off_x += 24
      change_color(currency[:color])
    end
    draw_text(x+off_x, y, w, h, reward.amount.to_s + reward_s)
    change_color(normal_color)
  end
  #--------------------------------------------------------------------------
  # Draw Points
  #--------------------------------------------------------------------------
  def draw_points(x, y, w, h, achievement)
    string = CSCA::ACHIEVEMENTS::POINTS + achievement.points.to_s
    draw_text(x, y, w, h, string)
  end
end
#==============================================================================
# ** CSCA_Window_AchievementPop
#------------------------------------------------------------------------------
#  This window displays when an achievement is unlocked if no custom graphic
#  is available.
#==============================================================================
class CSCA_Window_AchievementPop < Window_Base
  #--------------------------------------------------------------------------
  # Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    case CSCA::ACHIEVEMENTS::POP_ALIGN
    when :bottom
      super(Graphics.width/4,Graphics.height-fitting_height(3),window_width,fitting_height(3))
    when :middle
      super(Graphics.width/4,Graphics.height/2-fitting_height(1),window_width,fitting_height(3))
    when :top
      super(Graphics.width/4, 0, window_width, fitting_height(3))
    end
    self.opacity = 0
    self.contents_opacity = 0
    self.z = 1001
    @show_count = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return 272
  end
  #--------------------------------------------------------------------------
  # Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    if @show_count > 0
      update_fadein
      @show_count -= 1
    else
      update_fadeout
    end
  end
  #--------------------------------------------------------------------------
  # Update Fadein
  #--------------------------------------------------------------------------
  def update_fadein
    self.opacity += 16 if $game_map.ach_display.graphic.nil? unless $game_map.ach_display.nil?
    self.contents_opacity += 16
  end
  #--------------------------------------------------------------------------
  # Update Fadeout
  #--------------------------------------------------------------------------
  def update_fadeout
    self.opacity -= 16 if $game_map.ach_display.graphic.nil? unless $game_map.ach_display.nil?
    self.contents_opacity -= 16
  end
  #--------------------------------------------------------------------------
  # Open Window
  #--------------------------------------------------------------------------
  def open
    refresh
    @show_count = 150
    self.contents_opacity = 0
    self.opacity = 0
    self
  end
  #--------------------------------------------------------------------------
  # Close Window
  #--------------------------------------------------------------------------
  def close
    @show_count = 0
    self
  end
  #--------------------------------------------------------------------------
  # Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if $game_map.ach_display.nil?
    if $game_map.ach_display.graphic.nil?
      contents.font.bold = true
      draw_text(0, 0, contents.width, line_height, CSCA::ACHIEVEMENTS::UNLOCKED, 1)
      contents.font.bold = false
      draw_text(0,line_height,contents.width,line_height,$game_map.ach_display.name,1)
      draw_reward($game_map.ach_display) unless $game_map.ach_display.reward.nil?
    else
      draw_custom_image
    end
  end
  #--------------------------------------------------------------------------
  # Draw Reward if Exist
  #--------------------------------------------------------------------------
  def draw_reward(achievement)
    reward = achievement.reward
    currency = $game_party.get_csca_cs_currency(reward.id) if $imported["CSCA-CurrencySystem"] && reward.type == :gold
    case reward.type
    when :gold; reward_s = $imported["CSCA-CurrencySystem"] ? currency[:currency_unit] : reward_s = Vocab::currency_unit
    when :item;   reward_s = " " + $data_items[reward.id].name
    when :weapon; reward_s = " " + $data_weapons[reward.id].name
    when :armor;  reward_s = " " + $data_armors[reward.id].name
    end
    draw_text(0,line_height*2,contents.width,line_height,CSCA::ACHIEVEMENTS::REWARD+reward.amount.to_s+reward_s,1)
  end
  #--------------------------------------------------------------------------
  # Draw Popup Graphic if Exist
  #--------------------------------------------------------------------------
  def draw_custom_image
    bitmap = Cache.picture($game_map.ach_display.graphic)
    rect = Rect.new(0,0,bitmap.width,bitmap.height)
    target = Rect.new(0,0,contents.width,contents.height)
    contents.stretch_blt(target, bitmap, rect, 255)
  end
end
#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
# Overwrites: none
# Aliases: create_all_windows, update, pre_transfer
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # Alias Method; create all windows
  #--------------------------------------------------------------------------
  alias :csca_create_all_windows :create_all_windows
  def create_all_windows
    csca_create_all_windows
    csca_create_achievement_window unless CSCA::ACHIEVEMENTS::POP_ALIGN.nil?
  end
  #--------------------------------------------------------------------------
  # create achievement window
  #--------------------------------------------------------------------------
  def csca_create_achievement_window
    @achievement_window = CSCA_Window_AchievementPop.new
    @achievement_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # Alias Method; pre-transfer processing
  #--------------------------------------------------------------------------
  alias :csca_ach_pre_transfer :pre_transfer
  def pre_transfer
    @achievement_window.close unless CSCA::ACHIEVEMENTS::POP_ALIGN.nil?
    csca_ach_pre_transfer
  end
  #--------------------------------------------------------------------------
  # Alias Method; update
  #--------------------------------------------------------------------------
  alias :csca_ach_update :update
  def update
    csca_ach_update
    if $game_map.ach_earned
      @achievement_window.open unless CSCA::ACHIEVEMENTS::POP_ALIGN.nil?
      $game_map.ach_earned = false
    end
  end
end
#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
# Overwrites: none
# Aliases: none
#==============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # Gives Reward
  #--------------------------------------------------------------------------
  def csca_achievement_reward(reward)
    case reward.type
    when :gold; $imported["CSCA-CurrencySystem"] ? gain_currency(get_csca_cs_currency(reward.id), reward.amount) : gain_gold(reward.amount)
    when :item;   gain_item($data_items[reward.id], reward.amount)
    when :weapon; gain_item($data_weapons[reward.id], reward.amount)
    when :armor;  gain_item($data_armors[reward.id], reward.amount)
    end
  end
end
#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
# Overwrites: none
# Aliases: initialize, update
#==============================================================================
class Game_Map
  attr_accessor :ach_earned
  attr_accessor :ach_display
  #--------------------------------------------------------------------------
  # Alias Method; initialize
  #--------------------------------------------------------------------------
  alias :csca_ach_initialize :initialize
  def initialize
    csca_ach_initialize
    @ach_earned = false
    @ach_display = nil
  end
  #--------------------------------------------------------------------------
  # Alias Method; update
  #--------------------------------------------------------------------------
  alias :csca_ach_update :update
  def update(main)
    csca_update_achievements
    csca_ach_update(main)
  end
  #--------------------------------------------------------------------------
  # automatically earn achievement if progress 100%
  #--------------------------------------------------------------------------
  def csca_update_achievements
    $csca.achievements.each do |achievement|
      next if achievement.earned
      next if achievement.progress.nil?
      if csca_get_progress_completion(achievement)
        achievement.earn_achievement
        $game_map.ach_earned = true
        $game_map.ach_display = achievement
      end
    end
  end
  #--------------------------------------------------------------------------
  # determine progress completion
  #--------------------------------------------------------------------------
  def csca_get_progress_completion(achievement)
    return csca_ach_numerator(achievement)/csca_ach_denominator(achievement) >= 1
  end
  #--------------------------------------------------------------------------
  # determine rate numerator
  #--------------------------------------------------------------------------
  def csca_ach_numerator(achievement)
    id = achievement.progress.id
    case achievement.progress.type
    when :var
      return $game_variables[id]
    when :item
      return $game_party.item_number($data_items[id])
    when :weapon
      return $game_party.item_number($data_weapons[id])
    when :armor
      return $game_party.item_number($data_armors[id])
    when :gold
      if $imported["CSCA-CurrencySystem"]
        return $game_party.get_csca_cs_currency(id)[:amount]
      end
      return $game_party.gold
    when :step
      return $game_party.steps
    when :save
      return $game_system.save_count
    when :battle
      return $game_system.battle_count
    when :playtime
      return Graphics.frame_count / Graphics.frame_rate
    when :loot
      return $game_variables[CSCA_EXTRA_STATS::LOOTED]
    when :dtake
      return $game_variables[CSCA_EXTRA_STATS::DAMAGE_TAKEN]
    when :ddeal
      return $game_variables[CSCA_EXTRA_STATS::DAMAGE_DEALT]
    when :gspend
      return $game_variables[CSCA_EXTRA_STATS::GOLDSPENT]
    when :gearn
      return $game_variables[CSCA_EXTRA_STATS::GOLDGAINED]
    when :iuse
      return $game_variables[CSCA_EXTRA_STATS::ITEMS_USED]
    when :ibuy
      return $game_variables[CSCA_EXTRA_STATS::ITEMSBOUGHT]
    when :isell
      return $game_variables[CSCA_EXTRA_STATS::ITEMSSOLD]
    when :ebes
      return $game_party.csca_completion_percentage_bestiary*100.00
    when :eitm
      return $game_party.csca_completion_percentage_items*100.00
    when :ewep
      return $game_party.csca_completion_percentage_weapons*100.00
    when :earm
      return $game_party.csca_completion_percentage_armors*100.00
    when :eskl
      return $game_party.csca_completion_percentage_skills*100.00
    when :esta
      return $game_party.csca_completion_percentage_states*100.00
    when :ecst
      return $game_party.csca_completion_percentage_cust(id)*100.00
    when :etot
      return $game_party.csca_completion_percentage*100.00
    when :plvl
      return $csca.profession_ach_cache[id]
    when :rtda
      return $csca.recipe_types[id][1]
    when :nga
      return $csca.gathered_nodes[id]
    when :ntga
      return $csca.gathered_nodetypes[id]
    when :acht
      return $csca.achievements_earned
    when :achpt
      return $csca.achievement_total_points
    when :qamt
      return $csca.quest_info.completed
    when :sqc
      number = 0
      id.each do |quest_symbol|
        number += 1 if $csca.quest_info.list[quest_symbol]
      end
      return number
    end
    error = "Inappropriate achievement progress type given"
    script = "CSCA Achievements"
    suggestion = "Check to make sure your progress types are all correct"
    $csca.report_error(error, script, suggestion)
  end
  #--------------------------------------------------------------------------
  # determine rate denominator
  #--------------------------------------------------------------------------
  def csca_ach_denominator(achievement)
    return achievement.progress.upper_bound
  end
end