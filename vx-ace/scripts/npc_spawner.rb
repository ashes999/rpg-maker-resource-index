GRAPHIC_FILES = [ 'People1', 'People2', 'People3', 'Peopl4', 'People5', 'People6', 'Peopl7', 'People8' ]
DATA_MAP_ID = 2			# Map with our events
NPC_TEMPLATE_IDS = [1]
NPC_SPEEDS = [2, 3, 4, 5] # slower to faster
NPC_FREQUENCIES = [2, 3, 4] # lower to higher

# requires spawn_events.rb

# A placeholder class to hold values we need to spawn the event later.
class Npc
	attr_reader :graphic_file, :graphic_index, :move_speed, :move_frequency, :template_id
	
	# graphic_file is the filename used for the graphic, eg. Actor1.
	# graphic_index is the base 0 index (0-7; first row, then second row)
  # template_id is the ID of the event we're copying, on map with ID=DATA_MAP_ID
	def initialize(graphic_file = nil, graphic_index = nil, template_id = nil, npc_speed = nil, npc_frequency = nil)
		@graphic_file = graphic_file || GRAPHIC_FILES.sample
		@graphic_index = graphic_index || rand(8) # 8 indicies/characters per graphic
		@template_id = template_id || NPC_TEMPLATE_IDS.sample
		@move_speed = move_speed || NPC_SPEEDS.sample
		@move_frequency = move_frequency || NPC_FREQUENCIES.sample
	end
end

class NpcSpawner
	# dynamically updates the battle troop to match our target
	def self.create_npc
    npc = Npc.new
		events = $game_map.events    
		# Clone the event into a random spot
		location = find_random_empty_spot			
		template_id = npc.template_id
		$game_map.spawn_event(location[:x], location[:y], template_id, DATA_MAP_ID)					
		event = events[events.keys[-1]]
		event.set_graphic(npc.graphic_file, npc.graphic_index)
		event.move_speed = npc.move_speed
		event.move_frequency = npc.move_frequency
	end
	
  private
  
  # Finds an empty spot. See is_empty? below.
	def self.find_random_empty_spot
		x = rand($game_map.width)
		y = rand($game_map.height)		
		
		while !is_empty?(x, y)			
			x = rand($game_map.width)
			y = rand($game_map.height)
		end		
		
		return {:x => x, :y => y}
	end
	
	# Returns true if the tile has no events on it.
	def self.is_empty?(x, y)
		event_count = $game_map.events_xy(x, y).length	
		# Is it a floor tile? That's all we need.
		#return tile_type($game_map.data[x, y, 0]) == @floor_id && event_count == 0
    return event_count == 0
	end
end

# Used to set event direction, move speed and frequency (extends RPG Maker class)
class Game_Event
	def direction=(value)
		@direction = value
	end
	# These two are used to randomize event speed
	def move_speed=(value)
		@move_speed = value
	end
	def move_frequency=(value)
		@move_frequency = value
	end
end
