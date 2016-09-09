# Source: http://www.rpgmakervxace.net/topic/9758-garycxjk-hacked-together-credits-script/
# Modified to return to the title screen if you set RETURN_TO_TITLE to true
#==============================================================================
# 
# GaryCXJk - Hacked Together Credits Script v1.00
# * Last Updated: 2012.12.28
# * Level: Easy
# * Requires: N/A
#
#==============================================================================

$imported = {} if $imported.nil?
$imported["CXJ-HTCredits"] = true

#==============================================================================
#
# Changelog:
#
#------------------------------------------------------------------------------
# 2012.01.03 - v1.00
#
# * Initial release
#
#==============================================================================
#
# Okay, here's the thing. RPG Maker VX Ace's message system can be very
# flexible, to the point where you can use it as a basic credits system.
# However, sometimes you want that little bit more flexibility. So, at these
# times it would be very nice to see a credits system.
#
# Now this isn't the best credits script there could be, hence its name. That
# doesn't mean it's bad though, it only means it's still very basic, kind of
# for people who want to work with a quick script, and that the code is a bit
# messy.
#
#==============================================================================
#
# Installation:
#
# Make sure to put this below Materials, but above Main Process.
#
#==============================================================================
#
# Usage:
#
# There are two ways to use this script. First is changing the current scene
# to Scene_Credits. It will automatically return to the last scene after it's
# done. This scene is completely bare, save for the credits stuff. Any music
# or other effect should be done before this scene. You can also subclass it
# to add new functionality.
#
# The other way is to open a Window_Credits. You can either open one yourself
# or use CXJ::HT_CREDITS.refresh to open a global window. You must run
# CXJ::HT_CREDITS.update yourself each tick to run the window. To close the
# window, use CXJ::HT_CREDITS.terminate_message. Finally,
# CXJ::HT_CREDITS.credits_end? checks if the credits reach its end.
#
# A credits file is a regular text file which contains various data. It
# consists of three blocks, defined by square brackets. The [credits] section
# is the actual credits text. You can use certain formatting for that. None of
# the formatting will transfer over to the next line.
#
# \C  - Change color. The value that follows is four characters wide, and
#       is a hexadecimal value representing RGBA.
# \{  - Enlargen the text by eight.
# \}  - Shrink the text by eight.
# \Ax - Align the text to the center position.
#       L:   Align left.
#       C:   Align center.
#       R:   Align right.
# \Px - Sets the center position.
#       L:   At a quarter of the screen.
#       C:   At the center.
#       R:   At three quarters of the screen.
#       0-8: A position between the left and right position of the screen.
# \>> - Will process the next line on the same line as the current.
#
# The [timeline] section defines events that should happen during the credits
# sequence. You can define methods here, either as a symbol or as an evaluated
# line. You correctly format the lines as follows:
#
# time_in_seconds:method string
# time_in_seconds::symbol
#
# Example:
#
# 5.00:puts('Haldo world!')
# 5.10::make_font_bigger
#
# Finally, [settings] contains the settings. You can assign settings however
# you like, if you like. If you decide not to change a setting, you can always
# remove them.
#
# line_height     - The font size.
# color           - The font color, as an eight character hexadecimal value.
# duration        - The duration of the credits sequence.
# scroll_duration - The duration of the scrolling text.
# speed           - The speed of the scrolling text.
#
#==============================================================================
#
# License:
#
# Creative Commons Attribution 3.0 Unported
#
# The complete license can be read here:
# http://creativecommons.org/licenses/by/3.0/legalcode
#
# The license as it is described below can be read here:
# http://creativecommons.org/licenses/by/3.0/deed
#
# You are free:
#
# to Share — to copy, distribute and transmit the work
# to Remix — to adapt the work
# to make commercial use of the work
#
# Under the following conditions:
#
# Attribution — You must attribute the work in the manner specified by the
# author or licensor (but not in any way that suggests that they endorse you or
# your use of the work).
#
# With the understanding that:
#
# Waiver — Any of the above conditions can be waived if you get permission from
# the copyright holder.
#
# Public Domain — Where the work or any of its elements is in the public domain
# under applicable law, that status is in no way affected by the license.
#
# Other Rights — In no way are any of the following rights affected by the
# license:
#
# * Your fair dealing or fair use rights, or other applicable copyright
#   exceptions and limitations;
# * The author's moral rights;
# * Rights other persons may have either in the work itself or in how the work
#   is used, such as publicity or privacy rights.
#
# Notice — For any reuse or distribution, you must make clear to others the
# license terms of this work. The best way to do this is with a link to this
# web page.
#
#------------------------------------------------------------------------------
# Extra notes:
#
# Despite what the license tells you, I will not hunt down anybody who doesn't
# follow the license in regards to giving credits. However, as it is common
# courtesy to actually do give credits, it is recommended that you do.
#
# As I picked this license, you are free to share this script through any
# means, which includes hosting it on your own website, selling it on eBay and
# hang it in the bathroom as toilet paper. Well, not selling it on eBay, that's
# a dick move, but you are still free to redistribute the work.
#
# Yes, this license means that you can use it for both non-commercial as well
# as commercial software.
#
# You are free to pick the following names when you give credit:
#
# * GaryCXJk
# * Gary A.M. Kertopermono
# * G.A.M. Kertopermono
# * GARYCXJK
#
# Personally, when used in commercial games, I prefer you would use the second
# option. Not only will it actually give me more name recognition in real
# life, which also works well for my portfolio, it will also look more
# professional. Also, do note that I actually care about capitalization if you
# decide to use my username, meaning, capital C, capital X, capital J, lower
# case k. Yes, it might seem stupid, but it's one thing I absolutely care
# about.
#
# Finally, if you want my endorsement for your product, if it's good enough
# and I have the game in my posession, I might endorse it. Do note that if you
# give me the game for free, it will not affect my opinion of the game. It
# would be nice, but if I really did care for the game I'd actually purchase
# it. Remember, the best way to get any satisfaction is if you get people to
# purchase the game, so in a way, I prefer it if you don't actually give me
# a free copy.
#
# This script was originally hosted on:
# http://area91.multiverseworks.com
#
#==============================================================================
#
# The code below defines the settings of this script, and are there to be
# modified.
#
#==============================================================================

