# Source: http://niclas-thornqvist.se/rpg/scripts/ace/xs-core.txt
#==============================================================================
#   XaiL System - Core
#   Author: Nicke
#   Created: 07/01/2012
#   Edited: 08/10/2013
#   Version: 2.1f
#==============================================================================
# Instructions
# -----------------------------------------------------------------------------
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ? Materials but above ? Main. Remember to save.
#
# Core script for XaiL System.
# Caution! This needs to be located before any other XS scripts.
#
# *** Only for RPG Maker VX Ace. ***
#==============================================================================
($imported ||= {})["XAIL-XS-CORE"] = true

module Colors
  #--------------------------------------------------------------------------#
  # * Colors
  #--------------------------------------------------------------------------#
  White = Color.new(255,255,255)
  LightRed = Color.new(255,150,150)
  LightGreen = Color.new(150,255,150)
  LightBlue = Color.new(150,150,255)
  DarkYellow = Color.new(225,225,20)
  Alpha = Color.new(0,0,0,128)
  AlphaMenu = 100
end
module XAIL
  module CORE
  #--------------------------------------------------------------------------#
  # * Settings
  #--------------------------------------------------------------------------#
  # Graphics.resize_screen(width, height ) 
  Graphics.resize_screen(544,416) 
  
  # FONT DEFAULTS:
  Font.default_name = ["VL Gothic"]
  Font.default_size = 20
  Font.default_bold = false
  Font.default_italic = false
  Font.default_shadow = true
  Font.default_outline = true
  Font.default_color = Colors::White
  Font.default_out_color = Colors::Alpha
  
  # USE_TONE = true/false:
  # Window tone for all windows ingame. Default: true.
  USE_TONE = false
  
  # SAVE
  SAVE_MAX = 20       # Default 16.
  SAVE_FILE_VIS = 4   # Default 4.
  
  # JAPANESE = true/false
  JAPANESE = false
  
  end
end
# *** Don't edit below unless you know what you are doing. ***
#==============================================================================#
# ** Game_System
#==============================================================================#
class Game_System
  
  # // Method to determine japanese game.
  def japanese? ; return XAIL::CORE::JAPANESE ; end
  
end
#==============================================================================#
# ** String
#==============================================================================#
class String
  
  def to_class(parent = Kernel)
    # // Method to convert string to class.
    chain = self.split "::"
    klass = parent.const_get chain.shift
    return chain.size < 1 ? (klass.is_a?(Class) ? klass : nil) : chain.join("::").to_class(klass)
    rescue
    nil
  end
  
  def cap_words
    # // Method to capitalize every word.
    self.split(' ').map {|w| w.capitalize }.join(' ')
  end
  
  def slice_char(char)
    # // Method to slice char.
    self.split(char).map {|w| w.sub(char, " ") }.join(" ")
  end

end
#==============================================================================#
# ** Vocab
#==============================================================================#
class << Vocab
  
  def xparam(id)
    # // Method to return xparam name.
    case id
    when 0 ; "Hit Chance"
    when 1 ; "Evasion"
    when 2 ; "Critical Chance"
    when 3 ; "Critical Evasion"
    when 4 ; "Magic Evasion"
    when 5 ; "Magic Reflection"
    when 6 ; "Counter Attack"
    when 7 ; "HP Regeneration"
    when 8 ; "MP Regeneration"
    when 9 ; "TP Regeneration"
    end
  end
  
end
#==============================================================================
# ** Sound
#==============================================================================
class << Sound
  
  def play(name, volume, pitch, type = :se)
    # // Method to play a sound. If specified name isn't valid throw an error.
    case type
    when :se   ; RPG::SE.new(name, volume, pitch).play rescue valid?(name)
    when :me   ; RPG::ME.new(name, volume, pitch).play rescue valid?(name)
    when :bgm  ; RPG::BGM.new(name, volume, pitch).play rescue valid?(name)
    when :bgs  ; RPG::BGS.new(name, volume, pitch).play rescue valid?(name)
    end
  end
  
  def valid?(name)
    # // Method to raise error if specified sound name is invalid.
    msgbox("Error. Unable to find sound file: " + name)
    exit 
  end
  
