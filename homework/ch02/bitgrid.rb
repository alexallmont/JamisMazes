# A possible solution to the challenge in chapter 2 for storing cells
# in a bitmask. Rather than the most optimal case of a custom grid and
# maze generator, I am instead creating a duck-typed Cell variant called
# BitCell. This is an adaptor class that stores its owning grid and its
# row and column index. The computation of links and neighbours is done
# by referring to the 2D integer array in BitGrid. This is sub-optimal
# but allows the system to plug in to existing maze generators.
require_relative 'bitcell'
require 'chunky_png'

class BitGrid
  attr_reader :rows, :columns

  DEBUG_LINKS = false

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

  def each_cell
    @rows.times do |row|
      @columns.times do |column|
        yield BitCell.new(self, row, column)
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

  def contents_of(cell)
    if DEBUG_LINKS
      cell.bitmask.to_s(16)
    else
      ' '
    end
  end

  def background_colour_for(_cell)
    nil
  end

  def to_s
    output = "+#{'---+' * columns}\n"

    @rows.times do |row|
      top = '|'
      bottom = '+'

      @columns.times do |column|
        cell = BitCell.new(self, row, column)

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
