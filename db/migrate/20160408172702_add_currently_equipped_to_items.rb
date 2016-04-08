class AddCurrentlyEquippedToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :currently_equipped, :boolean
  end
end
