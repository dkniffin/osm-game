require 'rails_helper'

describe OSM::Node, type: :model do
  it_behaves_like 'a geographic point', factory: :osm_node, point_attribute: :way
end
