# Source: http://www.rpgmakervxace.net/topic/8529-xs-menu-delux/

#==============================================================================
#   XaiL System - Menu Delux
#   Author: Nicke
#   Created: 20/11/2012
#   Edited: 08/02/2013
#   Version: 1.1b
#==============================================================================
# Instructions
# -----------------------------------------------------------------------------
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ? Materials but above ? Main. Remember to save.
#==============================================================================
# Requires: XS - Core Script.
#==============================================================================
#
# This script changes the way the menu scene works. Not compatible with
# XS - Menu or XS - Icon Menu.
#
# Instructions are in the settings module below. Make sure you read through
# everything so you understand each section.
#
# *** Only for RPG Maker VX Ace. ***
#==============================================================================
($imported ||= {})["XAIL-XS-MENU_DELUX"] = true

module XAIL
  module MENU_DELUX
    #--------------------------------------------------------------------------#
    # * Settings
    #--------------------------------------------------------------------------#
    # FONT:
    # FONT = [name, size, color, bold, shadow]
    FONT = [["Calibri", "Verdana"], 18, Color.new(255,255,255), true, true]
    
    # PLAYTIME_ICON:
    # Set playtime window icon.
    # PLAYTIME_ICON = icon_id
    PLAYTIME_ICON = 280
    
    # MENU_ALIGNMENT:
    # MENU_ALIGNMENT = 0 (left), 1 (center), 2 (right)
    MENU_ALIGNMENT = 0 # Default: 2.
    
    # MENU_SKIN:
    # The windowskin to use for the windows.
    # Set to nil to disable.
    # MENU_SKIN = string
    MENU_SKIN = nil
    
    # MENU_LIST: 
    # name, icon_index and custom are optional.
    # If name is empty it will use the corresponding symbol as name instead.
    # To make a command a common event you need to set custom to the common event
    # id you want to run as seen below.
    # symbol => [name, description, icon_index, enabled, personal, custom]
    MENU_LIST = {
      :item      => ["", "Browse through your acquired items.", 4148, true, false],
      :equip     => ["Equipment", "Change your equipment.", 4145, true, true],
      :skill     => ["Spells", "Manage your available skills.", 4147, true, true],
      :status    => ["Stats", "See the current status of the hero.", 4136, true, true],
      :formation => ["", "Change the formation of the party.", 4134, true, false],
      :save      => ["", "Record your progress.", 4139, true, false],
      :load      => ["", "Load your saved progress.", 4165, true, false, Scene_Load],
      :game_end  => ["Quit", "Exit the program.", 4162, true, false],
      :title     => ["", "Return to title.", 4133, true, false, Scene_Title],
      :com_event => ["Camping", "Run common event camping.", 728, true, false, 1]
    } # Don't remove this line!
    
    # MENU_SAVE = true/false
    # Override enabled option for save (so you can change it ingame).
    MENU_SAVE = true
    
    # If MENU_CUSTOM is true you will have to add the commands yourself
    # ingame, which can be useful for certain quest related stuff or if you
    # want to enable/disable menu commands.
    # To add/remove a command ingame follow these instructions:
    # 
    # In a script call do like this:
    # menu_scene(key, type)
    # menu_scene(:item,:add) # To add item to menu list.
    # menu_scene(:item,:del) # To remove item from menu list.
    #
    # In a conditional branch you can check if a menu command is 
    # enabled/disabled:
    # menu_active?(key) 
    # menu_active?(:item) # Check if item is enabled.
    # !menu_active?(:item) # Check if item is disabled.
    #
    # To set a id to be enabled do like this:
    # menu_active(:skill, true) # Set menu skill to be enabled.
    #
    # To add/remove all available menu commands use one of the 
    # following methods in a script call:
    # menu_add_all
    # menu_del_all
    #
    # MENU_CUSTOM = true/false
    MENU_CUSTOM = false
    
    # The text to be displayed if no menu items is available.
    # Only used if MENU_CUSTOM is true.
    # MENU_EMPTY = string
    EMPTY = "Menu is not available at this point..."
    
    # MENU_MUSIC:
    # Set the music to be played at the menu scene.
    # This is optional.
    # MUSIC = true/false
    MUSIC = true
    # MUSIC_BGM = [name, volume, pitch]
    MUSIC_BGM = ["Theme4", 70, 100]
    # MUSIC_BGS = [name, volume, pitch]
    MUSIC_BGS = ["Darkness", 50, 100]
    
    # ANIM_LIST:
    # A list of animation images.
    # name  =>  [z, zoom_x, zoom_y, blend_type, opacity]
    ANIM_LIST = {
      "Menu_Fog1"   => [1, 1.2, 1.2, 1, 125],
      "Menu_Fog2"   => [1, 1.8, 1.8, 1, 155]
    } # Don't remove this line!
    
    # BACKGROUND:
    # name => [x, y, z, opacity]
    BACKGROUND = {
      #"" => [0, 0, 200, 255]
    } # Don't remove this line!
    
    # Show vocab for HP, MP and TP.
    # BAR_VOCAB = true/false
    BAR_VOCAB = false
    
    # BAR_COLOR = rgba(255,255,255,255)
    # Set the color of the gauges.
    BAR_HP = [Color.new(255,25,25,32), Color.new(255,150,150)]
    BAR_MP = [Color.new(25,25,255,32), Color.new(150,150,255)]
    BAR_TP = [Color.new(25,255,25,32), Color.new(150,255,150)]
    
    # DETAILS:
    # Setup details here. (Recommended to use the default ones since you will
    # need a bit RGSS knowledge to add more.)
    def self.details
      ["#{Vocab::currency_unit}: #{$game_party.gold}",
      "Steps: #{$game_party.steps}",
      "Collected Items: #{$game_party.all_items.size}",
      "Map: #{$data_mapinfos[$game_map.map_id].name}",
      "Leader: #{$game_party.leader.name}",
      "Battle Count: #{$game_system.battle_count}",
      "Save Count: #{$game_system.save_count}",
      "Party Members: #{$game_party.all_members.size}",
      "Highest Level: #{$game_party.highest_level}",
      "Variable I: #{$game_variables[1]}",
      "Variable II: #{$game_variables[2]}"]
    end
    
    # DETAILS_ICONS:
    # DETAILS_ICONS[id] = icon_id
    # Set the details icon_id. (optional)
    # Should be in the same order as details.
    # Use nil to disable a icon.
    DETAILS_ICONS = []
    DETAILS_ICONS[0]  = 2114 # GOLD
    DETAILS_ICONS[1]  = 172  # STEPS
    DETAILS_ICONS[2]  = 270  # ITEMS
    DETAILS_ICONS[3]  = 232  # MAP
    DETAILS_ICONS[4]  = 4425 # LEADER
    DETAILS_ICONS[5]  = 115  # BATTLE COUNT
    DETAILS_ICONS[6]  = 224  # SAVE COUNT
    DETAILS_ICONS[7]  = 121  # PARTY MEMBERS
    DETAILS_ICONS[8]  = 14   # HIGHEST LEVEL
    DETAILS_ICONS[9]  = nil  # VARIABLE 1
    DETAILS_ICONS[10] = nil  # VARIABLE 2
    
    # Transition, nil to use default.
    # TRANSITION [speed, transition, opacity]
    TRANSITION = nil
    
  end
