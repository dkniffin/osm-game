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
      dist_km = (speed * Ticker::TICK_TIME) / 1000
      bearing = bearing_to(action_details['target'])
      new_lat, new_lon = Geocoder::Calculations.endpoint([lat,lon], bearing, dist_km)
      update(lat: new_lat, lon: new_lon)
    end
    ActionCable.server.broadcast "characters", { id => self }
  end

  private

  def speed
    # Units: meters/second
    stats.try(:[],'speed').try(:to_i) || 1.4
  end
end
