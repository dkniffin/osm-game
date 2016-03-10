class ZombieSpawner
  SPAWN_DISTANCE = 0.25 # km

  def spawn
    Character.all.each do |c|
      number_of_zombies = rand(0..5)
      number_of_zombies.times do
        spawn_point = random_spawn_coords([c.lat, c.lon])
        Zombie.create(lat: spawn_point[0], lon: spawn_point[1])
      end
    end
  end

  private

  def random_spawn_coords(center)
    box = GeoHelpers.box_center_radius(center, SPAWN_DISTANCE)
    lat = rand(box[:s]..box[:n])
    lon = rand(box[:w]..box[:e])
    [lat, lon]
  end
end
