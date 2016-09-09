# Source: http://forums.rpgmakerweb.com/index.php?/topic/450-ve-light-effects/
#==============================================================================
# ** Victor Engine - Basic Module
#------------------------------------------------------------------------------
# Author : Victor Sant
#
# Version History:
#  v 1.00 - 2011.12.19 > First relase
#  v 1.01 - 2011.12.21 > Added Event Troop notes
#  v 1.02 - 2011.12.22 > Added character frames value
#  v 1.03 - 2011.12.30 > Added Actor and Enemy notes
#  v 1.04 - 2012.01.01 > Added party average level and map actors
#  v 1.05 - 2012.01.04 > Compatibility with Characters Scripts
#  v 1.06 - 2012.01.07 > Compatibility with Fog and Light Effect
#                      > Added new Sprite Character functions
#  v 1.07 - 2012.01.11 > Compatibility with Control Text and Codes
#  v 1.08 - 2012.01.13 > Compatibility with Trait Control
#  v 1.09 - 2012.01.15 > Fixed the Regular Expressions problem with "" and “”
#  v 1.10 - 2012.01.18 > Compatibility with Automatic Battlers
#  v 1.11 - 2012.01.26 > Compatibility with Followers Options
#                        Compatibility with Animated Battle beta
#  v 1.12 - 2012.02.08 > Compatibility with Animated Battle
#  v 1.13 - 2012.02.18 > Fix for non RTP dependant encrypted projects
#  v 1.14 - 2012.03.11 > Better version handling and required messages
#  v 1.15 - 2012.03.11 > Added level variable for enemies (to avoid crashes)
#  v 1.16 - 2012.03.21 > Compatibility with Follower Control
#  v 1.17 - 2012.03.22 > Compatibility with Follower Control new method
#------------------------------------------------------------------------------
#   This is the basic script for the system from Victory Engine and is
# required to use the scripts from the engine. This script offer some new
# functions to be used within many scripts of the engine.
#------------------------------------------------------------------------------
# Compatibility
#   Required for the Victor Engine
# 
# * Overwrite methods (Default)
#   module Cache
#     def self.character(filename)
#
#   class Sprite_Character < Sprite_Base
#     def set_character_bitmap
#
# * Alias methods (Default)
#   class Game_Interpreter
#     def command_108
#
#   class Window_Base < Window
#     def convert_escape_characters(text)
#
#------------------------------------------------------------------------------
# Instructions:
#  To instal the script, open you script editor and paste this script on
#  a new section on bellow the Materials section.
#
#------------------------------------------------------------------------------
# New functions
#
# * Random number between two vales
#   rand_between(min, max)
#    min : min value
#    max : max value
#   Can be called from any class, this method return an random value between
#   two specific numbers
#
# * Random array value
#   <Array>.random
#   <Array>.random!
#   Returns a random object from the array, the method .random! is destructive,
#   removing the value returned from the array.
#
# * Sum of the numeric values of a array
#   <Array>.sum
#   Returns the sum of all numeric values
#
# * Avarage of all numeric values from the array
#   <Array>.average(float = false)
#    float : float flag
#   Returns the average of all numeric values, if floa is true, the value
#   returned is a float, otherwise it's a integer.
#
# * Note for events
#   <Event>.note
#   By default, events doesn't have note boxes. This command allows to use
#   comments as note boxes, following the same format as the ones on the
#   database. Returns all comments on the active page of the event.
#
# * Comment calls
#   <Event>.comment_call
#   Another function for comment boxes, by default, they have absolutely no
#   effect in game when called. But this method allows to make the comment
#   box to behave like an script call, but with the versatility of the
#   note boxes. Remember that the commands will only take effect if there
#   is scripts to respond to the comment code.
#
#==============================================================================

#==============================================================================
# ** Victor Engine
#------------------------------------------------------------------------------
#   Setting module for the Victor Engine
#==============================================================================

