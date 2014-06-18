# Source: http://forums.rpgmakerweb.com/index.php?/topic/4599-xs-credits/
# Requires xail_system_core.rb
#==============================================================================
#   XaiL System - Title
#   Author: Nicke
#   Created: 02/01/2012
#   Edited: 17/01/2012
#   Version: 1.1b
#==============================================================================
# Instructions
# -----------------------------------------------------------------------------
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials but above ▼ Main. Remember to save.
#
# No need for explaining, just a simple title scene with a few settings.
#
# *** Only for RPG Maker VX Ace. ***
#==============================================================================
($imported ||= {})["XAIL-XS-TITLE"] = true

module XAIL
  module TITLE
  #--------------------------------------------------------------------------#
  # * Settings
  #--------------------------------------------------------------------------#
  # title list, the icon_index (set to nil) and custom_scene is optional.
  # TITLE_LIST:
  # ID = ['Title', :symbol, :command, icon_index, custom_scene (not needed) ]
  TITLE_LIST = []
  TITLE_LIST[0] = ['New Game', :new_game, :command_new_game, 301]
  TITLE_LIST[1] = ['Options',  :options,  :command_custom,   302,  Scene_Title]
  TITLE_LIST[2] = ['Credits',  :credits,  :command_custom,   303,  Scene_Title]
  TITLE_LIST[3] = ['Load',	 :continue, :command_continue, 304]
  TITLE_LIST[4] = ['Quit',	 :shutdown, :command_shutdown, 305]

  # If center window is true you cannot modify the x value.
  # TITLE_WINDOW [ Width, x, y, z, opacity, center window]
  TITLE_WINDOW = [160, 0, 150, 200, 255, true]

  # Title logo. Set nil to use default.
  # TITLE_LOGO = [ x, y, size, color, bold, shadow ]
  TITLE_LOGO = [0, 0, 48, Colors::LightGreen, true, false]

  # TITLE_ALIGNMENT = 0 (left), 1 (center), 2 (right)
  TITLE_ALIGNMENT = 1 # Default: 0.

  # The windowskin to use for the windows.
  # nil to disable.
  # SKIN = string
  SKIN = nil

  # Disable all of the icons if you don't need them.
  # ICON_ENABLE = true/false
  ICON_ENABLE = true

  # Transition, nil to use default.
  # TRANSITION [ SPEED, TRANSITION, OPACITY ]
  # TRANSITION = [40, "Graphics/Transitions/1", 50]
  TRANSITION = nil

  # Animate options.
  # Set ANIM_WINDOW_TIMER to nil to disable.
  ANIM_WINDOW_TIMER = 20 # Fade in time for window/icons.
  ANIM_SCENE_FADE = 1000 # Fade out time for scene. Default: 1000.
  ANIM_AUDIO_FADE = 1000 # Fade out time for audio. Default: 1000.

  # Switches enabled from start.
  # Set to nil to disable.
  # SWITCHES = [SWITCH_ID]
  SWITCHES = [1]

  # Run a common event on startup?
  # COMMON_EVENT = COMMON_EVENT_ID
  COMMON_EVENT = 1

  # Skip title. (Only in test mode)
  SKIP = false

  end
end
# *** Don't edit below unless you know what you are doing. ***
#==============================================================================
# ** Window_TitleCommand
#==============================================================================
class Window_TitleCommand < Window_Command

  def window_width
	# // Method to return the width of TITLE_WINDOW.
	return XAIL::TITLE::TITLE_WINDOW[0]
  end

  def alignment
	# // Method to return the alignment.
	return XAIL::TITLE::TITLE_ALIGNMENT
  end

  def make_command_list
	# // Method to add the commands.
	for i in XAIL::TITLE::TITLE_LIST
	  case i[1]
	  when :continue # Load
		add_command(i[0], i[1], continue_enabled, i[4])
	  else
		add_command(i[0], i[1], true, i[4])
	  end
	end
  end

