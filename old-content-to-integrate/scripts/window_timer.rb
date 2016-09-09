=begin
#==============================================================================
 ** Window Timer
 Author: Hime
 Date: Oct 20, 2012
------------------------------------------------------------------------------
 ** Change log
 Oct 20, 2012
   - initial release
------------------------------------------------------------------------------   
 ** Terms of Use
 * Free to use in non-commercial projects
 * Contact me for commercial use
 * No real support. The script is provided as-is
 * Will do bug fixes, but no compatibility patches
 * Features may be requested but no guarantees, especially if it is non-trivial
 * Preserve this header
------------------------------------------------------------------------------
 ** Description
 
 Adds a timer to a windows that allows it to do something. By default just 
 closes the window.
 
 This script provides auto-timer functionality to the following windows
   Window_Message
   Window_ChoiceList
   
 Simply include the control character
 
   \T[x]
   
 In the message, where x is the number of seconds to time-out.
 If T doesn't work you can change it to another letter.
 
 Messages will automatically proceed if it times out.
 
 Choices will default to the time-out choice, which is the last choice that
 is tagged with a timer control (so even if you have several, the last one is
 taken)
 
#==============================================================================
=end
$imported = {} if $imported.nil?
$imported["Tsuki_WindowTimer"] = true
#==============================================================================
# ** Configuration
#==============================================================================    
module Tsuki
  module Window_Timer
    
    # What character to use
    Timer_Control = "T"
#==============================================================================
# ** Rest of the script
#==============================================================================    
    Timer_Regex = /\\#{Timer_Control}\[\d+\]/i
  end
end

class Game_Message
  
  attr_accessor :choice_timeout
  
  alias :th_window_timer_clear :clear
  def clear
    th_window_timer_clear
    @choice_timeout = 0
  end
end

class Game_Interpreter
  
  alias :th_window_timer_setup_choices :setup_choices
  def setup_choices(params)
    th_window_timer_setup_choices(params)
  
    # The choice tagged with a timer is the time-out choice
    # Takes precedence over cancel choice
    params[0].each_with_index {|s, i|
      if s.match(Tsuki::Window_Timer::Timer_Regex)
        $game_message.choice_timeout = i + 1
        break
      end
    }
  end
end

# Provide some basic timer functionality to all windows
class Window_Base
  
  alias :th_window_timer_init :initialize
  def initialize(x, y, width, height)
    th_window_timer_init(x, y, width, height)
    @auto_close = 0
  end
  
  alias :th_window_timer_update :update
  def update
    th_window_timer_update
    update_timer if @auto_close > 0
  end
  
  def update_timer
    @auto_close -= 1
    update_timeout if @auto_close == 0
  end
  
  # By default, window just closes
  def update_timeout
    close
  end
  
  # convert to frames
  def set_timer(seconds)
    @auto_close = seconds * Graphics.frame_rate
  end
  
  # add new escape char for auto-timing
  alias :th_window_timer_process_escape_character :process_escape_character
  def process_escape_character(code, text, pos)
    case code.upcase
    when Tsuki::Window_Timer::Timer_Control
      set_timer(obtain_escape_param(text))
    end
    th_window_timer_process_escape_character(code, text, pos)
  end
end

# Window message can also auto-skip
class Window_Message
  
  def update_timeout
    super
    $game_message.clear
    @fiber = nil
  end
end

# Provide functionality for time-out choice selection
class Window_ChoiceList < Window_Command
  
  # If user makes a choice before time-out then ignore time-out
  def update_timeout
    super
    return if $game_message.choice_timeout == 0
    deactivate
    call_timeout_handler
  end
  
  def call_timeout_handler
    $game_message.choice_proc.call($game_message.choice_timeout - 1)
    close
  end
end
