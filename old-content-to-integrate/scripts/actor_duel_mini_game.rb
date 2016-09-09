#-------------------------------------------------------------------------------
#  Galv's Actor Duel Mini Game
#-------------------------------------------------------------------------------
#  For: RPGMAKER VX ACE
#  Version 1.5
#-------------------------------------------------------------------------------
#  2013-09-11 - Version 1.5 - fixed <fse: > tag for skills. Ooops!
#  2013-07-13 - Version 1.4 - fixed a bug with changing music script call
#  2013-07-11 - Version 1.3 - added compatibility with victor's animated battler
#                           - added tag for actor to play victory pose once
#  2013-07-11 - Version 1.2 - fixed (hopefully) a crash with AI battle. Updated
#                             AI to use skills more often.
#  2013-07-10 - Version 1.1 - added state icons, button combo moves, working
#                           - regen, poisons, buffs, projectile attacks.
#  2013-07-08 - Version 1.0 - release
#-------------------------------------------------------------------------------
#  Holder's animated battler spritesheets can be found here:
#  http://animatedbattlers.wordpress.com/
#-------------------------------------------------------------------------------
#  This script adds a scene where you can face two actors against each other in
#  a mini-game duel that plays similar to a fighting game.
#  You can do Player1 VS AI or Player1 VS Player2 (on same computer)
#
#  The actors use their statistics and hp in the duel. They can move, jump,
#  block, attack and use button combo skills that you create using notetags
#  on skills. Normal attack damage formula is taken from skill 1 by default.
#
#  Actors have stamina that regenerates during the fight. Each attack uses a
#  certain amount of stamina and the fighter cannot attack or use a skill if he
#  doesn't have enough left.
#
#  Fighters can be affected by buffs and states, however a few things have no
#  effect in an actor duel such as blinds or stuns. Poisons, regen, parameter
#  boosting stats do work.
#
#-------------------------------------------------------------------------------
#  BASIC INSTRUCTIONS
#-------------------------------------------------------------------------------
#  1. Get holder style battlers (http://animatedbattlers.wordpress.com/)
#  2. Import battlers into /Graphics/Battlers folder
#  3. Copy /Graphics/Battlers/FightSkills.png from the demo into your project
#  4. Copy /Graphics/System/kombat_bar.png from the demo into your project
#  5. Put this script below Materials and above main.
#  6. Read all instructions and settings
#  7. Remember to start a NEW GAME instead of loading a save file that was made
#     prior to adding this script
#-------------------------------------------------------------------------------
 
#-------------------------------------------------------------------------------
#  SCRIPT CALLS
#-------------------------------------------------------------------------------
#
#  set_fighters(id1,id2)         # Starts a kombat between actors with id1 & id2
#
#  set_fbacks("back1","back2")   # Change battlebacks for next kombat. "back1"
#                                # is from /Graphics/Battlebacks1/ and "back2"
#                                # is from /Graphics/Battlebacks2/ 
#
#  set_fmusic("MusicName")       # Change the kombat music
#
#  set_fmode(x)                  # 0 = P1 vs AI      1 = P1 vs P2    (Default 0)
#
#  add_fskill(a_id,s_id,[btns])  # a_id = actor id... s_id = skill id
#                                # [btns] is the button combo array which can
#                                # include:   :l   :r   :u   :d
#                                # (See explanation below)
#
#-------------------------------------------------------------------------------
#  btn       info
#  -----------------------------
#  :l        Left key for whomever is on the left. 'away from enemy' key.
#  :r        Right key for whomever is on the left. 'toward the enemy' key.
#  :u        Up key
#  :d        Down key
#
#  EXAMPLE OF SCRIPT CALL TO ADD A SKILL:
#  add_fskill(1,80,[:l,:l,:r])     # This will give actor 1 a button combo:
#                                  # Left, Left, Right, Attack (while on left)
#                                  # (Right, Right, Left, Attack while on right)
#                                  # Which will activate skill 80
#
#-------------------------------------------------------------------------------
 
#-------------------------------------------------------------------------------
#  Note tag for ACTORS required
#-------------------------------------------------------------------------------
#
#  <fimage: imagename>       # The name of the holder-style spritesheet 
#                            # image from /Graphics/Battlers/
#
#-------------------------------------------------------------------------------
#  Note tag for ACTORS to override Defaults
#-------------------------------------------------------------------------------
#
#  <fatks: x,x,x,x>          # The rows in the spritesheet to use for the
#                            # actor's normal attacks. Default is COMBO below
#
#  <fse miss: sename>        # SE to use for attacking and missing
#
#  <fhit: x>                 # Animation played when hitting enemy with attack
#
#  <frange: x>               # How close need to be to make contact with attack
#
#  <fviconeanim>             # This notetag will mean the actor's victory pose
#                            # will only play once instead of repeat.
#
#-------------------------------------------------------------------------------
 
#-------------------------------------------------------------------------------
#  Note tag for SKILLS
#-------------------------------------------------------------------------------
#
#  <fpose: x>            # The pose row used for actor when using this skill.
#                        # Will default to row 7 if no tag added.
#
#  <fcost: x>            # Stamina required to use skill
#
#  <fse: sename>         # SE that plays when using the skill
#
#  <fp: p,s,a,t,r>       # Use this tag if the skill will be a projectile.
#                        # p = pose row of SKILLIMAGE spritesheet
#                        # s = speed projectile travels
#                        # a = animation_id when projectile is created
#                        # t = time before projectile disappears (60 per second)
#                        # r = How close projectile needs to be to make contact
#                        # Skill's 'scope' must be set to enemy for this to work
#                        
#
#
#-------------------------------------------------------------------------------
#  BUTTON COMBO NOTE
#  If a skill has scope of ally, the animation in the database skill is played
#  on the user. If not, the animation is played when the skill hits the enemy.
#-------------------------------------------------------------------------------
 
#-------------------------------------------------------------------------------
#  DEFAULT SPRITESHEET POSES (HOLDER SETUP)
#-------------------------------------------------------------------------------
#  ROW     POSE                     USED IN DEFAULT SCRIPT
#
#   0      Idle                     Yes
#   1      Guard                    Yes
#   2      Poor Status              Yes
#   3      Get hit                  Yes
#   4      Normal Attack            Yes
#   5      Use Item
#   6      Use Skill
#   7      Use Magic                Yes
#   8      Move toward              Yes
#   9      Move back                Yes
#   10     Victory                  Yes
#   11     Battle Start
#   12     Dead                     Yes
#   13     Spritesheet Info
#-------------------------------------------------------------------------------
 
