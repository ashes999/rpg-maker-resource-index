# Source: http://forums.rpgmakerweb.com/index.php?/topic/2213-constant-vs-variable-fps/?p=24257
#==============================================================================
# ** Lemony's Current FPS
#------------------------------------------------------------------------------
# - Graphics.current_fps gets the FPS at the moment it was called.
#==============================================================================
module Graphics
  @timelapse_a, @timecounter, @current_fps = Time.now, 10, Graphics.frame_rate
  class << self
        attr_reader :current_fps
        alias lfps_update update
          def update
          lfps_update
          if (Time.now - @timelapse_a) > 0.1
                @current_fps = (@timecounter / (Time.now - @timelapse_a)).to_i
                @timelapse_a, @timecounter = Time.now, 0
          end
          @timecounter += 1
        end   
  end
end