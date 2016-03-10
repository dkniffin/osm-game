class ZombiesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "zombies"
  end
end
