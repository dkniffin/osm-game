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
    item_type_picker = Pickup.new(stats)
    item_type = item_type_picker.pick
    Item.new(category: item_type, name: item_type) unless item_type.nil?
  end

  def resource_stats(location)
    case location.location_type
    when :medical
      { medical: 4, food: 1 }
    end
  end
end
