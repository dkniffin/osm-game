class Search < ActiveInteraction::Base
  interface :character, methods: %i(items latlng)

  def execute
    # get character's location
    location = OSM::Way.containing_point(character.latlng).first

    # If there's no location, return
    return if location.nil?

    # find an item in that location
    item = search(location)

    # add it to the characters items
    character.items << item unless item.nil?
  end

  private

  def search(location)
    stats = resource_stats(location) || {}
    ItemSpawner.run!(category_probabilities: stats)
  end

  def resource_stats(location)
    case location.location_type
    when :medical
      { medical: 4, food: 1 }
    when :police
      { weapon: 5, medical: 1, food: 1 }
    when :weapon_shop
      { weapon: 5 }
    when :sporting_goods
      { weapon: 2, medical: 2, food: 1 }
    when :pawnbroker
      { weapon: 1 }
    when :house
      { weapon: 1, medical: 2, food: 5 }
    end
  end
end
