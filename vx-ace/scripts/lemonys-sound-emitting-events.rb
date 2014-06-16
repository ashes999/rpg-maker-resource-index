# Source: http://forums.rpgmakerweb.com/index.php?/topic/2167-new-event-type-sounds/?p=23782
#==============================================================================
# ** Lemony's Sound Emitting Events
#------------------------------------------------------------------------------
# * This little script allows to make certain events play music/sounds based
# on player proximity.
# * It is currently limited by one bgs at a time, resulting in lag if one
# sound emitting event's area is overlapping other's sound emitting event area.
#------------------------------------------------------------------------------
# To use it, simple make a comment inside the target event with the following
# LSEE TYPE RANGE PITCH VOLUME FILENAME => LSEE BGS 8 100 100 Fire
# If type is SE or ME, you need two additional variables
# LSEE TYPE RANGE PITCH VOLUME FILENAME DELAY_SECONDS RANDOM_SECONDS
#==============================================================================
class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * Refresh Alias
  #--------------------------------------------------------------------------
  alias lemony_see_refresh refresh
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
        lemony_see_refresh
        return if (@page.nil? || @page.list.nil?)
        @page.list.each {|p| b = p.parameters[0]
        s, @lsee_out = (b != nil && b.is_a?(String)) ? b.split : '', false
        if (p.code == 108 || p.code == 408) && b.include?('LSEE')
          @lsee_data = [s[1], s[2], s[3].to_i, s[4], s[5], s[6].to_i, s[7].to_i]
          break if @lsee_data != nil
        else @lsee_out = true end}
  end
  #--------------------------------------------------------------------------
  # * Update Alias
  #--------------------------------------------------------------------------
  alias lemony_see_update update
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
        lemony_see_update
        if !@lsee_data.nil?
          xx, yy = (@real_x - $game_player.real_x), (@real_y - $game_player.real_y)
          close = (Math.sqrt((xx * xx) + (yy * yy)) <= @lsee_data[1].to_i)
          r, d = @lsee_data[1].to_i, Math.sqrt((xx * xx) + (yy * yy))
          v, go, ms = (r - (d - 1 % r)) * @lsee_data[3].to_i / r, true, ['ME', 'SE']
          if !@lsee_out
                if ms.include?(@lsee_data[0])
                  @lsee_timer ||= ((@lsee_data[5] + rand(@lsee_data[6])) * Graphics.current_fps)
                  @lsee_timer = [@lsee_timer - 1, 0].max
                  go = @lsee_timer <= 0
                  @lsee_timer = nil if go
                end
                out = (!@lsee_data[7].nil? && (@lsee_data[7].volume > 0 && !close)) && go
                f = "#{@lsee_data[0]}.new('#{@lsee_data[4]}', #{v}, #{@lsee_data[2]})"
                @lsee_data[7] ||= eval("RPG::" + f) if close && go
                @lsee_data[7].volume = v if !@lsee_data[7].nil? && close
                @lsee_data[7].play if ((!@lsee_data[7].nil? && close) && go) || out
                @lsee_data[7].volume -= 1 if !@lsee_data[7].nil? && !close
                @lsee_data[7] = nil if (!@lsee_data[7].nil? && @lsee_data[7].volume <= 0)
          elsif @lsee_out
                @lsee_data[7].volume -= 1 if !@lsee_data[7].nil?
                @lsee_data[7].play if !@lsee_data[7].nil? && !ms.include?(@lsee_data[0])
                if (!@lsee_data[7].nil? && @lsee_data[7].volume <= 0)
                  @lsee_data, @lsee_out = nil, false
                end
          end
        end
  end
end