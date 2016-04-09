class CreateCar < ActiveRecord::Migration[5.0]
  def change
    create_table :cars do |t|
      t.integer :character_id
      t.string :name
      t.integer :health
      t.geometry :latlng
      t.timestamps
      t.hstore :action_details
    end
  end
end
