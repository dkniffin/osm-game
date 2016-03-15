# Normalizes various similar datatypes
module Normalize
  include Geographic

  @@factory = RGeo::Geographic.spherical_factory(srid: 4326)

  # Input:
  #  - Two arguments: lon, lat
  #  - An array with two elements: [lon, lat]
  #  - An RGeo point
  # Output:
  #  An rgeo point, with srid 4326
  def self.to_rgeo_point(arg1, arg2 = nil)
    # Convert array to two points
    if arg1.class == Array
      lon, lat = arg1
    elsif arg1.class == Float
      lon = arg1
      lat = arg2
    end

    # Convert points to Rgeo object
    point = if lon.present? && lat.present?
              @@factory.point(lon, lat)
            else
              arg1
            end

    point
  end

  # Input:
  #  - a Hash, with keys :n, :s, :e, :w
  #  - a 2d array of lon, lat points
  #  - a RGeo geometry
  # Output:
  #  An rgeo polygon
  def self.to_rgeo_polygon(raw)
    # Convert hash to 2D array
    outline = if raw.class == Hash
                [
                  [raw[:w], raw[:n]],
                  [raw[:e], raw[:n]],
                  [raw[:e], raw[:s]],
                  [raw[:w], raw[:s]]
                ]
              elsif raw.class == Array
                raw
              end

    # Convert 2D array of floats to polygon
    geometry = if outline.present?
                 line_string = to_rgeo_line_string(outline)
                 @@factory.polygon(line_string)
               else
                 raw
               end

    geometry
  end

  # Input:
  #  - Two arguments, each one a point allowed by to_rgeo_point
  #  - An array of two elements, each one a point allowed by to_rgeo_point
  #  - An rgeo line_string
  # Output:
  #  An rgeo line_string
  def self.to_rgeo_line_string(arg1, arg2 = nil)
    # Convert two arguments to an array
    points = arg2.present? ? [arg1, arg2] : arg1

    # Convert array of points to a linestring
    line_string = if points.class == Array
                    rgeo_points = points.map { |p| to_rgeo_point(p) }
                    @@factory.line_string(rgeo_points)
                  else
                    points
                  end

    line_string
  end
end
