class Item < ApplicationRecord
  belongs_to :character

  after_commit :touch_character

  private

  def touch_character
    character.touch
  end
end
