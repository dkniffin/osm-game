module OSM
  module Objects
    extend ActiveSupport::Concern

    included do
      scope :buildings, -> { where.not(building: ['no']) }
    end
  end
end
