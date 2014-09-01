#========================================================================
# ** Better Game Timer
#    By: ashes999 (ashes999@yahoo.com)
#    Version: 0.1
#------------------------------------------------------------------------
# * Description:
#
# -- Some extensions to make the timer a bit more useful and friendly.
# -- Original methods by Tsukihime (to add/lose time and pause/resume)
# -- You can also make the game time recolour if time is under some value (eg. 30s)
# -- via the CRITICAL_TIME_SECONDS constant.
# -- Finally, the timer pauses when message boxes, choices, etc. are visible.
# -- Author: ashes999 (ashes999@yahoo.com)
# -- Version 1.0

# Examples:
#  $game_timer.add_time(20) # adds 20 seconds
#  $game_timer.lose_time(15) # subtract 15 seconds
#  $game_timer.pause
#  $game_timer.resume
#========================================================================

# If remaining time is less than this many seconds, turn red. To disable, set to 0.
CRITICAL_TIME_SECONDS = 5

# End configuration

class Game_Timer

  alias timer_plus_update update
  def update
    if !@pause
      timer_plus_update unless $game_message.visible
    end	
  end

  # add more time, in seconds
  def add_time(count)
    @count += count * Graphics.frame_rate
  end

  # subtract time, in seconds
  def lose_time(count)
    @count = [@count - (count * Graphics.frame_rate), 0].max
  end

  def pause
    @pause = true
  end

  def resume
    @pause = false
  end
end

#==============================================================================
# ** Sprite_Timer
#------------------------------------------------------------------------------
#  This sprite is for timer displays. It monitors $game_timer and automatically 
# changes sprite states.
#==============================================================================

class Sprite_Timer < Sprite
  alias timer_plus_sprite_update update
  def update
    timer_plus_sprite_update
    update_color 
  end

  def update_color
    if @total_sec > 0 && @total_sec <= CRITICAL_TIME_SECONDS
      self.bitmap.font.color.set(255, 0, 0)    
    end
  end
end
