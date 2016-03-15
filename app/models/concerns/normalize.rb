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
      points = outline.map { |p| @@factory.point(*p) }
      geometry = @@factory.polygon(@@factory.line_string(points))
    else
      geometry = raw
    end

    geometry
  end
end
