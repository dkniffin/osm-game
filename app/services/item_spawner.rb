class ItemSpawner < ActiveInteraction::Base
  hash :category_probabilities, strip: false
  integer :skill

  ITEM_STATS = YAML.load(File.read(Rails.root.join('app', 'data', 'items.yml'))).freeze

  def execute
    item_category = Pickup.new(category_probabilities).pick
    items = ITEM_STATS[item_category]
    return nil if items.nil?
    items = items.map { |i| i.merge(category: item_category) }
    items = weighted_spawn_chances(items, skill)
    item_picker = Pickup.new(
      items,
      weight_func: method(:weighted_spawn_chance),
      key_func: method(:item_data)
    )
    item_data = item_picker.pick
    Item.new(item_data)
  end

  private

  def weighted_spawn_chance(raw_item_data)
    raw_item_data['weighted_spawn_chance']
  end

  def item_data(raw_item_data)
    raw_item_data.except('spawn_chance', 'weighted_spawn_chance')
  end

  # This function adds a weighted_spawn_chance key/value pair to the item hashes, which is the
  # likelyhood to find the item, if you have the given skill level
  def weighted_spawn_chances(items, skill)
    skill_factor = (50 - skill)/100.0
    items.map do |item|
      item.merge('weighted_spawn_chance' => item['spawn_chance'] * skill_factor + skill)
    end
  end
end
