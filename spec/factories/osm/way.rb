FactoryGirl.define do
  factory :osm_way, class: OSM::Way do
    sequence(:osm_id)
    way do
      polygon = [[0.0, 0.0], [1.0, 0.0], [1.0, 1.0], [0.0, 1.0]]
      RGeo::Geographic.spherical_factory(srid: 4326).polygon(polygon)
    end
  end
end
