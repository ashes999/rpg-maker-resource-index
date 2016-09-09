# Source: http://www.rpgmakervxace.net/topic/18164-crafting-system/
#==============================================================================
# Crafting System
# Version 1.9
# By Szyu
#
# About:
# Craft items, weapons and armors.
#
# Instructions:
# - Place below "? Materials" but above "? Main Process".
# - Call global Crafting List by "SceneManager.call(Scene_Crafting)" or
#       "SceneManager.call(Scene_Crafting, -1)".
#   For categorized Crafting Lists use "SceneManager.call(Scene_Crafting, x)"
#
# How to Use:
# - "<ingredients> content </ingredients>" marks the area for ingredients
# example:
#   <ingredients>
#   i: 3x 5   => 3 items of item_id 5
#   w: 2x 7   => 2 weapons of weapon_id 7
#   a: 1x 2   => 1 armor of armor_id 2
#   </ingredients>
#
# - "<recipe book>" marks the item as a recipe book, able to hold recipes
# - "<category: x>" marks a recipe book as category x. You can call seperate
#               category crafting lists by SceneManager.call(Scene_Crafting, x)
#
# - "<recipes> content </recipes>" marks the area for recipes if the
#                                  item is a crafting book
# example:
#   <recipes>
#   i: 5   => ability to craft the item with id 5
#   w: 7   => ability to craft the weapon with id 7
#   a: 2 - 20   => ability to craft armors from id 2 to id 20
#   </recipes>
#
# - "$data_items[book_id].add_recipe("i/w/a: id")" adds a new recipe to a book
# - "$data_items[book_id].add_recipe("i/w/a: id1 - id2")" adds a new recipe to a book
# - "$data_items[book_id].remove_recipe("i/w/a: id")" removes a recipe from a book
# - "$data_items[book_id].remove_recipe("i/w/a: id1 - id2")" removes a recipe from a book
#
# Requires:
# - RPG Maker VX Ace
#
# Terms of Use:
# - Free for commercal and non-commercial use. Please list me
#   in the credits to support my work.
#
# Pastebin:
# http://pastebin.com/CxB8F8T5
#
#==============================================================
#   * Configuration
#==============================================================

# Term used for crafting from recipe books
INGREDIENTS_TERM = "Ingredientes"
CR_WEAPON_TYPE_TERM = "Clase de arma"
CR_ARMOR_TYPE_TERM = "Clase de armadura"

CRAFTING_CATEGORIES = ["Alchemy","Blacksmithing"]

# Custom crafting sounds by category
CUSTOM_CRAFT_SOUNDS_BY_CAT = ["Saint5", "Bell2"]
# Custom crafting sounds for RPG::Item, RPG::Weapon, RPG::Armor if no special cat
CUSTOM_CRAFT_SOUNDS_BY_TYPE = ["Saint5", "Bell2", "Bell3"]

# If you want to use crafting from the menu, set this to true, else false
CRAFTING_IN_MENU = true
MENU_CRAFTING_VOCAB = "Crafting"


# Vocabs used in status section for crafted items
CRAFTING_ITEM_STATUS ={
      :empty      => "-",     # Text used when nothing is shown.
      :hp_recover => "HP",      # Text used for HP Recovery.
      :mp_recover => "MP",      # Text used for MP Recovery.
      :tp_recover => "TP",      # Text used for TP Recovery.
      :tp_gain    => "TP gain", # Text used for TP Gain.
      :applies    => "applies", # Text used for applied states and buffs.
      :removes    => "removes", # Text used for removed states and buffs.
    }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#==============================================================
