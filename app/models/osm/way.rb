module OSM
  class Way < ActiveRecord::Base
    include Geographic::Polygon
    include OSM::Objects

    self.table_name = 'planet_osm_polygon'
    self.primary_key = 'osm_id'

    geometry_attribute :way
  end
end
