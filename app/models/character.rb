class Character < ActiveRecord::Base
  include Game::Unit
  include Game::FEUpdater
  validates :name, presence: true
  has_many :items

  ATTACK_RANGE = 0.01 # km
  ATTACK_SPEED = 15
  ATTACK_DAMAGE = 8

  include Geographic::Point

  reverse_geocoded_by :lat, :lon

  def tick(tick_count)
    if current_action.present?
      if current_action == 'move'
        move_towards([action_details['target_lat'], action_details['target_lon']])
      end
    else
      zombie = Zombie.closest_to(lat, lon)
      if zombie.present?
        if latlng.distance(zombie.latlng) * 100 <= ATTACK_RANGE
          attack(zombie, tick_count)
        end
      end
    end
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
    ATTACK_DAMAGE
  end
end