end
# *** Don't edit below unless you know what you are doing. ***
#==============================================================================#
# ** Error Handler
#==============================================================================#
  unless $imported["XAIL-XS-CORE"]
    # // Error handler when XS - Core is not installed.
    msg = "The script %s requires the latest version of XS - Core in order to function properly."
    name = "XS - Menu Delux"
    msgbox(sprintf(msg, name))
    exit
  end
#==============================================================================#
# ** Game_System
#==============================================================================#
class Game_System
  
  attr_accessor :menu_list
  
  alias xail_menu_delux_gm_sys_initialize initialize
  def initialize(*args, &block)
    # // Method to initialize game system.
    xail_menu_delux_gm_sys_initialize(*args, &block)
    @menu_list = {}
  end
  
  def get_menu
    # // Method to get the menu list.
    XAIL::MENU_DELUX::MENU_CUSTOM ? @menu_list : XAIL::MENU_DELUX::MENU_LIST
  end
  
end
#==============================================================================#
# ** Game_Interpreter
#==============================================================================#
class Game_Interpreter
  
  def menu_scene(key, type = :add)  
    # // Method to add/remove a menu item to the list.
    case type
      when :add # // Add menu id.
       unless $game_system.menu_list.include?(XAIL::MENU_DELUX::MENU_LIST[key])
         $game_system.menu_list[key] = XAIL::MENU_DELUX::MENU_LIST[key]           
       end unless XAIL::MENU_DELUX::MENU_LIST[key].nil?
      when :del # // Remove menu id.
      unless XAIL::MENU_DELUX::MENU_LIST[key].nil?
        $game_system.menu_list.delete(key)
      end
    end
  end
  
  def menu_active?(key)
    # // Method to check if menu key is enabled.
    # This will return nil if menu item not added in the list.
    return $game_system.menu_list[key][3] rescue nil
  end
  
  def menu_active(key, enabled)
    # // Method to enable id.
    $game_system.menu_list[key][3] = enabled
  end
  
  def menu_add_all
    # // Method to add all available menu items.
    XAIL::MENU_DELUX::MENU_LIST.each_key {|key| menu_scene(key) }
  end
  
  def menu_del_all
    # // Method to remove all available menu items.
    XAIL::MENU_DELUX::MENU_LIST.each_key {|key| menu_scene(key, :del) }
  end

