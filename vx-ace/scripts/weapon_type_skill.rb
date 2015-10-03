class Game_Actor < Game_Battler
  def initialize(actor_id)
    # copied from VX Ace core
    super()
    setup(actor_id)
    @last_skill = Game_BaseItem.new
    
    # map of etype_id => exp
    @weapon_type_exp = {}
  end
  
  def weapon_level?(weapon_type_id)
    exp = @weapon_type_exp[weapon_type_id] || 0
    level = 1 + (exp / 100)
  end
  
  def before_attack
      # Not sure which weapon you used. Doesn't matter; increase xp for both
      self.weapons.each do |w|
      @weapon_type_exp[w.wtype_id] = 0 unless @weapon_type_exp.key?(w.wtype_id)
      @weapon_type_exp[w.wtype_id] += 1      
    end
  end
  
  def after_attack
  end
end
 
class Scene_Battle < Scene_Base
  alias_method :original_execute_action, :execute_action
  alias_method :original_process_action_end, :process_action_end
  
  def execute_action     
    attacker = @subject
    action = attacker.current_action
    if $game_party.members.include?(attacker) && !action.nil? && action.attack?
      attacker.before_attack
      @original_damage = {:attacker => attacker, :damage => action.item.damage, :formula => action.item.damage.formula}
      action.item.damage.formula = "1.1 * (#{action.item.damage.formula})"      
    end
    original_execute_action
  end
  
  def process_action_end
    original_process_action_end
    return if @original_damage.nil?
    
    @original_damage[:attacker].after_attack    
    @original_damage[:damage].formula = @original_damage[:formula] # reset
  end      
end
