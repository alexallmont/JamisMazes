# A cell adaptor class used in BitGrid.
class BitCell
  attr_reader :row, :column

  NORTH = 1 << 0
  EAST  = 1 << 1
  SOUTH = 1 << 2
  WEST  = 1 << 3

  def initialize(bitgrid, row, column)
    @bitgrid = bitgrid
    @row = row
    @column = column
  end

  def link(cell, bidi = true)
    @bitgrid.set_cell_bitmask(@row, @column, adjacency_bitmask(cell))
    cell.link(self, false) if bidi
    self
  end

  def unlink(cell, bidi = true)
    @bitgrid.clear_cell_bitmask(@row, @column, adjacency_bitmask(cell))
    cell.unlink(self, false) if bidi
    self
  end

  def linked?(cell)
    return false if cell.nil?
    (adjacency_bitmask(cell) & bitmask) != 0
  end

  def bitmask
    @bitgrid.cell_bitmask(@row, @column)
  end

  # Return the bitmask that would link to the passed cell
  def adjacency_bitmask(cell)
    if cell.column == column
      if cell.row == row - 1
        return NORTH
      elsif cell.row == row + 1
        return SOUTH
      end
    elsif cell.row == row
      if cell.column == column - 1
        return WEST
      elsif cell.column == column + 1
        return EAST
      end
    end
    return 0
  end

  def north
    return BitCell.new(@bitgrid, row - 1, column) if row > 0
  end

  def east
    return BitCell.new(@bitgrid, row, column + 1) if column < @bitgrid.columns - 1
  end

  def south
    return BitCell.new(@bitgrid, row + 1, column) if row < @bitgrid.rows - 1
  end

  def west
    return BitCell.new(@bitgrid, row, column - 1) if column > 0
  end

  def neighbours
    list = [north, east, south, west]
    list.delete_if { |cell| cell.nil? }
  end

  def links
    list = []
    bm = bitmask
    list << north if (bm & NORTH) != 0
    list << east if (bm & EAST) != 0
    list << south if (bm & SOUTH) != 0
    list << west if (bm & WEST) != 0
    list.delete_if { |cell| cell.nil? }
  end
end