end
#==============================================================================
# ** Window_MenuCommand
#==============================================================================
class Window_MenuCommand < Window_Command
  
  def window_width
    # // Method to return the width of the window.
    return Graphics.width / 4
  end
  
  def window_height
    # // Method to return the height of the window.
    return Graphics.height
  end
  
  def alignment
    # // Method to return the alignment.
    return XAIL::MENU_DELUX::MENU_ALIGNMENT
  end
  
  def menu_color(color, enabled = true)
     # // Method to set the color and alpha if not enabled.
    contents.font.color.set(color)
    contents.font.color.alpha = Colors::AlphaMenu unless enabled
  end
  
  def item_rect_for_text(index)
    # // Method to draw item rect for text.
    rect = item_rect(index)
    rect.x += 25
    draw_line_ex(rect.x - 4, rect.y + 9, Color.new(255,255,255), Color.new(0,0,0,128))
    draw_icon(XAIL::MENU_DELUX::MENU_LIST.values[index][2], -2, rect.y) unless XAIL::MENU_DELUX::MENU_LIST.values[index][2].nil?
    rect
  end
  
  def draw_item(index)
    # // Method to draw the command item.
    contents.font.name = XAIL::MENU_DELUX::FONT[0]
    contents.font.size = XAIL::MENU_DELUX::FONT[1]
    # // Save enable option.
    XAIL::MENU_DELUX::MENU_LIST[:save][3] = save_enabled if XAIL::MENU_DELUX::MENU_SAVE
    # // Default enable option.
    menu_color(XAIL::MENU_DELUX::FONT[2], menu_enabled?(index))
    # // Font settings
    contents.font.bold = XAIL::MENU_DELUX::FONT[3]
    contents.font.shadow = XAIL::MENU_DELUX::FONT[4]
    draw_text(item_rect_for_text(index), command_name(index), alignment)
    reset_font_settings
  end
  
  def menu_enabled?(index)
    # // Method to check if menu item is enabled.
    return $game_system.get_menu.values[index][3]
  end
  
  def make_command_list
    # // Method to add the commands.
    $game_system.get_menu.each {|key, value|
      name = value[0] == "" ? key.id2name.capitalize : value[0]
      XAIL::MENU_DELUX::MENU_LIST[:save][3] = save_enabled if XAIL::MENU_DELUX::MENU_SAVE
      add_command(name, key, value[3], value[5].nil? ? nil : value[5])
    }
  end

