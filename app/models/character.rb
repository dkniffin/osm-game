class Character < ActiveRecord::Base
  include Game::Unit
  include Game::FEUpdater
  validates :name, presence: true
  has_many :items

  include Geographic::Point

  reverse_geocoded_by :lat, :lon

  def search(lat, lon)
    update(current_action: :search, action_details: { target_lat: lat, target_lon: lon })
  end

  def use_item(item)
    item = item.class == Fixnum ? items.find(item) : item

    restore_health(item.stats.try(:[],'health_recovered').to_i)
    restore_food(item.stats.try(:[],'food_recovered').to_i)
    restore_water(item.stats.try(:[],'water_recovered').to_i)

    items.delete(item)
    item.destroy
  end

  def equip_item(item_id)
    item = items.find(item_id)
    return unless item.equippable?

    if current_weapon
      current_weapon.update(currently_equipped: false)
    end

    item.update(currently_equipped: true)
  end

  def unequip_item(item_id)
    item = items.find(item_id)
    item.update(currently_equipped: false)
  end

  def restore_food(restore)
    new_food = self.food += restore
    new_food = 100 if new_food > 100
    update(food: new_food)
  end

  def lose_food(damage)
    new_food = self.food -= damage
    new_food = 0 if new_food < 0
    update(food: new_food)
  end

  def restore_water(restore)
    new_water = self.water += restore
    new_water = 100 if new_water > 100
    update(water: new_water)
  end

  def lose_water(damage)
    new_water = self.water -= damage
    new_water = 0 if new_water < 0
    update(water: new_water)
  end

  def attack_speed
    Settings['character']['attack']['speed']
  end

  def attack_range
    Settings['character']['attack']['range']
  end

  def attack_damage
    default_damage = Settings['character']['attack']['damage_without_weapon']
    current_weapon.try(:stats).try(:[], 'damage').try(:to_i) || default_damage
  end

  def current_weapon
    items.weapon.equipped.first
  end

  def equipped_items
    items.equipped
  end

  def inventory
    items - equipped_items
  end

  def search_level
    self[:search_level] || Settings['character']['search']['default_level']
  end

  private

  def include_in_to_json
    [:lat, :lon, :inventory, :equipped_items]
  end
end