end
#==============================================================================
# ** DataManager
#==============================================================================
class << DataManager

  def savefile_max
    # // Method override, save file max.
    return XAIL::CORE::SAVE_MAX
  end
  
end
#==============================================================================
# ** SceneManager
#==============================================================================
class << SceneManager
  
  def call_ext(scene_class, args = nil)
    # // Method to call a scene with arguments.
    @stack.push(@scene)
    @scene = scene_class.new(args)
  end
  
end
#==============================================================================
# ** Scene_File
#==============================================================================
class Scene_File < Scene_MenuBase
  
  def visible_max
    # // Method override, visible_max for save files.
    return XAIL::CORE::SAVE_FILE_VIS
  end
  
end
#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
# Importing font fix that will remove weird characters.
# Adding new methods such as new gauge, actor param, font text, icon drawing,
# big icon drawing and a line with a shadow.
#==============================================================================
class Window_Base < Window
  
  # // Importing Custom font fix. (Credit Lone Wolf).
  alias :process_normal_character_vxa :process_normal_character
  def process_normal_character(c, pos)
    return unless c >= ' '
    process_normal_character_vxa(c, pos)
  end unless method_defined? :process_normal_character
  
  def draw_text_ex_no_reset(x, y, text)
    # // Method to draw ex text without resetting the font.
    text = convert_escape_characters(text)
    pos = {:x => x, :y => y, :new_x => x, :height => calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end 
  
  alias xail_core_winbase_upt_tone update_tone
  def update_tone(*args, &block)
    # // Method to change tone of the window.
    return unless XAIL::CORE::USE_TONE
    xail_core_winbase_upt_tone(*args, &block)
  end
  
  def draw_gauge_ex(x, y, width, height, rate, color1, color2)
    # // Method to draw a gauge.
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8
    contents.fill_rect(x, gauge_y, width + 1, height + 1, Color.new(255,255,255,64))
    contents.fill_rect(x, gauge_y, width, height, Color.new(0,0,0,100))
    contents.gradient_fill_rect(x, gauge_y, fill_w, height, color1, color2)
  end
  
  def draw_actor_param_gauge(actor, x, y, width, param_id, font, size, bar_color1, bar_color2, txt_color1, txt_color2)
    # // Method to draw actor parameters with a gauge.
    case param_id
    when 2 ; param_rate = actor.param(2) / actor.param_max(2).to_f
    when 3 ; param_rate = actor.param(3) / actor.param_max(3).to_f
    when 4 ; param_rate = actor.param(4) / actor.param_max(4).to_f
    when 5 ; param_rate = actor.param(5) / actor.param_max(5).to_f
    when 6 ; param_rate = actor.param(6) / actor.param_max(6).to_f
    when 7 ; param_rate = actor.param(7) / actor.param_max(7).to_f
    end
    contents.font.name = font
    contents.font.size = size
    contents.font.bold = true
    contents.font.shadow = false
    draw_gauge_ex(x, y - 14, width, 20, param_rate, bar_color1, bar_color2)
    contents.font.color = txt_color1
    draw_text(x + 10, y, 120, line_height, Vocab::param(param_id))
    contents.font.color = txt_color2
    draw_text(x + width - 38, y, 36, line_height, actor.param(param_id), 2)
    reset_font_settings
  end
  
  def draw_actor_xparam_gauge(actor, x, y, width, xparam_id, font, size, bar_color1, bar_color2, txt_color1, txt_color2)
    # // Method to draw actor xparameters with a gauge.
    case xparam_id
    when 0
      xparam_rate = actor.xparam(0) / 100.to_f
      xparam_name = Vocab.xparam(0)
    when 1
      xparam_rate = actor.xparam(1) / 100.to_f
      xparam_name = Vocab.xparam(1)
    when 2
      xparam_rate = actor.xparam(2) / 100.to_f
      xparam_name = Vocab.xparam(2)
    when 3
      xparam_rate = actor.xparam(3) / 100.to_f
      xparam_name = Vocab.xparam(3)
    when 4
      xparam_rate = actor.xparam(4) / 100.to_f
      xparam_name = Vocab.xparam(4)
    when 5
      xparam_rate = actor.xparam(5) / 100.to_f
      xparam_name = Vocab.xparam(5)
    when 6
      xparam_rate = actor.xparam(6) / 100.to_f
      xparam_name = Vocab.xparam(6)
    when 7
      xparam_rate = actor.xparam(7) / 100.to_f
      xparam_name = Vocab.xparam(7)
    when 8
      xparam_rate = actor.xparam(8) / 100.to_f
      xparam_name = Vocab.xparam(8)
    when 9
      xparam_rate = actor.xparam(9) / 100.to_f
      xparam_name = Vocab.xparam(9)
    end
    contents.font.name = font
    contents.font.size = size
    contents.font.bold = true
    contents.font.shadow = false
    draw_gauge_ex(x, y - 14, width, 20, xparam_rate, bar_color1, bar_color2)
    contents.font.color = txt_color1
    draw_text(x + 10, y, 120, line_height, xparam_name)
    contents.font.color = txt_color2
    draw_text(x + width - 38, y, 36, line_height, "#{actor.xparam(xparam_id)}%", 2)
    reset_font_settings 
  end
  
  def draw_line_ex(x, y, color, shadow)
    # // Method to draw a horizontal line with a shadow.
    line_y = y + line_height / 2 - 1
    contents.fill_rect(x, line_y, contents_width, 2, color)
    line_y += 1
    contents.fill_rect(x, line_y, contents_width, 2, shadow)
  end
  
  def draw_box(x, y, width, height, color, shadow)
    # // Method to draw a box with shadow.
    contents.fill_rect(x, y, width, height, color)
    x += 1
    y += 1
    contents.fill_rect(x, y, width, height, shadow)
  end
  
  def draw_vertical_line_ex(x, y, color, shadow)
    # // Method to draw a vertical line with a shadow.
    line_x = x + line_height / 2 - 1
    contents.fill_rect(line_x, y, 2, contents_height, color)
    line_x += 1
    contents.fill_rect(line_x, y, 2, contents_height, shadow)
  end
  
  def draw_icons(icons, alignment, x = 0, y = 0, offset_icon = [])
    # // Method to draw icons in a horizonal or vertical alignment.
    icons.each {|icon| 
      next if icon.nil?
      # // If included in offset do extra spacing.
      offset_icon.each {|offset|
        if icon == offset
          y += line_height * 1 if alignment == :vertical
          x += line_height * 1 if alignment == :horizontal
        end
      }
      draw_icon(icon.nil? ? nil : icon, x.nil? ? 0 : x, y.nil? ? 0 : y) rescue nil
      y += line_height if alignment == :vertical
      x += line_height if alignment == :horizontal
    }
  end
  
  def draw_big_icon(icon, x, y, width, height, opacity = 255)
    # // Method to draw a big icon.
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon % 16 * 24, icon / 16 * 24, 24, 24)
    rect2 = Rect.new(x, y, width, height)
    contents.stretch_blt(rect2, bitmap, rect, opacity)
  end
  
  def draw_font_text(text, x, y, width, alignment, font, size, color, bold = true, shadow = true)
    # // Method to draw font text.
    contents.font.name = font
    contents.font.size = size
    contents.font.color = color
    contents.font.bold = bold
    contents.font.shadow = shadow
    contents.font.out_color = Color.new(0,0,0,255)
    draw_text(x, y, width, calc_line_height(text), text, alignment)
    reset_font_settings
  end
  
  def draw_font_text_ex(text, x, y, font, size, color, bold = true, shadow = true)
    # // Method to draw font text ex.
    contents.font.name = font
    contents.font.size = size
    contents.font.color = color
    contents.font.bold = bold
    contents.font.shadow = shadow
    contents.font.out_color = Color.new(0,0,0,255)
    text = convert_escape_characters(text)
    pos = {:x => x, :y => y, :new_x => x, :height => calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
    reset_font_settings
  end
  
end
#==============================================================================#
# ** Window_Selectable
#------------------------------------------------------------------------------
#  Adding support for pageleft and pageright for window selectable.
#==============================================================================#
class Window_Selectable < Window_Base
  
  def cursor_pageright ; end
  def cursor_pageleft ; end

  alias xail_core_winselect_process_cursor_move process_cursor_move
  def process_cursor_move(*args, &block)
    # // Method to process cursor movement.
    xail_core_winselect_process_cursor_move(*args, &block)
    cursor_pageright if !handle?(:pageright) && Input.trigger?(:RIGHT)
    cursor_pageright if !handle?(:pageleft) && Input.trigger?(:LEFT)
  end
  
  alias xail_core_winselect_process_handling process_handling
  def process_handling(*args, &block)
    # // Method to process handling.
    xail_core_winselect_process_handling(*args, &block)
    return process_pageright if handle?(:pageright) && Input.trigger?(:RIGHT)
    return process_pageleft if handle?(:pageleft) && Input.trigger?(:LEFT)
  end
    
  def process_pageright
    # // Method to process page right.
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:pageright)
  end
  
  def process_pageleft
    # // Method to process page left.
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:pageleft)
  end
  