($imported ||= {})["Galv_ActorDuel"] = true
module GALVFIGHT
 
#-------------------------------------------------------------------------------
#
#  ** SETTINGS
#
#-------------------------------------------------------------------------------
   
  FONT = "Arial"  # Font used in script
  VICTOR_VAR = 1  # Variable used to store the winner's ID in. 0 if nobody wins.
   
  QUIT_SWITCH = 1 # Turn this swith ON to disable the quit menu. OFF to enable
   
  CMD_QUIT = "Quit Match"  # To quit the fight
  CMD_CANCEL = "Cancel"    # When cancelling the quit menu
 
  # Spritesheet
 
  COLS = 4        # Number of animation columns in spritesheet
  ROWS = 14       # Number of rows in spritesheet
  SIZE = 2        # Size of the battlers (2 = 2x zoom. 1 = normal)
   
  SKILLIMAGE = "FightSkills"  # name of skill spritesheet in /Graphics/Battlers/
  SKILLCOLS = 4   # Number of animation columns in skill spritesheet
  SKILLROWS = 14  # Number of rows in skill spritesheet
   
   
  # Actor Defaults
   
  COMBO = [4]           # Array of spritesheet rows that cycle with attacks
                        # eg. [4,5,6] will cycle rows 4,5 and 6 when attacking
  MISS_SE = "Wind7"     # "SE_Name" for missing and attack sound
  HIT_ANIM = 115        # Animation played when hitting enemy.
  GUARD_ANIM = 116      # Animation played when guarded a hit
  RANGE = 45            # Distance from opponent before attack makes contact
 
  JUMP_POSE = 8         # Pose used when jumping
   
  SKILLSE = "Wind7"     # "SE_Name" played when using a skill
 
   
  # Level Defaults
   
  MUSIC = "Battle6"        # Default battle BGM
  VICTORY_ME = "Victory1"  # Default victory ME
   
  BATTLEBACK1 = "Ship"  # Default battleback 1 from /Graphics/Battlebacks1/
  BATTLEBACK2 = "Ship"  # Default battleback 2 from /Graphics/Battlebacks2/
   
  P1_X = 100            # Starting X position of player 1
  P2_X = 455            # Starting X position of player 2
  Y = 310               # Grounded Y position
 
   
  # Fighting
   
  MAX_STAMINA = 500      # Stamina each fighter has
  STAMINA_COST = 100     # Amount of stamina out of 1000 that attacking uses
  REGEN_RATE = 1.3       # Speed that stamina regenerates
   
  GUARD_DAMAGE = 0.25    # Normal damage is multiplied by this when guarding.
   
  ATTACK_SKILL = 1       # Skill to use for basic attacks
   
  TURNTIMER = 150        # Number of frames before it counts as a new turn for
                         # buffs and states
   
   
  # Text
   
  START1 = "Ready?"      # Text that appears at the start
  START2 = "FIGHT!"
 
  NOWINNER = "MATCH OVER!"   # Message when player quits from the match
  WINS = " WINS!"            # Message that comes after winner's name
 
 
   
#-------------------------------------------------------------------------------
#  CONTROLS - PLAYER 1
#-------------------------------------------------------------------------------
  P1_UP =     :UP        # Jump
  P1_DOWN =   :DOWN      # Block
  P1_LEFT =   :LEFT      # Move left
  P1_RIGHT =  :RIGHT     # Move right
  P1_ACTION = :C         # (Spacebar key) Attack
 
#-------------------------------------------------------------------------------
#  CONTROLS - PLAYER 2
#-------------------------------------------------------------------------------
  P2_UP =     :R         # (W key) Jump
  P2_DOWN =   :Y         # (S key) Block
  P2_LEFT =   :X         # (A key) Move Left
  P2_RIGHT =  :Z         # (D key) Move Right
  P2_ACTION = :CTRL      # Attack
 
#-------------------------------------------------------------------------------
 
end
 
#-------------------------------------------------------------------------------
#
#  ** END SETTINGS
#
#-------------------------------------------------------------------------------
 
 
    #---------------#
#---|   GFIGHT_AI   |-----------------------------------------------------------
    #---------------#
 
