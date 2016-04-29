class Search < ActiveInteraction::Base
  interface :character, methods: %i(items latlng search_level)

  def execute
    # get character's location
    location = character.current_location

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
    LocationType.get(location.location_type).try(:[], 'resources')
  end
end
