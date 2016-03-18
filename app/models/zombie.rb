class Zombie < ApplicationRecord
  include Geographic::Point
  include Game::Unit

  AGGRO_DISTANCE = 0.1 # km
  ATTACK_RANGE = 0.001 # km
  ATTACK_DAMAGE = 5

  def speed
    1.0 * 60
  end

  def move(lat, lon)
    unless colides_with_building?(lat, lon)
      update(current_action: :move, action_details: { target_lat: lat, target_lon: lon })
    end
  end

  def tick
    case current_action
    when 'move'
      move_towards([action_details['target_lat'], action_details['target_lon']])
    else
      look_for_targets
    end

    attack_target_in_range

    broadcast_updates
  end

  private

  def attack_target_in_range
    attack_box = Geographic::Polygon.box_center_radius({ lat: lat, lon: lon }, ATTACK_RANGE)
    closest_character_in_range = Character.inside(attack_box).closest_to(latlng)
    if closest_character_in_range.present?
      closest_character_in_range.take_damage(ATTACK_DAMAGE)
    end
  end

  def look_for_targets
    aggro_box = Geographic::Polygon.box_center_radius({ lat: lat, lon: lon }, AGGRO_DISTANCE)
    closest_character_in_range = Character.inside(aggro_box).closest_to(latlng)
    if closest_character_in_range.present?
      move(closest_character_in_range.lat, closest_character_in_range.lon)
    end
  end

  def broadcast_updates
    ActionCable.server.broadcast "zombies", id => self.to_json(methods: [:lat, :lon])
  end
end
