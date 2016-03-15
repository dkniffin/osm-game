module OSM
  class Way < OSM::Base
    include Geographic::Polygon

    self.table_name = 'planet_osm_polygon'
    self.primary_key = 'osm_id'

    geometry_attribute :way
  end
end