#   * Scene_Crafting
#==============================================================
class Scene_Crafting < Scene_ItemBase

  def initialize()
    @cr_category = SceneManager.scene_param[0] ? SceneManager.scene_param[0] : -1
  end

  def start
    super
    create_help_window
    create_category_window
    create_ingredients_window
    create_item_window
  end

  def create_category_window
    @category_window = Window_CraftingCategory.new
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @help_window.height
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:return_scene))
  end

  def create_ingredients_window
    wx = 240
    wy = @category_window.y + @category_window.height
    ww = Graphics.width - wx
    wh = Graphics.height - wy
    @ingredients_window = Window_CraftingIngredients.new(wx,wy,ww,wh)
    @ingredients_window.viewport = @viewport
  end

  def create_item_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy
    @item_window = Window_CraftingItemList.new(0, wy, 240, wh)
    @item_window.cr_category = @cr_category
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @item_window.set_handler(:right, method(:ingredients_show_stats))
    @item_window.set_handler(:left, method(:ingredients_show_ingredients))
    @item_window.ingredients_window = @ingredients_window
    @category_window.item_window = @item_window
  end

  def on_category_ok
    @item_window.activate
    @item_window.select_last
  end

  def on_item_ok
    determine_crafting
  end

  def on_item_cancel
    @item_window.unselect
    @category_window.activate
  end

  def determine_crafting
    craft_item if @item_window.item.match_ingredients?
  end

  def craft_item
    item = @item_window.item
    item.ingredients.each do |ing|
      if ing[0].is_a?(RPG::BaseItem)
        $game_party.lose_item(ing[0],ing[1])
      else
        $game_party.lose_gold(ing[1])
      end
    end
    $game_party.gain_item(item,1)

    if @cr_category != -1
      csf = CUSTOM_CRAFT_SOUNDS_BY_CAT[@cr_category]
    else
      if item.is_a?(RPG::Item)
        csf = CUSTOM_CRAFT_SOUNDS_BY_TYPE[0]
      elsif item.is_a?(RPG::Weapon)
        csf = CUSTOM_CRAFT_SOUNDS_BY_TYPE[1]
      elsif item.is_a?(RPG::Armor)
        csf = CUSTOM_CRAFT_SOUNDS_BY_TYPE[2]
      end
    end
    RPG::SE.new(csf, 100, 50).play

    @item_window.refresh
    @item_window.activate
  end

  def ingredients_show_ingredients
    @ingredients_window.showtype = 0
  end

  def ingredients_show_stats
    @ingredients_window.showtype = 1
  end
end

#==============================================================
#   * Scene_Menu
#==============================================================
class Scene_Menu < Scene_MenuBase
  alias add_crafting_menu_entry create_command_window

  def create_command_window
    add_crafting_menu_entry
    @command_window.set_handler(:crafting,      method(:open_crafting)) if CRAFTING_IN_MENU
  end

  def open_crafting
    SceneManager.call(Scene_Crafting, -1)
  end
end

#==============================================================
#   * Window_CraftingCategory
#==============================================================
class Window_CraftingCategory < Window_HorzCommand
  attr_reader   :item_window

  def initialize
    super(0, 0)
  end

  def window_width
    Graphics.width
  end

  def col_max
    return 3
  end

  def update
    super
    @item_window.category = current_symbol if @item_window
  end

  def make_command_list
    add_command(Vocab::item,     :item)
    add_command(Vocab::weapon,   :weapon)
    add_command(Vocab::armor,    :armor)
  end

  def item_window=(item_window)
    @item_window = item_window
    update
  end
end

#==============================================================
#   * Window_CraftingCategory
#==============================================================
class Window_CraftingItemList < Window_Selectable
  attr_reader :ingredients_window
  attr_accessor :cr_category

  def initialize(x, y, width, height)
    super
    @category = :none
    @data = []
  end

  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end

  def col_max
    return 1
  end

  def item_max
    @data ? @data.size : 1
  end

  def item
    @data && index >= 0 ? @data[index] : nil
  end

  def current_item_enabled?
    return false unless @data[index]
    @data[index].match_ingredients?
  end

  def include?(item)
    case @category
    when :item
      item.is_a?(RPG::Item)
    when :weapon
      item.is_a?(RPG::Weapon)
    when :armor
      item.is_a?(RPG::Armor)
    else
      false
    end
  end

  def enable?(item)
    $game_party.usable?(item)
  end

  def make_item_list
    rbooks = $game_party.all_items.select {|item| item.recipe_book}
    rbooks.delete_if {|x| x.cr_category != @cr_category} if @cr_category != -1
    @data = []
    rbooks.each do |book|
      sdata = book.recipes.select {|recipe| include?(recipe) }
      @data.concat sdata
    end
    @data.push(nil) if include?(nil)
  end

  def select_last
    select(@data.index($game_party.last_item.object) || 0)
  end

  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y, item.match_ingredients?, width-70)
      draw_item_number(rect, item)
    end
  end

  def draw_item_number(rect, item)
    draw_text(rect, sprintf(":%2d", $game_party.item_number(item)), 2)
  end

  def update_help
    @help_window.set_item(item)
    @ingredients_window.item = item if @ingredients_window
  end

  def refresh
    make_item_list
    create_contents
    draw_all_items
  end

  def ingredients_window=(ingredients_window)
    @ingredients_window = ingredients_window
    update
  end

  def process_ok
    if current_item_enabled?
      Input.update
      deactivate
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end

  alias cr_us_win unselect
  def unselect
    cr_us_win
    @ingredients_window.contents.clear
  end