module CXJ
  module HT_CREDITS
    # General settings
    BASE_HEIGHT = 24                            # Base line height
    TEXT_COLOR = Color.new(255, 255, 255, 255)  # Default color
    DEFAULT_DURATION = 10                       # Duration of sequence in secs
    DEFAULT_SCROLL_DURATION = 0                 # Scoll duration in secs
    DEFAULT_SPEED = 1.0                         # Scroll speed
    ALLOW_MANUAL_CREDITS_CLOSE = true           # Manually close Scene_Credits?
    RETURN_TO_TITLE = true						# Automatically return to the title when we're done
	BGM_TO_PLAY = 'yusuf-islam-adhaan'			# Set to the filename (without extension) to start; nil for no audio
	
    # Searches through the following files.
    # It iterates through the file list. If a file can't be found, it moves
    # on to the next file. Otherwise it loads the data and skips the rest.
    # When using a packaged file, you can append it with a symbol name. This
    # way you can store the data in a general package.
    CREDITS_FILE = [
    "Data/Strings.rvdata2:credits",
    "Data/Credits.rvdata2",
    "Text/Credits.txt",
    ]
    
    # This list defines the file extensions of packaged files.
    CREDITS_PACKAGED = [
    "rvdata2",
    ]
    
    #------------------------------------------------------------------------
    # Use this module (CXJ::HT_CREDITS::METHODS) or Window_Credits to add new
    # methods.
    #------------------------------------------------------------------------
    module METHODS
    end
  end
end

#==============================================================================
#
# The code below should not be altered unless you know what you're doing.
#
#==============================================================================

