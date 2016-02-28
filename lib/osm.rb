module OSM
  def self.all
    OSM::Node.all + OSM::Way.all
  end

  def self.buildings
    OSM::Node.buildings + OSM::Way.buildings
  end
end
