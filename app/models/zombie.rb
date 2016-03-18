class Zombie < ApplicationRecord
  include Geographic::Point

  def tick
    broadcast_updates
  end

  private

  def broadcast_updates
    ActionCable.server.broadcast "zombies", id => self.to_json(methods: [:lat, :lon])
  end
end
