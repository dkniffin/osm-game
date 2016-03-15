class ChangeLatLonToGeometryColumn < ActiveRecord::Migration[5.0]
  def change
    factory = RGeo::Geographic.spherical_factory(srid: 4326)

    # Characters
    add_column :characters, :latlng, :geometry
    Character.all.each do |c|
      latlng = factory.point(c.lon, c.lat)
      c.update(latlng: latlng)
    end
    remove_column :characters, :lat
    remove_column :characters, :lon
  end
end
