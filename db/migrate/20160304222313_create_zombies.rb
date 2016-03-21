class CreateZombies < ActiveRecord::Migration[5.0]
  def change
    enable_extension "postgis"

    create_table :zombies do |t|
      t.integer :health
      t.geometry :latlng

      t.timestamps
    end
  end
end
