class AddCurrentActionToCharacter < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :current_action, :string
    add_column :characters, :action_details, :hstore
  end
end
