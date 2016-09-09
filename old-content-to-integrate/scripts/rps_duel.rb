###############################################################################
# RPS Duel by ashes999 (ashes999@yahoo.com)
# Version: 1.0
#
# Call rps_duel in a script to play. 
# You pick three moves, NPC picks three moves; winner takes all.
###############################################################################
PLAYER_ATTACK = 25
NPC_POSITION = {:x => 14, :y => 10}
PLAYER_POSITION = {:x => 4, :y => 10 }
FOREFIT_HP_LOSS = 10
ROUND_TIME = 4 # auto-forefit after this many seconds (from the indicator appearing)

###
# Test cases:
# 1) pre-empt the buzzer (should be forefit)
# 2) attack before the NPC (win/lose/tie +10 damage)
# 3) attack after the NPC (win/lose/tie, you take 10 damage)
# 4) don't attack (should be forefit)
###
def check_winner(player, npc)
  return :tie if player == npc
  return :lose if player == :forefit
  
  win = [[:rock, :scissors], [:scissors, :paper], [:paper, :rock]]
  lose = [[:rock, :paper], [:scissors, :rock], [:paper, :scissors]]

  pair = [player, npc]
  return :win if win.include?(pair)
  return :lose if lose.include?(pair)
end

def wait_for_move(npc_time)
  # wait randomly for 2-4 seconds
  # show prompt
  # give 1s to respond
  wait_time = rand(2) + 2
  move = :forefit unless input_wait(wait_time).nil?
  if (move == :forefit)
    RPG::SE.new('Buzzer1', 100, 100).play
    return move
  else
    show_picture(1, 'battle/exclamation', (640 - 128) / 2, (480 - 128) / 3)
    RPG::SE.new('Sword2', 100, 100).play
    
    # Always wait until the NPC moves
    start = Time.new.to_f
    move = input_wait(npc_time) || :none
    if move != :none
      player_moved
    end    
    stop = Time.new.to_f
    player_move_time = stop - start
    
    # Wait for the NPCs turn (if player moved faster)
    duration = npc_time - player_move_time  
    wait((duration * 60).to_i) if duration > 0 && move != :none
    show_picture(3, 'battle/small-exclamation', (NPC_POSITION[:x] + 0.5) * 32 + 7, (NPC_POSITION[:y] - 1) * 32)
    RPG::SE.new('Slash1', 100, 100).play
    
    # Wait for the remaining time; take input if the player didn't move yet
    round_time_left = ROUND_TIME - (Time.new.to_f - start)
    if move == :none      
      move = input_wait(round_time_left) || :forefit
      stop = Time.new.to_f
      
      if move != :forefit  
        player_move_time = stop - start
        player_moved        
      end
      # If round is supposed to be 5s, always wait 0.5s for sounds/graphics to appear properly
      wait(30) if stop - duration - start > 0
    else
      # always wait 0.5s for sounds/graphics to appear properly
      wait(30) if round_time_left > 0
    end
    
    RPG::SE.new('Bell3', 100, 100).play    
    wait(30)
    
    return move == :forefit ? move : [move, player_move_time]
  end
end

###
# npc_hp: health (eg. 50)
# npc_attack: damage per hit (eg. 25)
# npc_moves: hash of moves and probability, eg. {:rock => 50, :paper => 25, :scissors => 25 }
# fastest_attack: fastest time they will attack, eg. 2 = 2-3s, 7 = 7-8s
def rps_duel(npc_hp, npc_attack, npc_moves, fastest_attack, opponent)    
  show_picture(4, "battle/#{opponent}", NPC_POSITION[:x] * 32, NPC_POSITION[:y] * 32)
  show_picture(5, 'battle/fight-2x-hero', PLAYER_POSITION[:x] * 32, PLAYER_POSITION[:y] * 32)  
  raise "fastest_attack must be less than #{ROUND_TIME - 2} (you specified #{fastest_attack})" if fastest_attack > ROUND_TIME - 2
  
  player_hp = 100
  show_and_wait('Duel! Press A for rock, S for scissors, and D for paper, when the symbol appears. Too early or too late and you forefit the round.')
  result = :tie
  round = 1
  
  while player_hp > 0 && npc_hp > 0
    show_and_wait("Round #{round}: Player: #{player_hp}HP / NPC: #{npc_hp}HP. Fight!")
    npc_time = fastest_attack + rand    
    player_move = wait_for_move(npc_time)
    
    if player_move.is_a?(Array)
      player_move_time = player_move[1]
      player_move = player_move[0]
    end
    
    npc_move = pick_npc_move(npc_moves)    
    
    if (player_move == :forefit)
      player_hp -= FOREFIT_HP_LOSS
      result = :lose
    else
      result = check_winner(player_move, npc_move)
    
      npc_hp -= PLAYER_ATTACK if result == :win
      player_hp -= npc_attack if result == :lose
      
      # Fastest sword gets a +10 attack, win or lose
      if player_move_time <= npc_time
        npc_hp -= FOREFIT_HP_LOSS
      else
        player_hp -= FOREFIT_HP_LOSS
      end      
    end
    
    wait(60)
    (1..3).each do |n|
      screen.pictures[n].erase
    end
    
    if player_move == :forefit
      status_string = "You lose #{FOREFIT_HP_LOSS} health!"
    else
      status_string = "#{player_move_time <= npc_time ? 'You' : 'They'} deal #{FOREFIT_HP_LOSS} damage for being faster!"
    end
    
    show_and_wait("#{player_move.to_s} vs. #{npc_move.to_s}: #{result}!\n#{status_string}")
    
    round += 1
  end  
  
  result = player_hp > 0 ? 'Win' : 'Lose'
  show_and_wait("#{result} after #{round} rounds!")
  screen.pictures[4].erase
  screen.pictures[5].erase  
  $game_player.reserve_transfer(11, 8, 15, 4)
end

### helpers

def player_moved
  show_picture(2, 'battle/small-exclamation', (PLAYER_POSITION[:x] + 0.5) * 32 + 7, (PLAYER_POSITION[:y] - 1) * 32)
  RPG::SE.new('Slash10', 100, 100).play
end

def show_message(text)
  $game_message.add(text)
end

def show_and_wait(text)
  show_message(text)
  wait_for_message
end

# Synchronous: waits for up to <timeout> seconds. Returns early if you press a key.
def input_wait(timeout)
  time_left = timeout * 60
  
  start = Time.new.to_f
  while time_left > 0 do
    return :rock if Input.press?(:VK_A)
    return :scissors if Input.press?(:VK_S)
    return :paper if Input.press?(:VK_D)    
    time_left -= 1
    wait(1)
  end
  
  return nil
end

def show_picture(n, file_name, x, y)
  screen.pictures[n].show(file_name, 0, x, y, 100, 100, 255, 0)
end

def pick_npc_move(moves)
  # moves is a hash of move to probability, eg.
  # { :rock => 50, :paper => 25, :scissors => 25 }
  
  # cdf_moves is culmulative; for the above map, we get:
  # [ [:rock, 50], [:paper, 75], [:scissors, 100] ]
  cdf_moves = []
  seen_so_far = 0
  
  moves.each do |k, v|
    seen_so_far += v
    cdf_moves << [k, seen_so_far]    
  end
  
  prob = rand(seen_so_far)
  (0..cdf_moves.length).each do |n|
    return cdf_moves[n][0] if prob <= cdf_moves[n][1]
  end
  raise "Invalid move picked; #{cdf_moves} #{prob}"
end

class Game_Player
  attr_accessor :opacity
end
