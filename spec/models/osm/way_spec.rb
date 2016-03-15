require 'rails_helper'

describe OSM::Way, type: :model do
  it_behaves_like 'a geographic polygon', factory: :osm_way, geometry_attribute: :way
  it_behaves_like 'an osm object', factory: :osm_way
end
