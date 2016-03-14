class ChangeLatLonToGeometryColumn < ActiveRecord::Migration[5.0]
  def change
    # Characters
    add_column :characters, :latlng, :geometry, geographic: true, srid: 4326
    Character.all.each do |c|
      latlng = RGeo::Geographic.spherical_factory(srid: 4326).point(c.lon, c.lat)
      c.update(latlng: latlng)
    end
    remove_column :characters, :lat
    remove_column :characters, :lon

    # Zombies
    add_column :zombies, :latlng, :geometry, geographic: true, srid: 4326
    Zombie.all.each do |z|
      latlng = RGeo::Geographic.spherical_factory(srid: 4326).point(z.lon, z.lat)
      z.update(latlng: latlng)
    end
    remove_column :zombies, :lat
    remove_column :zombies, :lon
  end
end
