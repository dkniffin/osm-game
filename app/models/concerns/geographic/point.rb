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
        spatial = Arel.spatial(geometry.as_text).st_function(:ST_SetSRID, 4326)
        this_point = arel_table[:latlng].st_function(:ST_Transform, 4326)

        # Do the query
        where(spatial.st_contains(this_point))
      }

      scope :closest_to, -> (lat, lon) {
        point = RGeo::Geographic.spherical_factory(srid: 4326).point(lon, lat)
        character = Character.arel_table[:latlng]
        order(character.st_distance(point.as_text)).first
      }
    end
  end
end
