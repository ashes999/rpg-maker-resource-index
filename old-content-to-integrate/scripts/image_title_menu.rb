#==============================================================================
#
# -- Custom Title Menu
# -- Author: Haris1112 and ashes999 (current), NerdiGaming (original)
# -- Last Updated: May 10, 2016
# -- Version 1.5.3
#
#==============================================================================
# - Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a very simple script that allows you to use images for your title
# menu.
#
#==============================================================================
# - Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below Materials but above Main. Remember to save.
#
#==============================================================================
# - Terms of Use
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# - You MUST credit the original author: NerdiGaming
# - You MAY NOT re-distribute this script or any attached material to any
#	 location without my permission.
# - You MAY use this script or any attached material for non-commercial
#	 projects.
# - You MUST contact me before using this script or any attached material for
#	 commercial projects.
#
#==============================================================================
# - Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Version 1.5.3		- Don't break if Jet's mouse system is missing
# Version 1.5.1		- Keyboard takes precedence over mouse
#      		- Buttons now centered vertically as well
#					- Rearranged BUTTON_IMAGE_NAMES and BUTTON_COMMANDS
#					into a 2-D BUTTONS array. Association between image name
#					and command is now clearer.
# Version 1.5		- Now buttons can be layed out horizontally!
# Version 1.4.2		- Fixed mouse support (reliant on external Mouse module)
# Version 1.4.1		- More documentation, minor internal fixes.
#					- Centered buttons vertically however, now all the buttons
#					should have the same height.
#					- Added soft configuration checking
# Version 1.4		- Refactoring complete (see version 1.2.1 notes)
#					- Adding buttons requires:	» Button Image Name
#												» Button Command/Action
# Version 1.3 		- Added two new dummy buttons (achievements and credits).
#					You can update what they do at the end of the script.
# Version 1.2.1		- Made some refactoring (internal changes). Hopefully, 1.3 will
#					include the ability to easily add more menu items.
# Version 1.2		- Fixed a Bug: If players held down an input button the menu
#			   		would not update.
#			 		- Removed unecessary overwrites; improving compatability slightly.
#			 		- Removed some unecessary code.
# Version 1.1 		- Fixed a Bug: If a save file was present, New Game would be
#			   		selected instead of Continue.
# Version 1   		- Script Completed.
#==============================================================================

module TitleMenu
  PADDING 				= 5  	# Default: 5		(Amount of pixels between buttons.)
  HORIZONTAL_BUTTONS 	= false	# Default: false 	(buttons are placed vertically).

  # Offset moves the menu images in different directions (normal cartesian plane).
  Y_OFFSET = -75  # Default: 0 px
  X_OFFSET = 0  # Default: 0 px
  
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # BUTTON CONFIG
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  #	To add a buton, add an element to the BUTTONS array which contains
  # [ IMAGE_NAME, :COMMAND ]
  #
  # IMAGE_NAME
  # ==========
  # The images need to be placed in your Project\Graphics\System folder,
  # eg. Project\Graphics\System\new-game.png, IMAGE_NAME = 'new-game'
  #
  # :COMMAND
  # ========
  #	To specify a command that the button engages, see below.
  # Default commands include:	» :command_new_game		Starts a new game session
  #								» :command_continue		Displays load game screen
  #								» :command_shutdown		Synonymous to 'exit game'
  #	Custom commands can be declared in the Scene_Base class under
  # the 'Button Commands' header.
  #
  # Just follow the syntax of that is shown, and everything should be fine.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  BUTTONS					= [ ['new-game', :command_new_game],
								['continue-game', :command_continue],
								['achievements', :command_achievements],
								['credits', :command_credits],
								['exit', :command_shutdown]					]
  
  # Suffix at the end of file which denotes the "selected" state of hte button
  # eg. Project\Graphics\System\new-game.png --> new-game-selected.png
  SELECTED_BUTTON_SUFFIX	= '-selected'
 
  # If you use :command_continue as the command for your continue button, you can ignore this
  # Else, indicate the the index of your continue button below
  # Also remember, the first button's index is 0, the second button's index is 1, etc.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  CUSTOM_CONTINUE_BUTTON_INDEX 	= -1	# Default: -1
  
  # Continue Opacity is how transparent the continue image will be when there
  # are no save files present or if the continue option is disabled for some reason.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  CONTINUE_DISABLED_OPACITY = 100  # Default: 100

