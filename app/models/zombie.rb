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
    if latlng.distance(char.latlng) * 100 <= ATTACK_RANGE
      attack_character(char, tick_count)
    elsif latlng.distance(char.latlng) * 100 <= AGGRO_DISTANCE
      move_towards([char.lat, char.lon])
    end
    broadcast_updates
  end

  private

  def attack_character(char, tick_count)
    if tick_count % ATTACK_SPEED == 0
      char.take_damage(ATTACK_DAMAGE)
    end
  end

  def broadcast_updates
    ActionCable.server.broadcast "zombies", id => to_json(methods: [:lat, :lon])
  end
end
