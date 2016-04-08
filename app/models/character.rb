class Character < ActiveRecord::Base
  include Game::Unit
  include Game::FEUpdater
  validates :name, presence: true
  has_many :items

  ATTACK_RANGE = 0.01 # km
  ATTACK_SPEED = 15
  ATTACK_DAMAGE_WITHOUT_WEAPON = 8

  include Geographic::Point

  reverse_geocoded_by :lat, :lon

  def tick(tick_count)
    case current_action
    when 'move'
      move_towards([action_details['target_lat'], action_details['target_lon']]) do
        self.current_action = nil
        self.action_details = nil
      end
    when 'search'
      move_towards([action_details['target_lat'], action_details['target_lon']]) do
        Search.run(character: self)
        self.current_action = nil
        self.action_details = nil
      end
    else
      # Default action: attack the closest zombie, if they're in range
      zombie = Zombie.closest_to(lon, lat)
      if zombie.present?
        if latlng.distance(zombie.latlng) / 1000 <= ATTACK_RANGE
          attack(zombie, tick_count)
        end
      end
    end
  end

  def search(lat, lon)
    update(current_action: :search, action_details: { target_lat: lat, target_lon: lon })
  end

  def use_item(item_id)
    item = items.find(item_id)
    if item.category == 'medical'
      restore_health(30)
    end
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
    ATTACK_SPEED
  end

  def attack_range
    ATTACK_RANGE
  end

  def attack_damage
    current_weapon.try(:stats).try(:[], 'damage').try(:to_i) || ATTACK_DAMAGE_WITHOUT_WEAPON
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

  private

  def include_in_to_json
    [:lat, :lon, :inventory, :equipped_items]
  end
end
