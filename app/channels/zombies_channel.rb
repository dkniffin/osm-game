class ZombiesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "zombies"

    Zombie.all.each do |z|
      z.send(:broadcast_updates)
    end
  end
end
