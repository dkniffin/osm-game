module OSM
  class Way < OSM::Base
    self.table_name = 'planet_osm_polygon'
    self.primary_key = 'osm_id'

    def nodes
      read_attribute(:nodes).map do |node_id|
        Node.find(node_id)
      end
    end
  end
end
