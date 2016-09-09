# Source: http://www.rpgmakervxace.net/topic/2535-xs-icon-menu/
#==============================================================================
#   XaiL System - Icon Menu
#   Author: Nicke
#   Created: 07/04/2012
#   Edited: 03/11/2012
#   Version: 1.0d
#==============================================================================
# Instructions
# -----------------------------------------------------------------------------
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ? Materials but above ? Main. Remember to save.
#
# A highly customized menu that displays icons as commands.
#
# *** Only for RPG Maker VX Ace. ***
#==============================================================================
($imported ||= {})["XAIL-XS-ICON_MENU"] = true

module XAIL
  module ICON_MENU
    #--------------------------------------------------------------------------#
    # * Settings
    #--------------------------------------------------------------------------#
    # MENU_FONT = [name, size, color, bold, shadow]
    MENU_FONT = [["Anklada™", "Verdana"], 20, Color.new(255,255,25), true, true]
    
    # MENU_WINDOW [x, y, z, opacity]
    MENU_WINDOW = [130, 120, 200, 255]
    
    # Center the menu.
    # Note: If this is on the x and y coordinates is not available.
    # MENU_CENTER = true/false
    MENU_CENTER = false
    
    # The windowskin to use for the windows.
    # nil to disable.
    # MENU_SKIN = string
    MENU_SKIN = nil
    
    # Menu list - The icon_index (can be nil) and custom_scene is optional.
    # MENU_LIST: 
    # ID = ['Title', description, :symbol, :command, icon_index, active, custom ]
    MENU_LIST = []    
    MENU_LIST[0] = ["Equip", "Change your equipment.", :equip, :command_equip, 170, true]
    MENU_LIST[1] = ["Skills", "Manage your available skills.", :skill, :command_skill, 112, true]
    MENU_LIST[2] = ["Item", "Browse through your acquired items.", :item, :command_item, 264, true]
    MENU_LIST[3] = ["Status", "See the current status of the hero.", :status, :command_status, 122, true]
    MENU_LIST[4] = ["Save", "Record your progress.", :save, :command_save, 233, true]
    MENU_LIST[5] = ["Load", "Load your saved progress.", :load, :command_custom, 230,   true, Scene_Load]
    MENU_LIST[6] = ["Quit", "Exit the program.", :game_end, :command_game_end, 1,   true]
    MENU_LIST[7] = ["Title", "Return to title.", :title, :command_custom, 12, true, Scene_Title]
    
    # If MENU_CUSTOM is true you will have to add the commands yourself
    # ingame, which can be useful for certain quest related stuff or if you
    # want to disable commands temporarly.
    # To add/delete a command ingame follow these instructions:
    # 
    # In a Call Script do like this:
    # menu_scene(2,:add) # To add id 2 to menu list.
    # menu_scene(3,:del) # To remove id 3 from menu list.
    #
    # In a conditional branch do like this to check if a id is active:
    # menu_active?(5) # Returns true if id 5 is enabled.
    #
    # To set a id to be enabled do like this:
    # menu_active(1, true) # Set id 1 to be enabled.
    #
    # To add/delete every menu item to the list use this method:
    # menu_scene_all(type = :add/:del)
    #
    # MENU_CUSTOM = true/false
    MENU_CUSTOM = true
    
    # The text to be displayed if no menu items is available.
    # MENU_EMPTY = ""
    MENU_EMPTY = "The menu is not available at this point."
    
    # Animate timer for the help window. 0 = no animation.
    # Only occurs when menu command has changed.
    # ANIMATE_TIMER = number
    ANIMATE_TIMER = 10
    
    # Help window.
    # HELP = [x, y, z, opacity, enabled]
    HELP = [120, 60, 200, 0, true]
    
    # Gold window.
    # nil to disable the icon(s).
    # GOLD = [x, y, z, opacity, icon_index, enabled]
    GOLD = [224, 368, 200, 0, 361, true]
     
    # Weight window.
    # Note: XS - Inventory Weight is required to use this.
    # WEIGHT = [x, y, z, opacity, icon_index, enabled]
    WEIGHT = [384, 368, 200, 255, 116, false]
    
    # Transition, nil to use default.
    # TRANSITION [speed, transition, opacity]
    # TRANSITION = [40, "Graphics/Transitions/4", 50]
    TRANSITION = nil
    
    # Menu background image (System folder)
    # Note: You might want to decrease the opacity as well as arrange 
    # the windows so that you can properly see the background.
    # Set to nil to use default.
    BACK = nil
    
    # Note: Not active if menu background is in use.
    # Background type: 
    # 0 = normal blur (default)
    # 1 = radial blur
    # 2 = hue change
    # 3 = custom color
    # 4 = custom gradient
    # BACK_TYPE = [type, opacity, enabled]
    BACK_TYPE = [0, 150, true]
    # BACK_RADIAL_BLUR = 0-360, 2-100
    BACK_RADIAL_BLUR = [10, 10]
    # BACK_HUE = 0-360
    BACK_HUE = 15 
    # BACK_COLOR = 0-255 (Red, Green, Blue, Alpha)
    BACK_COLOR = Color.new(255,0,255,128)
    # BACK_GRADIENT = [ Color1, Color2, Vertical ]
    BACK_GRADIENT = [Color.new(0,0,250,128), Color.new(255,0,0,128), true]
    
  end