end

#==============================================================
#   * Window_MenuCraftingList
#==============================================================
class Window_MenuCraftingList < Window_Selectable

  attr_reader :ingredients_window
  attr_reader :book

  alias cr_ing_help call_update_help
  alias cr_ing_hide hide

  def initialize(book,y)
    @book = book
    super(0,y, 240, Graphics.height-y)
    self.visible = false
    refresh
  end

  def window_height
    Graphics.height-self.y
  end

  def item_max
    @book.recipes.size
  end

  def item_height
    line_height+4
  end

  def draw_item(index)
    recipe = @book.recipes[index]
    rect = item_rect(index)
    draw_icon(recipe.icon_index, rect.x+2, rect.y+2)
    draw_text(rect.x+30,rect.y+2,width-75, line_height, recipe.name)
    draw_text(rect.x-30,rect.y+2,width, line_height, sprintf(":%2d", $game_party.item_number(@item)), 2)
  end

  def process_ok
    super
    $game_party.menu_actor = $game_party.members[index]
  end

  def select_last
    select($game_party.menu_actor.index || 0)
  end

  def select_for_item(item)
    select(0)
    @book = item
  end

  def ingredients_window=(ingredients_window)
    @ingredients_window = ingredients_window
    update
  end

  def call_update_help
    cr_ing_help
    @ingredients_window.item = @book.recipes[@index] if @ingredients_window && @index >= 0
  end

  def hide
    cr_ing_hide
    @ingredients_window.hide.deactivate
  end
end