module Victor_Engine
  #--------------------------------------------------------------------------
  # * New method: required_script
  #--------------------------------------------------------------------------
  def self.required_script(name, req, version, type = 0)
    if type != :bellow && (!$imported[req] || $imported[req] < version)
      msg = "The script '%s' requires the script\n"
      case type
      when :above
        msg += "'%s' v%s or higher above it to work properly\n"
      else
        msg += "'%s' v%s or higher to work properly\n"
      end
      msg += "Go to http://victorscripts.wordpress.com/ to download this script."
      self.exit_message(msg, name, req, version)
    elsif type == :bellow && $imported[req]
      msg =  "The script '%s' requires the script\n"
      msg += "'%s' to be put bellow it\n"
      msg += "move the scripts to the proper position"
      self.exit_message(msg, name, req, version)
    end
  end
  #--------------------------------------------------------------------------
  # * New method: exit_message
  #--------------------------------------------------------------------------
  def self.exit_message(message, name, req, version)
    name = self.script_name(name)
    req  = self.script_name(req)
    msgbox(sprintf(message, name, req, version))
    exit
  end
  #--------------------------------------------------------------------------
  # * New method: script_name
  #--------------------------------------------------------------------------
  def self.script_name(name, ext = "VE")
    name = name.to_s.gsub("_", " ").upcase.split
    name.collect! {|char| char == ext ? "#{char} -" : char.capitalize }
    name.join(" ")
  end
end

$imported ||= {}
$imported[:ve_basic_module] = 1.17

#==============================================================================
# ** Object
#------------------------------------------------------------------------------
#  This class is the superclass of all other classes.
#==============================================================================

class Object
  #--------------------------------------------------------------------------
  # * Include setting module
  #--------------------------------------------------------------------------
  include Victor_Engine
  #-------------------------------------------------------------------------
  # * New method: rand_between
  #-------------------------------------------------------------------------
  def rand_between(min, max)
    min + rand(max - min + 1)
  end
  #--------------------------------------------------------------------------
  # * New method: numeric?
  #--------------------------------------------------------------------------
  def numeric?
    return false
  end
  #--------------------------------------------------------------------------
  # * New method: float?
  #--------------------------------------------------------------------------
  def float?
    return false
  end
  #--------------------------------------------------------------------------
  # * New method: item?
  #--------------------------------------------------------------------------
  def item?
    return false
  end
  #--------------------------------------------------------------------------
  # * New method: skill?
  #--------------------------------------------------------------------------
  def skill?
    return false
  end
  #--------------------------------------------------------------------------
  # * New method: file_exist?
  #--------------------------------------------------------------------------
  def file_exist?(path, filename)
    $file_list ||= {}
    $file_list[path + filename] ||= file_test(path, filename)
    $file_list[path + filename] == :exist
  end
  #--------------------------------------------------------------------------
  # * New method: get_file_list
  #--------------------------------------------------------------------------
  def file_test(path, filename)
    bitmap = Cache.load_bitmap(path, filename) rescue nil
    bitmap ? :exist : :inexist
  end
  #--------------------------------------------------------------------------
  # * New method: character_exist?
  #--------------------------------------------------------------------------
  def character_exist?(filename)
    file_exist?("Graphics/Characters/", filename)
  end
  #--------------------------------------------------------------------------
  # * New method: battler_exist?
  #--------------------------------------------------------------------------
  def battler_exist?(filename)
    file_exist?("Graphics/Battlers/", filename)
  end
  #--------------------------------------------------------------------------
  # * New method: get_filename
  #--------------------------------------------------------------------------
  def get_filename
    "[\"'“‘]([^\"'”‘”’]+)[\"'”’]"
  end
  #--------------------------------------------------------------------------
  # * New method: make_symbol
  #--------------------------------------------------------------------------
  def make_symbol(string)
    string.downcase.gsub(" ", "_").to_sym
  end
  #--------------------------------------------------------------------------
  # * New method: make_string
  #--------------------------------------------------------------------------
  def make_string(symbol)
    symbol.to_s.gsub("_", " ").upcase
  end
  #--------------------------------------------------------------------------
  # * New method: returing_value
  #--------------------------------------------------------------------------
  def returing_value(i, x)
    i % (x * 2) >= x ? (x * 2) - i % (x * 2) : i % (x * 2)
  end
end

#==============================================================================
# ** Numeric
#------------------------------------------------------------------------------
#  This is the abstract class for numbers.
#==============================================================================

class Numeric
  #--------------------------------------------------------------------------
  # * New method: numeric?
  #--------------------------------------------------------------------------
  def numeric?
    return true
  end
end