module GFIGHT_AI
  def update_f2_ai
    update_ai_random
    update_ai_decision
    update_ai_action
    update_timer
    update_victorcheck
  end
   
  def p1; @f1; end
  def ai; @f2; end
     
  def update_ai_random
    if !ai_timer_running?
      @chance = (rand(10) + 1).to_i
      @schance = (rand(10) + 1).to_i
    end
  end
 
  def update_ai_decision
    if ai.in_range_x
      update_ai_in_range
    else
      update_ai_out_of_range
    end
  end
   
  def update_ai_in_range
    if p1.attacking?
      # IF PLAYER IS ATTACKING
      if ai.getting_hit? && @chance > 2
        @ai_move = :down
        @ai_action = false
        @ai_timer = rand(50) + 10 if !ai_timer_running?
      else
        if @chance > 5
          @ai_move = :down
          @ai_action = false
          @ai_timer = rand(50) + 10 if !ai_timer_running?
        elsif @chance > 2
          ai_melee_action
          @ai_timer = rand(20) + 5 if !ai_timer_running?
        else
          @ai_move = random_move_in_range
          @ai_timer = rand(50) + 10 if !ai_timer_running?
        end
      end
    else
      # IF PLAYER IS NOT ATTACKING
      if @chance > 4
        ai_melee_action
        @ai_timer = rand(20) + 10 if !ai_timer_running?
      elsif @chance > 2
        @ai_move = :down
        @ai_action = false
        @ai_timer = rand(40) + 20 if !ai_timer_running?
      else
        @ai_move = random_move_in_range
        @ai_timer = rand(40) + 20 if !ai_timer_running?
      end
    end
  end
   
  def update_ai_out_of_range
    @ai_move = random_move_out_of_range
    @ai_action = false
    @ai_raction = true
  end
   
  def ai_jump
    if ai.fjumping?
      @ai_move = :none
    else
      @ai_move = :up
      ai.fight_pose = 0
    end
  end
   
  def random_move_in_range
    if ai.fight_x <= 20 + 10
      return @chance > 7 ? :right : :none
    elsif ai.fight_x >= Graphics.width - 20 - 10
      return @chance > 7 ? :left : :none
    elsif @chance >= 8
      return :right
    elsif @chance >= 5
      return :left
    elsif @chance == 1
      return ai.fjumping? ? :left : :up
    elsif @chance == 2
      return ai.fjumping? ? :right : :up
    else
      return :none
    end
  end
   
  def random_move_out_of_range
    if ai.fight_x <= 20 + 10
      @ai_timer = rand(30) + 10 if !ai_timer_running?
      return @chance > 4 ? :right : :none
    elsif ai.fight_x >= Graphics.width - 20 - 10
      @ai_timer = rand(30) + 10 if !ai_timer_running?
      return @chance > 4 ? :left : :none
    elsif @chance >= 7
      @ai_timer = rand(40) + 10 if !ai_timer_running?
      return ai_advance
    elsif @chance >= 4
      @ai_timer = rand(40) + 10 if !ai_timer_running?
      return ai_retreat
    else
      @ai_timer = rand(30) + 10 if !ai_timer_running?
      return :none
    end
  end
   
  def ai_timer_running?
    @ai_timer > 0
  end
   
  def update_ai_action
    ai.fight_move(@ai_move)
    ai_melee_action if @ai_action
    ai_range_action if @ai_raction
  end
   
  def ai_melee_action
    if @schance <= 2
      bcs = get_ai_random_skill
      ai.fight_combo_skill(bcs) if bcs > 0
    else
      ai.fight_action
    end
  end
   
  def ai_range_action
    if @schance <= 3
      bcs = get_ai_projectile_skill
      ai.fight_combo_skill(bcs) if bcs > 0
    end
  end
   
  def get_ai_projectile_skill
    ai.combo_skills.each { |combo|
      return combo[1] if $data_skills[combo[1]].fproj
    }
    return 0
  end
   
  def get_ai_random_skill
    cskills = ai.combo_skills.to_a
    rskill = cskills.sample
    @ai_raction = false
    return 0 if rskill.nil?
    return rskill[1] <= 0 ? 0 : rskill[1]
  end
   
  def ai_make_attack
    if ai.fstamina < GALVFIGHT::STAMINA_COST
      @ai_move = :down
    else
      @ai_action = true
      @ai_move = random_move_in_range
    end
  end
   
  def ai_retreat
    return ai.fight_x > p1.fight_x ? :right : :left
  end
   
  def ai_advance
    return ai.fight_x < p1.fight_x ? :right : :left
  end
 
  def update_timer
    @ai_timer -= 1
  end
   
  def update_victorcheck
    if p1.dead?
      @phase = 2
      @victor = ai
    end
  end
end # GFIGHT_AI
 
 
    #----------------------#
#---|   GAME_INTERPRETER   |----------------------------------------------------
    #----------------------#
 
class Game_Interpreter
  def set_fighters(player1,player2)
    $game_system.save_bgm
    command_221
    a = $game_actors[player1]
    b = $game_actors[player2]
    $game_system.fighters = [a,b]
    SceneManager.call(Scene_ActorDuel)
    wait(1)
    command_222
    $game_system.replay_bgm
  end
   
  def set_fbacks(back1,back2)
    $game_system.fbacks = [back1,back2]
  end
   
  def set_fmusic(music)
    $game_system.fmusic[0] = music
  end
   
  def set_fmode(mode)
    $game_system.fmode = mode
  end
   
  def add_skill(a_id,s_id,btns)
    $game_actors[a_id].combo_skills[btns] = s_id
  end
end
 
 
    #------------------#
#---|   RPG BASEITEM   |--------------------------------------------------------
    #------------------#
 
class RPG::BaseItem
  def f_atks
    if @f_atks.nil?
      if @note =~ /<fatks:[ ](.*)>/i
        @f_atks = $1.to_s.split(",").map {|i| i.to_i}
      else
        @f_atks = GALVFIGHT::COMBO
      end
    end
    @f_atks
  end
end # RPG::Item
 
class RPG::Skill
  def fpose
    if @fpose.nil?
      if @note =~ /<fpose:[ ](.*)>/i
        @fpose = $1.to_i
      else
        @fpose = 7
      end
    end
    @fpose
  end
  def fcost
    if @fcost.nil?
      if @note =~ /<fcost:[ ](.*)>/i
        @fcost = $1.to_i
      else
        @fcost = GALVFIGHT::STAMINA_COST
      end
    end
    @fcost
  end
  def fproj
    if @fproj.nil?
      if @note =~ /<fp:[ ](.*)>/i
        @fproj = $1.to_s.split(",").map {|i| i.to_i}
      else
        @fproj = nil
      end
    end
    @fproj
  end
  def fse
    if @fse.nil?
      if @note =~ /<fse:[ ](.*)>/i
        @fse = $1.to_s
      else
        @fse = GALVFIGHT::SKILLSE
      end
    end
    @fse
  end
end # RPG::Skill
 
 
    #----------------#
#---|   GAME_ACTOR   |----------------------------------------------------------
    #----------------#
 
