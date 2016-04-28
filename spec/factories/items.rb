FactoryGirl.define do
  factory :item do
    character
    name "Item"
    category ""
    stats do
      {
        health_recovered: 10,
        food_recovered: 10,
        water_recovered: 10
      }
    end
  end
end