module CXJ
  module HT_CREDITS
    #------------------------------------------------------------------------
    # These variables are used in various methods.
    #------------------------------------------------------------------------
    @credits_base_height = CXJ::HT_CREDITS::BASE_HEIGHT
    @credits_base_color = CXJ::HT_CREDITS::TEXT_COLOR
    @credits_base_duration = CXJ::HT_CREDITS::DEFAULT_DURATION
    @credits_base_scroll_duration = CXJ::HT_CREDITS::DEFAULT_SCROLL_DURATION
    @credits_base_speed = CXJ::HT_CREDITS::DEFAULT_SPEED
    @credits_text = []
    @credits_timeline = {}
    @credits_height = 0
    @credits_height_list = []
    @credits_base_scroll_duration = CXJ::HT_CREDITS::DEFAULT_DURATION if @credits_base_scroll_duration == 0
    
    #------------------------------------------------------------------------
    # Initializes the credits.
    #------------------------------------------------------------------------
    def self.init
      CREDITS_FILE.each do |filename|
        filedata = filename.split(/:/)
        filename = filedata[0]
        next unless File.exists?(filename)
        extname = File.extname(filename)
        ext = extname[1, extname.size - 1]
        if CREDITS_PACKAGED.include?(ext)
          if(filedata.size > 1)
            process_packaged(filename, filedata[1].to_sym)
          else
            process_packaged(filename)
          end
        else
          process_text(filename)
        end
        break if !@credits_text.empty?
      end	  
    end
    
    #------------------------------------------------------------------------
    # Gets credits data as a Hash.
    #------------------------------------------------------------------------
    def self.get_credits_data
      data = {
      :credits => @credits_text,
      :timeline => @credits_timeline,
      :settings => {
        :line_height => @credits_base_height,
        :color => @credits_color,
        :duration => @credits_base_duration,
        :scroll_duration => @credits_base_scroll_duratino,
        :speed => @credits_base_speed,
        }
      }
    end
    
    #------------------------------------------------------------------------
    # Store credits data as a file.
    #------------------------------------------------------------------------
    def self.store_credits_data(filename)
      save_data(get_credits_data, filename)
    end
    
    #------------------------------------------------------------------------
    # Process packaged credits data.
    #------------------------------------------------------------------------
    def self.process_packaged(filename, symbol = nil)
      credits_data = load_data(filename)
      return if(credits_data.nil?)
      if !symbol.nil?
        return if credits_data[symbol].nil?
        credits_data = credits_data[symbol]
      end
      return if @credits_text.nil?
      @credits_text = credits_data[:credits] if !credits_data[:credits].nil?
      @credits_timeline = credits_data[:timeline] if !credits_data[:timeline].nil?
      settings = {}
      settings = credits_data[:settings] if !credits_data[:settings].nil?
      @credits_base_height = settings[:line_height] if !settings[:line_height].nil?
      @credits_color = settings[:color] if !settings[:color].nil?
      @credits_base_duration = settings[:duration] if !settings[:duration].nil?
      @credits_base_scroll_duration = settings[:scroll_duration] if !settings[:scroll_duration].nil?
      @credits_base_speed = settings[:speed] if !settings[:speed].nil?
      calculate_total_height
    end
    
    #------------------------------------------------------------------------
    # Process a text file.
    #------------------------------------------------------------------------
    def self.process_text(filename)
      credits_content = ''
      File.open(filename, "r") do |file|
        credits_content = file.read()
      end
      tag_open = :none
      credits_content.split(/[\r\n]/).each do |line|
        if line =~ /^\s*\[(.*)\]\s*$/i
          case $1
          when "credits"
            tag_open = :credits
          when "timeline"
            tag_open = :timeline
          when "settings"
            tag_open = :settings
          end
        else
          case tag_open
          when :credits
            line.gsub!(/\\/)    { "\e" }
            line.gsub!(/\e\e/)  { "\\" }
            @credits_text.push(line)
          when :timeline            
			linepos = line.index(":")			
            linedata = line[0, linepos]
            posdata = line.split(/\./)
            curpos = posdata[0].to_i
            subpos = posdata[1].to_i
            subpos/= 10.0 while subpos > 1.0
            @credits_timeline[curpos + subpos] = line[linepos + 1, line.size - (linepos + 1)]
          when :settings
            if line =~ /^\s*(\w+)\s*=\s*(.+)\s*$/
              case $1
              when "line_height"
                @credits_base_height = $2.to_i
              when "color"
                @credits_color = process_color($2)
              when "duration"
                @credits_base_duration = $2.to_f
              when "scroll_duration"
                @credits_base_scroll_duration = $2.to_f
              when "speed"
                @credits_base_speed = $2.to_i
              end
            end
          end
        end
      end
      calculate_total_height
    end
    
    #------------------------------------------------------------------------
    # Calculate total height.
    #------------------------------------------------------------------------
    def self.calculate_total_height
      @credits_height = 0
      height_poll = 0
      last_i = 0
      for i in 0 ... text_count
        text = text(i)
        height_poll = [height_poll, get_line_height(text)].max
        next if text =~ /\e>>/
        @credits_height+= height_poll
        while last_i <= i
          @credits_height_list[last_i] = height_poll
          last_i+=1
        end
        height_poll = 0
      end
      @credits_height+= height_poll
      while last_i < text_count
        @credits_height_list[last_i] = height_poll
        last_i+=1
      end
    end
    
    #------------------------------------------------------------------------
    # Process a color.
    # Colors are done in hexadecimal format.
    #------------------------------------------------------------------------
    def self.process_color(color)
      vals = '0123456789abcdef'
      value = 0
      color = color.downcase
      while !color.empty?
        value = (value << 4) | vals.index(color.slice!(0, 1))
      end
      Color.new((value >> 24) & 0xff, (value >> 16) & 0xff, (value >> 8) & 0xff, value & 0xff)
    end
    
    #------------------------------------------------------------------------
    # The base line height.
    #------------------------------------------------------------------------
    def self.base_height
      @credits_base_height
    end
    
    #------------------------------------------------------------------------
    # The default color.
    #------------------------------------------------------------------------
    def self.default_color
      @credits_base_color
    end
    
    #------------------------------------------------------------------------
    # The amount of lines stored.
    #------------------------------------------------------------------------
    def self.text_count
      @credits_text.size
    end
    
    #------------------------------------------------------------------------
    # The duration of the credits sequence.
    #------------------------------------------------------------------------
    def self.default_duration
      @credits_base_duration
    end

    #------------------------------------------------------------------------
    # The duration of the scrolling text.
    #------------------------------------------------------------------------
    def self.default_scroll_duration
      @credits_base_scroll_duration
    end

    #------------------------------------------------------------------------
    # The default speed for the scrolling text.
    # Ignored if the duration of the credits sequence is set.
    #------------------------------------------------------------------------
    def self.default_speed
      @credits_base_speed
    end

    #------------------------------------------------------------------------
    # A text line.
    #------------------------------------------------------------------------
    def self.text(index)
      @credits_text[index]
    end
    
    #------------------------------------------------------------------------
    # The total height of the scrolling text.
    #------------------------------------------------------------------------
    def self.total_height
      @credits_height
    end
      
    #------------------------------------------------------------------------
    # The height of a given line.
    #------------------------------------------------------------------------
    def self.get_line_height(text)
      return @credits_height_list[text] if text.kind_of?(Numeric)
      result = base_height
      text.slice(/^.*$/).scan(/\e[\{\}]/).each do |esc|
        result += 8 if result <= 64 && esc == "\e{"
      end
      result
    end
    
    #------------------------------------------------------------------------
    # Get the timeline data.
    #------------------------------------------------------------------------
    def self.get_timeline_data
      @credits_timeline
    end
    
    init
  end
