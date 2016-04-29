class LocationType
  DATA = YAML.load(File.read(Rails.root.join('app', 'data', 'locations.yml'))).freeze

  def self.get(type)
    DATA[type.to_s]
  end
end
