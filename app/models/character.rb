class Character < ActiveRecord::Base
  include Math
  include Geocoder::Calculations
  validates :name, presence: true

  reverse_geocoded_by :lat, :lon

  def move(lat, lon)
    update(current_action: :move, action_details: { target: { lat: lat, lon: lon } })
  end

  def tick
    case current_action
    when 'move'
      move_towards(action_details['target'])
    end
    ActionCable.server.broadcast "characters", { id => self }
  end

  private

  def move_towards(target)
    # Calculate new position
    dist_km = (speed * Ticker::TICK_TIME) / 1000
    bearing = bearing_to(target)
    new_lat, new_lon = Geocoder::Calculations.endpoint([lat,lon], bearing, dist_km)
    # Check if we've passed it
    binding.pry
    if new_lat >= target[0] || new_lon >= target[1]
      update(lat: target[0], lon: target[1], current_action: nil, action_details: nil)
    else
      update(lat: new_lat, lon: new_lon)
    end
  end

  def speed
    # Units: meters/second
    stats.try(:[],'speed').try(:to_i) || 1.4
  end
end
