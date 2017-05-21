require 'chunky_png'

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
    return 0 if cell.nil?
    (adjacency_bitmask(cell) & bitmask) != 0
  end

  def bitmask
    @bitgrid.cell_bitmask(@row, @column)
  end

  # Returns the adjacency
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
    list.delete_if { |n| n.nil? }
    list
  end

  def links
    list = [north, east, south, west]
    list.delete_if { |n| n.nil? or n.bitmask == 0 }
    list
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
    return nil unless column.between?(0, @columns - 1)
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
    @rows.times do |row_i|
      @columns.times do |col_i|
        yield BitCell.new(self, row_i, col_i)
      end
    end
  end

  def cell_bitmask(row, column)
    @grid[row][column]
  end

  def clear_cell_bitmask(row, column, bitmask)
    @grid[row][column] &= ~bitmask
  end

  def set_cell_bitmask(row, column, bitmask)
    @grid[row][column] |= bitmask
  end

  def contents_of(_cell)
    ' '
  end

  def background_colour_for(_cell)
    nil
  end

  def to_s
    output = "+#{'---+' * columns}\n"

    @rows.times do |row_i|
      top = '|'
      bottom = '+'

      @columns.time do |col_i|
        cell = BitCell.new(self, row_i, col_i)

        body = " #{contents_of(cell)} "
        east_boundary = cell.linked?(cell.east) ? ' ' : '|'
        top << body << east_boundary

        south_boundary = cell.linked?(cell.south) ? '   ' : '---'
        corner = '+'
        bottom << south_boundary << corner
      end

      output << top << "\n"
      output << bottom << "\n"
    end

    output
  end

  def to_png(cell_size: 10)
    width = cell_size * columns
    height = cell_size * rows

    background = ChunkyPNG::Color::WHITE
    wall = ChunkyPNG::Color::BLACK

    img = ChunkyPNG::Image.new(width + 1, height + 1, background)

    [:backgrounds, :walls].each do |mode|
      each_cell do |cell|
        x1 = cell.column * cell_size
        y1 = cell.row * cell_size
        x2 = x1 + cell_size
        y2 = y1 + cell_size

        if mode == :backgrounds
          colour = background_colour_for(cell)
          img.rect(x1, y1, x2, y2, colour, colour) if colour
        else
          img.line(x1, y1, x2, y1, wall) unless cell.north
          img.line(x1, y1, x1, y2, wall) unless cell.west
          img.line(x2, y1, x2, y2, wall) unless cell.linked?(cell.east)
          img.line(x1, y2, x2, y2, wall) unless cell.linked?(cell.south)
        end
      end
    end

    img
  end

  def deadends
    list = []

    each_cell do |cell|
      list << cell if cell.links.count == 1
    end

    list
  end
end
