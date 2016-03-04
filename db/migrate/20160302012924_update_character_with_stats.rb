class UpdateCharacterWithStats < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :health, :int, default: 100
    add_column :characters, :water, :int, default: 100
    add_column :characters, :food, :int, default: 100
  end
end
