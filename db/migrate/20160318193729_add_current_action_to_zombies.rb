class AddCurrentActionToZombies < ActiveRecord::Migration[5.0]
  def change
    add_column :zombies, :current_action, :string
    add_column :zombies, :action_details, :hstore
  end
end
