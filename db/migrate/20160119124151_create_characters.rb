class CreateCharacters < ActiveRecord::Migration
  def change
    enable_extension "hstore"

    create_table :characters do |t|
      t.string   :name
      t.decimal  :lat
      t.decimal  :lon
      t.boolean  :player
      t.hstore :stats

      t.timestamps null: false
    end
  end
end