#==============================================================================
# ** Float
#------------------------------------------------------------------------------
#  This is the abstract class for the floating point values.
#==============================================================================

class Float
  #--------------------------------------------------------------------------
  # * New method: float?
  #--------------------------------------------------------------------------
  def float?
    return true
  end
end

#============================================================================== 
# ** Array     
#------------------------------------------------------------------------------
#  This class store arbitrary Ruby objects.
#==============================================================================

class Array
  #-------------------------------------------------------------------------
  # * New method: random
  #-------------------------------------------------------------------------
  def random
    self[rand(size)]
  end
  #-------------------------------------------------------------------------
  # * New method: random!
  #-------------------------------------------------------------------------
  def random!
    self.delete_at(rand(size))
  end
  #---------------------------------------------------------------------------
  # * New method: sum
  #---------------------------------------------------------------------------
  def sum
    self.inject(0) {|r, n| r += (n.numeric? ? n : 0)} 
  end
  #---------------------------------------------------------------------------
  # * New method: average
  #---------------------------------------------------------------------------
  def average(float = false)
    self.sum / [(float ? size.to_f : size.to_i), 1].max
  end
  #---------------------------------------------------------------------------
  # * New method: next_item
  #---------------------------------------------------------------------------
  def next_item
    item = self.shift
    self.push(item)
    item
  end
  #---------------------------------------------------------------------------
  # * New method: previous_item
  #---------------------------------------------------------------------------
  def previous_item
    item = self.pop
    self.unshift(item)
    item
  end
end

#==============================================================================
# ** RPG::Troop::Page
#------------------------------------------------------------------------------
#  This is the data class for battle events (pages).
#==============================================================================

class RPG::Troop::Page
  #--------------------------------------------------------------------------
  # * New method: note
  #--------------------------------------------------------------------------
  def note
    return "" if !@list || @list.size <= 0
    comment_list = []
    @list.each do |item|
      next unless item && (item.code == 108 || item.code == 408)
      comment_list.push(item.parameters[0])
    end
    comment_list.join("\r\n")
  end
end

#==============================================================================
# ** RPG::Skill
#------------------------------------------------------------------------------
#  This is the data class for skills.
#==============================================================================

class RPG::Skill
  #--------------------------------------------------------------------------
  # * New method: item?
  #--------------------------------------------------------------------------
  def item?
    return false
  end
  #--------------------------------------------------------------------------
  # * New method: skill?
  #--------------------------------------------------------------------------
  def skill?
    return true
  end
end

#==============================================================================
# ** RPG::Item
#------------------------------------------------------------------------------
#  This is the data class for sitems.
#==============================================================================

class RPG::Item
  #--------------------------------------------------------------------------
  # * New method: item?
  #--------------------------------------------------------------------------
  def item?
    return true
  end 
  #--------------------------------------------------------------------------
  # * New method: skill?
  #--------------------------------------------------------------------------
  def skill?
    return false
  end
end

#==============================================================================
# ** RPG::UsableItem
#------------------------------------------------------------------------------
#  This is the superclass for skills and items.
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # * New method: for_all_targets?
  #--------------------------------------------------------------------------
  def for_all_targets?
    return false
  end
end

#==============================================================================
# ** Cache
#------------------------------------------------------------------------------
#  This module loads each of graphics, creates a Bitmap object, and retains it.
# To speed up load times and conserve memory, this module holds the created
# Bitmap object in the internal hash, allowing the program to return
# preexisting objects when the same bitmap is requested again.
#==============================================================================

module Cache
  #--------------------------------------------------------------------------
  # * New method: cache
  #--------------------------------------------------------------------------
  def self.cache
    @cache
  end
  #--------------------------------------------------------------------------
  # * New method: character
  #--------------------------------------------------------------------------
  def self.character(filename, hue = 0)
    load_bitmap("Graphics/Characters/", filename, hue)
  end
end

#==============================================================================
# ** Game_BattlerBase
#------------------------------------------------------------------------------
#  This class handles battlers. It's used as a superclass of the Game_Battler
# classes.
#==============================================================================