end

class Window_Credits < Window_Base
  
  include CXJ::HT_CREDITS::METHODS
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, Graphics.height)
    self.opacity = 0
    self.arrows_visible = false
    hide
	
	if !CXJ::HT_CREDITS::BGM_TO_PLAY.nil?
	  @bgm = RPG::BGM.new(CXJ::HT_CREDITS::BGM_TO_PLAY, 100, 100)
	  @bgm.play	  
	end
  end
  #--------------------------------------------------------------------------
  # * Get Standard Padding Size
  #--------------------------------------------------------------------------
  def standard_padding
    return 0
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_message if @text
    start_message if !@text
  end
  #--------------------------------------------------------------------------
  # * Start Message
  #--------------------------------------------------------------------------
  def start_message
    @frame_count = 0
    @frame_rate = Graphics.frame_rate
    @frame_end = (CXJ::HT_CREDITS.default_duration * @frame_rate).floor
    @frame_end = (CXJ::HT_CREDITS.default_speed * CXJ::HT_CREDITS.total_height).ceil unless @frame_end > 0
    @text = true
    calculate_speed
    refresh
    show
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def contents_height
    @all_text_height ? @all_text_height : super
  end
  #--------------------------------------------------------------------------
  # * Update Message
  #--------------------------------------------------------------------------
  def update_message
    @scroll_pos += scroll_speed
    self.oy = @scroll_pos
    val = @timeline[@frame_count]
    if !val.nil?
      if val.instance_of?(Symbol)
        method(val).call
      else
        eval(val)
      end
    end
    @frame_count+=1
    terminate_message if credits_end?
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    reset_font_settings
    @all_text_height = CXJ::HT_CREDITS.total_height
    create_contents
    draw_all_text
    set_timeline
    self.oy = @scroll_pos = -height
  end
  #--------------------------------------------------------------------------
  # * Get Scroll Speed
  #--------------------------------------------------------------------------
  def scroll_speed
    next_y = (@speed + @remainder).floor
    @remainder = [@speed + @remainder - next_y, 0].max
    next_y
  end
  #--------------------------------------------------------------------------
  # * End Message
  #--------------------------------------------------------------------------
  def terminate_message
    hide
    close	
	@bgm = nil
  end
  
  #------------------------------------------------------------------------
  # If the credits have ended.
  #------------------------------------------------------------------------
  def credits_end?
    @frame_count > @frame_end
  end
  
  #------------------------------------------------------------------------
  # Draws all text.
  #------------------------------------------------------------------------
  def draw_all_text
    y = 0
    index = 0
    while index < CXJ::HT_CREDITS.text_count
      create_line(index, y)
      while index < CXJ::HT_CREDITS.text_count && CXJ::HT_CREDITS.text(index) =~ /\e>>/
        index+= 1
        create_line(index, y)
      end
      y+= CXJ::HT_CREDITS.get_line_height(index)
      index+= 1
    end
  end
  
  #------------------------------------------------------------------------
  # Initializes the timeline.
  #------------------------------------------------------------------------
  def set_timeline
    @timeline = {}
    CXJ::HT_CREDITS.get_timeline_data.each do |key,value|
      dur = (key * @frame_rate).floor
      val = value
      val = value[1, value.size - 1].to_sym if(value[0] == ":")
      @timeline[dur] = val
    end
  end
  
  #------------------------------------------------------------------------
  # Calculate the text speed.
  #------------------------------------------------------------------------
  def calculate_speed
    def_duration = CXJ::HT_CREDITS.default_scroll_duration * 1.0
    @speed = CXJ::HT_CREDITS.default_speed
    @remainder = 0
    if def_duration > 0
      frame_duration = def_duration * @frame_rate * 1.0
      @speed = (CXJ::HT_CREDITS.total_height + Graphics.height) / frame_duration
    end
  end
  
  #------------------------------------------------------------------------
  # Create a line.
  #------------------------------------------------------------------------
  def create_line(index, yPos)
    text = CXJ::HT_CREDITS.text(index).to_s.clone
    line_height = CXJ::HT_CREDITS.get_line_height(index)
    bitmap = Bitmap.new(Graphics.width, Graphics.height)
    data = {:x => 0, :y => 0, :align => 1, :pos => 0}
    bitmap.font.size = CXJ::HT_CREDITS.base_height
    bitmap.font.color = CXJ::HT_CREDITS::TEXT_COLOR
    pos = "C"
    if text =~ /P([LCR])/i
      pos = $1
    end
    process_char(text.slice!(0, 1), text, bitmap, line_height, data) while !text.empty?
    case data[:align]
    when 0
      xPos = Graphics.width / 2 + data[:pos]
    when 1
      xPos = (Graphics.width - data[:x]) / 2 + data[:pos]
    when 2
      xPos = Graphics.width / 2 - data[:x] + data[:pos]
    end
    line_width = [1,data[:x]].max
    place_rect = Rect.new(0, 0, line_width, line_height)
    contents.blt(xPos, yPos, bitmap, place_rect)
    bitmap.dispose
  end

  #------------------------------------------------------------------------
  # Process a character.
  #------------------------------------------------------------------------
  def process_char(char, text, bitmap, line_height, data)
    if char == "\e"
      process_special_character(text.slice!(0, 1), text, bitmap, line_height, data)
    else
      rect = bitmap.text_size(char)
      bitmap.draw_text(data[:x], data[:y], rect.width * 2, line_height, char)
      data[:x]+= rect.width
    end
  end
  
  #------------------------------------------------------------------------
  # Process a special character.
  #------------------------------------------------------------------------
  def process_special_character(char, text, bitmap, line_height, data)
    case char.upcase
    when "C"
      bitmap.font.color = CXJ::HT_CREDITS.process_color(text.slice!(0, 8))
    when "{"
      bitmap.font.size += 8 if bitmap.font.size <= 64
    when "}"
      bitmap.font.size -= 8 if bitmap.font.size >= 16
    when "A"
      align = text.slice!(0, 1)
      case align.upcase
      when "L"
        data[:align] = 0
      when "R"
        data[:align] = 2
      when "C"
        data[:align] = 1
      end
    when ">"
      text.slice!(0, 1)
    when "P"
      cur_char = text.slice!(0, 1)
      if cur_char =~ /[0-8]/i
        data[:pos] = Graphics.width / ((cur_char.to_i - 4) * 2)
      else
        case cur_char
        when "L"
          data[:pos] = 0 - Graphics.width / 2
        when "R"
          data[:pos] = Graphics.width / 2
        when "C"
          data[:pos] = 0
        end
      end
    end
  end
