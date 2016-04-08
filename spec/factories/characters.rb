FactoryGirl.define do
  factory :character do
    name { Faker::Lorem.word }
    latlng do
      lat = rand(-90.0..90.0)
      lon = rand(-180.0..180.0)
      RGeo::Geographic.spherical_factory(srid: 4326).point(lon, lat)
    end
    player { [true,false].sample }
  end
end