class Game_Actor < Game_Battler
  attr_reader :fhit_anim
  attr_reader :frange
  attr_accessor :fight_x
  attr_accessor :fight_y
  attr_accessor :fight_pose
  attr_accessor :fight_sprite
  attr_accessor :fight_speed
  attr_accessor :fight_mspeed
  attr_accessor :fstamina
  attr_accessor :combo_skills
  attr_accessor :fprojectiles
  attr_accessor :fvicpose
 
  alias galv_fight_gagb_setup setup
  def setup(actor_id)
    galv_fight_gagb_setup(actor_id)
    init_fight_vars
    @fight_sprite = actor.note =~ /<fimage: (.*)>/i ? $1 : ""
    @combo = actor.f_atks
    @combo_skills = {}
    @fse_miss = actor.note =~ /<fse miss: (.*)>/i ? $1 : GALVFIGHT::MISS_SE
    @fhit_anim = actor.note =~ /<fhit: (.*)>/i ? $1.to_i : GALVFIGHT::HIT_ANIM
    @frange = actor.note =~ /<frange: (.*)>/i ? $1.to_i : GALVFIGHT::RANGE
    @fvicpose = actor.note =~ /<fviconeanim>/i ? true : false # true = one play
  end
 
  def init_fight_vars
    @fight_x = 0
    @fight_y = GALVFIGHT::Y
    @fight_pose = 0
    @fight_speed = 0.to_f
    @fight_mspeed = 4
    @attack_timer = 0
    @skill_timer = 0
    @takehit_timer = 0
    @jump = 0
    @fstamina = GALVFIGHT::MAX_STAMINA
    @btn_combo = []
    @btn_timer = 0
    @fprojectiles = []
  end
 
  def fight_move(direction)
    case direction
    when :up
      fight_jump
      fight_slowing
    when :down
      fight_guard
      fight_slowing
    when :left
      if !attacking?
        if @fight_x < fight_target.fight_x
          @fight_pose = 9
        else
          @fight_pose = 8
        end
      end
      return @fight_speed = 0 if fight_left_limit
      @fight_speed -= 0.4
      @fight_speed = -@fight_mspeed if @fight_speed <= -@fight_mspeed
    when :right
      if !attacking?
        if @fight_x < fight_target.fight_x
          @fight_pose = 8
        else
          @fight_pose = 9
        end
      end
      return @fight_speed = 0 if fight_right_limit
      @fight_speed += 0.4
      @fight_speed = @fight_mspeed if @fight_speed >= @fight_mspeed
    when :none
      if !attacking?
        @fight_pose = fjumping? ? GALVFIGHT::JUMP_POSE : fight_idle_pose
      end
      fight_slowing
    end
  end
 
  def fight_right_limit; @fight_x >= Graphics.width - 20; end
  def fight_left_limit; @fight_x <= 20; end
 
  def fight_idle_pose
    hp < mhp * 0.25 ? 2 : 0
  end
 
  def fight_slowing
    if moving_right?
      return @fight_speed = 0 if @fight_x >= Graphics.width - 20
      @fight_speed -= [0 + @fight_speed,0.3].min
    elsif moving_left?
      return @fight_speed = 0 if @fight_x <= 20
      @fight_speed += [0 - @fight_speed,0.3].min
    end
  end
 
  def fight_action
    return if attacking? || guarding? || getting_hit?
    bcs = get_combo_skill
    if bcs.nil?
      fight_normal_attack
    else
      fight_combo_skill(bcs)
    end
  end
 
  def get_combo_skill
    @combo_skills.each { |combo|
      if @btn_combo.reverse[0..(combo[0].size - 1)] == combo[0].reverse
        return combo[1]
      end
    }
    return nil
  end
 
  def fight_normal_attack
    return if @fstamina < GALVFIGHT::STAMINA_COST
    @fskill_used = nil
    @fstamina -= GALVFIGHT::STAMINA_COST
    se = @fse_miss
    vol = 80 + rand(20)
    pit = 100 + rand(50)
    RPG::SE.new(se,vol,pit).play
    @combo = @combo.rotate
    @fight_pose = @combo[0]
    @attack_timer = 22
  end
 
  def fight_combo_skill(skill)
    sk = $data_skills[skill]
    return if @fstamina < sk.fcost #fight_normal_attack if @fstamina < sk.fcost
    return if attacking?
    @fstamina -= sk.fcost
    se = sk.fse
    vol = 80 + rand(20)
    pit = 100 + rand(50)
    RPG::SE.new(se,vol,pit).play
    if sk.fproj
      # Create Projectile Here
      @fprojectiles << FightProjectile.new(sk,self)
      self.animation_id = sk.fproj[2]
      @skill_timer = 22
    elsif sk.scope >= 7 
      self.animation_id = sk.animation_id
      self.fight_item_apply(self, sk)
      @skill_timer = 22
    else
      @fskill_used = sk
      @attack_timer = 22
    end
    @fight_pose = sk.fpose
  end
 
  def fight_item_apply(user, item)
    @result.clear
    @result.used = item_test(user, item)
    @result.missed = (@result.used && rand >= item_hit(user, item))
    @result.evaded = (!@result.missed && rand < item_eva(user, item))
    if @result.hit?
      @result.critical = (rand < item_cri(user, item))
      damage = fight_damage_value(self, $data_skills[item.id])
      fight_target.do_damage(guarding?,item.id,damage)
      item.effects.each {|effect| item_effect_apply(user, item, effect) }
      item_user_effect(user, item)
    end
  end
 
  def fight_guard
    return if attacking?
    @fight_pose = 1
  end
 
  def fight_jump
    return if fjumping? || in_air?
    @jump = -10 - GALVFIGHT::SIZE / 2
  end
 
  def fjumping?; @jump < 0; end
  def in_air?; @fight_y < GALVFIGHT::Y; end
  def attacking?; @attack_timer > 0 || @skill_timer > 0; end
  def guarding?; @fight_pose == 1; end
  def getting_hit?; @takehit_timer > 0; end
  def moving_right?; @fight_speed > 0; end
  def moving_left?; @fight_speed < 0; end
  def away(amount)
    if fight_x < fight_target.fight_x
      return amount
    else
      return -amount
    end
  end
 
  def move_pose(direction)
    return 1 if @fight_x < fight_target.fight_x
  end
 
  def update_fight
    @takehit_timer -= 1
    update_fight_movement
    update_gravity
    return @fight_pose = 12 if dead?
    return @fight_pose = 3 if getting_hit? && !guarding?
    update_btn_combo
    update_stamina
    update_hit
    @attack_timer -= 1
    @skill_timer -= 1
  end
 
  def update_stamina
    @fstamina += GALVFIGHT::REGEN_RATE if @fstamina < GALVFIGHT::MAX_STAMINA
  end
 
  def update_fight_movement
    if moving_right?
      @fight_x += [@fight_speed,@fight_mspeed].min
    elsif moving_left?
      @fight_x += [@fight_speed,-@fight_mspeed].max
    end
  end
 
  def update_gravity
    if fjumping? || in_air?
      @fight_y += @jump + $game_system.gravity
      @jump += 0.2
    else
      @fight_y = GALVFIGHT::Y
      @jump = 0
    end
  end
 
  def fight_target
    if $game_system.fighters[0].id == @actor_id
      return $game_system.fighters[1]
    else
      return $game_system.fighters[0]
    end
  end
 
  def update_hit
    if @attack_timer == 8
      if make_contact?
        if fight_target.guarding?
          fight_target.animation_id = GALVFIGHT::GUARD_ANIM
          s = @fskill_used ? @fskill_used : $data_skills[GALVFIGHT::ATTACK_SKILL]
          damage = fight_damage_value(self,s)
          do_damage(true,s.id,damage)
          @fskill_used = nil
        else
          if @fskill_used
            anim = @fskill_used.animation_id
            s = @fskill_used
          else
            anim = @fhit_anim
            s = $data_skills[GALVFIGHT::ATTACK_SKILL]
          end
          fight_target.animation_id = anim
          damage = fight_damage_value(self,s)
          do_damage(false,GALVFIGHT::ATTACK_SKILL,damage)
          @fskill_used = nil
        end
      end
    end
  end
 
  def proj_hit(skill)
    if fight_target.guarding?
      fight_target.animation_id = GALVFIGHT::GUARD_ANIM
    else
      fight_target.animation_id = skill.animation_id
    end
    fight_target.fight_item_apply(self,skill)
  end
   
  def do_damage(guard,s_id,damage,proj = false)
    if guard
      damage *= GALVFIGHT::GUARD_DAMAGE
      if damage > 0
        fight_target.fight_speed += away(2) * GALVFIGHT::SIZE
        @fight_speed += fight_target.away(2) * GALVFIGHT::SIZE if proj
      end
    else
      fight_target.fight_speed += away(4) * GALVFIGHT::SIZE if damage > 0
    end
    fight_target.fight_damage(damage)
  end
   
  def fight_damage_value(user, item)
    value = item.damage.eval(user, self, $game_variables)
    value *= item_element_rate(user, item)
    value *= pdr if item.physical?
    value *= mdr if item.magical?
    value *= rec if item.damage.recover?
    value = apply_variance(value, item.damage.variance)
    return value
  end
   
  def fight_damage(damage)
    change_hp(-damage.to_i,true) if SceneManager.scene.phase == 1
    @attack_timer = 0
    @skill_timer = 0
    if damage > 0
      @takehit_timer = 18 
      remove_states_by_damage
    end
  end
   
  def reach; @frange * GALVFIGHT::SIZE; end
  def range; (fight_target.fight_x - @fight_x).abs; end
  def in_range_x; (fight_target.fight_x - @fight_x).abs < reach; end
  def in_range_y; ((fight_target.fight_y - @fight_y).abs) * 1.2 < reach ;end
  def near_range_x; ((fight_target.fight_x - @fight_x).abs) / 1.5 < reach; end
   
  def make_contact?
    return true if in_range_x && in_range_y
  end
   
  def reset_fight
    erase_state(death_state_id)
    @hp = 1 if @hp <= 0
    init_fight_vars
  end
   
  def end_match
    @fight_pose = 0 if !dead?
  end
   
  def sta_rate
    @fstamina.to_f / GALVFIGHT::MAX_STAMINA
  end
   
  def update_btn_combo
    @btn_combo = [] if @btn_timer == 0
    @btn_timer -= 1
  end
   
  def add_combo(direction)
    @btn_timer = 20
    @btn_combo << direction
  end
