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

  def north=(bit_cell)
    raise 'invalid north cell' unless bit_cell.is_north_of?(self)
    if @row > 0
      @bitmask |= NORTH
    else
      @bitmask &= ^NORTH
    end
  end

  def is_north_of?(bit_cell)
    return (bit_cell.row - 1 == row) && (bit_cell.column == column)
  end

  def is_east_of?(bit_cell)
    return (bit_cell.row == row) && (bit_cell.column + 1 == column)
  end

  def is_south_of?(bit_cell)
    return (bit_cell.row + 1 == row) && (bit_cell.column == column)
  end

  def is_west_of?(bit_cell)
    return (bit_cell.row == row) && (bit_cell.column - 1 == column)
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

