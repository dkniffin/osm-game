module Geographic
  module Point
    extend ActiveSupport::Concern

    included do
      @@factory = RGeo::Geographic.spherical_factory(srid: 4326)

      # Returns the objects contained in the given box
      #  box can be any of the following:
      #   - a Hash, with keys :n, :s, :e, :w
      #   - a 2d array of lon, lat points
      #   - a RGeo geometry
      scope :inside, -> (raw) {
        # Convert hash to 2D array
        if raw.class == Hash
          outline = [
            [raw[:w], raw[:n]],
            [raw[:e], raw[:n]],
            [raw[:e], raw[:s]],
            [raw[:w], raw[:s]]
          ]
        elsif raw.class == Array
          outline = raw
        end

        # Convert 2D array of floats to polygon
        if outline.present?
          points = outline.map { |p| @@factory.point(*p) }
          geometry = @@factory.polygon(@@factory.line_string(points))
        else
          geometry = raw
        end

        # Set the SRID
        spatial = Geographic.set_srid(geometry)
        this_point = Geographic.set_srid(arel_table[:latlng])

        # Do the query
        where(spatial.st_contains(this_point))
      }

      # Returns the object closest to the given coordinates
      #  coordinates can be given as:
      #   - Two arguments: lon, lat
      #   - An array with two elements: [lon, lat]
      #   - An RGeo point
      scope :closest_to, -> (arg1, arg2=nil) {
        # Convert array to two points
        if arg1.class == Array
          lon, lat = arg1
        elsif arg1.class == Float
          lon, lat = arg1, arg2
        end

        # Convert points to Rgeo object
        if lon.present? && lat.present?
          point = @@factory.point(lon, lat)
        else
          point = arg1
        end

        target_point = Geographic.set_srid(point)
        this_point = Geographic.set_srid(arel_table[:latlng])

        # Do the query
        order(target_point.st_distance(this_point)).first
      }
    end
  end
end
