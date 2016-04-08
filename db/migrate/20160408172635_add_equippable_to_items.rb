class AddEquippableToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :equippable, :boolean
  end
end
