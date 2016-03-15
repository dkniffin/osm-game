require 'spec_helper'

shared_examples_for 'an osm object' do |options = {}|
  let(:model) { described_class }
  let(:factory) { options[:factory] || model.to_s.underscore.to_sym }

  describe '.buildings' do
    let(:valid_building_values) { %w(yes house commercial garage school) }
    let(:invalid_building_values) { %w(nil, no) }
    let!(:buildings) { create(factory, building: valid_building_values.sample) }
    let!(:non_buildings) { create(factory, building: invalid_building_values.sample) }

    it 'only includes buildings' do
      expect(model.buildings).to include(buildings)
      expect(model.buildings).to_not include(non_buildings)
    end
  end
end
