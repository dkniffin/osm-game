class ZombieSpawner < ActiveInteraction::Base
  interface :character, methods: %i(current_location lat lon)
  SPAWN_DISTANCE = 0.25 # km

  # TODO:
  # - Base the spawn chance on:
  #  - If a player is moving:
  #   - A new stealth skill
  #   - How fast their moving/how much noise they're making
  #  - If they're not moving:
  #   - How fortified their current location is

  # TODO: Make zombies also wander, and group into hordes

  def execute
    if Settings['zombie']['spawn']['chance'] > rand() * 100
      number_of_zombies = rand(1..5)
      puts "spawning #{number_of_zombies} zombies"
      number_of_zombies.times do
        spawn_point = random_spawn_coords(lat: character.lat, lon: character.lon)
        Zombie.create(lat: spawn_point[0], lon: spawn_point[1])
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
