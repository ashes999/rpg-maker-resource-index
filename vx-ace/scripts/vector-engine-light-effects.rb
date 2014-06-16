# Source: http://forums.rpgmakerweb.com/index.php?/topic/450-ve-light-effects/
#==============================================================================
# ** Victor Engine - Light Effects
#------------------------------------------------------------------------------
# Author : Victor Sant
#
# Version History:
#  v 1.00 - 2011.12.21 > First relase
#  v 1.01 - 2011.12.23 > Compatibility with Diagonal Movement
#  v 1.02 - 2011.12.24 > Better checks for images bigger than screen
#  v 1.03 - 2011.12.27 > Fixed bug when teleporting to same map
#  v 1.04 - 2011.12.30 > Faster Regular Expressions
#  v 1.05 - 2012.01.04 > Fixed lantern direction bug
#                      > Fixed load fail when lights ON
#  v 1.06 - 2012.01.07 > Fixed light opacity change not updating
#  v 1.07 - 2012.01.13 > Fixed update delay when exiting the menu
#  v 1.08 - 2012.01.15 > Fixed the positive sign on some Regular Expressions
#                      > Fixed the Regular Expressions problem with "" and “”
#------------------------------------------------------------------------------
#  This scripts allow to add varied light effects to the maps. But it works
# different from other scripts with this function.
# Normally, light effect scripts add images above the events, and then the
# screen is tone is changed, with the images staying bellow the darker layer.
# This script add an new darkened layer, and apply the light effect images
# on this layer.
#
#------------------------------------------------------------------------------
# Compatibility
#   Requires the script 'Victor Engine - Basic Module' v 1.09 or higher
# 
# * Alias methods (Default)
#   class Game_Map
#     def setup(map_id)
#
#  class Game_CharacterBase
#     def init_public_members
#     def update
#
#   class Game_Event < Game_Character
#     def clear_starting_flag
#
#   class Spriteset_Map
#     def initialize
#     def update
#     def dispose
#
#   class Scene_Map
#     def pre_transfer
#
# * Alias methods (Basic Module)
#   class Game_Interpreter
#     def comment_call
#
#------------------------------------------------------------------------------
# Instructions:
#  To instal the script, open you script editor and paste this script on
#  a new section on bellow the Materials section. This script must also
#  be bellow the script 'Victor Engine - Basic'
#  The lights must be placed on the folder "Graphics/Lights". Create a folder
#  named "Lights" on the Graphics folder.
#
#------------------------------------------------------------------------------
# Comment calls note tags:
#  Tags to be used in events comment box, works like a script call.
#
#  <create shade>
#  setting
#  </create shade>
#   Create a shade effect on the map, add the following values to the setting.
#     opacity: x : opacity (0-255)
#     red: x     : red tone   (0-255, can be negative)
#     green: x   : green tone (0-255, can be negative)
#     blue: x    : blue tone  (0-255, can be negative)
#     blend: x   : fog blend type (0: normal, 1: add, 2: subtract)
#
#  <actor light>      <event light>      <vehicle light>
#  setting            setting            setting
#  </actor light>     </event light>     </vehicle ligth>
#   Create a light effect on actor, event or vehicle, add the following 
#   values to the info. The ID, index and name must be added, other values
#   are optional.
#     id: x      : ligh effect ID
#     name: "x"  : ligh effect graphic filename ("filename")
#     index: x   : actor index, event id or (0: boat, 1: ship, 2: airship)
#     opacity: x : light opacity (0-255)
#     pos x: x   : coordinate X adjust
#     pos y: x   : coordinate Y adjust
#     var: x     : light opacity variation
#     speed: x   : light variation speed
#     zoom: x    : ligh effect zoom (100 = default size)
#
#  <map light>
#  setting
#  </map light>
#   Create a light effect on a specific map postion, add the following 
#   values to the info. The ID, map_x, map_y and name must be added, other
#   values are optional.
#     id: x      : ligh effect ID
#     name: "x"  : ligh effect graphic filename ("filename")
#     map x: x   : map X coordinate
#     map y: x   : map Y coordinate
#     opacity: x : light opacity (0-255)
#     pos x: x   : coordinate X adjust
#     pos y: x   : coordinate Y adjust
#     var: x     : light opacity variation
#     speed: x   : light variation speed
#     zoom: x    : ligh effect zoom (100 = default size)
#   
#  <actor lantern i: o>
#  <event lantern i: o>
#  <vehicle lantern i: o>
#   Call a lantern on the target character, lanterns are effets that
#   lights the front of the character
#     i : actor index, event id or (0: boat, 1: ship, 2: airship)
#     o : light opacity (0-255)
#
#  <light opacity id: o, d>
#   This tag allows to change the light opacity gradually
#     i : light effect ID
#     o : new opacity (0-255)
#     d : wait until complete change (60 frames = 1 second)
#
#  <shade opacity: o, d>
#   This tag allows to change the shade opacity gradually
#     o : new opacity (0-255)
#     d : wait until complete change (60 frames = 1 second)
#
#  <shade tone: r, g, b, d>
#   This tag allows to change the shade opacity gradually
#     r : red tone   (0-255, can be negative)
#     g : green tone (0-255, can be negative)
#     b : blue tone  (0-255, can be negative)
#     d : wait until complete change (60 frames = 1 second)
#
#  <remove_light: id>
#   This tag allows remove a light effect
#     id: ligh effect ID
#
#------------------------------------------------------------------------------
# Maps note tags:
#   Tags to be used on the Maps note box in the database
#
#  <create shade>
#  setting
#  </create shade>
#   Create a shade effect on the map, add the following values to the setting.
#    opacity: x : opacity (0-255)
#    red: x     : red tone   (0-255, can be negative)
#    green: x   : green tone (0-255, can be negative)
#    blue: x    : blue tone  (0-255, can be negative)
#    blend: x   : fog blend type (0: normal, 1: add, 2: subtract)
#
#  <actor light>      <event light>      <vehicle light>
#  setting            setting            setting
#  </actor light>     </event light>     </vehicle ligth>
#   Create a light effect on actor, event or vehicle, add the following 
#   values to the info. The ID, index and name must be added, other values
#   are optional.
#     id: x      : ligh effect ID
#     name: "x"  : ligh effect graphic filename ("filename")
#     index: x   : actor index, event id or (0: boat, 1: ship, 2: airship)
#     opacity: x : light opacity (0-255)
#     pos x: x   : coordinate X adjust
#     pos y: x   : coordinate Y adjust
#     var: x     : light opacity variation
#     speed: x   : light variation speed
#     zoom: x    : ligh effect zoom (100 = default size)
#
#  <map light>
#  setting
#  </map light>
#   Create a light effect on a specific map postion, add the following 
#   values to the info. The ID, map_x, map_y and name must be added, other
#   values are optional.
#     id: x      : ligh effect ID
#     name: "x"  : ligh effect graphic filename ("filename")
#     map x: x   : map X coordinate
#     map y: x   : map Y coordinate
#     opacity: x : light opacity (0-255)
#     pos x: x   : coordinate X adjust
#     pos y: x   : coordinate Y adjust
#     var: x     : light opacity variation
#     speed: x   : light variation speed
#     zoom: x    : ligh effect zoom (100 = default size)
#
#  <actor lantern i: o>
#  <event lantern i: o>
#  <vehicle lantern i: o>
#   Call a lantern on the target character, lanterns are effets that
#   lights the front of the character
#     i : actor index, event id or (0: boat, 1: ship, 2: airship)
#     o : light opacity (0-255)
#
#------------------------------------------------------------------------------
# Comment boxes note tags:
#   Tags to be used on events Comment boxes. They're different from the
#   comment call, they're called always the even refresh.
#
#  <custom light>
#  settings
#  </custom light>
#   Create a custom light effect on actor, event or vehicle, add the following 
#   values to the settings. The name must be added, other values
#   are optional.
#     name: "x"  : ligh effect graphic filename ("filename")
#     opacity: x : light opacity (0-255)
#     pos x: x   : coordinate X adjust
#     pos y: x   : coordinate Y adjust
#     var: x     : light opacity variation
#     speed: x   : light variation speed
#     zoom: x    : ligh effect zoom (100 = default size)
#
#  <simple light: o>
#  <simple lamp: o>
#  <simple torch: o>
#  <simple window 1: o>
#  <simple window 2: o>
#   Simple light shortcuts
#     o : new opacity (0-255)
#
#  <flash light: o>
#  <flash lamp: o>
#  <flash torch: o>
#  <flash window 1: o>
#  <flash window 2: o>
#   Flashing light shortcuts
#     o : new opacity (0-255)
#
#  <lantern: o>
#   Lanterns shortcut
#     o : new opacity (0-255)
#
#------------------------------------------------------------------------------
# Additional instructions:
#
#  The lights are placed on the shade, so you *must* create a shade in order
#  to display the lights. No shade, no lights.
#
#  The IDs of the light effects are used as identifiers. Don't use the
#  same value for different light spots, if you do so, one light will
#  replace the other. Also the IDs are used as referece to when
#  removing lights and changing light opacity.
#
#==============================================================================

