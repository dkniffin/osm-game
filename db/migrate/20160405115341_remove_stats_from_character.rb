class RemoveStatsFromCharacter < ActiveRecord::Migration[5.0]
  def change
    remove_column :characters, :stats
  end
end