#==============================================================
#   * Window_CraftingIngredients
#==============================================================
class Window_CraftingIngredients < Window_Selectable
  def initialize(x,y,w,h)
    super(x,y,w,h)
    @item = nil
    @showtype=0
  end

  def item=(item)
    @item = item
    refresh
  end

  def refresh
    contents.clear
    return if !@item
    case @showtype
    when 1
      #draw_stats_item if @item.is_a?(RPG::Item)
      draw_stats
    else
      draw_ingredients
    end
  end

  def draw_ingredients
    change_color(system_color)
    draw_text(0,line_height*0,width,line_height, INGREDIENTS_TERM)
    i = 1
    @item.ingredients.each do |ing|
      change_color(normal_color)
      change_color(normal_color)
      if ing[0].is_a?(String)
        draw_icon(361,0,line_height*i)
        draw_text(24,line_height*i, width,line_height, ing[0])
        inumber = $game_party.gold
      else
        draw_icon(ing[0].icon_index,0,line_height*i)
        draw_text(24,line_height*i, width,line_height, ing[0].name)
        inumber = $game_party.item_number(ing[0])
      end

      change_color(crisis_color) if inumber < ing[1]
      change_color(hp_gauge_color1) if inumber == 0
      change_color(tp_gauge_color2) if inumber >= ing[1]

      txt = sprintf("%d/%d",inumber, ing[1])
      draw_text(-24,line_height*i,width-4,line_height,txt,2)
      i += 1
    end
    change_color(normal_color)
  end

  def draw_stats
    draw_item_stats
    draw_item_effects
  end

  def showtype=(st)
    @showtype = st
    refresh
  end

  def draw_background_box(dx, dy, dw)
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(dx+1, dy+1, dw-2, line_height-2)
    contents.fill_rect(rect, colour)
  end

  def draw_item_stats
    return unless @item.is_a?(RPG::Weapon) || @item.is_a?(RPG::Armor)
    dx = 0; dy = 0
    dw = (contents.width) / 2
    for i in 0...8
      draw_equip_param(i, dx, dy, dw)
      dx = dx >= dw ? 0 : dw
      dy += line_height if dx == 0
    end
  end

  def draw_equip_param(param_id, dx, dy, dw)
    draw_background_box(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, Vocab::param(param_id))
    draw_set_param(param_id, dx, dy, dw)
  end

  def draw_set_param(param_id, dx, dy, dw)
    value = @item.params[param_id]
    change_color(param_change_color(value), value != 0)
    text = value.to_s
    text = "+" + text if value > 0
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
    return text
  end

  def draw_percent_param(param_id, dx, dy, dw)
    value = @item.per_params[param_id]
    change_color(param_change_color(value))
    text = (@item.per_params[param_id] * 100).to_i.to_s + "%"
    text = "+" + text if @item.per_params[param_id] > 0
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
    return text
  end

  def draw_item_effects
    return unless @item.is_a?(RPG::Item)
    dx = 0; dy = 0
    dw = (contents.width) / 2
    draw_hp_recover(dx, dy + line_height * 0, dw)
    draw_mp_recover(dx, dy + line_height * 1, dw)
    draw_tp_recover(dx + dw, dy + line_height * 0, dw)
    draw_tp_gain(dx + dw, dy + line_height * 1, dw)
    dw = contents.width
    draw_applies(dx, dy + line_height * 2, dw)
    draw_removes(dx, dy + line_height * 3, dw)
  end

  def draw_hp_recover(dx, dy, dw)
    draw_background_box(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, CRAFTING_ITEM_STATUS[:hp_recover])
    per = 0
    set = 0
    for effect in @item.effects
      next unless effect.code == 11
      per += (effect.value1 * 100).to_i
      set += effect.value2.to_i
    end
    if per != 0 && set != 0
      change_color(param_change_color(set))
      text = set > 0 ? sprintf("+%s", set.to_s) : set.to_s
      draw_text(dx+4, dy, dw-8, line_height, text, 2)
      dw -= text_size(text).width
      change_color(param_change_color(per))
      text = per > 0 ? sprintf("+%s%%", per.to_s) : sprintf("%s%%", per.to_s)
      draw_text(dx+4, dy, dw-8, line_height, text, 2)
      return
    elsif per != 0
      change_color(param_change_color(per))
      text = per > 0 ? sprintf("+%s%%", per.to_s) : sprintf("%s%%", per.to_s)
    elsif set != 0
      change_color(param_change_color(set))
      text = set > 0 ? sprintf("+%s", set.to_s) : set.to_s
    else
      change_color(normal_color, false)
      text = CRAFTING_ITEM_STATUS[:empty]
    end
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
  end

  def draw_mp_recover(dx, dy, dw)
    draw_background_box(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, CRAFTING_ITEM_STATUS[:mp_recover])
    per = 0
    set = 0
    for effect in @item.effects
      next unless effect.code == 12
      per += (effect.value1 * 100).to_i
      set += effect.value2.to_i
    end
    if per != 0 && set != 0
      change_color(param_change_color(set))
      text = set > 0 ? sprintf("+%s", set.to_s) : set.to_s
      draw_text(dx+4, dy, dw-8, line_height, text, 2)
      dw -= text_size(text).width
      change_color(param_change_color(per))
      text = per > 0 ? sprintf("+%s%%", per.to_s) : sprintf("%s%%", per.to_s)
      draw_text(dx+4, dy, dw-8, line_height, text, 2)
      return
    elsif per != 0
      change_color(param_change_color(per))
      text = per > 0 ? sprintf("+%s%%", per.to_s) : sprintf("%s%%", per.to_s)
    elsif set != 0
      change_color(param_change_color(set))
      text = set > 0 ? sprintf("+%s", set.to_s) : set.to_s
    else
      change_color(normal_color, false)
      text = CRAFTING_ITEM_STATUS[:empty]
    end
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
  end

  def draw_tp_recover(dx, dy, dw)
    draw_background_box(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, CRAFTING_ITEM_STATUS[:tp_recover])
    set = 0
    for effect in @item.effects
      next unless effect.code == 13
      set += effect.value1.to_i
    end
    if set != 0
      change_color(param_change_color(set))
      text = set > 0 ? sprintf("+%s", set.to_s) : set.to_s
    else
      change_color(normal_color, false)
      text = CRAFTING_ITEM_STATUS[:empty]
    end
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
  end

  def draw_tp_gain(dx, dy, dw)
    draw_background_box(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, CRAFTING_ITEM_STATUS[:tp_gain])
    set = @item.tp_gain
    if set != 0
      change_color(param_change_color(set))
      text = set > 0 ? sprintf("+%s", set.to_s) : set.to_s
    else
      change_color(normal_color, false)
      text = CRAFTING_ITEM_STATUS[:empty]
    end
    draw_text(dx+4, dy, dw-8, line_height, text, 2)
  end

  def draw_applies(dx, dy, dw)
    draw_background_box(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, CRAFTING_ITEM_STATUS[:applies])
    icons = []
    for effect in @item.effects
      case effect.code
      when 21
        next unless effect.value1 > 0
        next if $data_states[effect.value1].nil?
        icons.push($data_states[effect.data_id].icon_index)
      when 31
        icons.push($game_actors[1].buff_icon_index(1, effect.data_id))
      when 32
        icons.push($game_actors[1].buff_icon_index(-1, effect.data_id))
      end
      icons.delete(0)
      break if icons.size >= 10
    end
    draw_icons(dx, dy, dw, icons)
  end

  def draw_removes(dx, dy, dw)
    draw_background_box(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, CRAFTING_ITEM_STATUS[:removes])
    icons = []
    for effect in @item.effects
      case effect.code
      when 22
        next unless effect.value1 > 0
        next if $data_states[effect.value1].nil?
        icons.push($data_states[effect.data_id].icon_index)
      when 33
        icons.push($game_actors[1].buff_icon_index(1, effect.data_id))
      when 34
        icons.push($game_actors[1].buff_icon_index(-1, effect.data_id))
      end
      icons.delete(0)
      break if icons.size >= 10
    end
    draw_icons(dx, dy, dw, icons)
  end

  def draw_icons(dx, dy, dw, icons)
    dx += dw - 4
    dx -= icons.size * 24
    for icon_id in icons
      draw_icon(icon_id, dx, dy)
      dx += 24
    end
    if icons.size == 0
      change_color(normal_color, false)
      text = CRAFTING_ITEM_STATUS[:empty]
      draw_text(4, dy, contents.width-8, line_height, text, 2)
    end
  end
