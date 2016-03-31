module OSM
  module Objects
    extend ActiveSupport::Concern

    TYPES = {
      building: {
        not: {
          building: %w(no)
        }
      },
      medical: {
        amenity: %w(hospital doctors dentist clinic pharmacy veterinary)
      },
      gas_station: {
        amenity: %w(fuel)
      },
      food: {
        shop: %w(deli supermarket)
      }
    }


    included do
      TYPES.each do |type, definition|
        scope type, -> {
          filter = definition.delete(:not) || {}
          definition ||= {}
          where.not(filter).where(definition)
        }
      end

      def location_type
        TYPES.select do |type, definition|
          filter = definition.delete(:not) || {}
          definition ||= {}
          filter.none? { |tag, values| values.include?(tags[tag]) } && definition.all? { |tag, values| values.include?(tags[tag]) }
        end.keys.first
      end

      private

      def tags
        @tags ||= %i(building amenity shop).map { |tag| [tag, send(tag)] }.to_h
      end
    end
  end
end
