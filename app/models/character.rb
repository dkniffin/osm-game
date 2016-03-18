class Character < ActiveRecord::Base
  include Game::Unit
  validates :name, presence: true

  include Geographic::Point

  reverse_geocoded_by :lat, :lon

  def tick(tick_count)
    case current_action
    when 'move'
      move_towards([action_details['target_lat'], action_details['target_lon']])
    end
    ActionCable.server.broadcast "characters", id => self.to_json(methods: [:lat, :lon])
  end

  def restore_health(restore)
    new_health = self.health += restore
    new_health = 100 if new_health > 100
    update(health: new_health)
  end

  def take_damage(damage)
    new_health = self.health -= damage
    new_health = 0 if new_health < 0
    update(health: new_health)
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
end
