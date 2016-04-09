# Creates cars
class CarSpawner < ActiveInteraction::Base
  SPAWN_DISTANCE = 0.25 # km

  def execute
    Character.all.each do |c|
      number_of_cars = rand(0..5)
      number_of_cars.times do
        spawn_point = random_spawn_coords(lat: c.lat, lon: c.lon)
        Car.create(lat: spawn_point[0], lon: spawn_point[1])
      end
    end
  end

  private

  def random_spawn_coords(center)
    box = Geographic::Polygon.box_center_radius(center, SPAWN_DISTANCE)
    lat = rand(box[:s]..box[:n])
    lon = rand(box[:w]..box[:e])
    [lat, lon]
  end
end
