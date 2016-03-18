shared_examples_for 'an osm object' do |options = {}|
  let(:model) { described_class }
  let(:factory) { options[:factory] || model.to_s.underscore.to_sym }

  describe '.buildings' do
    let(:valid_building_values) { %w(yes house commercial garage school) }
    let(:invalid_building_values) { [nil, 'no'] }
    let!(:buildings) { valid_building_values.map { |v| create(factory, building: v) } }
    let!(:non_buildings) { invalid_building_values.map { |v| create(factory, building: v) } }

    it 'only includes buildings' do
      expect(model.buildings.ids).to include(*buildings.map(&:id))
      expect(model.buildings.ids).to_not include(*non_buildings(&:id))
    end
  end
end