end
#==============================================================================
# ** Window_MenuStatus
#==============================================================================
class Window_MenuStatus < Window_Selectable
  
  def initialize(x, y)
    # // Method to initialize the window.
    super(x, y, window_width, window_height)
    self.arrows_visible = false
    @pending_index = -1
    refresh
  end
  
  def window_width
    # // Method to determine window width.
    return Graphics.width / 2.4
  end
  
  def col_max
    # // Method to determine col max.
    return 2
  end

  def spacing
    # // Method to determine spacing.
    return 6 if Graphics.width == 544 # For standard resolution.
    return 44                         # For high resolution.
  end
  
  def item_width
    # // Method to determine item width.
    return 98
  end

  def item_height
    # // Method to determine item height.
    return 128
  end
  
  def refresh
    # // Method to refresh the window.
    super
    # // Only display cursor arrow if more or equal to 5 party members.
    if $game_party.all_members.size >= 5
      self.arrows_visible = true
    end
  end

  def draw_item(index)
    # // Method to draw item.
    actor = $game_party.members[index]
    rect = item_rect(index)
    # // Face
    draw_actor_face(actor, rect.x + 1, rect.y + 1, true)
    # // Name
    draw_font_text(actor.name, rect.x + 4, rect.y, rect.width, 0, XAIL::MENU_DELUX::FONT[0], 20, XAIL::MENU_DELUX::FONT[2])
    # // Level
    lvl = "#{Vocab::level_a}: #{actor.level}"
    draw_font_text(lvl, rect.x + 4, rect.y + 64, rect.width, 0, XAIL::MENU_DELUX::FONT[0], 18, XAIL::MENU_DELUX::FONT[2])
    # // Class
    # // Check if Yanfly Class System is installed.
    if $imported["YEA-ClassSystem"]
      actor_class = actor.subclass.nil? ? actor.class.name : "#{actor.class.name} [#{actor.subclass.name}]"
    else
      actor_class = actor.class.name
    end    
    draw_font_text(actor_class, rect.x - 4, rect.y + 76, rect.width, 2, XAIL::MENU_DELUX::FONT[0], 16, XAIL::MENU_DELUX::FONT[2])
    # // Stats
    draw_menu_stats(actor, :hp, rect.x, rect.y + 90, XAIL::MENU_DELUX::BAR_HP[0], XAIL::MENU_DELUX::BAR_HP[1], rect.width - 2)
    draw_menu_stats(actor, :mp, rect.x, rect.y + 100, XAIL::MENU_DELUX::BAR_MP[0], XAIL::MENU_DELUX::BAR_MP[1], rect.width - 2)
    draw_menu_stats(actor, :tp, rect.x, rect.y + 110, XAIL::MENU_DELUX::BAR_TP[0], XAIL::MENU_DELUX::BAR_TP[1], rect.width - 2)
  end
  
  def draw_menu_stats(actor, stat, x, y, color1, color2, width)
    # // Method to draw actor hp & mp.
    case stat
    when :hp
      rate = actor.hp_rate ; vocab = Vocab::hp_a ; values = [actor.hp, actor.mhp]
    when :mp
      rate = actor.mp_rate ; vocab = Vocab::mp_a ; values = [actor.mp, actor.mmp]
    when :tp
      rate = actor.tp_rate ; vocab = Vocab::tp_a ; values = [actor.tp, actor.max_tp]
    end
    contents.font.name = XAIL::MENU_DELUX::FONT[0]
    contents.font.size = 14 # // Override font size.
    contents.font.color = XAIL::MENU_DELUX::FONT[2]
    contents.font.bold = XAIL::MENU_DELUX::FONT[3]
    contents.font.shadow = XAIL::MENU_DELUX::FONT[4]
    # // Draw guage.
    draw_gauge_ex(x, y - 8, width, 8, rate, color1, color2)
    # // Draw stats.
    draw_text(x + 2, y, width, line_height, values[0], 0)
    draw_text(x + 1, y, width, line_height, values[1], 2)
    # // Draw vocab.
    draw_text(x, y, width, line_height, vocab, 1) if XAIL::MENU_DELUX::BAR_VOCAB
    reset_font_settings
  end

