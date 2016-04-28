class Zombie < ActiveRecord::Base
  include Geographic::Point
  include Game::Unit
  include Game::FEUpdater

  def speed
    Settings.zombie.movement.speed
  end

  def attack_speed
    Settings.zombie.attack.speed
  end

  def attack_range
    Settings.zombie.attack.range
  end

  def attack_damage
    Settings.zombie.attack.damage
  end

  def aggro_distance
    Settings.zombie.aggro.distance
  end

  private

  def include_in_to_json
    [:lat, :lon]
  end
end
