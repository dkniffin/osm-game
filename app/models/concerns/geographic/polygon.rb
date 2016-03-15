module Geographic
  module Polygon
    extend ActiveSupport::Concern

    included do
      # Returns the objects that contain the given point
      scope :containing_point, -> (arg1, arg2 = nil) {
        # Normalize
        rgeo_point = Normalize.to_rgeo_point(arg1, arg2)

        # Set SRID
        point = Geographic.set_srid(rgeo_point)
        geometry = Geographic.set_srid(geometry_column)

        # Do the Query
        where(geometry.st_contains(point))
      }

      # Returns the objects that intersect with the given line
      scope :intersected_by_line, -> (arg1, arg2 = nil) {
        # Normalize
        rgeo_line = Normalize.to_rgeo_line_string(arg1, arg2)

        # Set SRID
        line = Geographic.set_srid(rgeo_line)
        geometry = Geographic.set_srid(geometry_column)

        # Do the Query
        where(geometry.st_intersects(line))
      }
    end

    module ClassMethods
      attr_reader :geometry_attribute

      private

      def geometry_attribute(geometry_column = :geometry)
        @geometry_attribute = geometry_column
      end

      def geometry_column
        attr_sym = @geometry_attribute.try(:to_sym) || :geometry
        arel_table[attr_sym]
      end
    end
  end
end