end
# *** Don't edit below unless you know what you are doing. ***
#==============================================================================#
# ** Game_System
#==============================================================================#
class Game_System
  
  attr_accessor :menu_list
  
  alias xail_icon_menu_sys_initialize initialize unless $@
  def initialize(*args, &block)
    xail_icon_menu_sys_initialize(*args, &block)
    @menu_list = []
  end
  
end
#==============================================================================#
# ** Game_Interpreter
#==============================================================================#
class Game_Interpreter
  
  def menu_scene(id, type)  
    # // Method to add a item to the list.  
    case type
      when :add # // Add menu id.
      unless $game_system.menu_list.include?(XAIL::ICON_MENU::MENU_LIST[id])
        $game_system.menu_list.push(XAIL::ICON_MENU::MENU_LIST[id])
      end unless XAIL::ICON_MENU::MENU_LIST[id].nil?
      when :del # // Remove menu id.
      unless XAIL::ICON_MENU::MENU_LIST[id].nil?
        $game_system.menu_list.delete(XAIL::ICON_MENU::MENU_LIST[id])
      end 
    end
  end
  
  def menu_active?(id)
    # // Method to check if id is eanbled.
    return if $game_system.menu_list[id].nil?
    return $game_system.menu_list[id][5]
  end
  
  def menu_active(id, enabled)
    # // Method to enable id.
    $game_system.menu_list[id][5] = enabled
  end
  
  def menu_scene_all(type = :add)
    # // Method to add or delete all of the id's to the menu list.
    id = 0
    while id < XAIL::ICON_MENU::MENU_LIST.size
      case type
      when :add
        menu_scene(id, :add)
      else
        menu_scene(id, :del)
      end
      id += 1
    end
  end
  
