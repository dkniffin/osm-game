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
    picker = Pickup.new(stats)
    item_type = picker.pick
    puts "Found a #{item_type}!"
    Item.new(name: item_type) unless item_type.nil?
  end

  def resource_stats(location)
    case location.location_type
    when :medical
      { medkit: 4, can_of_food: 1 }
    end
  end
end
