module OSM
  class Way < OSM::Base
    self.table_name = 'planet_osm_polygon'
    self.primary_key = 'osm_id'

    scope :containing_point, -> (lat, lon) {
      point = RGeo::Geographic.spherical_factory(srid: 4326).point(lon, lat)
      spatial = Arel.spatial(point.as_text).st_function(:ST_SetSRID, 4326)
      matcher = OSM::Way.arel_table[:way].st_function(:ST_Transform, 4326).st_contains(spatial)
      where(matcher)
    }

    def nodes
      read_attribute(:nodes).map do |node_id|
        Node.find(node_id)
      end
    end
  end
end
