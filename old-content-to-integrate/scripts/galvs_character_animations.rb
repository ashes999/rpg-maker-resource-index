#------------------------------------------------------------------------------#
#  Galv's Character Animations
#------------------------------------------------------------------------------#
#  For: RPGMAKER VX ACE
#  Version 2.0
#------------------------------------------------------------------------------#
#  2013-01-24 - Version 2.0 - Significant changes for performance increase.
#  2013-01-07 - Version 1.7 - Slight tweaks
#  2012-10-06 - Version 1.6 - Updated alias names for compatibility
#  2012-10-06 - Version 1.5 - Added dash speed option. Fixed some code
#  2012-09-21 - Version 1.4 - Optimised the code significantly (to my ability)
#                           - Some bug fixes
#  2012-09-21 - Version 1.3 - Added ability to repeat common event
#                           - Added follower animations
#  2012-09-20 - Version 1.2 - fixed compatibility with Galv's Region Effects
#  2012-09-20 - Version 1.1 - added idle common event, removed unnecessary code
#  2012-09-20 - Version 1.0 - release
#------------------------------------------------------------------------------#
#  Designed to give actors additional animations such as:
#  - Idle
#  - Walking
#  - Dashing
#  - Custom (run a common event if you've been idle for a period of time)
#
#  INSTRUCTIONS:
#  1. Copy this script below materials and above main
#  2. Create your charsets to use one characterset per actor. (This is where
#     version 2 differs from version 1 greatly.
#     The first character in the charset is the Idle animation
#     The second character in the charset is the Walk animation
#     The third character in the charset is the Dash animation
#
#  (See demo if you don't understand) This change was done to reduce processing
#  significantly and prevent lag when doing too much at once)
#
#------------------------------------------------------------------------------#
#  KNOWN ISSUES:
#  - Move Route Change graphic commands only work when the switch is on.
#    Then if you turn it off again, the graphic changes back to the original.
#    Use "Set Actor Graphic" event command to change instead.
#------------------------------------------------------------------------------#

($imported ||= {})["Chara_Anims"] = true
module Chara_Anims
  
#------------------------------------------------------------------------------#  
#  SETUP OPTIONS
#------------------------------------------------------------------------------#

  ANIM_SWITCH = 1             # ID of a switch to disable this effect.
                              # Turn switch ON in order to use change graphic
                              # move route commands. Turn off to restore anims.
                              
  DASH_SPEED = 1.2            # 1 is RMVX default dash speed.

  COMMON_EVENT = 0            # Common event ID that plays after a certain time
  COMMON_EVENT_TIME = 0     # Frames idle before common event called.
  REPEAT_EVENT = false        # Repeat this common event if player remains idle?
                              # (restarts the common event time) true or false.
#------------------------------------------------------------------------------#  
#  END SETUP OPTIONS
#------------------------------------------------------------------------------#

end # Chara_Anims


class Sprite_Character < Sprite_Base
  alias galv_charanim_initialize initialize
  def initialize(viewport, character = nil)
    @idletime = 0
    galv_charanim_initialize(viewport, character)
  end

  alias galv_charanim_update update
  def update
    galv_charanim_update 
    return if $game_switches[Chara_Anims::ANIM_SWITCH]
    return move_anim if $game_player.moving?
    @idletime += 1
    idle_anim if @idletime == 5
    idle_event if @idletime == Chara_Anims::COMMON_EVENT_TIME
  end

  def idle_anim
    $game_player.step_anime = true
    if $game_party.leader.character_index != 1
      $game_party.battle_members.each { |m| m.set_g(1) }
      $game_player.refresh
    end
    @idletime += 1
  end

  def move_anim
    if $game_player.dash?
      if $game_party.leader.character_index != 0
        $game_party.battle_members.each { |m| m.set_g(0) }
        $game_player.refresh
      end
    else
      if $game_party.leader.character_index != 2
        $game_party.battle_members.each { |m| m.set_g(2) }
        $game_player.refresh
      end
    end
    @idletime = 0
  end

  def idle_event
    return @idletime = 0 if $game_map.interpreter.running?
    $game_temp.reserve_common_event(Chara_Anims::COMMON_EVENT)
    @idletime = 0 if Chara_Anims::REPEAT_EVENT
  end
end # Sprite_Character < Sprite_Base


class Game_CharacterBase
  alias galv_charanim_init_public_members init_public_members
  def init_public_members
    galv_charanim_init_public_members
    @step_anime = true
  end
  
  # OVERWRITE FOR PERFORMANCE PURPOSES
  def real_move_speed
    @move_speed + (dash? ? Chara_Anims::DASH_SPEED : 0)
  end
end # Game_CharacterBase


class Game_Actor < Game_Battler
  def set_g(i)
    @character_index = i
  end
end # Game_Actor < Game_Battler


class Game_Player < Game_Character
  attr_accessor :step_anime
end # class Game_Player < Game_Character
