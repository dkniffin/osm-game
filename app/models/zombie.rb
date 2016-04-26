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

  def attack_speed
    ATTACK_SPEED
  end

  def attack_range
    ATTACK_RANGE
  end

  def attack_damage
    ATTACK_DAMAGE
  end

  def aggro_distance
    AGGRO_DISTANCE
  end

  private

  def include_in_to_json
    [:lat, :lon]
  end
end
