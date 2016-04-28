FactoryGirl.define do
  factory :zombie do
    health 100
    latlng do
      lat = rand(-90.0..90.0)
      lon = rand(-180.0..180.0)
      RGeo::Geographic.spherical_factory(srid: 4326).point(lon, lat)
    end
  end
end
