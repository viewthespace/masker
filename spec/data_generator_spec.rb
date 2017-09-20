require 'spec_helper'

describe ::DataGenerator do
  context 'with known type' do
    before do
      allow(Faker::Name).to receive(:name).and_return('Morty Sanchez')
    end

    it 'returns a fake value' do
      expect(described_class.generate(:name)).to eq 'Morty Sanchez'
    end
  end

  context 'with unknown type' do
    it 'returns the passed in value' do
      expect(described_class.generate('')).to eq ''
    end
  end
end