end
#==============================================================================
# ** Window_MenuCommand
#==============================================================================
class Window_MenuCommand < Window_Command
  
  alias xail_icon_menu_window_width_cmd window_width
  def window_width(*args, &block)
    # // Method to return the width.
    xail_icon_menu_window_width_cmd(*args, &block)
    return 48 if get_menu.size == 1
    return 74 if get_menu.size == 2
    return 32 * get_menu.size
  end
  
  alias xail_icon_menu_window_height_cmd window_height
  def window_height(*args, &block)
    # // Method to return the height.
    xail_icon_menu_window_height_cmd(*args, &block)
    return fitting_height(1)
  end

  alias xail_icon_menu_col_max_cmd col_max
  def col_max(*args, &block)
    # // Method to determine col max.
    xail_icon_menu_col_max_cmd(*args, &block)
    return get_menu.size
  end
  
  alias xail_icon_menu_item_max_cmd item_max
  def item_max(*args, &block)
    xail_icon_menu_item_max_cmd(*args, &block)
    return get_menu.size
  end

  alias xail_icon_menu_spacing_cmd spacing
  def spacing(*args, &block)
    # // Method to determine spacing.
    xail_icon_menu_spacing_cmd(*args, &block)
    return 0
  end
  
  alias xail_icon_menu_contents_width_cmd contents_width
  def contents_width(*args, &block)
    # // Method to determine contents width.
    xail_icon_menu_contents_width_cmd(*args, &block)
    (item_width + spacing) * item_max - spacing
  end
  
  alias xail_icon_menu_contents_height_cmd contents_height
  def contents_height(*args, &block)
    # // Method to determine contents height.
    xail_icon_menu_contents_height_cmd(*args, &block)
    item_height
  end
  
  def get_menu
    # // Method to get the menu list.
    if XAIL::ICON_MENU::MENU_CUSTOM
      return @menu_list = $game_system.menu_list
    else
      return @menu_list = XAIL::ICON_MENU::MENU_LIST
    end
  end
  
  def draw_menu_icon(icon_index, x, y, enabled = true)
    # // Method to draw icon.
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    contents.blt(x, y, bitmap, rect, enabled ? 255 : 20)
  end
  
  def draw_item(index)
    # // Method override to draw the command item.
    x = (get_menu.size < 5) ? 0 : 2    
    for i in get_menu
      icon = i[4] unless i[4].nil?
      draw_menu_icon(icon, x, 0, i[5])
      x += item_width
    end
  end
  
  def make_command_list
    # // Method override to add the commands.
    for i in get_menu
      case i[2]
      when :save
        add_command(i[0], i[2], save_enabled, i[6])
      else
        add_command(i[0], i[2], i[5], i[6])
      end
    end
  end

end
#==============================================================================#
# ** Window_Gold
#==============================================================================#
class Window_Gold < Window_Base
  
  def window_width
    # // Method to return the window width.
    return 220
  end
  
  def refresh
    contents.clear
    # // Refresh method override, draw a icon and the value.
    if $imported["XAIL-HERO-CONTROL"]
      draw_icon(XAIL::ICON_MENU::GOLD[4], -(text_size($game_party.gold).width - 80), -2) 
      draw_currency_value(value, "/", -60, 0, contents.width - 8)
      draw_currency_value($game_party.max_gold, currency_unit,8, 0, contents.width - 8)
    else
      draw_icon(XAIL::ICON_MENU::GOLD[4], 116, -2) 
      draw_currency_value(value, currency_unit, -10, 0, contents.width - 8)
    end
  end
  
end
#==============================================================================#
# ** Window_Weight
#==============================================================================#
class Window_Weight < Window_Base
  
  def initialize
    # // Method to initialize.
    super(0, 0, window_width, fitting_height(1))
    refresh
  end

  def window_width
    # // Method to return the width.
    return 160
  end

  def refresh
    # // Method to refresh.
    contents.clear
    draw_weight
  end
  
  def draw_weight
    # // Method to draw the weight.
    weight = $game_party.weight
    max_weight = $game_party.max_weight
    value = "#{weight} / #{max_weight}"
    contents.font.name = XAIL::ICON_MENU::MENU_FONT[0]
    contents.font.size = XAIL::ICON_MENU::MENU_FONT[1]
    contents.font.color = XAIL::ICON_MENU::MENU_FONT[2]
    contents.font.bold = XAIL::ICON_MENU::MENU_FONT[3]
    contents.font.shadow = XAIL::ICON_MENU::MENU_FONT[4]
    unless XAIL::ICON_MENU::WEIGHT[4].nil?
      draw_icon(XAIL::ICON_MENU::WEIGHT[4], 116, 0) 
      draw_text(-44, -2, window_width, fitting_height(0), value, 2)
    else
      draw_text(-24, -2, window_width, fitting_height(0), value, 2)
    end
    reset_font_settings
  end
  
