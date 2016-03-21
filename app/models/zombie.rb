class Zombie < ApplicationRecord
  include Geographic::Point
  include Game::Unit

  AGGRO_DISTANCE = 0.1 # km
  ATTACK_RANGE = 0.01 # km
  ATTACK_DAMAGE = 5
  ATTACK_SPEED = 10

  def speed
    1.0 * 60
  end

  def move(lat, lon)
    unless colides_with_building?(lat, lon)
      update(current_action: :move, action_details: { target_lat: lat, target_lon: lon })
    end
  end

  def tick(tick_count)
    char = Character.closest_to(lat, lon)
    if latlng.distance(char.latlng) * 100 <= attack_range
      attack(char, tick_count)
    elsif latlng.distance(char.latlng) * 100 <= AGGRO_DISTANCE
      move_towards([char.lat, char.lon])
    end
    broadcast_updates
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

  private

  def broadcast_updates
    ActionCable.server.broadcast "zombies", id => to_json(methods: [:lat, :lon])
  end
end
