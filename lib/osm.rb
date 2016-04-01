module OSM
  def self.all
    OSM::Node.all + OSM::Way.all
  end

  def self.building
    OSM::Node.building + OSM::Way.building
  end
end
