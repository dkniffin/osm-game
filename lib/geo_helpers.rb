module GeoHelpers
  # Returns an object with n, s, e, w forming a square with the middle at center ([lat, lon]),
  # and with a given radius (in km)
  def box_center_radius(center, radius)
    {
      n: Geocoder::Calculations.endpoint(center, 0, radius)[0],
      s: Geocoder::Calculations.endpoint(center, 90, radius)[1],
      e: Geocoder::Calculations.endpoint(center, 180, radius)[0],
      w: Geocoder::Calculations.endpoint(center, -90, radius)[1]
    }
  end
end
