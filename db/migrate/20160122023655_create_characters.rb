class CreateCharacters < ActiveRecord::Migration[5.0]
  def change
    enable_extension "hstore"
    create_table :characters do |t|
      t.string :name
      t.decimal :lat
      t.decimal :lon
      t.boolean :player
      t.hstore :stats

      t.timestamps
    end
  end
end
