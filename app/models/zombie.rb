class Zombie < ApplicationRecord
  def tick
    broadcast_updates
  end

  private

  def broadcast_updates
    ActionCable.server.broadcast "zombies", { id => self }
  end
end
