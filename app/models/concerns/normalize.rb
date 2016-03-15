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
      lon, lat = arg1, arg2
    end

    # Convert points to Rgeo object
    if lon.present? && lat.present?
      point = @@factory.point(lon, lat)
    else
      point = arg1
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
      line_string = to_rgeo_line_string(outline)
      geometry = @@factory.polygon(line_string)
    else
      geometry = raw
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
    if arg2.present?
      points = [arg1, arg2]
    else
      points = arg1
    end

    # Convert array of points to a linestring
    if points.class == Array
      rgeo_points = points.map { |p| to_rgeo_point(p) }
      line_string = @@factory.line_string(rgeo_points)
    else
      line_string = points
    end

    line_string
  end
end
