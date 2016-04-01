require 'rails_helper'

describe Item, type: :model do
  subject { create(:item) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:category) }
  it { is_expected.to respond_to(:stats) }
  it { is_expected.to belong_to(:character) }
end
