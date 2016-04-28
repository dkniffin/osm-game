class ZombieTicker < ActiveInteraction::Base
  interface :subject,
            methods: %i(lon lat latlng attack attack_range delete_if_dead aggro_distance)
  integer :tick_count
  def execute
    char = Character.closest_to(zombie.lon, zombie.lat)
    if zombie.latlng.distance(char.latlng) / 1000 <= zombie.attack_range
      zombie.attack(char, tick_count)
    elsif zombie.latlng.distance(char.latlng) / 1000 <= zombie.aggro_distance
      zombie.move_towards([char.lat, char.lon])
    end
    zombie.delete_if_dead
  end

  private

  def zombie
    subject
  end
end
