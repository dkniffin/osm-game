require 'spec_helper'

shared_examples_for 'a geographic point' do |raw_options = {}|
  let(:default_options) { { point_attribute: :latlng, factory: model.to_s.underscore.to_sym } }
  let(:options) { default_options.merge(raw_options) }

  let(:factory) { RGeo::Geographic.spherical_factory(srid: 4326) }
  let(:model) { described_class }
  let(:latlng_array) { [-78.898619, 35.994033] }
  let(:latlng) { factory.point(*latlng_array) }
  let(:object) do
    FactoryGirl.create(options[:factory], options[:point_attribute] => latlng)
  end

  describe '.inside' do
    let(:hash) { { n: 36.002104, s: 35.978562, e: -78.881578, w: -78.912048 } }
    let(:array) do
      [
        [hash[:w], hash[:n]],
        [hash[:e], hash[:n]],
        [hash[:e], hash[:s]],
        [hash[:w], hash[:s]]
      ]
    end
    let(:rgeo) do
      points = array.map { |p| factory.point(*p) }
      factory.polygon(factory.line_string(points))
    end
    subject { model.inside(geometry) }

    context 'with a contained object' do
      before { object }
      context 'with a hash' do
        let(:geometry) { hash }

        it 'returns the object' do
          expect(subject.length).to eq(1)
          expect(subject).to include(object)
        end
      end

      context 'with an array' do
        let(:geometry) { array }

        it 'returns the object' do
          expect(subject.length).to eq(1)
          expect(subject).to include(object)
        end
      end

      context 'with a rgeo object' do
        let(:geometry) { rgeo }

        it 'returns the object' do
          expect(subject.length).to eq(1)
          expect(subject).to include(object)
        end
      end
    end
    context 'with no contained object' do
      context 'with a hash' do
        let(:geometry) { hash }

        it 'returns an empty array' do
          expect(subject.length).to eq(0)
        end
      end

      context 'with an array' do
        let(:geometry) { array }

        it 'returns an empty array' do
          expect(subject.length).to eq(0)
        end
      end

      context 'with a rgeo object' do
        let(:geometry) { rgeo }

        it 'returns an empty array' do
          expect(subject.length).to eq(0)
        end
      end
    end
  end

  describe '.closest_to' do
    let(:target_point_array) { [-78.0, 35.0] }
    let(:target_point) { factory.point(*target_point_array) }
    let(:arg1) { nil }
    let(:arg2) { nil }
    subject { model.closest_to(arg1, arg2) }

    context 'with no object' do
      let(:arg1) { target_point_array }

      it 'returns an empty set' do
        expect(subject).to match_array([])
      end
    end

    context 'with an object' do
      before { object }

      context 'with an array argument' do
        let(:arg1) { target_point_array }

        it 'returns the object' do
          expect(subject).to eq(object)
        end
      end

      context 'with lon, lat arguments' do
        let(:arg1) { target_point_array[0] }
        let(:arg2) { target_point_array[1] }

        it 'returns the object' do
          expect(subject).to eq(object)
        end
      end

      context 'with an rgeo point argument' do
        let(:arg1) { target_point }

        it 'returns the object' do
          expect(subject).to eq(object)
        end
      end
    end

    context 'with 2 objects' do
      before { object }
      let(:object2_latlng) { factory.point(-79.0, 36.0) }
      let!(:object2) do
        FactoryGirl.create(options[:factory], options[:point_attribute] => object2_latlng)
      end
      let(:arg1) { target_point }

      it 'returns the closest point' do
        expect(subject).to eq(object)
      end
    end
  end
end
