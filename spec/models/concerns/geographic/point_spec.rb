require 'spec_helper'

shared_examples_for 'a geographic point' do
  let(:factory) { RGeo::Geographic.spherical_factory(srid: 4326) }
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
  let(:model) { described_class }

  describe '.inside' do
    subject { model.inside(geometry) }

    context 'with a contained object' do
      let(:latlng) { factory.point(-78.898619, 35.994033) }
      let!(:object) { FactoryGirl.create(model.to_s.underscore.to_sym, latlng: latlng) }

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
end
