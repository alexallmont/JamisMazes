require_relative 'spec_helper'

describe Cell do

  before :each do
  end

  describe '#new' do
    it 'returns a new Cell object' do
      c = Cell.new(0, 0)
      c.should be_an_instance_of Cell
    end

    it 'should initialise empty' do
      c = Cell.new(0, 1)
      c.row.should == 0
      c.column.should == 1
      c.north.should == nil
      c.east.should == nil
      c.south.should == nil
      c.west.should == nil
      c.links.should == []
    end
  end
end