end # Game_Actor < Game_Battler
 
 
    #-----------------#
#---|   GAME_SYSTEM   |---------------------------------------------------------
    #-----------------#
 
class Game_System
  attr_accessor :fighters
  attr_accessor :fmode
  attr_accessor :gravity
  attr_accessor :fbacks
  attr_accessor :fmusic
   
  alias galv_fight_gs_initialize initialize
  def initialize
    galv_fight_gs_initialize
    @gravity = 5
    @fbacks = [GALVFIGHT::BATTLEBACK1,GALVFIGHT::BATTLEBACK2]
    @fmusic = [GALVFIGHT::MUSIC,GALVFIGHT::VICTORY_ME]
    @fmode = 0 #  0 is Player vs AI   1 is Player vs Player
  end
end # Game_System
 
 
    #---------------------#
#---|   SCENE_ACTORDUEL   |-----------------------------------------------------
    #---------------------#
 
class Scene_ActorDuel < Scene_Base
  attr_accessor :spriteset
  attr_reader :phase
  include GFIGHT_AI
   
  def start
    super
    init_fvariables
    determine_fighters
    create_spriteset
    create_windows
  end
   
  def init_fvariables
    $game_variables[GALVFIGHT::VICTOR_VAR] = 0
    @phase = 0
    @ai_move = :none
    @ai_action = false
    @ai_timer = 0
    @bufftimer = 0
    RPG::BGM.new($game_system.fmusic[0],100,100).play
  end
   
  def determine_fighters
    @f1,@f2 = $game_system.fighters
    @f1.fight_x = GALVFIGHT::P1_X
    @f2.fight_x = GALVFIGHT::P2_X
  end
   
  def create_spriteset
    @spriteset = Spriteset_ActorDuel.new
  end
   
  def create_windows
    @hp_window = Window_FightHealth.new
    @info_window = Window_Fight.new
    @command_window = Window_FightCommand.new
    @command_window.deactivate.hide
    @command_window.set_handler(:ok,     method(:on_ok))
    @command_window.set_handler(:cancel, method(:on_cancel))
  end
   
  def on_ok
    @phase = 2
    @command_window.hide.deactivate
    @f1.end_match
    @f2.end_match
  end
   
  def on_cancel
    @command_window.hide.deactivate
  end
 
