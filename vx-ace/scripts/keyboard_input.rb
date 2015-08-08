# Source: http://www.rpg2s.net/forum/index.php/topic/14903-keyboard-input-v-30-by-keroro/

#===============================================================================
# Keyboard Input - Porting to VX-ACE
# By Keroro - cris87@gmail.com
 
# Version 3.0
# Last Date Updated. 2012.03.17
#===============================================================================
#
# OriginalWij and Yanfly Collaboration - Keyboard Input
# Last Date Updated: 2010.06.12
# Level: Normal
#
# This is a utility script that provides the functionality to return inputs
# from the keyboard as well as free up more keys to be used in the Input module.
# This script will also replace Scene_Name and allow for direct keyboard input
# to type in an actor's name as well as fix the maximum characters shown from
# the default base script.
#
#===============================================================================
 
$imported = {} if $imported == nil
$imported["KeyboardInput"] = true
 
 
 
class << Input
	#--------------------------------------------------------------------------
	# Aliases (Mods - Linked to Module) - Created by OriginalWij
	#--------------------------------------------------------------------------
	alias ow_dt_i_press press? unless $@
	alias ow_dt_i_trigger trigger? unless $@
	alias ow_dt_i_repeat repeat? unless $@
	alias ow_dt_i_update update unless $@
end
 
