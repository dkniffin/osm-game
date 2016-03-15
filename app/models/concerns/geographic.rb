module Geographic
  def self.set_srid(geometry)
    case geometry.class.name
    when /RGeo/
      Arel.spatial(geometry.as_text).st_function(:ST_SetSRID, 4326)
    when 'Arel::Attributes::Attribute'
      geometry.st_function(:ST_Transform, 4326)
    end
  end
end
