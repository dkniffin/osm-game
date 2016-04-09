# A car
class Car < ActiveRecord::Base
  include Geographic::Point
  include Game::Unit
  include Game::FEUpdater

  has_many :characters

  include Geographic::Point

  reverse_geocoded_by :lat, :lon

  def tick(tick_count)
    # move_towards([action_details['target_lat'], action_details['target_lon']]) do
    #   self.current_action = nil
    #   self.action_details = nil
    # end
  end

  private

  def include_in_to_json
    [:lat, :lon]
  end
end
