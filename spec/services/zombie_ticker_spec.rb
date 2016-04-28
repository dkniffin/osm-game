require 'rails_helper'

describe ZombieTicker, type: :service do
  let!(:character) { create(:character) }
  let!(:zombie) { create(:zombie) }

  subject { ZombieTicker.run!(subject: zombie, tick_count: 1) }

  context "when there's a character within attack range" do
    let!(:character) do
      create(:character, lat: zombie.lat + 0.0000001, lon: zombie.lon + 0.0000001)
    end
    it 'attacks' do
      expect(zombie).to receive(:attack).with(character, 1)
      subject
    end
  end

  context "when there's a character within aggro range" do
    let!(:character) do
      create(:character, lat: zombie.lat + 0.0001, lon: zombie.lon + 0.0001)
    end
    it 'moves towards the character' do
      expect(zombie).to receive(:move_towards).with([character.lat, character.lon]).once
      subject
    end
  end

  context "when the zombies's health drops to zero" do
    let!(:zombie) { create(:zombie, health: 0) }

    it "destroys the zombie" do
      expect(zombie).to receive(:destroy)
      subject
    end
  end
end
