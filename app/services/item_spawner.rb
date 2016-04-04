class ItemSpawner < ActiveInteraction::Base
  hash :category_probabilities, strip: false

  ITEM_STATS = YAML.load(File.read(Rails.root.join('app', 'data', 'items.yml'))).freeze

  def execute
    item_category = Pickup.new(category_probabilities).pick
    items = ITEM_STATS[item_category]
    return nil if items.nil?
    item_data = Pickup.new(
      items,
      weight_func: proc { |item| item['spawn_chance'] },
      key_func: proc { |item| item.except('spawn_chance').merge(category: item_category) }
    ).pick
    Item.new(item_data)
  end
end
