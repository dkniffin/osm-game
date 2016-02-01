class Character < ActiveRecord::Base
  include Math
  include Geocoder::Calculations
  validates :name, presence: true

  reverse_geocoded_by :lat, :lon

  def move(lat, lon)
    update(current_action: :move, action_details: { target_lat: lat, target_lon: lon })
  end

  def tick
    case current_action
    when 'move'
      move_towards([action_details['target_lat'], action_details['target_lon']])
    end
    ActionCable.server.broadcast "characters", { id => self }
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

  def speed
    # Units: meters/second
    stats.try(:[],'speed').try(:to_i) || 1.4
  end

  def unordered_between?(subject, arg1, arg2)
    subject.between?(*[arg1, arg2].sort)
  end
end
