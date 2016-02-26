require_relative '../osm'
namespace :osm do
  desc "Runs the server tick"
  task import: :environment do
    OSM.import({n: 35.995967672, s: 35.9884762566, e: -78.898100853, w:-78.9077138901 })
  end
end