class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :buffs
  #--------------------------------------------------------------------------
  # * New method: get_cond
  #--------------------------------------------------------------------------
  def get_cond(text)
    case text.upcase
    when "HIGHER"    then ">"
    when "LOWER"     then "<"
    when "EQUAL"     then "=="
    when "DIFFERENT" then "!="
    else "!="
    end
  end
  #--------------------------------------------------------------------------
  # * New method: get_param
  #--------------------------------------------------------------------------
  def get_param(text)
    case text.upcase
    when "MAXHP" then self.mhp
    when "MAXMP" then self.mmp
    when "MAXTP" then self.max_tp
    else eval("self.#{text.downcase}")
    end
  end
  #--------------------------------------------------------------------------
  # * New method: get_param_id
  #--------------------------------------------------------------------------
  def get_param_id(text)
    case text.upcase
    when "MAXHP", "HP" then 0
    when "MAXMP", "MP" then 1
    when "ATK" then 2
    when "DEF" then 3
    when "MAT" then 4
    when "MDF" then 5
    when "AGI" then 6
    when "LUK" then 7
    end
  end
  #--------------------------------------------------------------------------
  # * New method: danger?
  #--------------------------------------------------------------------------
  def danger?
    hp < mhp * 25 / 100
  end
  #--------------------------------------------------------------------------
  # * New method: sprite
  #--------------------------------------------------------------------------
  def sprite
    valid = SceneManager.scene_is?(Scene_Battle) && SceneManager.scene.spriteset
    valid ? SceneManager.scene.spriteset.sprite(self) : nil
  end
end

#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemy characters. It's used within the Game_Troop class
# ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * New method: note
  #--------------------------------------------------------------------------
  def note
    enemy ? enemy.note : ""
  end
  #--------------------------------------------------------------------------
  # * New method: get_all_notes
  #--------------------------------------------------------------------------
  def get_all_notes
    result = note
    states.compact.each {|state| result += state.note }
    result
  end
  #--------------------------------------------------------------------------
  # * New method: level
  #--------------------------------------------------------------------------
  def level
    return 1
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * New method: note
  #--------------------------------------------------------------------------
  def note
    actor ? actor.note : ""
  end
  #--------------------------------------------------------------------------
  # * New method: hue
  #--------------------------------------------------------------------------
  def hue
    @hue ? @hue : 0
  end
  #--------------------------------------------------------------------------
  # * New method: get_all_notes
  #--------------------------------------------------------------------------
  def get_all_notes
    result = note
    result += self.class.note
    equips.compact.each {|equip| result += equip.note }
    states.compact.each {|state| result += state.note }
    result
  end
  #--------------------------------------------------------------------------
  # * New method: in_active_party?
  #--------------------------------------------------------------------------
  def in_active_party?
    $game_party.battle_members.include?(self)
  end
  #--------------------------------------------------------------------------
  # * New method: in_reserve_party?
  #--------------------------------------------------------------------------
  def in_reserve_party?
    $game_party.reserve_members.include?(self)
  end
  #--------------------------------------------------------------------------
  # * New method: in_party?
  #--------------------------------------------------------------------------
  def in_party?
    $game_party.all_members.include?(self)
  end
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
# and items. The instance of this class is referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * New method: average_level
  #--------------------------------------------------------------------------
  def average_level
    battle_members.collect {|actor| actor.level }.average
  end
  #--------------------------------------------------------------------------
  # * New method: reserve_members
  #--------------------------------------------------------------------------
  def reserve_members
    all_members - battle_members
  end
end

#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * New method: event_list
  #--------------------------------------------------------------------------
  def event_list
    events.values
  end
  #--------------------------------------------------------------------------
  # * New method: note
  #--------------------------------------------------------------------------
  def note
    @map ? @map.note : ""
  end
  #--------------------------------------------------------------------------
  # * New method: vehicles
  #--------------------------------------------------------------------------
  def vehicles
    @vehicles
  end
  #--------------------------------------------------------------------------
  # * New method: actors
  #--------------------------------------------------------------------------
  def actors
    [$game_player] + $game_player.followers.visible_followers
  end
end

#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
#  This class deals with characters. Common to all characters, stores basic
# data, such as coordinates and graphics. It's used as a superclass of the
# Game_Character class.
#==============================================================================

