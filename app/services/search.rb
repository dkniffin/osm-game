class Search < ActiveInteraction::Base
  interface :character, methods: %i(items latlng search_level)

  def execute
    # get character's location
    location = OSM::Way.containing_point(character.latlng).first

    # If there's no location, return
    return if location.nil?

    # find an item in that location
    item = search(location, character.search_level)

    # add it to the characters items
    character.items << item unless item.nil?
  end

  private

  def search(location, skill)
    stats = resource_stats(location) || {}
    ItemSpawner.run!(category_probabilities: stats, skill: skill)
  end

  def resource_stats(location)
    case location.location_type
    when :medical
      { medical: 4, food: 1 }
    end
  end
end
