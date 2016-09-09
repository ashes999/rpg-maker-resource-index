###
# EXTERNAL DATA, v1.0.0
# By ashes999 (@yahoo.com)
#
# Allows you to externalize variables so they can be tweaked without editing the game
# in RPG Maker (eg. an artist/designer can tweak variables and quickly re-test).
# NOTE: This script requires the json_parser script.
# 
# Create a JSON file in Data/external.json, and keep all your variables in a hash
# eg. { 'number_of_npcs': 6, 'run_speed': 12 }
# 
# To access them, call ExternalData::instance.get(key)
# eg. ExternalData::instance.get(:run_speed)
#
# If you change the file while the game is running, the new contents will automatically be
# reloaded when you call ExternalData::instance.
###
class ExternalData
  FILENAME = 'Data/external.json'
  
  def self.instance
    @@instance ||= ExternalData.new
    @@instance.refresh_data_if_needed
    return @@instance
  end
  
  def get(key)
    key = key.to_sym
    raise "#{key} isn't a valid extern; did you mean one of: #{@externs.keys}" unless @externs.key?(key)
    return @externs[key]
  end
  
  def refresh_data_if_needed
    mtime = File.mtime(FILENAME)
    if mtime != @last_mtime
      @last_mtime = mtime
      file = File.read(FILENAME)
      json = JSON.decode(file)
      
      # Convert from string keys to symbol keys
      @externs = {}
      json.each do |k, v|
        @externs[k.to_sym] = v
      end
    end
  end
  
  private
  
  def initialize
    @last_mtime = nil
    refresh_data_if_needed
  end  
end