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
    before { subject.update(current_action: nil, action_details: nil) }
    let(:target_lat) { 39.0 }
    let(:target_lon) { -105.0 }

    it 'updates current action to search, with the given target' do
      subject.search(target_lat, target_lon)
      expect(subject.current_action).to eq('search')
      expect(subject.action_details)
        .to include('target_lat' => target_lat.to_s, 'target_lon' => target_lon.to_s)
    end
  end

  describe '#use_item' do
    let!(:item) { create(:item, character: subject) }

    it 'destroys the item' do
      expect { subject.use_item(item) }.to change { Item.count }.from(1).to(0)
    end

    it 'removes the item from the characters items' do
      expect { subject.use_item(item) }.to change { subject.items.count }.from(1).to(0)
    end

    context 'when the item is a medical item' do
      let!(:item) { create(:item, character: subject, category: 'medical') }
      before { subject.update(health: 70) }

      it 'restores the approprate amount of health' do
        expect { subject.use_item(item) }.to change { subject.health }.from(70).to(100)
      end
    end
  end

  describe '#tick' do
    let(:starting_location) { [35.0, -105.0] }
    let(:current_action) { nil }
    let(:action_details) { nil }
    let(:near_target) { ['34.999999', '-105.0'] }
    let(:far_target) { ['34.0', '-105.0'] }
    subject do
      create(:character,
             lat: starting_location[0],
             lon: starting_location[1],
             current_action: current_action,
             action_details: action_details)
    end

    context 'when the current action is move' do
      let(:current_action) { 'move' }
      let(:action_details) { { target_lat: near_target[0], target_lon: near_target[1] } }

      it 'calls move_towards' do
        expect(subject).to receive(:move_towards).with(near_target).once
        subject.tick(1)
      end

      context 'when the target is within one step' do
        before { subject.tick(1) }

        it 'sets the lat/lon to the target' do
          expect(subject.lat.to_s).to eq(near_target[0])
          expect(subject.lon.to_s).to eq(near_target[1])
        end

        it 'sets current_action to nil' do
          expect(subject.current_action).to eq(nil)
        end

        it 'sets action_details to nil' do
          expect(subject.action_details).to eq(nil)
        end
      end

      context 'when the target is not within one step' do
        let(:action_details) { { target_lat: far_target[0], target_lon: far_target[1] } }

        it 'changes the lat/lon' do
          expect { subject.tick(1) }.to change { subject.lat }
        end

        it 'does not set current_action to nil' do
          subject.tick(1)
          expect(subject.current_action).to_not eq(nil)
        end

        it 'does not set the action_details to nil' do
          subject.tick(1)
          expect(subject.action_details).to_not eq(nil)
        end
      end
    end

    context 'when the current action is search' do
      let(:current_action) { 'search' }
      let(:action_details) { { target_lat: near_target[0], target_lon: near_target[1] } }

      it 'calls move_towards' do
        expect(subject).to receive(:move_towards).with(near_target).once
        subject.tick(1)
      end

      context 'when the target is within one step' do
        it 'calls Search.run' do
          expect(Search).to receive(:run).with(character: subject).once
          subject.tick(1)
        end

        it 'sets current_action to nil' do
          subject.tick(1)
          expect(subject.current_action).to eq(nil)
        end

        it 'sets action_details to nil' do
          subject.tick(1)
          expect(subject.action_details).to eq(nil)
        end
      end

      context 'when the target is not within one step' do
        let(:action_details) { { target_lat: far_target[0], target_lon: far_target[1] } }

        it 'changes the lat/lon' do
          expect { subject.tick(1) }.to change { subject.lat }
        end

        it 'does not call Search.run' do
          expect(Search).to_not receive(:run).with(character: subject)
          subject.tick(1)
        end

        it 'does not set current_action to nil' do
          subject.tick(1)
          expect(subject.current_action).to_not eq(nil)
        end

        it 'does not set the action_details to nil' do
          subject.tick(1)
          expect(subject.action_details).to_not eq(nil)
        end
      end
    end

    context 'when there is no current action' do
      let(:current_action) { nil }
      let(:action_details) { nil }

      context 'and there is a zombie in range' do
        let!(:zombie) { create(:zombie, lat: near_target[0].to_f, lon: near_target[1].to_f) }

        it 'attack is called' do
          expect(subject).to receive(:attack).with(zombie, 1)
          subject.tick(1)
        end
      end
    end
  end
end
