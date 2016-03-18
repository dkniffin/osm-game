class Character < ActiveRecord::Base
  include Math
  include Geocoder::Calculations
  validates :name, presence: true

  include Geographic::Point

  reverse_geocoded_by :lat, :lon

  def lat
    latlng.y
  end

  def lng
    latlng.x
  end
  alias_method :lon, :lng

  def lat=(new_lat)
    update(latlng: Normalize.to_rgeo_point(lon, new_lat))
  end

  def lng=(new_lng)
    update(latlng: Normalize.to_rgeo_point(new_lng, lat))
  end
  alias_method :lon=, :lng=

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
    ActionCable.server.broadcast "characters", id => self
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
    target = RGeo::Geographic.spherical_factory(srid: 4326).point(target_lon, target_lat)
    OSM::Way.buildings.intersected_by_line(latlng, target).present?
  end

  def speed
    # Units: meters/second
    stats.try(:[], 'speed').try(:to_i) || 1.4 * 60
  end

  def unordered_between?(subject, arg1, arg2)
    subject.between?(*[arg1, arg2].sort)
  end
end