#==============================================================================
# ** Victor Engine
#------------------------------------------------------------------------------
#   Setting module for the Victor Engine
#==============================================================================

module Victor_Engine
  #--------------------------------------------------------------------------
  # * required
  #   This method checks for the existance of the basic module and other
  #   VE scripts required for this script to work, don't edit this
  #--------------------------------------------------------------------------
  def self.required(name, req, version, type = nil)
    if !$imported[:ve_basic_module]
      msg = "The script '%s' requires the script\n"
      msg += "'VE - Basic Module' v%s or higher above it to work properly\n"
      msg += "Go to http://victorscripts.wordpress.com/ to download this script."
      msgbox(sprintf(msg, self.script_name(name), version))
      exit
    else
      self.required_script(name, req, version, type)
    end
  end
  #--------------------------------------------------------------------------
  # * script_name
  #   Get the script name base on the imported value, don't edit this
  #--------------------------------------------------------------------------
  def self.script_name(name, ext = "VE")
    name = name.to_s.gsub("_", " ").upcase.split
    name.collect! {|char| char == ext ? "#{char} -" : char.capitalize }
    name.join(" ")
  end
end

$imported ||= {}
$imported[:ve_light_effects] = 1.08
Victor_Engine.required(:ve_light_effects, :ve_basic_module, 1.09, :above)

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
  # * New method: lights
  #--------------------------------------------------------------------------
  def self.lights(filename)
    self.load_bitmap('Graphics/Lights/', filename)
  end