class Game_CharacterBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :move_speed
  attr_accessor :move_frequency
  #--------------------------------------------------------------------------
  # * New method: is_player?
  #--------------------------------------------------------------------------
  def is_player?
    return false
  end
  #--------------------------------------------------------------------------
  # * New method: is_event?
  #--------------------------------------------------------------------------
  def is_event?
    return false
  end
  #--------------------------------------------------------------------------
  # * New method: is_follower?
  #--------------------------------------------------------------------------
  def is_follower?
    return false
  end
  #--------------------------------------------------------------------------
  # * New method: is_vehicle?
  #--------------------------------------------------------------------------
  def is_vehicle?
    return false
  end
  #--------------------------------------------------------------------------
  # * New method: frames
  #--------------------------------------------------------------------------
  def frames
    return 3
  end
  #--------------------------------------------------------------------------
  # * New method: hue
  #--------------------------------------------------------------------------
  def hue
    @hue ? @hue : 0
  end
end

#==============================================================================
# ** Game_Character
#------------------------------------------------------------------------------
#  This class deals with characters. It's used as a superclass of the
# Game_Player and Game_Event classes.
#==============================================================================

class Game_Character < Game_CharacterBase
  #--------------------------------------------------------------------------
  # * New method: move_toward_position
  #--------------------------------------------------------------------------
  def move_toward_position(x, y)
    sx = distance_x_from(x)
    sy = distance_y_from(y)
    if sx.abs > sy.abs
      move_straight(sx > 0 ? 4 : 6)
      move_straight(sy > 0 ? 8 : 2) if !@move_succeed && sy != 0
    elsif sy != 0
      move_straight(sy > 0 ? 8 : 2)
      move_straight(sx > 0 ? 4 : 6) if !@move_succeed && sx != 0
    end
  end
end

#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player.
# The instance of this class is referenced by $game_map.
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * New method: is_player?
  #--------------------------------------------------------------------------
  def is_player?
    return true
  end
  #--------------------------------------------------------------------------
  # * New method: perform_transfer
  #--------------------------------------------------------------------------
  def new_map_id
    @new_map_id
  end
  #--------------------------------------------------------------------------
  # * New method: hue
  #--------------------------------------------------------------------------
  def hue
    actor ? actor.hue : 0
  end
end

#==============================================================================
# ** Game_Follower
#------------------------------------------------------------------------------
#  This class handles the followers. Followers are the actors of the party
# that follows the leader in a line. It's used within the Game_Followers class.
#==============================================================================

class Game_Follower < Game_Character
  #--------------------------------------------------------------------------
  # * New method: is_follower?
  #--------------------------------------------------------------------------
  def is_follower?
    return true
  end
  #--------------------------------------------------------------------------
  # * New method: index
  #--------------------------------------------------------------------------
  def index
    @member_index
  end
end

#==============================================================================
# ** Game_Followers
#------------------------------------------------------------------------------
#  This class handles the followers. It's a wrapper for the built-in class
# "Array." It's used within the Game_Player class.
#==============================================================================

class Game_Followers
  #--------------------------------------------------------------------------
  # * New method: get_actor
  #--------------------------------------------------------------------------
  def get_actor(id)
    list = [$game_player] + visible_followers.select do |follower|
      follower.actor && follower.actor.id == id
    end
    list.first
  end
end

#==============================================================================
# ** Game_Vehicle
#------------------------------------------------------------------------------
#  This class handles vehicles. It's used within the Game_Map class. If there
# are no vehicles on the current map, the coordinates is set to (-1,-1).
#==============================================================================

class Game_Vehicle < Game_Character
  #--------------------------------------------------------------------------
  # * New method: is_vehicle?
  #--------------------------------------------------------------------------
  def is_vehicle?
    return true
  end
  #--------------------------------------------------------------------------
  # * New method: map_id
  #--------------------------------------------------------------------------
  def map_id
    @map_id 
  end
end

#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class deals with events. It handles functions including event page 
# switching via condition determinants, and running parallel process events.
# It's used within the Game_Map class.
#==============================================================================

class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * New method: name
  #--------------------------------------------------------------------------
  def name
    @event.name
  end
  #--------------------------------------------------------------------------
  # * New method: is_event?
  #--------------------------------------------------------------------------
  def is_event?
    return true
  end
  #--------------------------------------------------------------------------
  # * New method: note
  #--------------------------------------------------------------------------
  def note
    return "" if !@page || !@page.list || @page.list.size <= 0
    comment_list = []
    @page.list.each do |item|
      next unless item && (item.code == 108 || item.code == 408)
      comment_list.push(item.parameters[0])
    end
    comment_list.join("\r\n")
  end  
