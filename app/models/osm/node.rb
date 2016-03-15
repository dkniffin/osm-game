module OSM
  class Node < ActiveRecord::Base
    include Geographic::Point
    include OSM::Objects

    self.table_name = 'planet_osm_point'
    self.primary_key = 'osm_id'

    point_attribute :way
  end
end