end # TitleMenu

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # * Button Commands - Define methods for custom buttons below
  #--------------------------------------------------------------------------
  def command_continue	# Override
    if @continue_enabled
      close_command_window
      SceneManager.call(Scene_Load)
    end
  end
  
  def command_achievements
    fadeout_all
	SceneManager.call(CSCA_Scene_Achievements)
    Graphics.fadein(3000 / Graphics.frame_rate)
  end
  
  def command_credits
	SceneManager.goto(Scene_Credits)
  end

  #--------------------------------------------------------------------------
  # * Z-Indices (Do not change)
  #--------------------------------------------------------------------------
  HIDDEN_Z = -2
  VISIBLE_Z = 10
  
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  def start
	super
	SceneManager.clear
	Graphics.freeze
	check_continue
	create_background
	create_command_window
	play_title_music
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    SceneManager.snapshot_for_background
    dispose_background
  end
  #--------------------------------------------------------------------------
  # * Check User Input
  #--------------------------------------------------------------------------
  def check_input
    hide_menu_items
    
    @sprites_selected[@command_window.index].z = VISIBLE_Z
    @sprites[@command_window.index].z = HIDDEN_Z
  end
  
  # private
  def hide_menu_items
    @sprites.zip(@sprites_selected).each do |sprite, sprite_selected|
	  sprite.z = VISIBLE_Z
	  sprite_selected.z = HIDDEN_Z
	end  
  end
  #--------------------------------------------------------------------------
  # * Tests if Point(x, y) is within Rectangle(rect)
  #--------------------------------------------------------------------------
  def within?(x, y, rect)
    return false if x < rect.x or y < rect.y
    bound_x = rect.x + rect.width; bound_y = rect.y + rect.height
    return true if x < bound_x and y < bound_y
    return false
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super

    # The checks below use Jet's mouse system. Only do this if the mouse
    # moves, so that keyboard takes precedence over mouse.
      
    if defined?(Mouse)
      # Check if Mouse is over a Button Image
      x = Mouse.pos[0]	
      y = Mouse.pos[1]	
      
      if x != @old_mouse_x || y != @old_mouse_y then
        @bounds.each_with_index do |rect, i|
          if within?(x, y, rect)
            @command_window.select(i)
            check_input
          end
        end
      end
      
      @old_mouse_x = x
      @old_mouse_y = y
    end
	  
    if Input.trigger?(:DOWN)
      check_input
    end
    
    if Input.trigger?(:UP)
      check_input
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Continue is Enabled
  #--------------------------------------------------------------------------
  def check_continue
	@continue_enabled = DataManager.save_file_exists?
	
	if TitleMenu::CUSTOM_CONTINUE_BUTTON_INDEX < 0
	  TitleMenu::BUTTONS.each_with_index do |button, index|
	    if button[1].to_sym == :command_continue
	      @continue_button_index = index
	    end
	  end
	end
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
	# Draw Title Background Image 
    @sprite1 = Sprite.new
    @sprite2 = Sprite.new
    @sprite1.bitmap = Cache.title1( $data_system.title1_name )
	@sprite2.bitmap = Cache.title2( $data_system.title2_name )
    center_sprite( @sprite1 )
	center_sprite( @sprite2 )

    # Drawing New-style Menu (i.e. with images)
	@sprites = []
	@sprites_selected = []
	@bounds = []
	
    # Calculate Space adjustments for Horizontal/Vertical buttons
	x_multiplier = 0; y_multiplier = 0
	x_center_offset = 0; y_center_offset = 0
	sample_sprite = Cache.system(TitleMenu::BUTTONS[0][0])
	width = sample_sprite.width
	height = sample_sprite.height
	if !TitleMenu::HORIZONTAL_BUTTONS
	  y_multiplier = ( height + TitleMenu::PADDING )
	  y_center_offset = ( (y_multiplier.to_f * TitleMenu::BUTTONS.size.to_f) / 2 )
    else
	  x_multiplier = ( width + TitleMenu::PADDING )
	  x_center_offset = ( (x_multiplier.to_f * TitleMenu::BUTTONS.size.to_f) / 2 )
	end
		
    i = 0
    while i < TitleMenu::BUTTONS.size
	  @sprites[i] = Sprite.new
      @sprites[i].bitmap = Cache.system(TitleMenu::BUTTONS[i][0])
      @sprites[i].x = ( ( Graphics.width / 2 ) - ( @sprites[i].bitmap.width / 2 ) + i * x_multiplier - x_center_offset) - TitleMenu::X_OFFSET
      @sprites[i].y = ( ( Graphics.height / 2 ) - ( @sprites[i].bitmap.height / 2 ) + i * y_multiplier - y_center_offset) - TitleMenu::Y_OFFSET
      @sprites[i].z = VISIBLE_Z
      
      @sprites_selected[i] = Sprite.new
      @sprites_selected[i].bitmap = Cache.system( TitleMenu::BUTTONS[i][0] + TitleMenu::SELECTED_BUTTON_SUFFIX )
      @sprites_selected[i].x = @sprites[i].x
      @sprites_selected[i].y = @sprites[i].y
      @sprites_selected[i].z = HIDDEN_Z
	  
	  @bounds[i] = Rect.new(@sprites[i].x, @sprites[i].y, @sprites[i].bitmap.width, @sprites[i].bitmap.height)
	  i += 1
    end
	
    # Applies The Opacity If Continue Is Disabled
    if !@continue_enabled
      @sprites[@continue_button_index].opacity = TitleMenu::CONTINUE_DISABLED_OPACITY
      @sprites_selected[@continue_button_index].opacity = TitleMenu::CONTINUE_DISABLED_OPACITY
    end
	
	# Selected first button by default
	@sprites_selected[0].z = VISIBLE_Z
  end
    
  #--------------------------------------------------------------------------
  # * Dispose Background
  #--------------------------------------------------------------------------
  def dispose_background
    # Dispose of Title Images
	@sprite1.bitmap.dispose
    @sprite1.dispose
    @sprite2.bitmap.dispose
    @sprite2.dispose
    
	# Dispose of new-style menu
    @sprites.zip(@sprites_selected).each do |sprite, sprite_selected|
	  sprite.dispose
	  sprite_selected.dispose
	end
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window    
	@command_window = Window_TitleCommand.new
	# Take command window out of scope, so mouse scripts can't select options
	@command_window.x = Graphics.width
    
    # Need to extend for our new menu items. Reset to control order.
    @command_window.clear_command_list
    i = 0
    while i < TitleMenu::BUTTONS.size do
	  if i == @continue_button_index
		@command_window.add_command(TitleMenu::BUTTONS[i][0], TitleMenu::BUTTONS[i][0].to_sym, @continue_enabled)
	  else
		@command_window.add_command(TitleMenu::BUTTONS[i][0], TitleMenu::BUTTONS[i][0].to_sym)
	  end
	  @command_window.set_handler(TitleMenu::BUTTONS[i][0].to_sym, method(TitleMenu::BUTTONS[i][1]))
	  i += 1
    end
	
	@sprites.each do |sprite|
	  sprite.z = VISIBLE_Z
	end
	
	# Verify button to highlight first
	check_input

    @command_window.z = HIDDEN_Z # Don't show default selection window
  end
end # Scene_Title