end
#==============================================================================#
# ** Window_Help
#==============================================================================#
class Window_Icon_Help < Window_Help
  
  attr_accessor :index
  
  alias xail_icon_menu_winhelp_init initialize
  def initialize(*args, &block)
    xail_icon_menu_winhelp_init(*args, &block)
    @menu_list = get_menu
    @index = nil
  end
  
  def get_menu
    # // Method to get the menu list.
    if XAIL::ICON_MENU::MENU_CUSTOM
      @menu_list = $game_system.menu_list
    else
      @menu_list = XAIL::ICON_MENU::MENU_LIST
    end
  end
  
  alias xail_icon_menu_winhelp_set_text set_text
  def set_text(text, enabled)
    # // Method to set a new the tp text to the window.
    xail_icon_menu_winhelp_set_text(text)
    if text != @text
      menu_color(XAIL::ICON_MENU::MENU_FONT[2], enabled)
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
    contents.font.name = XAIL::ICON_MENU::MENU_FONT[0]
    contents.font.size = XAIL::ICON_MENU::MENU_FONT[1]
    menu_color(XAIL::ICON_MENU::MENU_FONT[2], menu_enabled?(@index))
    contents.font.bold = XAIL::ICON_MENU::MENU_FONT[3]
    contents.font.shadow = XAIL::ICON_MENU::MENU_FONT[4]
    # // Draw title and description for the menu.
    draw_help_ex(0, 0, @text)
    reset_font_settings
  end
  
  def draw_help_ex(x, y, text)
    # // Special method to draw a text.
    text = convert_escape_characters(text)
    pos = {:x => x, :y => y, :new_x => x, :height => calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end
  
  def menu_enabled?(index)
    # // Method to check if menu item is enabled.
    return get_menu[index][5]
  end
  
  def menu_color(color, enabled = true)
     # // Method to set the color and alpha if not enabled.
    contents.font.color.set(color)
    contents.font.color.alpha = 150 unless enabled
  end
  
end
#==============================================================================#
# ** Scene_MenuBase
#------------------------------------------------------------------------------
#  New Scene :: Scene_MenuBase
#==============================================================================#
class Scene_MenuBase < Scene_Base
  
  alias xail_icon_menubase_start start
  def start(*args, &block)
    # // Method to start the scene
    xail_icon_menubase_start(*args, &block)
    @menu_list = get_menu
  end

  alias xail_icon_menubase_post_start post_start
  def post_start(*args, &block)
    # // Method to post_start the scene.
    xail_icon_menubase_post_start(*args, &block)
    perform_transition unless @menu_list.empty?
  end
  
  def get_menu
    # // Method to get the menu list.
    if XAIL::ICON_MENU::MENU_CUSTOM
      return @menu_list = $game_system.menu_list
    else
      return @menu_list = XAIL::ICON_MENU::MENU_LIST
    end
  end
  
  alias xail_icon_menubase_terminate terminate
  def terminate(*args, &block)
    # // Method to terminate the scene.
    xail_icon_menubase_terminate(*args, &block)
    dispose_help
  end
  
  def dispose_help
    # // Dispose help window.
    @help_window.dispose unless @help_window.nil?
    @help_window = nil
  end
  
  def create_background
    # // Method to create custom background.
    @background_sprite = Sprite.new
    if XAIL::ICON_MENU::BACK.nil?
      @background_sprite.bitmap = SceneManager.background_bitmap
      if XAIL::ICON_MENU::BACK_TYPE[2]
        source = SceneManager.background_bitmap
        bitmap = Bitmap.new(Graphics.width, Graphics.height)
        bitmap.stretch_blt(bitmap.rect, source, source.rect) unless SceneManager.scene_is?(Scene_Load)
        case XAIL::ICON_MENU::BACK_TYPE[0]
        when 0 ; bitmap.blur # // Default
        when 1 ; bitmap.radial_blur(XAIL::ICON_MENU::BACK_RADIAL_BLUR[0], XAIL::ICON_MENU::BACK_RADIAL_BLUR[0])
        when 2 ; bitmap.hue_change(XAIL::ICON_MENU::BACK_HUE)
        when 3 ; bitmap.fill_rect(bitmap.rect, XAIL::ICON_MENU::BACK_COLOR)
        when 4 ; bitmap.gradient_fill_rect(bitmap.rect, XAIL::ICON_MENU::BACK_GRADIENT[0],
                 XAIL::MENU::BACK_GRADIENT[1], XAIL::ICON_MENU::BACK_GRADIENT[2])
        end
        @background_sprite.opacity = XAIL::ICON_MENU::BACK_TYPE[1]
        @background_sprite.bitmap = bitmap
      end
    else
      @background_sprite.bitmap = Cache.system(XAIL::ICON_MENU::BACK)
    end
  end
  
  alias xail_icon_menubase_transition perform_transition
  def perform_transition(*args, &block)
    # // Method to create the transition.
    if XAIL::ICON_MENU::TRANSITION.nil?
      xail_icon_menubase_transition(*args, &block)
    else
      Graphics.transition(XAIL::ICON_MENU::TRANSITION[0],XAIL::ICON_MENU::TRANSITION[1],XAIL::ICON_MENU::TRANSITION[2])
    end
  end

end
#==============================================================================#
# ** Scene_Menu
#------------------------------------------------------------------------------
#  New Scene :: Scene_Menu
#==============================================================================#
class Scene_Menu < Scene_MenuBase
  
  def start
    super
    # // Method to start the scene.
    @menu_list = get_menu
    return command_map if @menu_list.empty?
    @anim_timer = XAIL::ICON_MENU::ANIMATE_TIMER
    create_menu_command_window
    if XAIL::ICON_MENU::HELP[4]
      create_menu_help_window
      help_update(@command_window.index)
    end
    create_menu_gold_window if XAIL::ICON_MENU::GOLD[5]
    create_menu_weight_window if XAIL::ICON_MENU::WEIGHT[5] and $imported["XAIL-INVENTORY-WEIGHT"]
  end
  
  def create_menu_command_window
    # // Method to create the command window.
    @command_window = Window_MenuCommand.new
    @command_window.windowskin = Cache.system(XAIL::ICON_MENU::MENU_SKIN) unless XAIL::ICON_MENU::MENU_SKIN.nil?
    if XAIL::ICON_MENU::MENU_CENTER
      @command_window.x = (Graphics.width - @command_window.width) / 2
      @command_window.y = (Graphics.height - @command_window.height) / 2
    else
      @command_window.x = XAIL::ICON_MENU::MENU_WINDOW[0]
      @command_window.y = XAIL::ICON_MENU::MENU_WINDOW[1]
    end
    @command_window.z = XAIL::ICON_MENU::MENU_WINDOW[2]
    @command_window.opacity = XAIL::ICON_MENU::MENU_WINDOW[3]
    for i in @menu_list
      @command_window.set_handler(i[2], method(i[3]))
    end
    @command_window.set_handler(:cancel, method(:return_scene))
  end
  
  def create_menu_help_window
    # // Create the help window.
    @help_window = Window_Icon_Help.new(2)
    @help_window.viewport = @viewport
    @help_window.windowskin = Cache.system(XAIL::ICON_MENU::MENU_SKIN) unless XAIL::ICON_MENU::MENU_SKIN.nil?
    @help_window.index = @command_window.index
    @help_window.x = XAIL::ICON_MENU::HELP[0]
    @help_window.y = XAIL::ICON_MENU::HELP[1]
    @help_window.z = XAIL::ICON_MENU::HELP[2]
    @help_window.opacity = XAIL::ICON_MENU::HELP[3]
    @help_window.contents_opacity = 255
  end
  
  def create_menu_message_window
    # // Method to create the message window.
    @message_window = Window_Message.new
  end
  
  def create_menu_gold_window
    # // Method to create the gold window.
    @gold_window = Window_Gold.new
    @gold_window.windowskin = Cache.system(XAIL::ICON_MENU::MENU_SKIN) unless XAIL::ICON_MENU::MENU_SKIN.nil?
    @gold_window.x = XAIL::ICON_MENU::GOLD[0]
    @gold_window.y = XAIL::ICON_MENU::GOLD[1]
    @gold_window.z = XAIL::ICON_MENU::GOLD[2]
    @gold_window.opacity = XAIL::ICON_MENU::GOLD[3]
  end
  
  def create_menu_weight_window
    # // Method to create the weight window.
    @weight_window = Window_Weight.new
    @weight_window.windowskin = Cache.system(XAIL::ICON_MENU::MENU_SKIN) unless XAIL::ICON_MENU::MENU_SKIN.nil?
    @weight_window.x = XAIL::ICON_MENU::WEIGHT[0]
    @weight_window.y = XAIL::ICON_MENU::WEIGHT[1]
    @weight_window.z = XAIL::ICON_MENU::WEIGHT[2]
    @weight_window.opacity = XAIL::ICON_MENU::WEIGHT[3]
  end
    
  def get_menu
    # // Method to get the menu list.
    if XAIL::ICON_MENU::MENU_CUSTOM
      return @menu_list = $game_system.menu_list
    else
      return @menu_list = XAIL::ICON_MENU::MENU_LIST
    end
  end
  
  alias xail_upd_icon_menu_index_change update
  def update(*args, &block)
    # // Method for updating the scene.
    xail_upd_icon_menu_index_change(*args, &block)
    if XAIL::ICON_MENU::HELP[4]
      old_index = @help_window.index
      if old_index != @command_window.index
        # // Animate the help window.
        help_animate
        # // Update help window.
        help_update(@command_window.index)
        # // Reset animate for the help window.
        help_animate_reset
      end
    end
  end
  
  def help_animate
    # // Method to animate help window.   
    for i in 1..@anim_timer
      break if scene_changing?
      update_basic
      @help_window.contents_opacity = 255 - i * (255 / @anim_timer * 2)
    end
  end
  
  def help_animate_reset
    # // Method to reset animation.   
    for i in 1..@anim_timer
      break if scene_changing?
      update_basic
      @help_window.contents_opacity = i * (255 / @anim_timer * 2)
    end
  end
  
  def help_update(index)
    # // If index changes update help window text.   
    icon = get_menu[index][4]
    title = '\i[' + icon.to_s + ']' + " " + get_menu[index][0]
    desc = '\c[0]' + get_menu[index][1]
    text = "#{title}\n#{desc}"
    enabled = get_menu[index][5]
    @help_window.index = index
    @help_window.set_text(text, enabled)
  end
  
  def command_status
    # // command_status (Don't remove)
    SceneManager.call(Scene_Status)
  end
  
  def command_skill
    # // command_skill (Don't remove)
    SceneManager.call(Scene_Skill)
  end
  
  def command_equip
    # // command_equip (Don't remove)
    SceneManager.call(Scene_Equip)
  end
  
  def command_custom
    # // Method to call a custom command.
    SceneManager.call(@command_window.current_ext)
  end
  
  def command_map
    # // command_map (Don't remove)
    create_menu_message_window
    $game_message.texts << XAIL::ICON_MENU::MENU_EMPTY
    SceneManager.call(Scene_Map)
  end
  
end # END OF FILE

#=*==========================================================================*=#
# ** END OF FILE
#=*==========================================================================*=#
