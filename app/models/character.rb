class Character < ActiveRecord::Base
  include Math
  include Geocoder::Calculations
  validates :name, presence: true

  reverse_geocoded_by :lat, :lon

  def move(lat, lon)
    unless colides_with_building?(lat, lon)
      update(current_action: :move, action_details: { target_lat: lat, target_lon: lon })
    end
  end

  def tick
    case current_action
    when 'move'
      move_towards([action_details['target_lat'], action_details['target_lon']])
    end
    ActionCable.server.broadcast "characters", { id => self }
  end

  def restore_health(restore)
    self.health += restore
    if self.health > 100
      return 100
    else
      self.health
    end
    save
  end

  def take_damage(damage)
    self.health -= damage
    if self.health < 0
      return 0
    else
      self.health
    end
    save
  end

  private

  def move_towards(target)
    target = target.map(&:to_f)
    # Calculate new position
    dist_km = (speed * Ticker::TICK_TIME) / 1000
    bearing = bearing_to(target)
    new_lat, new_lon = Geocoder::Calculations.endpoint([lat, lon], bearing, dist_km)

    # Check if we've passed it
    if unordered_between?(new_lat, lat, target[0]) && unordered_between?(new_lon, lon, target[1])
      update(lat: new_lat, lon: new_lon)
    else
      update(lat: target[0], lon: target[1], current_action: nil, action_details: nil)
    end
  end

  def colides_with_building?(target_lat, target_lon)
    OSM::Way.buildings.is_intersected_by_line([lat, lon], [target_lat, target_lon]).present?
  end

  def speed
    # Units: meters/second
    stats.try(:[],'speed').try(:to_i) || 1.4 * 60
  end

  def unordered_between?(subject, arg1, arg2)
    subject.between?(*[arg1, arg2].sort)
  end
end
