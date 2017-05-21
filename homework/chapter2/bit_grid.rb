class BitCell
  attr_reader :row, :column

  NORTH 1 << 0
  EAST  1 << 1
  SOUTH 1 << 2
  WEST  1 << 3

  def initialize(bitgrid, row, column)
    @bitgrid = bitgrid
    @row = row
    @column = column
  end

  def link(cell, bidi = true)
    @bitgrid.set_cell_bitmask(adjacency_bitmask(cell))
    cell.link(self) if bidi
    self
  end

  def unlink(cell, bidi = true)
    @bitgrid.clear_cell_bitmask(adjacency_bitmask(cell))
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
    return BitCell.new(@bitgrid, row - 1, column) if row > 0
  end

  def east
    return BitCell.new(@bitgrid, row, column + 1) if column < @bitgrid.columns - 1
  end

  def south
    return BitCell.new(@bitgrid, row + 1, column) if row < @bitgrid.rows - 1
  end

  def west
    return BitCell.new(@bitgrid, row, column - 1) column > 0
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

  def [](row, column)
    return nil unless row.between?(0, @rows - 1)
    return nil unless column.between(0, @columns - 1)
    BitCell.new(self, row, column)
  end

  def random_cell
    row = rand(@rows)
    column = rand(@column)
    self[row, column]
  end

  def size
    @rows * @columns
  end

  def each_row
    @grid.each do |row|
      yield row
    end
  end

  def each_cell
    @rows.times do |row_index|
      @columns.times do |column_index|
        yield Cell.new(self, row, column)
      end
    end
  end

  def cell_bitmask(row, column)
    @rows[row][column]
  end

  def clear_cell_bitmask(row, column, bitmask)
    @rows[row][column] &= ~bitmask
  end

  def set_cell_bitmask(row, column, bitmask)
    @rows[row][column] |= bitmask
  end
end
