module Geographic
  module Point
    extend ActiveSupport::Concern

    included do
      @@factory = RGeo::Geographic.spherical_factory(srid: 4326)

      # Returns the objects contained in the given box
      scope :inside, -> (raw) {
        # Normalize
        geometry = Normalize.to_rgeo_polygon(raw)

        # Set the SRID
        spatial = Geographic.set_srid(geometry)
        this_point = Geographic.set_srid(point_column)

        # Do the query
        where(spatial.st_contains(this_point))
      }

      # Returns the object closest to the given coordinates
      scope :closest_to, -> (arg1, arg2=nil) {
        # Normalize
        rgeo_point = Normalize.to_rgeo_point(arg1, arg2)

        # Set the SRID
        target_point = Geographic.set_srid(rgeo_point)
        this_point = Geographic.set_srid(point_column)

        # Do the query
        order(target_point.st_distance(this_point)).first
      }

      private

      def self.point_column
        column_sym = self.try(:point_attribute).try(:to_sym) || :latlng
        arel_table[column_sym]
      end
    end
  end
end