end
#==============================================================================
# ** Window_Menu_Details
#==============================================================================
class Window_Menu_Details < Window_Base
  
  def initialize(x, y)
    # // Method to initialize.
    super(x, y, window_width, window_height)
    @leader = $game_party.leader
    refresh
  end
  
  def window_width
    # // Method to determine window width.
    return Graphics.width / 3
  end
  
  def window_height
    # // Method to determine window height.
    return Graphics.height
  end
  
  def refresh
    # // Method to refresh the window.
    contents.clear
    # // Draw details.
    y = -10
    XAIL::MENU_DELUX.details.each_index {|i|
      draw_line_ex(0, y += 24, Color.new(255,255,255,32), Color.new(0,0,0,64))
      draw_font_text(XAIL::MENU_DELUX.details[i], -4, line_height * i + 4, contents_width, 2, XAIL::MENU_DELUX::FONT[0], 16, XAIL::MENU_DELUX::FONT[2])
    }
    # // Draw icons.
    draw_icons(XAIL::MENU_DELUX::DETAILS_ICONS, :vertical, 2, line_height * 0 + 2)
  end

  def update
    # // Method to update details window.
    super
    if @leader != $game_party.leader
      @leader = $game_party.leader
      refresh
    end
  end
  
end
#==============================================================================
# ** Window_Menu_Playtime
#==============================================================================
class Window_Menu_Playtime < Window_Base
  
  def initialize(x, y)
    # // Method to initialize.
    super(x, y, 120, fitting_height(1))
    @playtime = $game_system.playtime_s
    refresh
  end
  
  def refresh
    # // Method to refresh the window.
    contents.clear
    # // Draw icon.
    draw_icon(XAIL::MENU_DELUX::PLAYTIME_ICON, 4, 0)
    # // Draw playtime.
    draw_font_text(@playtime, 0, 6, contents_width, 2, XAIL::MENU_DELUX::FONT[0], 22, XAIL::MENU_DELUX::FONT[2])
  end
  
  def update
    # // Method to update the window.
    super
    @playtime = $game_system.playtime_s
    refresh
  end
  
end
#==============================================================================#
# ** Window_Menu_Help
#==============================================================================#
class Window_Menu_Help < Window_Help
  
  attr_accessor :index
  
  alias xail_icon_menu_winhelp_init initialize
  def initialize(*args, &block)
    # // Method to initialize help window.
    xail_icon_menu_winhelp_init(*args, &block)
    @index = 0
  end

  def set_text(text, enabled)
    # // Method to set a new help text.
    if text != @text
      menu_color(XAIL::MENU_DELUX::FONT[2], enabled)
      @text = text
      refresh
    end
  end
  
  def refresh
    # // Refresh help contents.
    contents.clear
    draw_help_text
  end
  
  def draw_help_text
    # // Method to draw the help text.
    contents.font.name = XAIL::MENU_DELUX::FONT[0]
    contents.font.size = XAIL::MENU_DELUX::FONT[1]
    menu_color(XAIL::MENU_DELUX::FONT[2], menu_enabled?(@index))
    contents.font.bold = XAIL::MENU_DELUX::FONT[3]
    contents.font.shadow = XAIL::MENU_DELUX::FONT[4]
    # // Draw title and description for the menu.
    draw_line_ex(0, 14, Color.new(255,255,255), Color.new(0,0,0,128))
    draw_text_ex_no_reset(0, 0, @text)
    reset_font_settings
  end
  
  def menu_enabled?(index)
    # // Method to check if menu item is enabled.
    return $game_system.get_menu.values[index][3]
  end
  
  def menu_color(color, enabled = true)
     # // Method to set the color and alpha if not enabled.
    contents.font.color.set(color)
    contents.font.color.alpha = 150 unless enabled
  end
  
