#=============================================================================
#	Custom Saving System: allows you to add any data to the current save game.
#      Data is automatically loaded and saved to the current save game.
#=============================================================================
# --- Author:			Haris1112 (hk12@live.ca), Ashes999 (ashes999@yahoo.com)
# --- Version:			1.1.1
#=============================================================================
#  Use DataManager.set(key, value) to add an object,
#  and DataManager.get(key) to get it back.
#=============================================================================
module DataManager

  @@contents = {}
  @@initial_contents = {}

  # Loading
  class << self
    alias :load_contents :extract_save_contents
  end
  def self.extract_save_contents(contents)
    load_contents(contents)
    @@contents.each do |k, v|
	  @@contents[k] = contents[k]
    end
  end

  # Saving
  class << self
    alias :save_contents :make_save_contents
  end
  def self.make_save_contents
    contents = save_contents
    @@contents.each do |key, value|
      contents[key] = value
    end
	
	return contents
  end
  
  class << self
    alias :on_new_game :setup_new_game
  end
  def self.setup_new_game	
    on_new_game
	setup(@@initial_contents)
  end

  def self.setup(hash)	
	@@initial_contents = hash
	
    @@contents = {}
    @@initial_contents.each do |key, value|
	  @@contents[key] = value
    end
  end
  
  def self.get(key)
    return @@contents[key]
  end

  def self.set(key, value)
    @@contents[key] = value
  end
end
