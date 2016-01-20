class CharacterSerializer < ActiveModel::Serializer
  attributes :name, :lat, :lon, :player, :stats
end
