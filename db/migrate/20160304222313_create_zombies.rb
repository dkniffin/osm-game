class CreateZombies < ActiveRecord::Migration[5.0]
  def change
    create_table :zombies do |t|
      t.integer :health
      t.decimal :lat
      t.decimal :lon

      t.timestamps
    end
  end
end