end
#==============================================================================#
# ** Scene_MenuBase
#==============================================================================#
class Scene_MenuBase < Scene_Base
  
  def start
    # // Method to start the scene.
    super
    @actor = $game_party.menu_actor
    if SceneManager.scene_is?(Scene_Menu)
      @backgrounds = []
      @animations = []
      create_menu_backgrounds
      create_menu_animations
    end
  end
  
  def create_menu_backgrounds
    # // Method to create custom background(s).
    XAIL::MENU_DELUX::BACKGROUND.each {|key, value| @backgrounds << [Sprite.new, key] }
    @backgrounds.each {|i|
      i[0].bitmap = Cache.system(i[1])
      i[0].x = XAIL::MENU_DELUX::BACKGROUND[i[1]][0]
      i[0].y = XAIL::MENU_DELUX::BACKGROUND[i[1]][1]
      i[0].z = XAIL::MENU_DELUX::BACKGROUND[i[1]][2]
      i[0].opacity = XAIL::MENU_DELUX::BACKGROUND[i[1]][3]
    }
  end
  
  def create_menu_animations
    # // Method to create custom animation(s).
    # name  =>  [z, zoom_x, zoom_y, blend_type, opacity]
    XAIL::MENU_DELUX::ANIM_LIST.each {|key, value| @animations.push << [Plane.new, key] }
    @animations.each {|i|
      i[0].bitmap = Cache.system(i[1])
      i[0].z = XAIL::MENU_DELUX::ANIM_LIST[i[1]][0]
      i[0].zoom_x = XAIL::MENU_DELUX::ANIM_LIST[i[1]][1]
      i[0].zoom_y = XAIL::MENU_DELUX::ANIM_LIST[i[1]][2]
      i[0].blend_type = XAIL::MENU_DELUX::ANIM_LIST[i[1]][3]
      i[0].opacity = XAIL::MENU_DELUX::ANIM_LIST[i[1]][4]
    }
  end

  alias xail_upd_menubase_delux_upd update
  def update(*args, &block)
    # // Method for updating the scene.
    xail_upd_menubase_delux_upd(*args, &block)
    if SceneManager.scene_is?(Scene_Menu)
      for i in 0...@animations.size
        @animations[i][0].ox += 1.2 - i
        @animations[i][0].oy -= 0.6 + i
      end unless scene_changing?
      delay?(1)
    end
  end
  
  def delay?(amount)
    # // Method to delay.
    amount.times do
      update_basic
    end
  end
  
  alias xail_menubase_delux_transition perform_transition
  def perform_transition(*args, &block)
    # // Method to create the transition.
    return if $game_system.get_menu.empty?
    if XAIL::MENU_DELUX::TRANSITION.nil?
      xail_menubase_delux_transition(*args, &block)
    else
      Graphics.transition(XAIL::MENU_DELUX::TRANSITION[0],XAIL::MENU_DELUX::TRANSITION[1],XAIL::MENU_DELUX::TRANSITION[2])
    end
  end
  
  def dispose_sprites
    # // Method to dispose sprites.
    @backgrounds.each {|i| i[0].dispose unless i[0].nil? ; i[0] = nil } rescue nil
    @animations.each {|i| i[0].dispose unless i[0].nil? ; i[0] = nil } rescue nil
  end
  
  def terminate
    # // Method to terminate.
    super
    dispose_sprites unless SceneManager.scene_is?(Scene_Menu)
  end

