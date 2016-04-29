module OSM
  module Objects
    extend ActiveSupport::Concern

    TYPES = {
      medical: {
        amenity: %w(hospital doctors dentist clinic pharmacy veterinary)
      },
      gas_station: {
        amenity: %w(fuel)
      },
      food: {
        shop: %w(deli supermarket)
      },
      police: {
        amenity: %w(police)
      },
      weapon_shop: {
        shop: %w(weapons)
      },
      sporting_goods: {
        shop: %w(outdoor hunting sport)
      },
      pawnbroker: {
        shop: %w(pawnbroker)
      },
      house: {
        building: %w(house)
      },
      cemetery: {
        landuse: %w(cemetery)
      },
      building: {
        not: {
          building: ['no', nil]
        }
      }
    }.freeze

    included do
      TYPES.each do |type, definition|
        scope type, -> {
          filter_hash = definition[:not] || {}
          requirement_hash = definition.except(:not)
          where.not(filter_hash).where(requirement_hash)
        }
      end

      scope :with_type, -> {
        types = TYPES.keys - [:building]
        types.map { |t| send(t) }.reduce(:+)
      }

      def location_type
        TYPES.select do |_type, definition|
          filter = definition.delete(:not) || {}
          definition ||= {}
          filter.none? { |tag, values| values.include?(tags[tag]) } &&
            definition.all? { |tag, values| values.include?(tags[tag]) }
        end.keys.first
      end

      private

      def tags
        @tags ||= %i(building amenity shop).map { |tag| [tag, send(tag)] }.to_h
      end
    end
  end
end
