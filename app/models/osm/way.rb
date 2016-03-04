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

    scope :is_intersected_by_line, -> (start_point_raw, end_point_raw) {
      # select ST_AsText(ST_Transform(way, 4326)) from planet_osm_polygon where
      # ST_Intersects(ST_Transform(way, 4326), ST_SetSRID('LINESTRING(-78.9070808887482 35.9935415035295, -78.905763 35.993808)'::geometry, 4326));
      start_point = RGeo::Geographic.spherical_factory(srid: 4326).point(start_point_raw[1], start_point_raw[0])
      end_point = RGeo::Geographic.spherical_factory(srid: 4326).point(end_point_raw[1], end_point_raw[0])
      line = RGeo::Geographic.spherical_factory(srid: 4326).line(start_point, end_point)
      spatial = Arel.spatial(line.as_text).st_function(:ST_SetSRID, 4326)
      matcher = OSM::Way.arel_table[:way].st_function(:ST_Transform, 4326).st_intersects(spatial)
      where(matcher)
    }

    def nodes
      read_attribute(:nodes).map do |node_id|
        Node.find(node_id)
      end
    end
  end
end
