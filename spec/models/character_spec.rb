require 'rails_helper'

RSpec.describe Character, type: :model do
  subject { create(:character) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:lat) }
  it { is_expected.to respond_to(:lon) }
  it { is_expected.to respond_to(:player) }
  it { is_expected.to respond_to(:stats) }

  context 'when name is empty' do
    subject { build(:character, name: nil) }

    it 'is invalid' do
      expect(subject).to be_invalid
    end
  end
end
