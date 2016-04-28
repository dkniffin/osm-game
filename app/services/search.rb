class Search < ActiveInteraction::Base
  interface :character, methods: %i(items latlng search_level)

  STATS = YAML.load(File.read(Rails.root.join('app', 'data', 'location_resources.yml'))).freeze

  def execute
    # get character's location
    location = OSM::Way.containing_point(character.latlng).with_type.first

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
    STATS[location.location_type]
  end
end
