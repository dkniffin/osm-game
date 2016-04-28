class AddUserToCharacters < ActiveRecord::Migration[5.0]
  def change
    add_reference :characters, :user, index: true, foreign_key: true
    remove_column :characters, :player # Never ended up using this column
  end
end
