module Game
  module Unit
    extend ActiveSupport::Concern

    included do
      before_save :full_health

      def move(lat, lon)
        unless colides_with_building?(lat, lon)
          update(current_action: :move, action_details: { target_lat: lat, target_lon: lon })
        end
      end

      def speed
        # Units: meters/second
        # stats.try(:[], 'speed').try(:to_i) ||
        1.4 * 60
      end

      def speed_per_tick
        speed.to(1.meter.per.send(::Ticker::TICK_TIME.parts[0][0]))
      end

      def attack(target, tick_count)
        if tick_count % attack_speed == 0
          target.take_damage(attack_damage)
        end
      end

      def restore_health(restore)
        new_health = self.health += restore
        new_health = 100 if new_health > 100
        update(health: new_health)
      end

      def take_damage(damage)
        new_health = self.health -= damage
        new_health = 0 if new_health < 0
        update(health: new_health)
      end

      def delete_if_dead
        if health <= 0
          if self.class == Zombie
            destroy
          end
        end
      end

      private

      def move_towards(target)
        target = target.map(&:to_f)
        # Calculate new position
        dist_km = (speed * Ticker::TICK_TIME) / 1000
        bearing = Geocoder::Calculations.bearing_between([lat, lon], target)
        new_lat, new_lon = Geocoder::Calculations.endpoint([lat, lon], bearing, dist_km)

        # Check if we've passed it
        if unordered_between?(new_lat, lat, target[0]) && unordered_between?(new_lon, lon, target[1])
          update(lat: new_lat, lon: new_lon)
        else
          update(lat: target[0], lon: target[1], current_action: nil, action_details: nil)
        end
      end

      def colides_with_building?(target_lat, target_lon)
        target = RGeo::Geographic.spherical_factory(srid: 4326).point(target_lon, target_lat)
        OSM::Way.buildings.intersected_by_line(latlng, target).present?
      end

      def unordered_between?(subject, arg1, arg2)
        subject.between?(*[arg1, arg2].sort)
      end

      def full_health
        self.health ||= 100
      end
    end
  end
end
