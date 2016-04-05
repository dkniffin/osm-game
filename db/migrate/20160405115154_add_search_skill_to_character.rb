class AddSearchSkillToCharacter < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :search_level, :integer
  end
end