#--------|  UPDATE
 
  def update
    super
    update_graphics
    case @phase
    when 0
      update_begin
    when 1
      return if @command_window.active
      update_fighter1
      update_fighter2
      update_other
    when 2
      update_common(@f2)
      update_common(@f1)
      @f1.fight_speed = 0
      @f2.fight_speed = 0
      update_end
    end
  end
   
  def update_begin
    return while @info_window.active
    @phase = 1
  end
   
  def update_end
    RPG::ME.new($game_system.fmusic[1],100,100).play if !@end_timer
    @end_timer ||= 60
    @victor.fight_pose = 10 if @victor
    @end_timer -= 1
    return if @end_timer > 0
    @info_window.victory(@victor) if @end_timer == 0
    return while @info_window.active
    $game_system.fighters.each { |actor| actor.reset_fight }
    $game_variables[GALVFIGHT::VICTOR_VAR] = @victor ? @victor.id : 0
    SceneManager.return
  end
   
  def update_graphics
    @spriteset.update
  end
   
  def update_other
    if Input.trigger?(:B) && !$game_switches[GALVFIGHT::QUIT_SWITCH]
      @command_window.show.activate
    end
    if @bufftimer >= GALVFIGHT::TURNTIMER
      @f1.on_turn_end
      @f2.on_turn_end
      @f1.remove_buffs_auto
      @f2.remove_buffs_auto
      @bufftimer = 0
    end
    @bufftimer += 1
  end
   
  def update_fighter1
    update_f1_movement
    update_f1_action
    update_common(@f1)
  end
   
  def update_f1_movement
    if Input.press?(GALVFIGHT::P1_DOWN)
      @f1.fight_move(:down)
      @f1.add_combo(:d) if Input.trigger?(GALVFIGHT::P1_DOWN)
    elsif Input.trigger?(GALVFIGHT::P1_UP)
      @f1.fight_move(:up)
      @f1.add_combo(:u)
    elsif Input.press?(GALVFIGHT::P1_LEFT)
      @f1.fight_move(:left)
      @f1.add_combo(get_back_dir(@f1)) if Input.trigger?(GALVFIGHT::P1_LEFT)
    elsif Input.press?(GALVFIGHT::P1_RIGHT)
      @f1.fight_move(:right)
      @f1.add_combo(get_forward_dir(@f1)) if Input.trigger?(GALVFIGHT::P1_RIGHT)
    else
      @f1.fight_move(:none)
    end
  end
   
  def get_back_dir(player)
    return player.fight_x < player.fight_target.fight_x ? :l : :r
  end
   
  def get_forward_dir(player)
    return player.fight_x < player.fight_target.fight_x ? :r : :l
  end
   
  def update_f1_action
    @f1.fight_action if Input.trigger?(GALVFIGHT::P1_ACTION) &&
      !@f1.attacking? && !@f1.guarding?
    if @f2.dead?
      @phase = 2
      @victor = @f1
    end
  end
   
  def update_fighter2
    if $game_system.fmode == 1
      update_f2_movement
      update_f2_action
    else
      update_f2_ai
    end
    update_common(@f2)
  end
   
  def update_f2_movement
    if Input.press?(GALVFIGHT::P2_DOWN)
      @f2.fight_move(:down)
      @f2.add_combo(:d) if Input.trigger?(GALVFIGHT::P2_DOWN)
    elsif Input.trigger?(GALVFIGHT::P2_UP)
      @f2.fight_move(:up)
      @f2.add_combo(:u)
    elsif Input.press?(GALVFIGHT::P2_LEFT)
      @f2.fight_move(:left)
      @f2.add_combo(get_back_dir(@f2)) if Input.trigger?(GALVFIGHT::P2_LEFT)
    elsif Input.press?(GALVFIGHT::P2_RIGHT)
      @f2.fight_move(:right)
      @f2.add_combo(get_forward_dir(@f2)) if Input.trigger?(GALVFIGHT::P2_RIGHT)
    else
      @f2.fight_move(:none)
    end
  end
 
  def update_f2_action
    @f2.fight_action if Input.trigger?(GALVFIGHT::P2_ACTION) && !@f2.attacking? && !@f2.guarding?
    if @f1.dead?
      @phase = 2
      @victor = @f2
    end
  end
   
  def update_common(fighter)
    fighter.update_fight
  end
 
#--------|  DESTROY
 
  def dispose_spriteset
    @spriteset.dispose
  end
   
  def terminate
    super
    dispose_spriteset
    @f1.on_battle_end
    @f2.on_battle_end
  end
end # Scene_Kombat < Scene_Base
 
 
    #-------------------------#
#---|   SPRITESET_ACTORDUEL   |-------------------------------------------------
    #-------------------------#
 
class Spriteset_ActorDuel
  attr_accessor :viewport3
 
  def initialize
    create_viewports
    create_battleback1
    create_battleback2
    create_fighters
    create_face1
    create_face2
    create_bars
    update
  end
 
#-------- |  CREATE STUFF
 
  def create_viewports
    @viewport1 = Viewport.new
    @viewport2 = Viewport.new
    @viewport3 = Viewport.new
    @viewport1.z = 20
    @viewport2.z = 50
    @viewport3.z = 150
  end
   
  def create_battleback1
    return if !$game_system.fbacks[0]
    @back1_sprite = Sprite.new(@viewport1)
    @back1_sprite.bitmap = Cache.battleback1($game_system.fbacks[0])
    @back1_sprite.z = -1
    center_sprite(@back1_sprite)
  end
 
  def create_battleback2
    return if !$game_system.fbacks[1]
    @back2_sprite = Sprite.new(@viewport1)
    @back2_sprite.bitmap = Cache.battleback2($game_system.fbacks[1])
    @back2_sprite.z = 0
    center_sprite(@back2_sprite)
  end
   
  def create_fighters
    @fighters = []
    @shadows = []
    $game_system.fighters.each { |f|
      @shadows << Sprite_FightShadow.new(@viewport2,f)
      @fighters << Sprite_Fighter.new(@viewport2,f)
    }
  end
   
  def create_face1
    face_index = $game_system.fighters[0].face_index
    @face1 = Sprite.new(@viewport2)
    @face1.bitmap = Cache.face($game_system.fighters[0].face_name)
    rect = Rect.new(face_index % 4 * 96, face_index / 4 * 96, 96, 96)
    @face1.src_rect.set(rect)
  end
   
  def create_face2
    face_index = $game_system.fighters[1].face_index
    @face2 = Sprite.new(@viewport2)
    @face2.bitmap = Cache.face($game_system.fighters[1].face_name)
    rect = Rect.new(face_index % 4 * 96, face_index / 4 * 96, 96, 96)
    @face2.src_rect.set(rect)
    @face2.x = Graphics.width - 96
    @face2.mirror = true
  end
   
  def create_bars
    @bar1 = Sprite.new(@viewport3)
    @bar1.bitmap = Cache.system("kombat_bar") rescue Cache.system("")
    @bar2 = Sprite.new(@viewport3)
    @bar2.bitmap = Cache.system("kombat_bar") rescue Cache.system("")
    @bar2.x = Graphics.width - @bar2.bitmap.width
    @bar2.mirror = true
  end
   
