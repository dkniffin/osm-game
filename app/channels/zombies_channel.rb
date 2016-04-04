class ZombiesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "zombies"

    Zombie.all.each do |z|
      # TODO: Fix an issue where zombies won't show up on the FE until they move
      z.send(:broadcast_updates)
    end
  end
end
