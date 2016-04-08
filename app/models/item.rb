class Item < ApplicationRecord
  belongs_to :character

  after_commit :touch_character

  scope :weapon, -> { where(category: :weapon) }
  scope :equipped, -> { where(currently_equipped: true) }

  private

  def touch_character
    character.touch
  end
end
