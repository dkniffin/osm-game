class Character < ActiveRecord::Base
  validates :name, presence: true
end