end

#==============================================================
#   * Window_MenuCommand
#==============================================================
class Window_MenuCommand < Window_Command
  alias add_crafting_menu_entry add_main_commands

  def add_main_commands
    add_crafting_menu_entry
    add_command(MENU_CRAFTING_VOCAB, :crafting) if CRAFTING_IN_MENU
  end
end

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#==============================================================
#   * Initialize BaseItems
#==============================================================
module DataManager
  class << self
    alias load_db_sz_crafting load_database
    alias save_crafting_recipe_books make_save_contents
    alias load_crafting_recipe_books extract_save_contents
  end

  def self.load_database
    load_db_sz_crafting
    load_crafting_item_notetags
  end

  def self.load_crafting_item_notetags
    groups = [$data_items, $data_weapons, $data_armors]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_crafting_notetags_sz
      end
    end
  end


  def self.make_save_contents
    contents = save_crafting_recipe_books
    recipe_books = {}
    for item in $data_items
      next if item.nil?
      next if not item.recipe_book
      recipe_books[item.id] = item.recipes
    end

    contents[:recipe_books] = recipe_books
    contents
  end

  def self.extract_save_contents(contents)
    load_crafting_recipe_books(contents)
    recipe_books = contents[:recipe_books]

    recipe_books.each do |id, recipes|
      $data_items[id].recipes = recipes
    end
  end
end

#==============================================================
#   * Call Scene with Parameters
#==============================================================
class << SceneManager
  alias call_scene_crafting call

  attr_accessor :scene_param

  def call(scene_class, *param)
    @scene_param = param
    call_scene_crafting(scene_class)
  end
end

#==============================================================
#   * List Recipes of a Book
#==============================================================
class Scene_Item < Scene_ItemBase
  alias sz_crafting_determitem determine_item

  def determine_item
    if item.recipe_book
      create_crafting_item_window
      show_crafting_sub_window(@crafting_item_window)
    else
      sz_crafting_determitem
    end
  end

  def create_crafting_item_window
    wy = @help_window.height+@category_window.height
    @crafting_item_window = Window_MenuCraftingList.new(item,wy)
    @crafting_item_window.set_handler(:cancel, method(:on_sz_item_cancel))
    @crafting_item_window.set_handler(:left, method(:ingredients_show_ingredients))
    @crafting_item_window.set_handler(:right, method(:ingredients_show_stats))

    ww = Graphics.width - @crafting_item_window.width
    wh = Graphics.height - wy
    @ingredients_window = Window_CraftingIngredients.new(240, wy,ww,wh)
    @ingredients_window.viewport
    @crafting_item_window.ingredients_window = @ingredients_window
  end

  def on_sz_item_cancel
    hide_crafting_sub_window(@crafting_item_window)
  end


  def show_crafting_sub_window(window)
    height_remain = @help_window.height+@category_window.height
    @viewport.rect.height = height_remain
    window.show.activate
  end

  def hide_crafting_sub_window(window)
    @viewport.rect.y = @viewport.oy = 0
    @viewport.rect.height = Graphics.height
    window.hide.deactivate
    activate_item_window
  end

  def ingredients_show_ingredients
    @ingredients_window.showtype = 0
  end

  def ingredients_show_stats
    @ingredients_window.showtype = 1
  end
