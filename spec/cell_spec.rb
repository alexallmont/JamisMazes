require_relative 'spec_helper'

describe Cell do

  before :each do
  end

  describe '#new' do
    it 'returns a new Cell object' do
      c = Cell.new(0, 0)
      expect(c).to be_an_instance_of(Cell)
    end

    it 'should initialise empty' do
      c = Cell.new(0, 1)
      expect(c.row).to eq(0)
      expect(c.column).to eq(1)
      expect(c.north).to eq(nil)
      expect(c.east).to eq(nil)
      expect(c.south).to eq(nil)
      expect(c.west).to eq(nil)
      expect(c.links).to eq([])
    end
  end
end
