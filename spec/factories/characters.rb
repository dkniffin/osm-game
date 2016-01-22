FactoryGirl.define do
  factory :character do
    name { Faker::Lorem.word }
    lat { rand(-90.0..90.0) }
    lon { rand(-180.0..180.0) }
    player { [true,false].sample }
    stats { {} }
  end
end