end

#==============================================================================
# ** Game_Screen
#------------------------------------------------------------------------------
#  This class handles screen maintenance data, such as change in color tone,
# flashes, etc. It's used within the Game_Map and Game_Troop classes.
#==============================================================================

class Game_Screen
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :lights
  attr_reader   :shade
  attr_accessor :remove_light
  #--------------------------------------------------------------------------
  # * Alias method: clear
  #--------------------------------------------------------------------------
  alias :clear_ve_light_effects :clear
  def clear
    clear_ve_light_effects
    clear_lights
  end
  #--------------------------------------------------------------------------
  # * New method: clear_lights
  #--------------------------------------------------------------------------
  def clear_lights
    @lights = {}
    @remove_light = []
    @shade = Game_ShadeEffect.new
  end
  #--------------------------------------------------------------------------
  # * New method: lights
  #--------------------------------------------------------------------------
  def lights
    @lights ||= {}
  end
  #--------------------------------------------------------------------------
  # * New method: remove_light
  #--------------------------------------------------------------------------
  def remove_light
    @remove_light ||= []
  end
  #--------------------------------------------------------------------------
  # * New method: shade
  #--------------------------------------------------------------------------
  def shade
    @shade ||= Game_ShadeEffect.new
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
  # * Alias method: setup
  #--------------------------------------------------------------------------
  alias :setup_ve_light_effects :setup
  def setup(map_id)
    setup_ve_light_effects(map_id)
    setup_lights_effect
  end
  #--------------------------------------------------------------------------
  # * New method: setup_lights_effect
  #--------------------------------------------------------------------------
  def setup_lights_effect
    setup_map_shade(note)
    setup_map_lights(:actor, note)
    setup_map_lights(:event, note)
    setup_map_lights(:vehicle, note)
    setup_map_lights(:map, note)
    setup_map_lantern(:actor, note)
    setup_map_lantern(:event, note)
    setup_map_lantern(:vehicle, note)
  end
  #--------------------------------------------------------------------------
  # * New method: setup_map_shade
  #--------------------------------------------------------------------------
  def setup_map_shade(text)
    regexp = /<CREATE SHADE>([^><]*)<\/CREATE SHADE>/im
    if text =~ regexp
      info  = $1.dup
      shade = @screen.shade
      shade.show
      shade.opacity = info =~ /OPACITY: (\d+)/i ? $1.to_i : 192
      shade.blend   = info =~ /BLEND: (\d+)/i   ? $1.to_i : 2
      red   = info =~ /RED: (\d+)/i   ? $1.to_i : 0
      green = info =~ /GREEN: (\d+)/i ? $1.to_i : 0
      blue  = info =~ /BLUE: (\d+)/i  ? $1.to_i : 0
      shade.set_color(red, green, blue)
    end
  end
  #--------------------------------------------------------------------------
  # * New method: setup_map_lights
  #--------------------------------------------------------------------------
  def setup_map_lights(type, text)
    value  = get_regexp_value(type)
    regexp = /<#{value} LIGHT>([^><]*)<\/#{value} LIGHT>/im
    text.scan(regexp) do 
      light = setup_light($1.dup, type)
      @screen.lights[light.id] = light if light.id
    end
  end
  #--------------------------------------------------------------------------
  # * New method: setup_map_lantern
  #--------------------------------------------------------------------------
  def setup_map_lantern(type, text)
    value  = get_regexp_value(type)
    regexp = /<#{value} LANTERN (\d+): (\d+)>/i  
    text.scan(regexp) do |index, opacity|
      target = get_font(type, index.to_i)
      next unless target 
      target.lantern = opacity.to_i
      target.update_lantern
    end
  end
  #--------------------------------------------------------------------------
  # * New method: get_regexp_value
  #--------------------------------------------------------------------------
  def get_regexp_value(type)
    case type
    when :actor   then "ACTOR"
    when :event   then "EVENT"
    when :vehicle then "VEHICLE"
    when :map     then "MAP"
    end
  end
  #--------------------------------------------------------------------------
  # * New method: setup_light
  #--------------------------------------------------------------------------
  def setup_light(info, type)
    light = Game_LightEffect.new
    light.name     = info =~ /NAME: #{get_filename}/i ? $1.dup : ""
    light.id       = info =~ /ID: (\w+)/i         ? $1.to_s : 0
    light.id       = info =~ /ID: (\d+)/i         ? $1.to_i : light.id
    light.x        = info =~ /POS X: ([+-]?\d+)/i ? $1.to_i : 0
    light.y        = info =~ /POS Y: ([+-]?\d+)/i ? $1.to_i : 0
    light.speed    = info =~ /SPEED: (\d+)/i      ? $1.to_i : 0
    light.zoom     = info =~ /ZOOM: (\d+)/i       ? $1.to_f : 100.0
    light.opacity  = info =~ /OPACITY: (\d+)/i    ? $1.to_i : 192
    light.variance = info =~ /VAR: (\d+)/i        ? $1.to_i : 0
    if type == :map
      map_x = info =~ /MAP X: (\d+)/i ? $1.to_i : 0
      map_y = info =~ /MAP Y: (\d+)/i ? $1.to_i : 0
      light.info = {x: map_x, y: map_y}
    else
      index = info =~ /INDEX: (\d+)/i ? $1.to_i : 0
      light.info = {type => index}
    end
    light
  end
  #--------------------------------------------------------------------------
  # * New method: set_light
  #--------------------------------------------------------------------------
  def set_light(id, name, info, op = 0, x = 0, y = 0, v = 0, s = 0, z = 100)
    light = Game_LightEffect.new
    light.id       = id
    light.name     = name
    light.info     = info
    light.opacity  = op.to_i
    light.x        = x.to_i
    light.y        = y.to_i
    light.variance = v.to_i
    light.speed    = s.to_i
    light.zoom     = z.to_f
    light
  end
  #--------------------------------------------------------------------------
  # * New method: get_font
  #--------------------------------------------------------------------------
  def get_font(type, i)
    case type
    when :actor   then actors[i]
    when :event   then events[i]
    when :vehicle then vehicles[i]  
    end
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
  attr_accessor :lantern
  #--------------------------------------------------------------------------
  # * Alias method: init_public_members
  #--------------------------------------------------------------------------
  alias :init_public_members_ve_light_effects :init_public_members
  def init_public_members
    init_public_members_ve_light_effects
    @lantern = 0
  end
  #--------------------------------------------------------------------------
  # * Alias method: update
  #--------------------------------------------------------------------------
  alias :update_ve_light_effects :update
  def update
    update_ve_light_effects
    update_lantern
  end
  #--------------------------------------------------------------------------
  # * New method: update_lantern
  #--------------------------------------------------------------------------
  def update_lantern
    diag = $imported[:ve_diagonal_move] && diagonal?
    if @lantern != 0 && ((!diag && @lantern_direction != @direction) ||
       (diag && @lantern_direction != @diagonal))
      @lantern_direction = (diag ? @diagonal : @direction)
      light = setup_lantern
      $game_map.screen.lights[light.id] = light
    elsif @lantern == 0 && @lantern_direction
      id = is_event? ? "EL#{@id}" : "AL#{@id}"
      $game_map.screen.remove_light.push(id) if $game_map.screen.remove_light
      @lantern_direction = nil
    end
  end
  #--------------------------------------------------------------------------
  # * New method: setup_lantern
  #--------------------------------------------------------------------------
  def setup_lantern
    id   = is_event? ? "EL#{@id}" : "AL#{@id}"
    type = is_event? ? :event : :actor
    case @lantern_direction
    when 1
      name  = 'lantern_downleft'
      value = [id, name, {type => @id}, @lantern, -48, 48]
    when 3
      name  = 'lantern_downright'
      value = [id, name, {type => @id}, @lantern, 48, 48]
    when 2
      name  = 'lantern_down'
      value = [id, name, {type => @id}, @lantern, 0, 64]
    when 4
      name  = 'lantern_left'
      value = [id, name, {type => @id}, @lantern, -64, 0]
    when 6
      name  = 'lantern_right'
      value = [id, name, {type => @id}, @lantern, 64, 0]
    when 7
      name  = 'lantern_upleft'
      value = [id, name, {type => @id}, @lantern, -48, -48]
    when 8
      name  = 'lantern_up'
      value = [id, name, {type => @id}, @lantern, 0, -64,]
    when 9
      name  = 'lantern_upright'
      value = [id, name, {type => @id}, @lantern, 48, -48]
    end
    $game_map.set_light(*value)
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
  # * Alias method: clear_starting_flag
  #--------------------------------------------------------------------------
  alias :clear_starting_flag_ve_light_effects :clear_starting_flag
  def clear_starting_flag
    clear_starting_flag_ve_light_effects
    @lantern = 0
    $game_map.screen.remove_light.push("EV#{@id}")
    refresh_lights if @page
  end
  #--------------------------------------------------------------------------
  # * New method: refresh_lights
  #--------------------------------------------------------------------------
  def refresh_lights
    case note
    when /<SIMPLE LIGHT: (\d+)?>/i
      set_light("EV#{@id}", "light", $1 ? $1 : 255)
    when /<SIMPLE LAMP: (\d+)?>/i
      set_light("EV#{@id}", "lamp", $1 ? $1 : 255)
    when /<SIMPLE TORCH: (\d+)?>/i
      set_light("EV#{@id}", "torch", $1)
    when /<SIMPLE WINDOW (\d+): (\d+)?>/i
      adj = $1 == "1" ? 0 : 14
      set_light("EV#{@id}", "window", $2 ? $2 : 255, 0, 0, 0, adj)
    when /<FLASH LIGHT: (\d+)?>/i
      set_light("EV#{@id}", "light", $1 ? $1 : 255, 30, 1)
    when /<FLASH LAMP: (\d+)?>/i
      set_light("EV#{@id}", "lamp", $1 ? $1 : 255, 30, 1)
    when /<FLASH TORCH: (\d+)?>/i
      set_light("EV#{@id}", "torch", $1 ? $1 : 255, 30, 1)
    when /<FLASH WINDOW (\d+): (\d+)?>/i
      adj = $1 == "1" ? 0 : 14
      set_light("EV#{@id}", "window", $2 ? $2 : 255, 30, 1, 0, adj)        
    when /<CUSTOM LIGHT>([^><]*)<\/CUSTOM LIGHT>/im
      info = $1.dup
      n = info =~ /NAME: #{get_filename}/i ? $1.dup : ""
      x = info =~ /POS X: ([+-]?\d+)/i  ? $1.to_i : 0
      y = info =~ /POS Y: ([+-]?\d+)/i  ? $1.to_i : 0
      s = info =~ /SPEED: (\d+)/i       ? $1.to_i : 0
      z = info =~ /ZOOM: (\d+)/i        ? $1.to_f : 100.0
      o = info =~ /OPACITY: (\d+)/i     ? $1.to_i : 192
      v = info =~ /VAR: (\d+)/i         ? $1.to_i : 0
      set_light("EV#{@id}", n, o, v, s, x, y, z)       
    when /<LANTERN(?:: (\d+))?>/i
      @lantern = ($1 ? $1.to_i : 255)
    end
  end
  #--------------------------------------------------------------------------
  # * New method: set_light
  #--------------------------------------------------------------------------
  def set_light(id, name, op = 255, v = 0, s = 0, x = 0, y = 0, z = 100)
    value = [id, name, {:event => @id}, op, x, y, v, s, z].compact
    $game_map.screen.lights[id] = $game_map.set_light(*value)
    $game_map.screen.remove_light.delete(id)
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
  # * Alias method: comment_call
  #--------------------------------------------------------------------------
  alias :comment_call_ve_light_effects :comment_call
  def comment_call
    call_create_lights
    call_change_shade_opacity
    call_change_shade_tone
    call_change_light_opacity
    call_remove_light
    comment_call_ve_light_effects
  end
  #--------------------------------------------------------------------------
  # * New method: create_lights
  #--------------------------------------------------------------------------
  def call_create_lights
    $game_map.setup_map_shade(note)
    $game_map.setup_map_lights(:actor, note)
    $game_map.setup_map_lights(:event, note)
    $game_map.setup_map_lights(:vehicle, note)
    $game_map.setup_map_lights(:map, note)
    $game_map.setup_map_lantern(:actor, note)
    $game_map.setup_map_lantern(:event, note)
    $game_map.setup_map_lantern(:vehicle, note)
  end
  #--------------------------------------------------------------------------
  # * New method: call_change_shade_opacity
  #--------------------------------------------------------------------------
  def call_change_shade_opacity
    return if !$game_map.screen.shade.visible
    note.scan(/<SHADE OPACITY: ((?:\d+,? *){2})>/i) do
      if $1 =~ /(\d+) *,? *(\d+)?/i
        duration = $2 ? $2.to_i : 0
        $game_map.screen.shade.change_opacity($1.to_i, duration)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * New method: call_change_shade_tone
  #--------------------------------------------------------------------------
  def call_change_shade_tone
    return if !$game_map.screen.shade.visible
    note.scan(/<SHADE TONE: ((?:\d+,? *){4})>/i) do
      if $1 =~ /(\d+) *, *(\d+) *, *(\d+) *, *(\d+)/i
        $game_map.screen.shade.change_color($1.to_i, $2.to_i, $3.to_i, $4.to_i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * New method: call_change_light_opacity
  #--------------------------------------------------------------------------
  def call_change_light_opacity
    return if !$game_map.screen.shade.visible
    note.scan(/<LIGHT OPACITY (\d+): ((?:\d+,? *){2})>/i) do
      light = $game_map.screen.lights[$1.to_i]
      if light && $2 =~ /(\d+) *,? *(\d+)?/i
        duration = $2 ? $2.to_i : 0
        light.change_opacity($1.to_i, duration)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * New method: call_remove_light
  #--------------------------------------------------------------------------
  def call_remove_light
    note.scan(/<REMOVE LIGHT: (\d+)>/i) do 
      $game_map.screen.remove_light.push($1.to_i)
    end
  end
end

#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc. It's used
# within the Scene_Map class.
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Alias method: initialize
  #--------------------------------------------------------------------------
  alias :initialize_ve_light_effects :initialize
  def initialize
    initialize_ve_light_effects
    2.times { update_light(true) }
  end
  #--------------------------------------------------------------------------
  # * Alias method: update
  #--------------------------------------------------------------------------
  alias :update_ve_light_effects :update
  def update
    update_ve_light_effects
    update_light
  end
  #--------------------------------------------------------------------------
  # * Alias method: dispose
  #--------------------------------------------------------------------------
  alias :dispose_ve_light_effects :dispose
  def dispose
    dispose_ve_light_effects
    dispose_light unless SceneManager.scene_is?(Scene_Map)
  end
  #--------------------------------------------------------------------------
  # * New method: update_light
  #--------------------------------------------------------------------------
  def update_light(forced = false)
    return unless Graphics.frame_count % 2 == 0 || forced
    update_shade
    update_effects
  end
  #--------------------------------------------------------------------------
  # * New method: dispose_light
  #--------------------------------------------------------------------------
  def dispose_light
    if @light_effect
      @light_effect.dispose
      @light_effect = nil
      @screen_shade = nil
    end
  end
  #--------------------------------------------------------------------------
  # * New method: update_shade
  #--------------------------------------------------------------------------
  def update_shade
    if !@light_effect && $game_map.screen.shade.visible
      refresh_lights
    elsif $game_map.screen.shade.visible && @light_effect
      @light_effect.update
    elsif @light_effect && !$game_map.screen.shade.visible
      dispose_light
    end
  end
  #--------------------------------------------------------------------------
  # * New method: refresh_lights
  #--------------------------------------------------------------------------
  def refresh_lights
    @light_effect.dispose if @light_effect
    @screen_shade = $game_map.screen.shade
    @light_effect = Sprite_Light.new(@screen_shade, @viewport2)
    $game_map.event_list.each {|ev| ev.refresh_lights}
    @light_effect.update
  end  
  #--------------------------------------------------------------------------
  # * New method: update_effects
  #--------------------------------------------------------------------------
  def update_effects
    return if !@light_effect || $game_map.screen.lights.empty?
    $game_map.screen.lights.keys.each {|key| create_light(key) }
    $game_map.screen.remove_light.clear
  end
  #--------------------------------------------------------------------------
  # * New method: create_light
  #--------------------------------------------------------------------------
  def create_light(key)
    effect = @light_effect.lights[key]
    return if remove_light(key)
    return if effect && effect.light == $game_map.screen.lights[key]
    @light_effect.create_light($game_map.screen.lights[key])
  end
  #--------------------------------------------------------------------------
  # * New method: remove_light
  #--------------------------------------------------------------------------
  def remove_light(key)
    return false if !$game_map.screen.remove_light.include?(key) 
    @light_effect.remove_light(key)
    $game_map.screen.lights.delete(key)
    return true
  end
end

#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================

class Scene_Map
  #--------------------------------------------------------------------------
  # * Alias method: pre_transfer
  #--------------------------------------------------------------------------
  alias :pre_transfer_ve_light_effects :pre_transfer
  def pre_transfer
    pre_transfer_ve_light_effects
    if $game_player.new_map_id !=  $game_map.map_id
      @spriteset.dispose_light
      $game_map.screen.clear_lights
    end
  end
end

#==============================================================================
# ** Game_ShadeEffect
#------------------------------------------------------------------------------
#  This class handles the shade layer data
#==============================================================================

class Game_ShadeEffect
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :visible
  attr_reader   :color
  attr_accessor :blend
  attr_accessor :opacity
  #--------------------------------------------------------------------------
  # * initialize
  #--------------------------------------------------------------------------
  def initialize
    init_opacity
    init_color
  end
  #--------------------------------------------------------------------------
  # * init_opacity
  #--------------------------------------------------------------------------
  def init_opacity
    @visible = false
    @opacity = 0
    @opacity_target   = 0
    @opacity_duration = 0
  end
  #--------------------------------------------------------------------------
  # * init_color
  #--------------------------------------------------------------------------
  def init_color
    @blend = 0
    @color = Color.new(0, 0, 0, 0)
    @color_duration = 0
    @color_target   = Color.new(0, 0, 0, 0)
  end
  #--------------------------------------------------------------------------
  # * show
  #--------------------------------------------------------------------------
  def show
    @visible = true
  end
  #--------------------------------------------------------------------------
  # * hide
  #--------------------------------------------------------------------------
  def hide
    @visible = false
  end
  #--------------------------------------------------------------------------
  # * set_color
  #--------------------------------------------------------------------------
  def set_color(r = 0, g = 0, b = 0)
    @color        = get_colors(r, g, b)
    @color_target = @color.clone
  end
  #--------------------------------------------------------------------------
  # * change_opacity
  #--------------------------------------------------------------------------
  def change_opacity(op, d)
    @opacity_target   = op
    @opacity_duration = [d, 0].max
    @opacity = @opacity_target if @opacity_duration == 0
  end
  #--------------------------------------------------------------------------
  # * change_color
  #--------------------------------------------------------------------------
  def change_color(r, g, b, d)
    @color_target   = get_colors(r, g, b)
    @color_duration = [d, 0].max
    @color = @color_target.clone if @color_duration == 0
  end
  #--------------------------------------------------------------------------
  # * get_colors
  #--------------------------------------------------------------------------
  def get_colors(r, g, b)
    color = Color.new(255 - r, 255 - g, 255 - b, 255) if @blend == 2
    color = Color.new(r, g, b, 255) if @blend != 2
    color
  end
  #--------------------------------------------------------------------------
  # * update
  #--------------------------------------------------------------------------
  def update
    update_opacity
    update_color
  end
  #--------------------------------------------------------------------------
  # * update_opacity
  #--------------------------------------------------------------------------
  def update_opacity
    return if @opacity_duration == 0
    d = @opacity_duration
    @opacity = (@opacity * (d - 1) + @opacity_target) / d
    @opacity_duration -= 1
  end
  #--------------------------------------------------------------------------
  # * update_color
  #--------------------------------------------------------------------------
  def update_color
    return if @color_duration == 0
    d = @color_duration
    @color.red   = (@color.red   * (d - 1) + @color_target.red)   / d
    @color.green = (@color.green * (d - 1) + @color_target.green) / d
    @color.blue  = (@color.blue  * (d - 1) + @color_target.blue)  / d
    @color_duration -= 1
  end
end

#==============================================================================
# ** Game_LightEffect
#------------------------------------------------------------------------------
#  This class handles the light sprite data
#==============================================================================

class Game_LightEffect
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :id
  attr_accessor :name
  attr_accessor :info
  attr_accessor :opacity
  attr_accessor :x
  attr_accessor :y
  attr_accessor :variance
  attr_accessor :speed
  attr_accessor :zoom
  attr_accessor :opacity_target
  attr_accessor :opacity_duration
  #--------------------------------------------------------------------------
  # * change_opacity
  #--------------------------------------------------------------------------
  def change_opacity(op, d)
    @opacity_target   = op
    @opacity_duration = [d, 0].max
    @opacity = @opacity_target if @opacity_duration == 0
  end
end

#==============================================================================
# ** Game_LightBitmap
#------------------------------------------------------------------------------
#  This class handles the bitmpas of each light spot
#==============================================================================

class Game_LightBitmap
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :light
  attr_reader   :bitmap
  attr_reader   :opacity
  attr_reader   :x
  attr_reader   :y
  #--------------------------------------------------------------------------
  # * initialize
  #--------------------------------------------------------------------------
  def initialize(light)
    @light = light
    init_basic
    update
  end
  #--------------------------------------------------------------------------
  # * init_basic
  #--------------------------------------------------------------------------
  def init_basic
    @bitmap   = Cache.lights(@light.name)
    @target   = set_target
    @opacity  = @light.opacity
    @speed    = @light.speed
    @variance = 0.0
    @light.opacity_duration = 0
    @light.opacity_target   = 0
  end
  #--------------------------------------------------------------------------
  # * width
  #--------------------------------------------------------------------------
  def width
    @bitmap.width * @light.zoom / 100.0
  end
  #--------------------------------------------------------------------------
  # * height
  #--------------------------------------------------------------------------
  def height
    @bitmap.height * @light.zoom / 100.0
  end
  #--------------------------------------------------------------------------
  # * update
  #--------------------------------------------------------------------------
  def update
    update_position
    update_opacity
    update_variance
  end
  #--------------------------------------------------------------------------
  # * update_position
  #--------------------------------------------------------------------------
  def update_position
    @target.is_a?(Game_Character) ? character_position : map_position
  end
  #--------------------------------------------------------------------------
  # * character_position
  #--------------------------------------------------------------------------
  def character_position
    @x = $game_map.adjust_x(@target.real_x) * 32  - width / 2  + @light.x + 16
    @y = $game_map.adjust_y(@target.real_y) * 32  - height / 2 + @light.y + 16
  end
  #--------------------------------------------------------------------------
  # * map_position
  #--------------------------------------------------------------------------
  def map_position
    @x = $Game_Map.adjust_x(@target[:x]) * 32 - width / 2  + @light.x + 16
    @y = $Game_Map.adjust_y(@target[:y]) * 32 - height / 2 + @light.y + 16
  end
  #--------------------------------------------------------------------------
  # * change_opacity
  #--------------------------------------------------------------------------
  def change_opacity(op, d)
    @light.opacity_target   = op
    @light.opacity_duration = [d, 0].max
    @light.opacity = @light.opacity_target if @light.opacity_duration == 0
  end
  #--------------------------------------------------------------------------
  # * update_opacity
  #--------------------------------------------------------------------------
  def update_opacity
    return if @light.opacity_duration == 0
    d = @light.opacity_duration
    @light.opacity = (@light.opacity * (d - 1) + @light.opacity_target) / d
    @light.opacity_duration -= 1
  end
  #--------------------------------------------------------------------------
  # * update_variance
  #--------------------------------------------------------------------------
  def update_variance
    @variance += @speed 
    @speed *= -1 if @variance.abs > @light.variance.abs
    @opacity = [[@light.opacity + @variance, 0].max, 255].min
  end
  #--------------------------------------------------------------------------
  # * dispose
  #--------------------------------------------------------------------------
  def dispose
    @bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # * set_target
  #--------------------------------------------------------------------------
  def set_target
    if @light.info.keys.include?(:actor)
      target = $game_map.actors[@light.info[:actor]]
    elsif @light.info.keys.include?(:event)
      target = $game_map.events[@light.info[:event]]
    elsif @light.info.keys.include?(:vehicle)
      target = $game_map.vehicles[@light.info[:vehicle]]
    else
      target = @light.info
    end
    target
  end
end

#==============================================================================
# ** Sprite_Light
#------------------------------------------------------------------------------
#  This sprite is used to display the light effects
#==============================================================================

class Sprite_Light < Sprite_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :lights
  #--------------------------------------------------------------------------
  # * initialize
  #--------------------------------------------------------------------------
  def initialize(shade, viewport)
    super(viewport)
    @shade = shade
    self.bitmap     = Bitmap.new(Graphics.width, Graphics.height)
    self.blend_type = @shade.blend
    self.opacity    = @shade.opacity
    self.z = 100
    @lights = {}
  end
  #--------------------------------------------------------------------------
  # * map_x
  #--------------------------------------------------------------------------
  def map_x
    $game_map.adjust_x($game_map.display_x)
  end
  #--------------------------------------------------------------------------
  # * map_y
  #--------------------------------------------------------------------------
  def map_y
    $game_map.adjust_y($game_map.display_y) 
  end
  #--------------------------------------------------------------------------
  # * update
  #--------------------------------------------------------------------------
  def update
    super
    self.ox = map_x
    self.oy = map_y
    update_opacity
    update_lights
  end
  #--------------------------------------------------------------------------
  # * update lights
  #--------------------------------------------------------------------------
  def update_lights
    rect = Rect.new(map_x, map_y, Graphics.width, Graphics.height)
    self.bitmap.fill_rect(rect, color)
    draw_light_effects
  end
  #--------------------------------------------------------------------------
  # * color
  #--------------------------------------------------------------------------
  def color
    @shade.color
  end
  #--------------------------------------------------------------------------
  # * draw_light_effects
  #--------------------------------------------------------------------------
  def draw_light_effects
    @lights.values.each do |light|
      light.update
      next if !on_screen?(light)
      draw_light(light)
    end
  end
  #--------------------------------------------------------------------------
  # * on_sceen?
  #--------------------------------------------------------------------------
  def on_screen?(light)
    ax1 = light.x
    ay1 = light.y
    ax2 = light.x + light.width
    ay2 = light.y + light.height
    bx1 = map_x
    by1 = map_y
    bx2 = map_x + Graphics.width
    by2 = map_y + Graphics.height
    check1 = ax1.between?(bx1, bx2) || ax2.between?(bx1, bx2) ||
             ax1 < bx1 && ax2 > bx2
    check2 = ay1.between?(by1, by2) || ay2.between?(by1, by2) ||
             ay1 < by1 && ay2 > by2
    check1 && check2
  end
  #--------------------------------------------------------------------------
  # * draw_light
  #--------------------------------------------------------------------------
  def draw_light(light)
    img  = light.bitmap
    rect = Rect.new(light.x, light.y, light.width, light.height)
    self.bitmap.stretch_blt(rect, img, img.rect, light.opacity)
  end
  #--------------------------------------------------------------------------
  # * update_opacity
  #--------------------------------------------------------------------------
  def update_opacity
    @shade.update
    self.opacity    = @shade.opacity
    self.blend_type = @shade.blend
  end
  #--------------------------------------------------------------------------
  # * create_light
  #--------------------------------------------------------------------------
  def create_light(light)
    remove_light(light.id)
    @lights[light.id] = Game_LightBitmap.new(light)
  end
  #--------------------------------------------------------------------------
  # * remove_light
  #--------------------------------------------------------------------------
  def remove_light(id)
    @lights.delete(id) if @lights[id]
  end
  #--------------------------------------------------------------------------
  # * dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @lights.values.each {|light| light.dispose unless light.bitmap.disposed? }
  end
end