require 'rails_helper'

describe CharacterTicker, type: :service do
  let(:character_params) { {} }
  let!(:character) do
    create(:character, character_params)
  end

  let(:tick_count) { 1 }
  subject { CharacterTicker.run!(subject: character, tick_count: tick_count) }

  describe 'action handling' do
    let(:starting_location) { [35.0, -105.0] }
    let(:current_action) { nil }
    let(:action_details) { nil }
    let(:near_target) { ['34.999999', '-105.0'] }
    let(:far_target) { ['34.0', '-105.0'] }

    let(:character_params) do
      {
        lat: starting_location[0],
        lon: starting_location[1],
        current_action: current_action,
        action_details: action_details
      }
    end

    context 'when the current action is move' do
      let(:current_action) { 'move' }
      let(:action_details) { { target_lat: near_target[0], target_lon: near_target[1] } }

      it 'calls move_towards' do
        expect(character).to receive(:move_towards).with(near_target).once
        subject
      end

      context 'when the target is within one step' do
        before { subject }

        it 'sets the lat/lon to the target' do
          expect(character.lat.to_s).to eq(near_target[0])
          expect(character.lon.to_s).to eq(near_target[1])
        end

        it 'sets current_action to nil' do
          expect(character.current_action).to eq(nil)
        end

        it 'sets action_details to nil' do
          expect(character.action_details).to eq(nil)
        end
      end

      context 'when the target is not within one step' do
        let(:action_details) { { target_lat: far_target[0], target_lon: far_target[1] } }

        it 'changes the lat/lon' do
          expect { subject }.to change { character.lat }
        end

        it 'does not set current_action to nil' do
          subject
          expect(character.current_action).to_not eq(nil)
        end

        it 'does not set the action_details to nil' do
          subject
          expect(character.action_details).to_not eq(nil)
        end
      end
    end

    context 'when the current action is search' do
      let(:current_action) { 'search' }
      let(:action_details) { { target_lat: near_target[0], target_lon: near_target[1] } }

      it 'calls move_towards' do
        expect(character).to receive(:move_towards).with(near_target).once
        subject
      end

      context 'when the target is within one step' do
        it 'calls Search.run' do
          expect(Search).to receive(:run).with(character: character).once
          subject
        end

        it 'sets current_action to nil' do
          subject
          expect(character.current_action).to eq(nil)
        end

        it 'sets action_details to nil' do
          subject
          expect(character.action_details).to eq(nil)
        end
      end

      context 'when the target is not within one step' do
        let(:action_details) { { target_lat: far_target[0], target_lon: far_target[1] } }

        it 'changes the lat/lon' do
          expect { subject }.to change { character.lat }
        end

        it 'does not call Search.run' do
          expect(Search).to_not receive(:run).with(character: character)
          subject
        end

        it 'does not set current_action to nil' do
          subject
          expect(character.current_action).to_not eq(nil)
        end

        it 'does not set the action_details to nil' do
          subject
          expect(character.action_details).to_not eq(nil)
        end
      end
    end

    context 'when there is no current action' do
      let(:current_action) { nil }
      let(:action_details) { nil }

      context 'and there is a zombie in range' do
        let!(:zombie) { create(:zombie, lat: near_target[0].to_f, lon: near_target[1].to_f) }

        it 'attack is called' do
          expect(character).to receive(:attack).with(zombie, 1)
          subject
        end
      end
    end
  end

  describe 'hunger and thirst' do
    let(:character_params) { { food: 100, water: 100 } }
    context 'every 50 ticks' do
      let(:tick_count) { 50 }

      it 'decrements food' do
        expect { subject }.to change { character.food }.by(-1)
      end

      context "if the character's food is at 0" do
        let(:character_params) { { food: 0 } }
        it "doesn't drop below zero" do
          expect { subject }.to_not change { character.food }
        end

        it 'decrements health by 5' do
          expect { subject }.to change { character.health }.by(-5)
        end
      end
    end
  end
end