end
#==============================================================================#
# ** Window_Icon
#------------------------------------------------------------------------------
#  New Window :: Window_Icon - A window for drawing icon(s).
#==============================================================================#
class Window_Icon < Window_Base
  
  attr_accessor :enabled
  attr_accessor :alignment
  
  def initialize(x, y, window_width, hsize)
    # // Method to initialize the icon window.
    super(0, 0, window_width, window_height(hsize))
    @icons = []
    @index = 0
    @enabled = true
    @alignment = 0
    refresh
  end
  
  def window_height(hsize)
    # // Method to return the height.
    fitting_height(hsize)
  end
  
  def refresh
    # // Method to refresh the icon window.
    contents.clear
  end
  
  def draw_cmd_icons(icons, index)
    # // Draw all of the icons.
    return if !@enabled
    count = 0
    for i in icons
      align = 0
      x = 110
      next if i[index].nil?
      case @alignment
      when 1, 2 ; align = -110
      end
      draw_icon(i[index], x + align, 24 * count)
      count += 1
      break if (24 * count > height - 24)
    end
  end
  
end
#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
# Adding check item method to return a item based on the type.
#==============================================================================
class Game_Party < Game_Unit
  
  def check_item?(item, type)
    # // Method to return a item based on the type.
    case type
    when :items    ; $data_items[item]
    when :weapons  ; $data_weapons[item]
    when :armors   ; $data_armors[item]
    when :gold     ; item
    when :exp      ; item
    end
  end

end 
#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
# Adding methods to check for comments on events.
#==============================================================================
class Game_Event < Game_Character
  
  def comment?(comment)
    # // Method to check if comment is included in event.
    unless empty? or @list.nil?
      for evt in @list
        if evt.code == 108 or evt.code == 408
          if evt.parameters[0].include?(comment)
            return true
          end
        end
      end
    end
    return false
  end
  
  def comment_int?(comment)
    # // Method to check for a integer in event.
    unless empty? or @list.nil?
      for evt in @list
        if evt.code == 108 or evt.code == 408
          if evt.parameters[0] =~ /<#{comment}:[ ]?(\d*)>?/
            return ($1.to_i > 0 ? $1.to_i : 0)
          end
        end
      end
    end
  end
  
  def comment_string?(comment)
    # // Method to check for a string in event.
    unless empty? or @list.nil?
      for evt in @list
        if evt.code == 108 or evt.code == 408
          if evt.parameters[0] =~ /<#{comment}:[ ]?(\w*)>?/
            return $1.to_s
          end
        end
      end
    end
  end


end # END OF FILE

#=*==========================================================================*=#
# ** END OF FILE
#=*==========================================================================*=#
