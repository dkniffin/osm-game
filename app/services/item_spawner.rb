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
      key_func: proc { |item| item.except('spawn_chance') }
    ).pick
    Item.new(item_data)
  end

  private

  def lookup_table_for_category(category)
    ITEM_STATS[category].map do |data|
      spawn_chance = data.delete('spawn_chance')
      data['category'] = category
      [data, spawn_chance]
    end.to_h
  end
end
