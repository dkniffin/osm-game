class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.references :character
      t.string :name
      t.string :type
      t.hstore :stats

      t.timestamps
    end
  end
end
