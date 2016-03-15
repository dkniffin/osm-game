require 'rails_helper'

RSpec.describe Character, type: :model do
  subject { create(:character) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:latlng) }
  it { is_expected.to respond_to(:player) }
  it { is_expected.to respond_to(:stats) }

  it_behaves_like 'a geographic point'

  context 'when name is empty' do
    subject { build(:character, name: nil) }

    it 'is invalid' do
      expect(subject).to be_invalid
    end
  end

  describe '#take_damage' do
    before { subject.take_damage(amount) }

    context 'valid amount' do
      let(:amount) { 10 }

      it 'subtract from the total health' do
        expect(subject.health).to eq(90)
      end
    end

    context 'valid amount' do
      let(:amount) { 100 }
      it 'cannot drop below 0' do
        expect(subject.health).to eq(0)
      end
    end
  end
end