module Input
	#--------------------------------------------------------------------------
	# constants - Created by OriginalWij and Yanfly and Keroro
	#--------------------------------------------------------------------------
	VALUES = {}
	VALUES[:VK_A] = 65; VALUES[:VK_B] = 66; VALUES[:VK_C] = 67;
	VALUES[:VK_D] = 68; VALUES[:VK_E] = 69; VALUES[:VK_F] = 70;
	VALUES[:VK_G] = 71; VALUES[:VK_H] = 72; VALUES[:VK_I] = 73;
	VALUES[:VK_J] = 74; VALUES[:VK_K] = 75; VALUES[:VK_L] = 76
	VALUES[:VK_M] = 77; VALUES[:VK_N] = 78; VALUES[:VK_O] = 79;
	VALUES[:VK_P] = 80; VALUES[:VK_Q] = 81; VALUES[:VK_R] = 82;
	VALUES[:VK_S] = 83; VALUES[:VK_T] = 84; VALUES[:VK_U] = 85;
	VALUES[:VK_V] = 86; VALUES[:VK_W] = 87; VALUES[:VK_X] = 88
	VALUES[:VK_Y] = 89; VALUES[:VK_Z] = 90;
	LETTERS = [:VK_A,:VK_B,:VK_C,:VK_D,:VK_E,:VK_F,:VK_G,:VK_H,:VK_I,:VK_J, \
	:VK_K,:VK_L,:VK_M,:VK_N,:VK_O,:VK_P,:VK_Q,:VK_R,:VK_S,:VK_T, \
	:VK_U,:VK_V,:VK_W,:VK_X,:VK_Y,:VK_Z]
	VALUES[:NUM0] = 48; VALUES[:NUM1] = 49; VALUES[:NUM2] = 50;
	VALUES[:NUM3] = 51; VALUES[:NUM4] = 52; VALUES[:NUM5] = 53;
	VALUES[:NUM6] = 54; VALUES[:NUM7] = 55; VALUES[:NUM8] = 56;
	VALUES[:NUM9] = 57; VALUES[:PAD0] = 96; VALUES[:PAD1] = 97;
	VALUES[:PAD2] = 98; VALUES[:PAD3] = 99; VALUES[:PAD4] = 100;
	VALUES[:PAD5] = 101; VALUES[:PAD6] = 102; VALUES[:PAD7] = 103;
	VALUES[:PAD8] = 104; VALUES[:PAD9] = 105;
	NUMBERS = [:NUM0,:NUM1,:NUM2,:NUM3,:NUM4,:NUM5,:NUM6,:NUM7,:NUM8,:NUM9]
	NUMPAD = [:PAD0,:PAD1,:PAD2,:PAD3,:PAD4,:PAD5,:PAD6,:PAD7,:PAD8,:PAD9]
	VALUES[:ENTER] = 13;
	VALUES[:SPACE] = 32;
	VALUES[:ESC] = 27;
	VALUES[:BACK] = 8;
	VALUES[:PGUP] = 33;
	VALUES[:PGDN] = 34;
	VALUES[:CAPS] = 20;
	#TODO: aggiungere tags per punteggiatura
	
	#--------------------------------------------------------------------------
	# initial module settings - Created by OriginalWij and Yanfly
	#--------------------------------------------------------------------------
	GetKeyState = Win32API.new("user32", "GetAsyncKeyState", "i", "i")
	GetCapState = Win32API.new("user32", "GetKeyState", "i", "i")
	KeyRepeatCounter = {}
	module_function
	#--------------------------------------------------------------------------
	# alias method: update - Created by OriginalWij and Keroro
	#--------------------------------------------------------------------------
	def update
		ow_dt_i_update
		for key in KeyRepeatCounter.keys
			if (GetKeyState.call(VALUES[key]).abs & 0x8000 == 0x8000)
				KeyRepeatCounter[key] += 1
			else
				KeyRepeatCounter.delete(key)
			end
		end
	end
	
	#--------------------------------------------------------------------------
	# alias method: press? - Created by OriginalWij and Keroro
	#--------------------------------------------------------------------------
	def press?(key)
		return ow_dt_i_press(key) if !VALUES.has_key?(key)
		return true unless KeyRepeatCounter[key].nil?
		return key_pressed?(key)
	end
	#--------------------------------------------------------------------------
	# alias method: trigger? - Created by OriginalWij and Keroro
	#--------------------------------------------------------------------------
	def trigger?(key)
		return ow_dt_i_trigger(key) if !VALUES.has_key?(key)
		count = KeyRepeatCounter[key]
		return ((count == 0) or (count.nil? ? key_pressed?(key) : false))
	end
	#--------------------------------------------------------------------------
	# alias method: repeat? - Created by OriginalWij and Keroro
	#--------------------------------------------------------------------------
	def repeat?(key)
		return ow_dt_i_trigger(key) if !VALUES.has_key?(key)
		count = KeyRepeatCounter[key]
		return true if count == 0
		if count.nil?
			return key_pressed?(key)
		else
			return (count >= 23 and (count - 23) % 6 == 0)
		end
	end
	
	
	#--------------------------------------------------------------------------
	# new method: key_pressed? - Created by OriginalWij and Keroro
	#--------------------------------------------------------------------------
	def key_pressed?(key)
		if (GetKeyState.call(VALUES[key]).abs & 0x8000 == 0x8000)
			KeyRepeatCounter[key] = 0
			return true
		end
		return false
	end
	
	#--------------------------------------------------------------------------
	# new method: typing? - Created by Yanfly and Keroro
	#--------------------------------------------------------------------------
	def typing?
		return true if repeat?(:SPACE)
		for key in LETTERS
			return true if repeat?(key)
		end
		for key in NUMBERS
			return true if repeat?(key)
		end
		return false
	end
	
	#--------------------------------------------------------------------------
	# new method: key_type - Created by Yanfly and Keroro
	#--------------------------------------------------------------------------
	
	def key_type
		return " " if repeat?(:SPACE)
		for key in LETTERS
			next unless repeat?(key)
			return upcase? ? key.to_s[3].upcase : key.to_s[3].downcase
		end
		for key in NUMBERS
			return key.to_s[3] if repeat?(key)
		end
		for key in NUMPADS
			return key.to_s[3] if repeat?(key)
		end
		
		return ""
	end
	#--------------------------------------------------------------------------
	# new method: upcase? - Created by Yanfly
	#--------------------------------------------------------------------------
	def upcase?
		return !press?(:SHIFT) if GetCapState.call(VALUES[:CAPS]) == 1
		return true if press?(:SHIFT)
		return false
	end