#-------- |  UPDATE STUFF
 
  def update
    @fighters.each { |s| s.update }
    @shadows.each { |s| s.update }
    @viewport1.update
    @viewport2.update
    @viewport3.update
    update_projectiles
  end
 
  def update_projectiles
    $game_system.fighters.each { |f|
      f.fprojectiles.each_with_index { |p,i|
        if p.finished?
          p.dispose if !p.nil?
          p = nil
        else
          p.update
        end
      }
      f.fprojectiles.compact!
    }
  end
 
#-------- |  DESTROY STUFF
   
  def dispose
    dispose_viewports
    dispose_fighters
    dispose_background
    dispose_faces
    dispose_projectiles
  end
 
  def dispose_viewports
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
  end
   
  def dispose_fighters
    @fighters.each { |s| s.dispose }
    @shadows.each { |s| s.dispose }
    @bar1.dispose
    @bar2.dispose
  end
   
  def dispose_background
    @back1_sprite.dispose if @back1_sprite
    @back2_sprite.dispose if @back2_sprite
  end
   
  def dispose_faces
    @face1.dispose
    @face2.dispose
  end
   
  def dispose_projectiles
    $game_system.fighters.each { |f|
      f.fprojectiles.each { |p| p.dispose }
    }
  end
   
  def center_sprite(sprite)
    sprite.ox = sprite.bitmap.width / 2
    sprite.oy = sprite.bitmap.height / 2
    sprite.x = Graphics.width / 2
    sprite.y = Graphics.height / 2
  end
end # Spriteset_ActorDuel
 
 
    #-------------------#
#---|   SPRITE_FIGHTER  |-------------------------------------------------------
    #-------------------#
 
class Sprite_Fighter < Sprite_Battler
  def initialize(viewport, battler = nil)
    super(viewport,battler)
    init_fvariables
  end
 
  def init_fvariables
    @pattern = 0
    @speed_timer = 0
    @pose = 0
    if $game_system.fighters[0].id == @battler.id 
      player = 0; opponent = 1
    else
      player = 1; opponent = 0
    end
    @player = $game_system.fighters[player]
    @opponent = $game_system.fighters[opponent]
  end
   
  def update
    if @battler.fight_sprite
      update_bitmap
      update_pose
      update_src_rect
      update_anim
      update_position
      update_facing
    end
    super
  end
 
  def update_bitmap
    new_bitmap = Cache.battler(@battler.fight_sprite,
      @battler.battler_hue)
    if bitmap != new_bitmap
      self.bitmap = new_bitmap
      spritesheet_normal
      init_visibility
      self.zoom_x = GALVFIGHT::SIZE
      self.zoom_y = GALVFIGHT::SIZE
    end
  end
 
  def spritesheet_normal
    @cw = bitmap.width / GALVFIGHT::COLS
    @ch = bitmap.height / GALVFIGHT::ROWS
    self.ox = @cw / 2
    self.oy = @ch
  end
 
  def update_pose
    if @pose != @battler.fight_pose
      @pattern = 0
      @pose = @battler.fight_pose
    end
  end
 
  def update_src_rect
    if @pattern >= GALVFIGHT::COLS
      if @battler.fight_pose == 10 && @battler.fvicpose
        @pattern = GALVFIGHT::COLS - 1
      else
        @pattern = 0
      end
    end
    sx = @pattern * @cw
    sy = @battler.fight_pose * @ch
    self.src_rect.set(sx, sy, @cw, @ch)
  end
   
  def update_origin;end
 
  def update_anim
    @speed_timer += 1
    if @speed_timer > 6
      @pattern += 1
      @speed_timer = 0
    end
  end
   
  def update_facing
    self.mirror = @player.fight_x > @opponent.fight_x ? false : true
  end
 
  def update_position
    self.x = @battler.fight_x
    self.y = @battler.fight_y
  end
   
  def make_animation_sprites
    @ani_sprites = []
    if !@@ani_spr_checker.include?(@animation)
      16.times do
        sprite = ::Sprite.new(viewport)
        sprite.visible = false
        @ani_sprites.push(sprite)
      end
      if @animation.position == 3
        @@ani_spr_checker.push(@animation)
      end
    end
    @ani_duplicated = @@ani_checker.include?(@animation)
    if !@ani_duplicated && @animation.position == 3
      @@ani_checker.push(@animation)
    end
  end
end # Sprite_Fighter < Sprite_Battler
 
 
    #------------------#
#---|   SPRITE_SHADOW  |--------------------------------------------------------
    #------------------#
 
class Sprite_FightShadow < Sprite
  def initialize(viewport, player)
    super(viewport)
    @player = player
    create_shadow
  end
 
  def dispose
    bitmap.dispose if bitmap
    super
  end
 
  def update
    super
    update_position
  end
 
  def create_shadow
    self.bitmap = Cache.system("Shadow")
    self.ox = self.bitmap.width / 2
    self.oy = self.bitmap.height
    self.z = 0
    self.zoom_x = GALVFIGHT::SIZE
    self.zoom_y = GALVFIGHT::SIZE
  end
 
  def update_position
    self.x = @player.fight_x
    self.y = GALVFIGHT::Y
  end
end # Sprite_FightShadow < Sprite
 
 
    #-----------------------#
#---|   WINDOW_FIGHTHEALTH  |---------------------------------------------------
    #-----------------------#
 