end


class Window_Selectable < Window_Base
  alias :sz_cr_input_handler_process_handling :process_handling

  def process_handling
    return unless open? && active
    sz_cr_input_handler_process_handling
    return call_handler(:left) if handle?(:left) && Input.trigger?(:LEFT)
    return call_handler(:right) if handle?(:right) && Input.trigger?(:RIGHT)
  end
end

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#==============================================================
#   * Content of Crafting Items
#==============================================================
class RPG::BaseItem
  attr_accessor :ingredients
  attr_accessor :recipe_book
  attr_accessor :recipes
  attr_accessor :cr_category


  def load_crafting_notetags_sz
    @ingredients = []
    @recipe_book = false
    @recipes = []
    @cr_category = -1

    @scan_ingredients = false
    @scan_recipes = false

    self.note.split(/[\r\n]+/).each do |line|
      case line.downcase
      # Ingredients
      when /<(?:ingredients?)>/i
        @scan_ingredients = true
      when /<\/(?:ingredients?)>/i
        @scan_ingredients = false
      # Recipes
      when /<(?:recipes?)>/i
        @scan_recipes = true
      when /<\/(?:recipes?)>/i
        @scan_recipes = false
      # Crafting Book
      when /<(?:recipe book)>/i
        @recipe_book = true
        @itype_id = 2
      when /<category:\s*?(\d+)>/i
        @cr_category = $1.to_i if @recipe_book
      else
        scan_ingredients(line) if @scan_ingredients
        scan_recipes(line) if @scan_recipes
      end
    end
  end

  def scan_ingredients(line)
    return if @crafting_book
    return unless line =~ /(\w+):\s*?(\d+)[x]?\s*(\d+)?/i ? true : false
    case $1
    when "c"
      @ingredients.push([Vocab::currency_unit,$2.to_i])
    when "i"
      @ingredients.push([$data_items[$3.to_i], $2.to_i])
    when "w"
      @ingredients.push([$data_weapons[$3.to_i], $2.to_i])
    when "a"
      @ingredients.push([$data_armors[$3.to_i], $2.to_i])
    end
  end

  def scan_recipes(line)
    return unless line =~ /(\w+):\s*(\d+)\s*-?\s*(\d+)?/i ? true : false
    from = $2.to_i
    if $3 == nil
      til = from
    else
      til = $3.to_i
    end

    for i in from..til
      case $1
      when "i"
        @recipes.push($data_items[i])
      when "w"
        @recipes.push($data_weapons[i])
      when "a"
        @recipes.push($data_armors[i])
      end
    end
    @recipes = @recipes.sort_by {|x| [x.class.to_s, x.id]}
  end


  def match_ingredients?
    @ingredients.each do |ing|
      icount = ing[0].is_a?(RPG::BaseItem) ? $game_party.item_number(ing[0]) : $game_party.gold
      return false if icount < ing[1]
    end
    return true
  end

  def add_recipe(type)
    return unless @recipe_book
    return unless type =~ /(\w+):\s*(\d+)\s*-?\s*(\d+)?/i ? true : false
    from = $2.to_i
    if $3 == nil
      til = from
    else
      til = $3.to_i
    end

    for i in from..til
      case $1
      when "i"
        return if @recipes.include?($data_items[i])
        @recipes.push($data_items[i])
      when "w"
        return if @recipes.include?($data_weapons[i])
        @recipes.push($data_weapons[i])
      when "a"
        return if @recipes.include?($data_armors[i])
        @recipes.push($data_armors[i])
      end
    end

    @recipes = @recipes.sort_by {|x| [x.class.to_s, x.id]}
  end

  def remove_recipe(type)
    return unless @recipe_book
    return unless type =~ /(\w+):\s*(\d+)\s*-?\s*(\d+)?/i ? true : false
    from = $2.to_i
    if $3 == nil
      til = from
    else
      til = $3.to_i
    end

    for i in from..til
      case $1
      when "i"
        return if not @recipes.include?($data_items[i])
        @recipes.delete($data_items[i])
      when "w"
        return if not @recipes.include?($data_weapons[i])
        @recipes.delete($data_weapons[i])
      when "a"
        return if not @recipes.include?($data_armors[i])
        @recipes.delete($data_armors[i])
      end
    end

    @recipes = @recipes.sort_by {|x| [x.class.to_s, x.id]}
  end
end
