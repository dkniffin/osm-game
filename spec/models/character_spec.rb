require 'rails_helper'

describe Character, type: :model do
  subject { create(:character) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:latlng) }
  it { is_expected.to respond_to(:player) }
  it { is_expected.to have_many(:items) }

  it_behaves_like 'a geographic point'

  context 'when name is empty' do
    subject { build(:character, name: nil) }

    it 'is invalid' do
      expect(subject).to be_invalid
    end
  end

  describe '#take_damage' do
    before { subject.update(health: 100) }
    it 'subtracts from the total health' do
      subject.take_damage(10)
      expect(subject.health).to eq(90)
    end

    it 'cannot drop below 0' do
      subject.take_damage(1000)
      expect(subject.health).to eq(0)
    end
  end

  describe '#restore_health' do
    before { subject.update(health: 50) }
    it 'adds to the total health' do
      subject.restore_health(10)
      expect(subject.health).to eq(60)
    end

    it 'cannot go above 100' do
      subject.restore_health(1000)
      expect(subject.health).to eq(100)
    end
  end

  describe '#restore_food' do
    before { subject.update(food: 20) }
    it 'adds to the total food' do
      subject.restore_food(40)
      expect(subject.food).to eq(60)
    end

    it 'cannot go above 100' do
      subject.restore_food(600)
      expect(subject.food).to eq(100)
    end
  end

  describe '#lose_food' do
    before { subject.update(food: 10) }
    it 'subtracts from the total food' do
      subject.lose_food(10)
      expect(subject.food).to eq(0)
    end

    it 'cannot drop below 0' do
      subject.lose_food(10)
      expect(subject.food).to eq(0)
    end
  end

  describe '#restore_water' do
    before { subject.update(water: 30) }
    it 'adds to the total water' do
      subject.restore_water(60)
      expect(subject.water).to eq(90)
    end

    it 'cannot go above 100' do
      subject.restore_water(99)
      expect(subject.water).to eq(100)
    end
  end

  describe '#lose_water' do
    before { subject.update(water: 100) }
    it 'subtracts from the total water' do
      subject.lose_water(1)
      expect(subject.water).to eq(99)
    end

    it 'cannot drop below 0' do
      subject.lose_water(1000)
      expect(subject.water).to eq(0)
    end
  end

  context 'with a known lat/lng' do
    let(:lat) { 35.0 }
    let(:lon) { -105.0 }
    before { subject.update(latlng: Normalize.to_rgeo_point(lon, lat)) }

    describe '#lat' do
      it 'returns the latitude' do
        expect(subject.lat).to eq(lat)
      end
    end

    describe '#lng' do
      it 'returns the longitude' do
        expect(subject.lng).to eq(lon)
      end
    end

    describe '#lon' do
      it 'returns the longitude' do
        expect(subject.lon).to eq(lon)
      end
    end

    describe '#lat=' do
      let(:new_lat) { 34.0 }
      it 'updates the latitude' do
        subject.lat = new_lat
        expect(subject.lat).to eq(new_lat)
      end
    end

    describe '#lng=' do
      let(:new_lng) { -104.0 }
      it 'updates the longitude' do
        subject.lng = new_lng
        expect(subject.lng).to eq(new_lng)
      end
    end
  end

  describe '#search' do
    pending 'updates current action to search, with the given target'
  end

  describe '#use_item' do
    pending 'destroys the item'
    pending 'removes the item from the characters items'
    context 'when the item is a medical item' do
      pending 'restores the approprate amount of health'
    end
  end

  describe '#tick' do
    context 'when the current action is move' do
      pending 'calls move_towards'
      context 'when the target is within one step' do
        pending 'sets the lat/lon to the target'
        pending 'sets current_action to nil'
        pending 'sets action_details to nil'
      end

      context 'when the target is not within one step' do
        pending 'changes the lat/lon'
        pending 'does not set current_action to nil'
        pending 'does not set the action_details to nil'
      end
    end

    context 'when the current action is search' do
      pending 'calls move_towards'
      context 'when the target is within one step' do
        pending 'calls Search.run'
        pending 'sets current_action to nil'
        pending 'sets action_details to nil'
      end

      context 'when the target is not within one step' do
        pending 'changes the lat/lon'
        pending 'does not call Search.run'
        pending 'does not set current_action to nil'
        pending 'does not set the action_details to nil'
      end
    end

    context 'when there is no current action' do
      context 'and there is a zombie in range' do
        pending 'attack is called'
      end
    end
  end
end
