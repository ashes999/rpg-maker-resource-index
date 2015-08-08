#=============================================================================
#	Persistent Data: store and access data that persists across all save games.
#      Note: data is stored in the file specified in @@FILENAME below.
#=============================================================================
# --- Author:			Haris1112 (hk12@live.ca)
# --- Version:			1.0.0
#=============================================================================
#  Use PersistentData.set(key, value) to add an object,
#  and PersistentData.get(key) to get it back.
#  To remove persistet data, set the value to nil.
#=============================================================================
module PersistentData
  # File to save persitant data to, with extension.
  @@FILENAME = "persist.dat"
  
  def self.load_data 
	File.open(@@FILENAME, "rb") do |file|
	  contents = Marshal.load(file)
	  return contents
    end
  end
  
  def self.save_data(data)
    File.open(@@FILENAME, "wb") do |file|
      Marshal.dump(data, file)
    end
  end
  
  def self.has?(key)
    contents = load_data
	return contents.has_key?(key)
  end
  
  def self.set(key, value)
    contents = load_data
	contents[key] = value	
	save_data(contents)
  end
  
  def self.get(key)
    contents = load_data
    return contents[key]
  end
end
