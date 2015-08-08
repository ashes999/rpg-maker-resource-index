#==============================================================================
#
# -- A simple points system; get or lose points from events.
# -- Points are via "events" which are a name + score, eg.
# -- "break the statue" => 100 points
# -- Author: ashes999 (ashes999@yahoo.com)
# -- Version 1.0

# TODO: add persistence for save/load
# Requires custom_save_system.rb

module PointsSystem

  # Start: variables you can customize
  # These map to system sounds.
  
  POSITIVE_SOUND = 14 # actor damage
  NEGATIVE_SOUND = 15 # actor collapse
  
  # Display points on map?
  DISPLAY_POINTS_ON_MAP = true
  DISPLAY_POINTS_OPACITY = 75
  PADDING = 16 # Default: 16
  POINTS_WIDTH = 128 # Default: 128
  POINTS_HEIGHT = 56 # Default: 80 or 56 
  POINTS_X = Graphics.width - 3 * PADDING
  POINTS_Y = PADDING
  
  # End variables. Please don't touch anything below this line.
  
  # Prepare/Register for Saving.
  DataManager.setup({ :points_scored => [] })

  def self.add_points(event, score)
    points_scored = get_points_scored
    points_scored << Points.new(score, event)
    if (score >= 0) then
      play_sound(:positive)
    else
      play_sound(:negative)
    end
  end
  
  def self.total_points
    sum = 0
    get_points_scored.map { |p| sum += p.points }
    return sum
  end
  
  def self.get_points_scored
    # Key => event name, value => score
    return DataManager.get(:points_scored)
  end
  
  # key => :positive or :negative
  def self.play_sound(key)
    Sound.play_system_sound(POSITIVE_SOUND) if key == :positive
    Sound.play_system_sound(NEGATIVE_SOUND) if key == :negative
  end
  
    def self.show_ui(value)
      SceneManager.scene.points_visible(value)
    end
  
  class Points
    attr_reader :points, :event
    
    def initialize(points, event)
      @points = points
      @event = event	  
    end
  end
  
  class Window_Points < Window_Base
    def initialize(x, y, width, height, opacity)
      super(x, y, width, height)
      update
      self.opacity = opacity
      self.visible = SceneManager.scene.is_a?(Scene_Menu) || SceneManager.scene.is_a?(Scene_Map)
    end
    
    def update
      contents.clear
	    contents.font.size = 20
      contents.draw_text(0, 4, contents.width, 20, "#{PointsSystem.total_points} points", 1)
    end
  end
end

class Scene_Menu
  alias points_start start
  
  def start
    points_start
    @ui = PointsSystem::Window_Points.new(0, 0, 150, 50, 255)
    return if @ui.nil?
    @ui.x = 0
    # If using advanced_game_time, above the clock
    above = @clock || @gold_window    
    @ui.width = above.width  
    @ui.height = above.height
    @ui.y = above.y - @ui.height
  end
end

class Scene_Map
  alias game_points_init create_all_windows
  alias game_points_map_update update
  
  def points_visible(value)
    @points_ui.visible = value
  end
  
  def create_all_windows
    game_points_init
    x = PointsSystem::POINTS_X
    y = PointsSystem::POINTS_Y
    width = PointsSystem::POINTS_WIDTH
    height = PointsSystem::POINTS_HEIGHT
    opacity = PointsSystem::DISPLAY_POINTS_OPACITY
    @points_ui = PointsSystem::Window_Points.new(x, y, width, height, opacity) if PointsSystem::DISPLAY_POINTS_ON_MAP
  end
  
  def update
    game_points_map_update
    return unless PointsSystem::DISPLAY_POINTS_ON_MAP
    @points_ui.update unless SceneManager.scene != self
  end
end
