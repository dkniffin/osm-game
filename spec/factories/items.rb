FactoryGirl.define do
  factory :item do
    character
    name "Item"
    category ""
    stats { {} }
  end
end
