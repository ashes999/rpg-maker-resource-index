#==============================================================================
# ** Proton Analytics
#	 By: ashes999 (ashes999@yahoo.com)
#    Ver: 1.0
#------------------------------------------------------------------------------
#  * Description:
#  Collections session and event data for your RPG Maker VX Ace game.
#==============================================================================
class ProtonAnalytics
  
  ### DEFINE VARIABLES HERE ###
  
  @secret = 'BF468887-FBEA-4CE7-B967-07B1A43C58DE'
  @version = '1.1'
  @platform = 'Windows'
  
  ### END DEFINE VARIABLES ###
  
  @disabled = false
  
  def self.start_new_session
    begin
      self.invoke('StartNewSession', nil, nil, nil);
    rescue
      @disabled = true
    end  
  end
  
  def self.add_event(event, param_name = nil, param_value = nil)
    self.invoke('AddEvent', event, param_name, param_value)
  end
  
  def self.invoke(command, param1, param2, param3)
    begin
      params = " \"#{param1}\" \"#{param2}\" \"#{param3}\""
      spawn("System\\Proton32 #{@secret} #{@version} #{@platform} #{command} #{params}")
    rescue
      # temporary failure? try again later.
    end
  end
  
end
