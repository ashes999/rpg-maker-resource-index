#===============================================================================
# Splash Screens
# By Jet10985 (Jet)
#===============================================================================
# This script will add a splash screen of pictures and such before the title
# screen.
# This script has: 7 customization options.
#===============================================================================
# Overwritten Methods:
# None
#-------------------------------------------------------------------------------
# Aliased methods:
# Scene_Title: new
#===============================================================================
=begin
NOTE:

All pictures used here much be in the Graphics/Pictures folder.
All sounds used here must be in the Audio/SE folder.
=end

module JetSplashScreen
  
  # These are the pictures that will be cycled through in the splash scene
  SPLASH_PICTURES = ["logo-horizontal", "muslimgamer"]
  
  # These are SE that will be played for each picture. The SE will play
  # with the same picture that shares the index.
  # If you don't want an SE to play with a picture, fill the index with ""
  SPLASH_SOUNDS = ["nightingale", "heartbeat"]
  
  # Do you want to skip the splash scene in testing mode?
  SPLASH_DISABLED_IN_DEBUG = false
  
  # Do you want the splash screen skippable in the actual game as well?
  SPLASH_SKIPPABLE = true
  
  # If SPLASH_SKIPPABLE is true, what button should be pressed to skip it?
  # Note: Input::C is the enter button
  SPLASH_SKIP_BUTTON = Input::C
  
  #=============================================================================
  # Harder Config (For those who know how to configure well)
  #=============================================================================
  
  # Enabling this ignore the SPLASH_PICTURES and SPLASH_SOUNDS config above
  ENABLE_HARDER_CONFIG = true
  
  # This is the config for a cooler looking splash scene.
  # It follows this format:
  # picture_name => [se_name, anim_id, fadein_time, fadeout_time, frame_time]
  # se_name is the SE to be played with the picture. Use "" for no SE
  # anim_id is the animation to be played ontop of the picture. Use 0 for none
  # fadein_time is how many frames it takes to fade into the picture
  # fadeout_time is how many frames it takes to fadeout to the next picture
  # frame_time is how long the picture stays on the screen before fading out
  SUPER_SPLASH = {
  
  "logo-horizontal" => ["nightingale", 0, (0.5 * Graphics.frame_rate).to_i,
        (0.5 * Graphics.frame_rate).to_i, (4.5 * Graphics.frame_rate).to_i],
        
  "muslimgamer" => ["heartbeat", 0, (0.5 * Graphics.frame_rate).to_i,
        (0.5 * Graphics.frame_rate).to_i, (4.5 * Graphics.frame_rate).to_i]
  
  }
  
end
#===============================================================================
# DO NOT EDIT PAST HERE UNLESS YOU KNOW WHAT TO DO
#===============================================================================

class Scene_Splash < Scene_Base
  
  include JetSplashScreen
  
  def start
    if ENABLE_HARDER_CONFIG
      do_super_splash
    else
      create_sprites
      create_sounds
      do_splash
    end
  end
  
  def terminate
    return if @sprites.nil?
    for sprite in @sprites
      sprite.dispose
      sprite = nil
    end
  end
  
  def create_sprites
    @sprites = []
    for pic in SPLASH_PICTURES
      f = Cache.picture(pic)
      g = Sprite_Base.new
      g.bitmap = f
      g.visible = false
      @sprites << g
    end
  end
  
  def create_sounds
    @sounds = []
    for sound in SPLASH_SOUNDS
      @sounds << RPG::SE.new(sound, 100, 100)
    end
  end
  
  def do_splash
    Graphics.transition
    Graphics.fadeout(60)
    for sprite in @sprites
      sprite.visible = true
      Graphics.fadein(60)
      begin
        @sounds[@sprites.index(sprite)].play
      rescue
      end
      180.times do
        Input.update if SPLASH_SKIPPABLE
        if Input.trigger?(SPLASH_SKIP_BUTTON)
          RPG::SE.stop
          SceneManager.call(Scene_Title)
          break
        end
        Graphics.wait(1)
      end
      Graphics.fadeout(60)
      sprite.visible = false
    end
    $jet6667876666765 = true
    SceneManager.call(Scene_Title)
  end
  
  def do_super_splash
    Graphics.transition
    Graphics.fadeout(1)
    for sprite in SUPER_SPLASH.keys
      q = Sprite_Base.new
      q.bitmap = Cache.picture(sprite)
      Graphics.fadein(SUPER_SPLASH[sprite][2])
      begin
        RPG::SE.new(SUPER_SPLASH[sprite][0], 100, 100).play
      rescue
      end
      anim = load_data("Data/Animations.rvdata2")[SUPER_SPLASH[sprite][1]]
      if SUPER_SPLASH[sprite][1] != 0
        q.start_animation(anim)
      end
      SUPER_SPLASH[sprite][4].times do
        Input.update if SPLASH_SKIPPABLE
        if Input.trigger?(SPLASH_SKIP_BUTTON)
          RPG::SE.stop
          SceneManager.call(Scene_Title)
          break
        end
        q.update
        Graphics.update
      end
      Graphics.fadeout(SUPER_SPLASH[sprite][3])
    end
    $jet6667876666765 = true
    SceneManager.call(Scene_Title)
  end
end

class << Scene_Title
  
  alias jet6732_new new
  def new(*args)
    $jet6667876666765 = false if $jet6667876666765.nil?
    if $jet6667876666765 or JetSplashScreen::SPLASH_DISABLED_IN_DEBUG && $TEST
      jet6732_new(*args)
    else
      SceneManager.call(Scene_Splash)
    end
  end
end