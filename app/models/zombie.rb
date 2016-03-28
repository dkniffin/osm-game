class Zombie < ActiveRecord::Base
  include Geographic::Point
  include Game::Unit
  include Game::FEUpdater

  AGGRO_DISTANCE = 0.1 # km
  ATTACK_RANGE = 0.01 # km
  ATTACK_DAMAGE = 5
  ATTACK_SPEED = 10

  def speed
    1.0 * 60
  end

  def tick(tick_count)
    char = Character.closest_to(lat, lon)
    if latlng.distance(char.latlng) * 100 <= attack_range
      attack(char, tick_count)
    elsif latlng.distance(char.latlng) * 100 <= AGGRO_DISTANCE
      move_towards([char.lat, char.lon])
    end
    delete_if_dead
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
