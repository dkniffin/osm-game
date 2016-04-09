# A Car channel
class CarChannel < ApplicationCable::Channel
  def subscribed
    stream_from "car"
    Car.all.each do |c|
      c.send(:broadcast_updates)
    end

    def move(data)
      car(data).move(data['lat'], data['long'])
    end

    private

    def car(data)
      Car.find(data['id'])
    end
  end
end