end

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  An interpreter for executing event commands. This class is used within the
# Game_Map, Game_Troop, and Game_Event classes.
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Alias method: command_108
  #--------------------------------------------------------------------------
  alias :command_108_ve_basic_module :command_108
  def command_108
    command_108_ve_basic_module
    comment_call
  end
  #--------------------------------------------------------------------------
  # * New method: comment_call
  #--------------------------------------------------------------------------
  def comment_call
  end
  #--------------------------------------------------------------------------
  # * New method: note
  #--------------------------------------------------------------------------
  def note
    @comments ? @comments.join("\r\n") : ""
  end
end

#==============================================================================
# ** Sprite_Character
#------------------------------------------------------------------------------
#  This sprite is used to display characters. It observes a instance of the
# Game_Character class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------
  # * Overwrite method: set_character_bitmap
  #--------------------------------------------------------------------------
  def set_character_bitmap
    update_character_info
    set_bitmap
    set_bitmap_position
  end
  #--------------------------------------------------------------------------
  # * New method: center_y
  #--------------------------------------------------------------------------
  def actor?
    @character.is_a?(Game_Player) || @character.is_a?(Game_Follower)
  end
  #--------------------------------------------------------------------------
  # * New method: center_y
  #--------------------------------------------------------------------------
  def actor
    actor? ? @character.actor : nil
  end
  #--------------------------------------------------------------------------
  # * New method: update_character_info
  #--------------------------------------------------------------------------
  def update_character_info
  end
  #--------------------------------------------------------------------------
  # * New method: hue
  #--------------------------------------------------------------------------
  def hue
    @character.hue
  end
  #--------------------------------------------------------------------------
  # * New method: set_bitmap
  #--------------------------------------------------------------------------
  def set_bitmap
    self.bitmap = Cache.character(set_bitmap_name, hue)
  end
  #--------------------------------------------------------------------------
  # * New method: set_bitmap_name
  #--------------------------------------------------------------------------
  def set_bitmap_name
    @character_name
  end
  #--------------------------------------------------------------------------
  # * New method: set_bitmap_position
  #--------------------------------------------------------------------------
  def set_bitmap_position
    sign = get_sign
    if sign && sign.include?('$')
      @cw = bitmap.width / @character.frames
      @ch = bitmap.height / 4
    else
      @cw = bitmap.width / (@character.frames * 4)
      @ch = bitmap.height / 8
    end
    self.ox = @cw / 2
    self.oy = @ch
  end
  #--------------------------------------------------------------------------
  # * New method: get_sign
  #--------------------------------------------------------------------------
  def get_sign
    @character_name[/^[\!\$]./]
  end
end

#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display battlers. It observes a instance of the
# Game_Battler class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :dmg_mirror
  #--------------------------------------------------------------------------
  # * New method: center_x
  #--------------------------------------------------------------------------
  def center_x
    self.ox
  end
  #--------------------------------------------------------------------------
  # * New method: center_y
  #--------------------------------------------------------------------------
  def center_y
    self.oy / 2
  end
end

#==============================================================================
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  This class brings together battle screen sprites. It's used within the
# Scene_Battle class.
#==============================================================================

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :viewport1
  #--------------------------------------------------------------------------
  # * New method: sprite
  #--------------------------------------------------------------------------
  def sprite(subject)
    battler_sprites.compact.select {|sprite| sprite.battler == subject }.first
  end
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This is a superclass of all windows in the game.
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Alias method: convert_escape_characters
  #--------------------------------------------------------------------------
  alias :convert_escape_ve_basic_module :convert_escape_characters
  def convert_escape_characters(text)
    result = text.to_s.clone
    result = text_replace(result)
    result = convert_escape_ve_basic_module(text)
    result
  end
  #--------------------------------------------------------------------------
  # * New method: text_replace
  #--------------------------------------------------------------------------
  def text_replace(result)
    result.gsub!(/\r/) { "" }
    result.gsub!(/\\/) { "\e" }
    result
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :spriteset
end