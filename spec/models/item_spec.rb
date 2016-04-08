require 'rails_helper'

describe Item, type: :model do
  subject { create(:item) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:category) }
  it { is_expected.to respond_to(:stats) }
  it { is_expected.to respond_to(:equippable?) }
  it { is_expected.to respond_to(:currently_equipped?) }
  it { is_expected.to belong_to(:character) }

  describe '.weapon' do
    subject { Item.weapon }
    let!(:weapons) { create_list(:item, 3, category: 'weapon') }
    let!(:non_weapons) { create_list(:item, 3, category: 'non_weapon') }

    it 'returns items with a category of weapon' do
      expect(subject).to eq(weapons)
    end
  end

  describe '.equipped' do
    subject { Item.equipped }
    let!(:equipped) { create_list(:item, 3, currently_equipped: true) }
    let!(:not_equipped) { create_list(:item, 3, currently_equipped: false) }

    it 'returns items that are currently equipped' do
      expect(subject).to eq(equipped)
    end
  end
end