end
#==============================================================================#
# ** Scene_Title
#------------------------------------------------------------------------------
#  New Scene :: Scene_Title
#==============================================================================#
class Scene_Title < Scene_Base

  alias xail_title_main main  
  def main(*args, &block)
	# // Method main.
	command_new_game(true) if XAIL::TITLE::SKIP && $TEST && !$BTEST
	return if XAIL::TITLE::SKIP && $TEST && !$BTEST
	xail_title_main(*args, &block)
  end

  alias xail_title_start start
  def start(*args, &block)
	# // Method to start the scene.
	super
	xail_title_start(*args, &block)
	create_title_icon_window
	create_title_command_window
  end

  def terminate
	# // Method to terminate.
	super
  end

  def create_title_command_window
	# // Method to create the commands.
	@command_window = Window_TitleCommand.new
	@command_window.windowskin = Cache.system(XAIL::TITLE::SKIN) unless XAIL::TITLE::SKIN.nil?
	if XAIL::TITLE::TITLE_WINDOW[5]
	  @command_window.x = (Graphics.width - @command_window.width) / 2
	else
	  @command_window.x = XAIL::TITLE::TITLE_WINDOW[1]
	end
	@command_window.y = XAIL::TITLE::TITLE_WINDOW[2]
	@command_window.z = XAIL::TITLE::TITLE_WINDOW[3]
	@command_window.opacity = XAIL::TITLE::TITLE_WINDOW[4]
	for i in XAIL::TITLE::TITLE_LIST
	  @command_window.set_handler(i[1], method(i[2]))
	end
	pre_animate_in(@command_window) unless XAIL::TITLE::ANIM_WINDOW_TIMER.nil?
  end

  def create_title_icon_window
	# // Method to create the menu icon window.
	@command_icon = Window_Icon.new(0, 0, @command_window.width, XAIL::TITLE::TITLE_LIST.size)
	@command_icon.alignment = XAIL::TITLE::TITLE_ALIGNMENT
	@command_icon.enabled = XAIL::TITLE::ICON_ENABLE
	@command_icon.draw_cmd_icons(XAIL::TITLE::TITLE_LIST, 3)
	if XAIL::TITLE::TITLE_WINDOW[5]
	  @command_icon.x = (Graphics.width - @command_window.width) / 2
	else
	  @command_icon.x = XAIL::TITLE::TITLE_WINDOW[1]
	end
	@command_icon.y = XAIL::TITLE::TITLE_WINDOW[2]
	@command_icon.z = 201
	@command_icon.opacity = 255
	pre_animate_in(@command_icon) unless XAIL::TITLE::ANIM_WINDOW_TIMER.nil?
  end

  def pre_animate_in(command)
	# // Method for pre_animate the window.
	command.opacity -= 255
	command.contents_opacity -= 255
  end

  def fade_animate(command, fade)
	# // Method for fading in/out.
	timer = XAIL::TITLE::ANIM_WINDOW_TIMER
	while timer > 0
	  Graphics.update
	  case fade
	  when :fade_in
	  command.opacity += 255 / XAIL::TITLE::ANIM_WINDOW_TIMER unless command == @command_icon
	  command.contents_opacity += 255 / XAIL::TITLE::ANIM_WINDOW_TIMER
	  when :fade_out
	  command.opacity -= 255 / XAIL::TITLE::ANIM_WINDOW_TIMER unless command == @command_icon
	  command.contents_opacity -= 255 / XAIL::TITLE::ANIM_WINDOW_TIMER  
	  end
	  command.update
	  timer -= 1
	end
  end

  def post_start
	# // Method for post_start.
	super
	unless XAIL::TITLE::ANIM_WINDOW_TIMER.nil?
	  fade_animate(@command_window, :fade_in)
	  fade_animate(@command_icon, :fade_in)
	end
  end

  def close_command_window
	# // Method for close_command_window.
	unless XAIL::TITLE::ANIM_WINDOW_TIMER.nil?
	  fade_animate(@command_icon, :fade_out)
	  fade_animate(@command_window, :fade_out)
	end
  end

  def fadeout_scene
	time = XAIL::TITLE::ANIM_AUDIO_FADE
	# // Method to fade out the scene.
	RPG::BGM.fade(time)
	RPG::BGS.fade(time)
	RPG::ME.fade(time)
	Graphics.fadeout(XAIL::TITLE::ANIM_SCENE_FADE * Graphics.frame_rate / 1000)
	RPG::BGM.stop
	RPG::BGS.stop
	RPG::ME.stop
  end

  def command_new_game(skip = false)
	# // Method to call new game.
	DataManager.setup_new_game
	if skip
	  SceneManager.clear
	  DataManager.load_database
	  SceneManager.call(Scene_Map)
	end
	if !skip
	  close_command_window
	  fadeout_scene
	end
	$game_map.autoplay
	if !XAIL::TITLE::SWITCHES.nil?
	  for i in XAIL::TITLE::SWITCHES
		$game_switches[i] = true
	  end
	end
	if !XAIL::TITLE::COMMON_EVENT.nil?
	  $game_temp.reserve_common_event(XAIL::TITLE::COMMON_EVENT)
	end
	SceneManager.goto(Scene_Map) if !skip
  end

  def command_continue
	# // Method to call load.
	close_command_window
	SceneManager.call(Scene_Load)
  end

  def command_shutdown
	# // Method to call shutdown.
	close_command_window
	fadeout_scene
	SceneManager.exit
  end

  def command_custom
	# // Method to call a custom command.
	SceneManager.goto(@command_window.current_ext)
  end

  alias xail_title_draw_game_title draw_game_title
  def draw_game_title(*args, &block)
	if !XAIL::TITLE::TITLE_LOGO.nil?
	  rect = Rect.new(XAIL::TITLE::TITLE_LOGO[0], XAIL::TITLE::TITLE_LOGO[1], Graphics.width, Graphics.height / 2)
	  @foreground_sprite.bitmap.font.size = XAIL::TITLE::TITLE_LOGO[2]
	  @foreground_sprite.bitmap.font.color = XAIL::TITLE::TITLE_LOGO[3]
	  @foreground_sprite.bitmap.font.bold = XAIL::TITLE::TITLE_LOGO[4]
	  @foreground_sprite.bitmap.font.shadow = XAIL::TITLE::TITLE_LOGO[5]
	end
	xail_title_draw_game_title(*args, &block)
  end

  def perform_transition
	# // Method to perform a transition.
	if XAIL::TITLE::TRANSITION.nil?
	  Graphics.transition(15)
	else
	  Graphics.transition(XAIL::TITLE::TRANSITION[0],XAIL::TITLE::TRANSITION[1],XAIL::TITLE::TRANSITION[2])
	end
  end

end # END OF FILE

#=*==========================================================================*=#
# ** END OF FILE
#=*==========================================================================*=#
