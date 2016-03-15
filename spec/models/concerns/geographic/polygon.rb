shared_examples_for 'a geographic polygon' do |raw_options = {}|
  let(:default_options) { { geometry_attribute: :geometry, factory: model.to_s.underscore.to_sym } }
  let(:options) { default_options.merge(raw_options) }

  let(:factory) { RGeo::Geographic.spherical_factory(srid: 4326) }
  let(:model) { described_class }
  let(:geometry_points) { [[0.0, 0.0], [1.0, 0.0], [1.0, 1.0], [0.0, 1.0]] }
  let(:geometry) { Normalize.to_rgeo_polygon(geometry_points) }
  let(:object) do
    FactoryGirl.create(options[:factory], options[:geometry_attribute] => geometry)
  end

  describe '.containing_point' do
    let(:target_point_array) { [0.5, 0.5] }
    let(:target_point) { factory.point(*target_point_array) }
    let(:arg1) { nil }
    let(:arg2) { nil }
    subject { model.containing_point(arg1, arg2) }

    context 'with no objects' do
      let(:arg1) { target_point_array }

      it 'returns an empty set' do
        expect(subject).to match_array([])
      end
    end

    context 'with an object that contains the point' do
      before { object }

      context 'with an array argument' do
        let(:arg1) { target_point_array }

        it 'returns the object' do
          expect(subject.ids).to include(object.id)
        end
      end

      context 'with lon, lat arguments' do
        let(:arg1) { target_point_array[0] }
        let(:arg2) { target_point_array[1] }

        it 'returns the object' do
          expect(subject.ids).to include(object.id)
        end
      end

      context 'with an rgeo point argument' do
        let(:arg1) { target_point }

        it 'returns the object' do
          expect(subject.ids).to include(object.id)
        end
      end
    end

    context 'with multiple objects' do
      before { object }
      let(:geometry2_points) { [[0.25, 0.25], [0.75, 0.25], [0.75, 0.75], [0.25, 0.75]] }
      let(:geometry2) { Normalize.to_rgeo_polygon(geometry2_points) }
      let!(:object2) do
        FactoryGirl.create(options[:factory], options[:geometry_attribute] => geometry2)
      end
      let(:geometry3_points) { [[1.0, 1.0], [2.0, 1.0], [2.0, 2.0], [1.0, 2.0]] }
      let(:geometry3) { Normalize.to_rgeo_polygon(geometry3_points) }
      let!(:object3) do
        FactoryGirl.create(options[:factory], options[:geometry_attribute] => geometry3)
      end
      let(:arg1) { target_point_array }

      it 'returns the ones that contain the point' do
        expect(subject.ids).to contain_exactly(object.id, object2.id)
      end
    end
  end

  describe '.intersected_by_line' do
    let(:line_points) { [[-1.0, -1.0], [2.0, 2.0]] }
    let(:line) { Normalize.to_rgeo_line_string(line_points) }
    let(:arg1) { nil }
    let(:arg2) { nil }
    subject { model.intersected_by_line(arg1, arg2) }

    context 'with no objects' do
      let(:arg1) { line_points }

      it 'returns an empty set' do
        expect(subject).to match_array([])
      end
    end

    context 'with an object that intersects with the line' do
      before { object }

      context 'with an array of points' do
        let(:arg1) { line_points }

        it 'returns the object' do
          expect(subject.ids).to include(object.id)
        end
      end

      context 'with two point arguments' do
        let(:arg1) { line_points[0] }
        let(:arg2) { line_points[1] }

        it 'returns the object' do
          expect(subject.ids).to include(object.id)
        end
      end

      context 'with an rgeo line_string' do
        let(:arg1) { line }

        it 'returns the object' do
          expect(subject.ids).to include(object.id)
        end
      end
    end
  end
end