end
#==============================================================================#
# ** Scene_Menu
#==============================================================================#
class Scene_Menu < Scene_MenuBase
  
  def start
    super
    # // Method to start the scene.
    # // Return if menu empty.
    return command_map if $game_system.get_menu.empty?
    # // Create windows.
    create_menu_command_window
    create_menu_status_window
    create_menu_details_window
    create_menu_playtime_window
    create_menu_help_window
    # // Set help text to first menu command.
    help_update(@command_window.index)
    # // Play music if enabled.
    play_menu_music if XAIL::MENU_DELUX::MUSIC
  end
  
  def create_menu_command_window
    # // Method to create the command window.
    @command_window = Window_MenuCommand.new
    @command_window.windowskin = Cache.system(XAIL::MENU_DELUX::MENU_SKIN) unless XAIL::MENU_DELUX::MENU_SKIN.nil?
    @command_window.back_opacity = 96
    $game_system.get_menu.each {|key, value|
      unless value[5].nil?
        @command_window.set_handler(key, method(:command_custom))
      else
        if value[4]
          @command_window.set_handler(key, method(:command_personal))
        else
          @command_window.set_handler(key, method("command_#{key}".to_sym))
        end
      end
    }    
    @command_window.set_handler(:cancel, method(:return_scene))
  end
  
  def create_menu_status_window
    # // Method to create the status window.
    @status_window = Window_MenuStatus.new(0, 0)
    @status_window.height = Graphics.height - 72
    @status_window.x = @command_window.width
    @status_window.back_opacity = 96
  end
  
  def create_menu_details_window
    # // Method to create the details window.
    @details_window = Window_Menu_Details.new(0, 0)
    @details_window.x = Graphics.width - @details_window.width
    @details_window.back_opacity = 96
  end
  
  def create_menu_playtime_window
    # // Method to create the playtime window.
    @playtime_window = Window_Menu_Playtime.new(0, 0)
    @playtime_window.x = Graphics.width - @playtime_window.width
    @playtime_window.y = Graphics.height - @playtime_window.height - 26
    @playtime_window.opacity = 0
    @playtime_window.z = 201
  end
  
  def create_menu_help_window
    # // Method to create the help window.
    @help_window = Window_Menu_Help.new(2)
    @help_window.viewport = @viewport
    @help_window.windowskin = Cache.system(XAIL::MENU_DELUX::MENU_SKIN) unless XAIL::MENU_DELUX::MENU_SKIN.nil?
    @help_window.index = @command_window.index
    @help_window.y = Graphics.height - @help_window.height
    @help_window.back_opacity = 255
    @help_window.z = 200
  end
  
  def play_menu_music
    # // Method to play menu music.
    @last_bgm = RPG::BGM.last
    @last_bgs = RPG::BGS.last
    bgm = XAIL::MENU_DELUX::MUSIC_BGM
    bgs = XAIL::MENU_DELUX::MUSIC_BGS
    Sound.play(bgm[0], bgm[1], bgm[2], :bgm)
    Sound.play(bgs[0], bgs[1], bgs[2], :bgs)
  end
  
  alias xail_upd_menu_delux_upd update
  def update(*args, &block)
    # // Method for updating the scene.
    xail_upd_menu_delux_upd(*args, &block)
    old_index = @help_window.index
    help_update(@command_window.index) if old_index != @command_window.index
  end
  
  def help_update(index)
    # // If index changes update help window text.
    list = XAIL::MENU_DELUX::MENU_LIST
    icon = list.values[index][2].nil? ? "" : list.values[index][2]
    name = list.values[index][0] == "" ? list.keys[index].id2name.capitalize : list.values[index][0]
    if icon == "" ; title = name ; else ; title = '\i[' + icon.to_s + ']' + name ; end
    desc = '\c[0]' + list.values[index][1]
    text = "#{title}\n#{desc}"
    enabled = list.values[index][3]
    @help_window.index = index
    @help_window.set_text(text, enabled)
  end
  
  def on_personal_ok
    # // Method override on personal ok.
    scene = "Scene_#{@command_window.current_symbol.to_s.capitalize}".to_class
    SceneManager.call(scene)
  end
  
  def command_custom
    # // Method to call a custom command. (Don't remove)
    if @command_window.current_ext.is_a?(Integer)
      $game_temp.reserve_common_event(@command_window.current_ext)
      return command_map
    end
    SceneManager.call(@command_window.current_ext)
  end
  
  def command_map
    # // command_map (Don't remove)
    if $game_system.get_menu.empty?
      Sound.play_buzzer
      $game_message.texts << XAIL::MENU_DELUX::EMPTY
    end
    SceneManager.call(Scene_Map)
  end
  
  def pre_terminate
    # // Method to pre terminate scene menu.
    # // Play last bgm and bgs if menu music is enabled.
    if XAIL::MENU_DELUX::MUSIC
      @last_bgm.replay rescue nil
      @last_bgs.replay rescue nil
    end
  end
  
end # END OF FILE

#=*==========================================================================*=#
# ** END OF FILE
#=*==========================================================================*=#
