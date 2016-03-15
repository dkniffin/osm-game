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
      scope :intersected_by_line, -> (start_point, end_point) {
        line = RGeo::Geographic.spherical_factory(srid: 4326).line(start_point, end_point)
        spatial = Arel.spatial(line.as_text).st_function(:ST_SetSRID, 4326)
        matcher = geometry_column.st_function(:ST_Transform, 4326).st_intersects(spatial)
        where(matcher)
      }
    end

    module ClassMethods
      attr_reader :geometry_attribute

      private

      def geometry_attribute(geometry_column = :geometry)
        @geometry_attribute = geometry_column
      end

      def geometry_column
        arel_table[@geometry_attribute.to_sym]
      end
    end
  end
end
