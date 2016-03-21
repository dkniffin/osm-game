require 'rails_helper'

RSpec.describe Zombie, type: :model do
  it { is_expected.to respond_to(:lat) }
  it { is_expected.to respond_to(:lon) }
  it { is_expected.to respond_to(:health) }
end
