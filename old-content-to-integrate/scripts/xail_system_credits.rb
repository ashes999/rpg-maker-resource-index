# Source: http://niclas-thornqvist.se/rpg/scripts/ace/xs-credits.txt
#==============================================================================
#   XS - Credits
#   Author: Nicke
#   Created: 02/09/2012
#   Edited: 20/01/2013
#   Version: 1.0b
#==============================================================================
# Instructions
# -----------------------------------------------------------------------------
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ? Materials but above ? Main. Remember to save.
#==============================================================================
# Requires: XS - Core Script.
#==============================================================================
# Will return to title scene when the process is done.
# Simple credit scene. Setup text and background to be displayed.
#
# To call this scene simply use on of the following codes in a script call:
# SceneManager.call(Scene_Credits)
# SceneManager.goto(Scene_Credits)
#
# Note: This scene should only be called at the appropriate time.
# For example when the player complete the game.
#
# *** Only for RPG Maker VX Ace. ***
#==============================================================================
($imported ||= {})["XAIL-CREDITS"] = true

module XAIL
  module CREDITS
  #--------------------------------------------------------------------------#
  # * Settings
  #--------------------------------------------------------------------------#
    # FONT = [name, size, color, bold, shadow]
    FONT = [["Anklada", "Verdana"], 24, Color.new(255,255,255), true, true]
    
    # Setup music to be played.
    # Set to nil to disable.
    # MUSIC = [name, pitch, volume]
    MUSIC = ["Town3", 100, 80]
    
    # Fade out music in milliseconds.
    # MUSIC_FADE = number
    MUSIC_FADE = 1000
    
    # Setup the credit text/background here.
    # CREDIT = 
    #[bg, credit_text, text_x, text_y, bg_x, bg_y, wait (can be nil), 
    # fade_in, fade_out, bg_stay?, credit_text_stay?, end_delay]
    CREDIT = {
    0 => [
      "Fog04", "Created by...", 210, -80, 0, 0, 120, 50, 255, true, false, 120
    ],
    1 => [
      "Fog04", "People 1", 210, -40, 0, 0, 120, 50, 255, true, false, 120
    ],
    2 => [
      "Fog04", "People 2", 210, 0, 0, 0, 120, 50, 255, false, false, 120
    ],
    3 => [
      "Fog06", "Copyright 2012", 210, 0, 0, 0, 120, 50, 255, true, false, 120
    ],
    } # Don't remove this line.

    # Delay before going to title scene after everything is processed.
    # END_DELAY = number
    END_DELAY = 500
    
  end
end
# *** Don't edit below unless you know what you are doing. ***
#==============================================================================#
# ** Error Handler
#==============================================================================#
  unless $imported["XAIL-XS-CORE"]
    # // Error handler when XS - Core is not installed.
    msg = "The script %s requires the latest version of XS - Core in order to function properly."
    name = "XS - Credits"
    msgbox(sprintf(msg, name))
    exit
  end
#==============================================================================#
# ** Scene_Credits
#==============================================================================#
class Scene_Credits < Scene_Base
  
  def initialize
    # // Method to initialize the scene.
    Graphics.fadeout(30)
    delay?(40)
    setup_dummy_bg
    delay?(40)
    Graphics.fadein(30)
    setup_music unless XAIL::CREDITS::MUSIC.nil?
    setup_credit
  end
  
  def update
    # // Method to update the scene.
    super
    goto_title
  end

  def terminate
    # // Method to terminate the scene.
    dispose_dummy_bg
  end
  
  def dispose_dummy_bg
    # // Method to dispose dummy background.
    @dummy_bg = nil, @dummy_bg.dispose unless @dummy_bg.nil?
  end
  
  def dispose_credit
    # // Method to dispose credit.
    @bgs = nil, @bgs.dispose unless @bgs.nil?
    @texts = nil, @texts.dispose unless @texts.nil? or @texts[0].nil?
  end

  def setup_dummy_bg
    # // Method to setup dummy background.
    @dummy_bg = Sprite.new
    b = Bitmap.new(Graphics.width, Graphics.height)
    @dummy_bg.bitmap = b
    b.fill_rect(b.rect, Color.new(0,0,0))
  end
  
  def setup_music
    # // Method to play a bgm.
    bgm = XAIL::CREDITS::MUSIC
    Sound.play(bgm[0], bgm[1], bgm[2], :bgm)
  end
  
  def setup_credit
    # // Method to setup the credit(s).
    c = XAIL::CREDITS::CREDIT
    c.keys.each {|i| display_credit(c[i])}
  end
  
  def delay?(amount)
    # // Method to delay.
    if amount.nil?
      loop do
        update_basic
      end
    else
      amount.times do
        update_basic
      end
    end  
  end  
  
  def display_credit(credit)
    # // Method to display a text.
    return if credit.nil?
    unless credit[0].nil?
      begin 
        @bgs = Sprite.new
        @bgs.z = 1
        @bgs.x, @bgs.y = credit[4], credit[5]
        @bgs.bitmap = Cache.picture(credit[0])
      rescue
        msgbox("Error. Unable to locate background image: " + credit[0])
        exit
      end
    end
    unless credit[1].nil?
      @texts = Sprite.new
      @texts.z = 2
      @texts.bitmap = Bitmap.new(Graphics.width, Graphics.height)
      @texts.bitmap.font.name = XAIL::CREDITS::FONT[0]
      @texts.bitmap.font.size = XAIL::CREDITS::FONT[1]
      @texts.bitmap.font.color = XAIL::CREDITS::FONT[2]
      @texts.bitmap.font.bold = XAIL::CREDITS::FONT[3]
      @texts.bitmap.font.shadow = XAIL::CREDITS::FONT[4]
      @texts.bitmap.draw_text(credit[2], credit[3], Graphics.width, Graphics.height, credit[1]) 
    end
    for i in 1..credit[7]
      update_basic
      @bgs.opacity = i * (255 / credit[7])
      @texts.opacity = i * (255 / credit[7])
    end
    delay?(credit[6])
    for i in 1..credit[8]
      update_basic
      @bgs.opacity = 255 - i * (255 / credit[8]) unless credit[9]
      @texts.opacity = 255 - i * (255 / credit[8]) unless credit[10]
    end
    delay?(credit[11])
    unless credit[9]
      @bgs = nil, @bgs.dispose unless @bgs.nil?
    end
    unless credit[10]
      @texts = nil, @texts.dispose unless @texts.nil?
    end
  end
  
  def goto_title
    # // Method to go to title scene.
    Graphics.fadeout(30)
    dispose_credit
    RPG::BGM.fade(XAIL::CREDITS::MUSIC_FADE)
    delay?(XAIL::CREDITS::END_DELAY)
    RPG::BGM.stop
    SceneManager.goto(Scene_Title)
    Graphics.fadein(30)
  end
  
end # END OF FILE

#=*==========================================================================*=#
# ** END OF FILE
#=*==========================================================================*=#
