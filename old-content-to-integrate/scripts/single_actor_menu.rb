# Source: http://www.rpgmakervxace.net/topic/33725-single-actor-menu/
#-----------------------------------------------------------------------------
# One Actor Menu Display v 1.0
# Author: Zvart
#-----------------------------------------------------------------------------

# Compatibility: Deals a bit with messing with the Command Window, as well as
# how the Actor's statistics are drawn. Any script that works with these may
# not work right with this script and vice versa.

# IF YOU INTEND TO USE CUSTOM COMMANDS: Edit out Lines 51 to 61.
# This includes using Yanfly's "YEA Ace Menu Engine"

# Bugs: None known.

# Terms of Use:
# Free to use in non-commercial and commercial projects with credit to Zvart.


# Description: This script changes the Main Menu to make use of the full area
# for the Menu Status screen when there is only one Actor in the game.


#-----------------------------------------------------------------------------
# Customization
#
# For best results, pictures should be about 272x288 for standard RPG Maker
# window size.
#
#-----------------------------------------------------------------------------

module Zvart_menu

  PICTURE_NAME = "Actor4-0"   # Insert the name of the picture you want on the
                              # Main Menu.

  PICTURE_X = 50              # How far left(lower) or right(higher) the picture
                              # should be.

  PICTURE_Y = 100             # How far up(lower) or down(higher) the picture
                              # should be.

  HP_BAR_LENGTH = 248         # How long the HP bar should be
  MP_BAR_LENGTH = 248         # How long the MP bar should be
  TP_BAR_LENGTH = 248         # How long the TP bar should be

end
#----------------------------------------------------------------------------
# I cannot save you if you edit past this point.
#----------------------------------------------------------------------------

class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_main_commands
    add_original_commands
    add_save_command
    add_game_end_command
  end
end


class Window_MenuStatus < Window_Selectable

  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    (height - standard_padding * 2)
  end
  #--------------------------------------------------------------------------
  # * Replace Method: Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_party.members[index]
    enabled = $game_party.battle_members.include?(actor)
    rect = item_rect(index)
    draw_item_background(index)
    draw_actor_picture(actor, rect.x + 1, rect.y + 1, enabled)
    draw_actor_simple_status(actor, rect.x + 108, rect.y + line_height / 2)
  end
  #-------------------------------------------------------------------------
  # * New Method: Draw Actor Picture
  #-------------------------------------------------------------------------
  def draw_actor_picture(face_name, face_index, x, y, enabled = true)
    bitmap = Cache.picture(Zvart_menu::PICTURE_NAME.to_s)
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(Zvart_menu::PICTURE_X, Zvart_menu::PICTURE_Y, bitmap, rect, enabled ? 255 : translucent_alpha)
    bitmap.dispose
  end

  #--------------------------------------------------------------------------
  # * Replace Method: Draw HP
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = Zvart_menu::HP_BAR_LENGTH)
    draw_gauge(x, y, width, actor.hp_rate, hp_gauge_color1, hp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::hp_a)
    draw_current_and_max_values(x, y, width, actor.hp, actor.mhp,
      hp_color(actor), normal_color)
  end
  #--------------------------------------------------------------------------
  # * Replace Method: Draw MP
  #--------------------------------------------------------------------------
  def draw_actor_mp(actor, x, y, width = Zvart_menu::MP_BAR_LENGTH)
    draw_gauge(x, y, width, actor.mp_rate, mp_gauge_color1, mp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::mp_a)
    draw_current_and_max_values(x, y, width, actor.mp, actor.mmp,
      mp_color(actor), normal_color)
  end
  #--------------------------------------------------------------------------
  # * Replace Method: Draw TP
  #--------------------------------------------------------------------------
  def draw_actor_tp(actor, x, y, width = Zvart_menu::TP_BAR_LENGTH)
    draw_gauge(x, y, width, actor.tp_rate, tp_gauge_color1, tp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::tp_a)
    change_color(tp_color(actor))
    draw_text(x + width - 42, y, 42, line_height, actor.tp.to_i, 2)
  end
  #--------------------------------------------------------------------------
  # * Replace Method: Draw Simple Status
  #--------------------------------------------------------------------------
  def draw_actor_simple_status(actor, x, y)
    draw_actor_name(actor, x - 100, y)
    draw_actor_level(actor, x - 100, y + line_height * 1)
    draw_actor_icons(actor, x - 100, y + line_height * 2)
    draw_actor_class(actor, x - 100, y + line_height * 3)
    draw_actor_hp(actor, x, y + line_height * 1)
    draw_actor_mp(actor, x, y + line_height * 2)
    draw_actor_tp(actor, x, y + line_height * 3)
  end
end


class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_MenuCommand.new
    @command_window.set_handler(:item,      method(:command_item))
    @command_window.set_handler(:skill,     method(:command_skill))
    @command_window.set_handler(:equip,     method(:command_equip))
    @command_window.set_handler(:status,    method(:command_status))
    @command_window.set_handler(:formation, method(:command_formation))
    @command_window.set_handler(:save,      method(:command_save))
    @command_window.set_handler(:game_end,  method(:command_game_end))
    @command_window.set_handler(:cancel,    method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * New Methods: [Skill], [Equipment] and [Status] Commands
  #--------------------------------------------------------------------------
  def command_skill
    SceneManager.call(Scene_Skill)
  end
  def command_equip
    SceneManager.call(Scene_Equip)
  end
  def command_status
    SceneManager.call(Scene_Status)
  end
end
