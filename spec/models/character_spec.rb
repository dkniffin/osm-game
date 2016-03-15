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

  describe '#take_damage' do
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
end