end

class Scene_Credits < Scene_Base
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    @window_credits = Window_Credits.new
  end
  
  #------------------------------------------------------------------------
  # Update
  #------------------------------------------------------------------------
  def update
    super
    if (Input.trigger?(:C) && CXJ::HT_CREDITS::ALLOW_MANUAL_CREDITS_CLOSE) || @window_credits.credits_end?
      @ending = true
    end
    if @ending
      Graphics.brightness = [Graphics.brightness - 16, 0].max
      if Graphics.brightness == 0
        @window_credits.terminate_message		
		if CXJ::HT_CREDITS::RETURN_TO_TITLE == true
			SceneManager.goto(Scene_Title) 
		else		
			SceneManager.return
		end
        Graphics.brightness = 255
      end
    end
  end
end

module CXJ
  module HT_CREDITS
    #------------------------------------------------------------------------
    # Refresh the credits window.
    # It will automatically create and open a window if it hasn't.
    #------------------------------------------------------------------------
    def self.refresh
      @credits_window.dispose if !@credits_window.nil? && !@credits_window.disposed?
      @credits_window = Window_Credits.new
      @credits_window.open if @credits_window.close?
      @credits_window.start_message
    end
    
    #------------------------------------------------------------------------
    # Update.
    #------------------------------------------------------------------------
    def self.update
      @credits_window.update
    end
    
    #------------------------------------------------------------------------
    # Whether the credits have ended or not.
    #------------------------------------------------------------------------
    def self.credits_end?
      @credits_window.credits_end?
    end
    
    #------------------------------------------------------------------------
    # Manually terminates the window.
    #------------------------------------------------------------------------
    def self.terminate_message
      @credits_window.terminate_message
    end
  end
end