class Window_FightHealth < Window_Base
  def initialize
    super(0, 0, Graphics.width, 140)
    self.opacity = 0
    refresh
  end
   
  def player; $game_system.fighters; end
     
  def update
    super
    refresh
  end
 
  def refresh
    contents.clear
    contents.font.name = GALVFIGHT::FONT
    draw_player1
    draw_player2
  end
   
  def draw_player1
    pl = player[0]
    draw_hp(pl, 100, 15, false)
    draw_stamina(pl, 100, 40, false)
    draw_text(100,0,100,line_height,pl.name,0)
    draw_actor_icons(pl, 100, 65, 240)
  end
   
  def draw_player2
    pl = player[1]
    draw_hp(pl, contents.width - 224, 15, true)
    draw_stamina(pl, contents.width - 224, 40, true)
    draw_text(contents.width - 200,0,100,line_height,pl.name,2)
    draw_actor_icons(pl, contents.width - 224, 65, 240)
  end
   
  def draw_hp(actor, x, y, r)
    draw_gauge(x, y, 124, actor.hp_rate, hp_gauge_color1, hp_gauge_color2, r, 12)
  end
   
  def draw_stamina(actor, x, y, r)
    draw_gauge(x, y, 124, actor.sta_rate, mp_gauge_color1, mp_gauge_color2, r, 6)
  end
   
  def draw_gauge(x, y, width, rate, color1, color2, reverse, height)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8
    contents.fill_rect(x, gauge_y, width, height, gauge_back_color)
    if reverse
      contents.gradient_fill_rect(x + width - fill_w, gauge_y, fill_w, height,
        color1, color2)
    else
      contents.gradient_fill_rect(x, gauge_y, fill_w, height, color1, color2)
    end
  end
end # Window_FightHealth < Window_Base
 
 
    #-----------------#
#---|   WINDOW_FIGHT  |---------------------------------------------------------
    #-----------------#
 
class Window_Fight < Window_Base
  attr_accessor :phase
  attr_accessor :victor
   
  def initialize
    super(0, 0, Graphics.width, Graphics.height)
    self.opacity = 0
    @phase = 0
    @timer = 0
  end
   
  def update
    case @phase
    when 0
      contents.clear
      contents.font.name = GALVFIGHT::FONT
      contents.font.size += 1
      draw_text(0,0,width,height,GALVFIGHT::START1,1)
    when 2
      contents.clear
      contents.font.name = GALVFIGHT::FONT
      contents.font.size = 80
      draw_text(0,0,width,height,GALVFIGHT::START2,1)
    when 3
      contents.clear
      deactivate
    when 4
      contents.clear
      contents.font.size = 60
      if @victor
        contents.font.name = GALVFIGHT::FONT
        txt = @victor.name.upcase + GALVFIGHT::WINS
        draw_text(0,0,width,height,txt,1)
      else
        contents.font.name = GALVFIGHT::FONT
        draw_text(0,0,width,height,GALVFIGHT::NOWINNER,1)
      end
    when 5
      contents.clear
      deactivate
    end
    @timer += 1
    @phase = 1 if @timer == 40
    @phase = 2 if @timer == 100
    @phase = 3 if @timer == 130
    @phase = 5 if @timer == 300
  end
   
  def victory(victor)
    @victor = victor
    @phase = 4
    @timer = 150
    activate
  end
end # Window_Fight < Window_Base
 
 
    #------------------------#
#---|   WINDOW_FIGHTCOMMAND  |--------------------------------------------------
    #------------------------#
 
class Window_FightCommand < Window_Command
  def initialize
    super(Graphics.width / 2 - window_width / 2, Graphics.height / 2 - 80)
  end
 
  def window_width; return 160; end
  def visible_line_number; return 2; end
 
  def make_command_list
    add_command(GALVFIGHT::CMD_QUIT, :quit, true)
    add_command(GALVFIGHT::CMD_CANCEL, :cancel, true)
  end
 
  def update; super; end
  def select_last; select(0); end
end # Window_FightCommand < Window_Command
 
 
    #---------------------------#
#---|   SPRITE_FIGHTPROJECTILE  |-----------------------------------------------
    #---------------------------#
 
class FightProjectile < Sprite_Base
  attr_accessor :skill
  def initialize(skill, owner)
    @owner = owner
    @target = owner.fight_target
    @skill = skill
    super(SceneManager.scene.spriteset.viewport3)
    init_fvariables
    create_bitmap
  end
 
  def init_fvariables
    self.x = @owner.fight_x
    self.y = @owner.fight_y
    self.opacity = 0
    @pattern = 0
    @pose = @skill.fproj[0]
    @speed_timer = 0
    @range_limit = @skill.fproj[3]
    @range = 0
    @reach = @skill.fproj[4]
  end
   
  def update
    update_src_rect
    update_anim
    update_position
    update_hit
    super
  end
 
  def create_bitmap
    self.bitmap = Cache.battler(GALVFIGHT::SKILLIMAGE, 0)
    @cw = bitmap.width / GALVFIGHT::SKILLCOLS
    @ch = bitmap.height / GALVFIGHT::SKILLROWS
    self.ox = @cw / 2
    self.oy = @ch
    self.mirror = @owner.fight_x > @target.fight_x ? false : true
  end
 
  def update_src_rect
    if @pattern >= GALVFIGHT::SKILLCOLS
      @pattern = 0
    end
    sx = @pattern * @cw
    sy = @pose * @ch
    self.src_rect.set(sx, sy, @cw, @ch)
  end
 
  def update_anim
    @speed_timer += 1
    if @speed_timer > 6
      @pattern += 1
      @speed_timer = 0
    end
  end
 
  def update_position
    self.x += self.mirror ? @skill.fproj[1] : -@skill.fproj[1]
    self.opacity += 20
    @range += 1
  end
   
  def make_animation_sprites
    @ani_sprites = []
    if !@@ani_spr_checker.include?(@animation)
      16.times do
        sprite = ::Sprite.new(viewport)
        sprite.visible = false
        @ani_sprites.push(sprite)
      end
      if @animation.position == 3
        @@ani_spr_checker.push(@animation)
      end
    end
    @ani_duplicated = @@ani_checker.include?(@animation)
    if !@ani_duplicated && @animation.position == 3
      @@ani_checker.push(@animation)
    end
  end
   
  def dispose; super; end
   
  def finished?; @range >= @range_limit; end
   
  def in_range_x; (@target.fight_x - self.x).abs < @reach; end
  def in_range_y; (@target.fight_y - self.y).abs < @reach + 60; end
   
  def make_contact?; return true if in_range_x && in_range_y; end
     
  def update_hit
    if make_contact?
      @owner.proj_hit(@skill)
      @range = @range_limit
    end
  end
end # FightProjectile < Sprite_Base
