module OSM
  class Base < ActiveRecord::Base
    scope :buildings, -> { where.not(building: ['no']) }
  end
end
