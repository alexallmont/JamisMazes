class BitCell
  attr_reader :row, :column

  NORTH 1 << 0
  EAST  1 << 1
  SOUTH 1 << 2
  WEST  1 << 3

  def initialize(bit_grid, row, column)
    @bit_grid = bit_grid
    @row = row
    @column = column
    @bitmask = 0
  end

  def link(cell, bidi = true)
    @bitmask |= adjacency_bitmask(cell)
    cell.link(self) if bidi
    self
  end

  def unlink(cell, bidi = true)
    @bitmask &= ~adjacency_bitmask(cell)
    cell.unlink(self) if bidi
    self
  end

  # Returns the adjacency
  def adjacency_bitmask(cell)
    if cell.column == column
      if cell.row = row - 1
        return NORTH
      elsif cell.row = row + 1
        return SOUTH
      end
    elsif cell.row == row
      if cell.column = column - 1
        return WEST
      elsif cell.column = column + 1
        return EAST
      end
    end
    return 0
  end

  def north
    return BitCell.new(@bit_grid, row - 1, column) if row > 0
  end

  def east
    return BitCell.new(@bit_grid, row, column + 1) if column < @bit_grid.columns - 1
  end

  def south
    return BitCell.new(@bit_grid, row + 1, column) if row < @bit_grid.rows - 1
  end

  def west
    return BitCell.new(@bit_grid, row, column - 1) column > 0
  end

  def to_i
    @bitmask
  end

end

class BitGrid
  attr_reader :rows, :columns

  def initialize(rows, columns)
    @rows = rows
    @columns = columns

    @grid = Array.new(rows) do |row|
      Array.new(columns) do |column|
        0
      end
    end
  end
end
