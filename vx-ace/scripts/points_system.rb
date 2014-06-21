#==============================================================================
#
# -- A simple points system; get or lose points from events.
# -- Points are via "events" which are a name + score, eg.
# -- "break the statue" => 100 points
# -- Author: ashes999 (ashes999@yahoo.com)
# -- Version 1.0
module PointsSystem

	# Start: variables you can customize
	# These map to system sounds.
	
	POSITIVE_SOUND = 21 # shop
	NEGATIVE_SOUND = 3 # buzzer
	
	# End variables. Please don't touch anything below this line.

	# Key => event name, value => score
	@@points_scored = {}

	def self.add_points(event, score)
		@@points_scored[event] = score
		if (score >= 0) then
			play_sound(:positive)
		else
			play_sound(:negative)
		end
	end
	
	def self.total_points
		sum = 0
		@@points_scored.map { |k, v| sum += v }
		return sum
	end
	
	def self.points_breakdown
		return @@points_scored
	end
	
	# key => :positive or :negative
	def self.play_sound(key)
		Sound.play_system_sound(POSITIVE_SOUND) if key == :positive
		Sound.play_system_sound(NEGATIVE_SOUND) if key == :negative
	end
	
end