end #Input
 
 
#===============================================================================
# Window_NameEdit
#===============================================================================
 
class Window_NameEdit < Window_Base
	
	#--------------------------------------------------------------------------
	# overwrite method: initialize
	#--------------------------------------------------------------------------
	def initialize(actor, max_char)
		dw = Graphics.width - 176
		dy = (Graphics.height - 128) / 2
		if $game_message.visible
			difference = Graphics.height - 128
			case $game_message.position
			when 0; dy += 64
			when 1; dy += 0
			when 2; dy -= 64
			end
		end
		super(88, dy, dw, 128)
		@actor = actor
		@name = actor.name
		@max_char = max_char
		name_array = @name.split(//)[0...@max_char]
		@name = ""
		for i in 0...name_array.size
			@name += name_array[i]
		end
		@default_name = @name
		@index = name_array.size
		self.active = false
		refresh
	end
	
	#--------------------------------------------------------------------------
	# overwrite method: item_rect
	#--------------------------------------------------------------------------
	def item_rect(index)
		if index == @max_char
			rect = Rect.new(0, 0, 0, 0)
		else
			rect = Rect.new(0, 0, 0, 0)
			rect.x = 112 + index * 12
			rect.y = 36
			rect.width = 24
			rect.height = line_height
		end
		return rect
	end
	
end # Window_NameEdit
 
#===============================================================================
# Scene_Base
#===============================================================================
 
class Scene_Base
	
	#--------------------------------------------------------------------------
	# new method: name_entry
	#--------------------------------------------------------------------------
	def name_entry(actor_id, max_char)
		@name_actor_id = actor_id
		@name_entry_max = max_char
		start_name_entry
	end_name_entry
end
 
#--------------------------------------------------------------------------
# new method: start_name_entry
#--------------------------------------------------------------------------
def start_name_entry
	Graphics.freeze
	actor = $game_actors[@name_actor_id]
	@edit_window = Window_NameEdit.new(actor, @name_entry_max)
	Graphics.transition(10)
	loop do
		update_name_entry
		if Input.repeat?(:BACK) and @edit_window.index > 0
			Sound.play_cancel
			@edit_window.back
		elsif Input.typing? and @edit_window.index != @edit_window.max_char
			Sound.play_cursor
			@edit_window.add(Input.key_type)
		elsif Input.trigger?(:ENTER)
			Sound.play_ok
			actor.name = @edit_window.name
			break
		elsif Input.trigger?(:ESC)
			Sound.play_cancel
			break
		end
	end
end
 
#--------------------------------------------------------------------------
# new method: update_name_entry
#--------------------------------------------------------------------------
def update_name_entry
	Graphics.update
	Input.update
	if SceneManager.scene.is_a?(Scene_Map)
		$game_map.update
		@spriteset.update
	elsif SceneManager.scene.is_a?(Scene_Battle)
		Graphics.update
		Input.update
		$game_system.update
		$game_troop.update
		@spriteset.update
		@message_window.update
	end
	@edit_window.update
end
 
#--------------------------------------------------------------------------
# end_name_entry
#--------------------------------------------------------------------------
def end_name_entry
	@edit_window.dispose
	@edit_window = nil
	@name_actor_id = nil
	@name_entry_max = nil
end
end # Scene_Base
 
#===============================================================================
# Game_Interpreter
#===============================================================================
 
class Game_Interpreter
 
#--------------------------------------------------------------------------
# overwrite method: command_303 (Name Input Processing)
#--------------------------------------------------------------------------
def command_303
	if $data_actors[@params[0]] != nil
		SceneManager.scene.name_entry(@params[0], @params[1])
	end
	@index += 1
	return false
end
 
end # Game_Interpreter
 
