module OSM
  class Node < OSM::Base
    self.table_name = 'planet_osm_point'
    self.primary_key = 'osm_id'
  end
end
