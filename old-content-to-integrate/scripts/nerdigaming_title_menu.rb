#==============================================================================
#
# -- Custom Title Menu
# -- Author: ashes999 (current), NerdiGaming (previous)
# -- Last Updated: May 28, 2015
# -- Version 1.2.2
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
#  You can use this script for any purpose, commercial or non-ommercial.
#
#==============================================================================
# - Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Version 1.2.2 -       Contacted original author, who made license very permissive.
# Version 1.2.1 -	Made some refactoring (internal changes). Hopefully, 1.3 will
#					include the ability to easily add more menu items.
# Version 1.2 - 	Fixed a Bug: If players held down an input button the menu
#			   		would not update.
#			 		- Removed unecessary overwrites; improving compatability slightly.
#			 		- Removed some unecessary code.
# Version 1.1 		- Fixed a Bug: If a save file was present, New Game would be
#			   		selected instead of Continue.
# Version 1   		- Script Completed.
#==============================================================================

module TitleMenu
 
    # Padding increases the distance between the New Game and Exit Game images
    # from the Continue Game image.
    #	 New  Game
    #    ->	  <-  This Space
    #  Continue  Game
    #    ->	  <-  This Space
    #	 Exit Game
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    PADDING = 5  # Default: 5

    # Offset moves the menu images in different directions (inverted cartesian plane).
    Y_OFFSET = 0  # Default: 0
    X_OFFSET = 0  # Default: 0
    
    # This is where you specify what you want your images to be called.
    # The images need to be placed in your Project\Graphics\System folder,
    # eg. Project\Graphics\System\new-game.png, new-game-selected.png
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    NEW_IMAGE			   	= 'new-game'
    NEW_SELECTED_IMAGE	  	= "#{NEW_IMAGE}-selected"
    CONTINUE_IMAGE		  	= 'continue-game'
    CONTINUE_SELECTED_IMAGE	= "#{CONTINUE_IMAGE}-selected"
    ACHIEVEMENTS_IMAGE		= 'achievements'
    ACHIEVEMENTS_SELECTED_IMAGE = "#{ACHIEVEMENTS_IMAGE}-selected"
    CREDITS_IMAGE			= 'credits'
    CREDITS_SELECTED_IMAGE	= "#{CREDITS_IMAGE}-selected"
    EXIT_IMAGE				= 'exit'
    EXIT_SELECTED_IMAGE		= "#{EXIT_IMAGE}-selected"
    

    # Continue Opacity is how transparent the continue image will be when there
    # are no save files present or if the continue option is disabled for some reason.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    CONTINUE_DISABLED_OPACITY = 100  # Default: 100
    
end # TitleMenu

