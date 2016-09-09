#=============================================================================
#	Custom Saving System: allows you to add any data to the current save game.
#      Data is automatically loaded and saved to the current save game.
#=============================================================================
# --- Author:			Haris1112 (hk12@live.ca), Ashes999 (ashes999@yahoo.com)
# --- Version:			1.1.2
#=============================================================================
#  Use DataManager.set(key, value) to add an object,
#  and DataManager.get(key) to get it back.
#=============================================================================
module DataManager

  @contents = {}
  
  # Loading
  class << self
    alias :old_extract_save_contents :extract_save_contents
    alias :old_make_save_contents :make_save_contents
    alias :old_setup_new_game :setup_new_game
  end
    
  def self.extract_save_contents(contents)
    old_extract_save_contents(contents)
    
    contents.each do |k, v|
	    @contents[k] = contents[k]
    end    
  end
  
  # Takes a function with a map argument: do whatever it is to set up parameters
  # and stuff you need on a new-game, and/or things to reset between starting a
  # new game and/or loading save games.
  def self.setup(callback)
    @callback = callback
  end

  # Saving
  def self.make_save_contents
    contents = old_make_save_contents
    @contents.each do |key, value|
      contents[key] = value
    end
	
    return contents
  end
  
  def self.setup_new_game    
    Logger.log(Kernel.caller)
    old_setup_new_game
    @contents = {}
    @callback.call(@contents)
  end

  def self.get(key)
    return @contents[key]
  end

  def self.set(key, value)
    @contents[key] = value
  end
end
