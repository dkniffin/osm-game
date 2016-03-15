module OSM
  class Node < OSM::Base
    include Geographic::Point

    self.table_name = 'planet_osm_point'
    self.primary_key = 'osm_id'
    self.point_attribute = 'way'
  end
end
