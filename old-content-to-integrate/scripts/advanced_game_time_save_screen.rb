#========================================================================
# ** Advanced Game Time: Save Screen
#    By: ashes999 (ashes999@yahoo.com)
#    Version: 1.0
#------------------------------------------------------------------------
# * Description:
# Displays the current time, instead of the total play time, on save slots.
# Used with Advanced Game Time.
#========================================================================

module DataManager
  class << self
    alias :base_save_header :make_save_header  
  end
  
  def self.make_save_header    
    header = base_save_header    
    header[:game_time] = $game_time
    return header
  end
end

class Window_SaveFile < Window_Base
  def draw_playtime(x, y, width, align)
    header = DataManager.load_header(@file_index)
    return unless header
    game_time = header[:game_time]
    hour = game_time.hour
    suffix = 'am'
    if hour > 12 then
      hour -= 12
      suffix = 'pm'
    end
    minute = game_time.min
    minute = "0#{minute}" if minute.to_s.length == 1
    draw_text(x, y, width, line_height, "#{hour}:#{minute} #{suffix}", 2)	
  end
end