class Scene_Title < Scene_Base
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
  # * Check User Input; called whenever the user changes input
  #--------------------------------------------------------------------------
  def check_input
	hide_menu_items
	
    case @command_window.index
		when 0  # New Game Is Selected
		  @spriteNewGameSelected.z = VISIBLE_Z
		  @spriteNewGame.z = HIDDEN_Z
		when 1  # Continue Game Is Selected
		  @spriteContinueGameSelected.z = VISIBLE_Z
		  @spriteContinueGame.z = HIDDEN_Z
		when 2 # Achievements
		  @spriteAchievementsSelected.z = VISIBLE_Z
		  @spriteAchievements.z = HIDDEN_Z
		when 3 # Credits
		  @spriteCreditsSelected.z = VISIBLE_Z
		  @spriteCredits.z = HIDDEN_Z
		when 4  # Exit Game Is Selected
		  @spriteExitGameSelected.z = VISIBLE_Z
		  @spriteExitGame.z = HIDDEN_Z
		end
  end
  
  # private
  def hide_menu_items
	@spriteNewGameSelected.z = HIDDEN_Z
	@spriteNewGame.z = VISIBLE_Z

	@spriteContinueGameSelected.z = HIDDEN_Z
	@spriteContinueGame.z = VISIBLE_Z
	 
	@spriteAchievementsSelected.z = HIDDEN_Z
	@spriteAchievements.z = VISIBLE_Z
	 
	@spriteCreditsSelected.z = HIDDEN_Z
	@spriteCredits.z = VISIBLE_Z
		  
	@spriteExitGameSelected.z = HIDDEN_Z
	@spriteExitGame.z = VISIBLE_Z
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    
    if Input.trigger?(:DOWN)
	  check_input
    end
    if Input.repeat?(:DOWN)
	  check_input
    end
    
    if Input.trigger?(:UP)
	  check_input
    end
    if Input.repeat?(:UP)
	  check_input
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Continue is Enabled
  #--------------------------------------------------------------------------
  def check_continue
    @continue_enabled = (Dir.glob('Save*.rvdata2').size > 0)
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @sprite1 = Sprite.new
    @sprite1.bitmap = Cache.title1( $data_system.title1_name )
    @sprite2 = Sprite.new
    @sprite2.bitmap = Cache.title2( $data_system.title2_name )
    center_sprite( @sprite1 )
    center_sprite( @sprite2 )
    
    # Creates The Continue Game Image
    @spriteContinueGame = Sprite.new
    @spriteContinueGame.bitmap = Cache.system( TitleMenu::CONTINUE_IMAGE )
    @spriteContinueGame.x = ( ( Graphics.width / 2 ) - (@spriteContinueGame.bitmap.width / 2 ) )
    @spriteContinueGame.y = ( ( Graphics.height / 2 ) - (@spriteContinueGame.bitmap.height / 2 ) )
    @spriteContinueGame.z = VISIBLE_Z
    
    # Creates The Continue Game Selected Image
    @spriteContinueGameSelected = Sprite.new
    @spriteContinueGameSelected.bitmap = Cache.system( TitleMenu::CONTINUE_SELECTED_IMAGE )
    @spriteContinueGameSelected.x = ( ( Graphics.width / 2 ) - ( @spriteContinueGameSelected.bitmap.width / 2 ) )
    @spriteContinueGameSelected.y = ( ( Graphics.height / 2 ) - ( @spriteContinueGameSelected.bitmap.height / 2 ) )
    @spriteContinueGameSelected.z = HIDDEN_Z
    
    # Applies The Opacity If Continue Is Disabled
    if !@continue_enabled
	  @spriteContinueGame.opacity = TitleMenu::CONTINUE_DISABLED_OPACITY
	  @spriteContinueGameSelected.opacity = TitleMenu::CONTINUE_DISABLED_OPACITY
    end
    
    # Creates The New Game Image
    @spriteNewGame = Sprite.new
    @spriteNewGame.bitmap = Cache.system( TitleMenu::NEW_IMAGE )
    @spriteNewGame.x = ( ( Graphics.width / 2 ) - ( @spriteNewGame.bitmap.width / 2 ) )
    @spriteNewGame.y = ( ( Graphics.height / 2 ) - ( @spriteNewGame.bitmap.height / 2 ) ) - ( @spriteContinueGame.bitmap.height + TitleMenu::PADDING )
    @spriteNewGame.z = HIDDEN_Z
    
    # Creates The New Game Selected Image
    @spriteNewGameSelected = Sprite.new
    @spriteNewGameSelected.bitmap = Cache.system( TitleMenu::NEW_SELECTED_IMAGE )
    @spriteNewGameSelected.x = ( ( Graphics.width / 2 ) - ( @spriteNewGameSelected.bitmap.width / 2 ) )
    @spriteNewGameSelected.y = ( ( Graphics.height / 2 ) - ( @spriteNewGameSelected.bitmap.height / 2 ) )  - ( @spriteContinueGame.bitmap.height + TitleMenu::PADDING )
    @spriteNewGameSelected.z = HIDDEN_Z
    
    # Creates The Achievements Image
    @spriteAchievements = Sprite.new
    @spriteAchievements.bitmap = Cache.system( TitleMenu::ACHIEVEMENTS_IMAGE )
    @spriteAchievements.x = ( ( Graphics.width / 2 ) - ( @spriteAchievements.bitmap.width / 2 ) )
    @spriteAchievements.y = @spriteContinueGame.bitmap.y + @spriteContinueGame.bitmap.height + TitleMenu::PADDING 
    @spriteAchievements.z = HIDDEN_Z
    
    # Creates The Achievements Selected Image
    @spriteAchievementsSelected = Sprite.new
    @spriteAchievementsSelected.bitmap = Cache.system( TitleMenu::ACHIEVEMENTS_IMAGE_SELECTED )
    @spriteAchievementsSelected.x = @spriteAchievements.x
    @spriteAchievementsSelected.y = @spriteAchievements.y
    @spriteNewGameSelected.z = HIDDEN_Z
    
	# Creates The Credits Image
    @spriteCredits = Sprite.new
    @spriteCredits.bitmap = Cache.system( TitleMenu::CREDITS_IMAGE )
    @spriteCredits.x = ( ( Graphics.width / 2 ) - ( @spriteAchievements.bitmap.width / 2 ) )
    @spriteCredits.y = @spriteAchievements.bitmap.y + @spriteAchievements.bitmap.height + TitleMenu::PADDING 
    @spriteCredits.z = HIDDEN_Z
    
    # Creates The Achievements Selected Image
    @spriteCreditsSelected = Sprite.new
    @spriteCreditsSelected.bitmap = Cache.system( TitleMenu::CREDITS_IMAGE_SELECTED )
    @spriteCreditsSelected.x = @spriteCredits.x
    @spriteCreditsSelected.y = @spriteCredits.y
    @spriteCreditsSelected.z = HIDDEN_Z
    
    # Creates The Exit Game Image
    @spriteExitGame = Sprite.new
    @spriteExitGame.bitmap = Cache.system( TitleMenu::EXIT_IMAGE )
    @spriteExitGame.x = @spriteCredits.x
    @spriteExitGame.y = spriteCredits.bitmap.y + @spriteCredits.bitmap.height + TitleMenu::PADDING 
    @spriteExitGame.z = VISIBLE_Z
    
    # Creates The Exit Game Selected Image
    @spriteExitGameSelected = Sprite.new
    @spriteExitGameSelected.bitmap = Cache.system( TitleMenu::EXIT_SELECTED_IMAGE )
    @spriteExitGameSelected.x = @spriteExitGame.x
    @spriteExitGameSelected.y = @spriteExitGame.y
    @spriteExitGameSelected.z = HIDDEN_Z
    
    # Applies The Offset To The Continue Game Images
    @spriteContinueGame.x -= TitleMenu::X_OFFSET
    @spriteContinueGame.y -= TitleMenu::Y_OFFSET
    @spriteContinueGameSelected.x -= TitleMenu::X_OFFSET
    @spriteContinueGameSelected.y -= TitleMenu::Y_OFFSET
    
    # Applies The Offset To The New Game Images
    @spriteNewGame.x -= TitleMenu::X_OFFSET
    @spriteNewGame.y -= TitleMenu::Y_OFFSET
    @spriteNewGameSelected.x -= TitleMenu::X_OFFSET
    @spriteNewGameSelected.y -= TitleMenu::Y_OFFSET
    
    # Applies The Offset to credits/achievements
    @spriteCredits.x -= TITLEMENU::X_OFFSET
    @spriteCredits.y -= TITLEMENU::Y_OFFSET
    @spriteCreditsSelected.x -= TitleMenu::X_OFFSET
    @spriteCreditsSelected.y -= TitleMenu::Y_OFFSET
    @spriteAchievements.x -= TITLEMENU::X_OFFSET
    @spriteAchievements.y -= TITLEMENU::Y_OFFSET
    @spriteAchievementsSelected.x -= TitleMenu::X_OFFSET
    @spriteAchievementsSelected.y -= TitleMenu::Y_OFFSET
    
    # Applies The Offset To The Exit Game Images
    @spriteExitGame.x -= TitleMenu::X_OFFSET
    @spriteExitGame.y -= TitleMenu::Y_OFFSET
    @spriteExitGameSelected.x -= TitleMenu::X_OFFSET
    @spriteExitGameSelected.y -= TitleMenu::Y_OFFSET    
  end
  #--------------------------------------------------------------------------
  # * Dispose Background
  #--------------------------------------------------------------------------
  def dispose_background
    @sprite1.bitmap.dispose
    @sprite1.dispose
    @sprite2.bitmap.dispose
    @sprite2.dispose
    
    @spriteNewGame.bitmap.dispose
    @spriteNewGame.dispose
    @spriteNewGameSelected.bitmap.dispose
    @spriteNewGameSelected.dispose
    
    @spriteContinueGame.bitmap.dispose
    @spriteContinueGame.dispose
    @spriteContinueGameSelected.bitmap.dispose
    @spriteContinueGameSelected.dispose
    
    @spriteAchievements.bitmap.dispose
    @spriteAchievements.dispose
    @spriteAchievementsSelected.bitmap.dispose
    @spriteAchievementsSelected.dispose
    
    @spriteCredits.bitmap.dispose
    @spriteCredits.dispose
    @spriteCreditsSelected.bitmap.dispose
    @spriteCreditsSelected.dispose
    
    @spriteExitGame.bitmap.dispose
    @spriteExitGame.dispose
    @spriteExitGameSelected.bitmap.dispose
    @spriteExitGameSelected.dispose
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
	# Called when the window is first made.
    @command_window = Window_TitleCommand.new
    @command_window.set_handler(:new_game, method(:command_new_game))
    @command_window.set_handler(:continue, method(:command_continue))
    @command_window.set_handler(:achievements, method(:command_achievements))
    @command_window.set_handler(:credits, method(:command_credits))
    @command_window.set_handler(:shutdown, method(:command_shutdown))    
    @command_window.z = HIDDEN_Z
    @spriteNewGame.z = VISIBLE_Z
  end
  #--------------------------------------------------------------------------
  # * [Continue] Command
  #--------------------------------------------------------------------------
  def command_continue
    if @continue_enabled
	  close_command_window
	  SceneManager.call(Scene_Load)
    end
  end
  
  def command_achievements
  end
  
  def command_credits
  end
end # Scene_Title
