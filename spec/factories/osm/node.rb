FactoryGirl.define do
  factory :osm_node, class: OSM::Node do
    sequence(:osm_id)
    way do
      lat = rand(-90.0..90.0)
      lon = rand(-180.0..180.0)
      RGeo::Geographic.spherical_factory(srid: 4326).point(lon, lat)
    end
  end
end
