#!/usr/bin/ruby
$LOAD_PATH.unshift '../../book/ch02'

require 'grid'
require 'sidewinder'
require 'io/console'

class Player
  attr_reader :row, :column
  attr_reader :dir

  def initialize(grid, row, column)
    @row = row
    @column = column
    @grid = grid
    @dir = :north
  end

  def compass_points
    [:north, :east, :south, :west]
  end

  def dir_to_index(dir)
    compass_points.index(dir)
  end

  def index_to_dir(index)
    compass_points[index]
  end

  def dir_to_cell(dir)
    index_to_cell(dir_to_index(dir))
  end

  def index_to_cell(index)
    drow = [-1, 0, 1, 0]
    dcol = [0, 1, 0, -1]
    @grid[row + drow[index], column + dcol[index]]
  end

  def current_cell
    @grid[row, column]
  end

  def turned_dir(delta)
    idir = dir_to_index(dir)
    idir += delta
    idir %= 4
    index_to_dir(idir)
  end

  def turn_left
    @dir = turned_dir(-1)
  end

  def turn_right
    @dir = turned_dir(1)
  end

  def forward_wall?
    !current_cell.linked?(dir_to_cell(turned_dir(0)))
  end

  def left_wall?
    !current_cell.linked?(dir_to_cell(turned_dir(-1)))
  end

  def right_wall?
    !current_cell.linked?(dir_to_cell(turned_dir(1)))
  end

  def move_forward
    return false if forward_wall?
    cell = dir_to_cell(@dir)
    @row = cell.row
    @column = cell.column
  end
end

def describe(is_wall)
  if is_wall
    'a wall'
  else
    'an open space'
  end
end

grid = Grid.new(6, 6)
Sidewinder.on(grid)
player = Player.new(grid, 3, 0)

loop do
  puts
  puts 'Press A D to turn left or right, or W to move forward. Q quits'
  puts "  You are facing #{player.dir}"
  puts "  In front of you is #{describe(player.forward_wall?)}"
  puts "  To your left is #{describe(player.left_wall?)}"
  puts "  To your right is #{describe(player.right_wall?)}"

  print '> '
  chr = STDIN.getch.upcase
  puts chr

  case chr
  when 'A'
    player.turn_left
    puts 'You turn left'
  when 'D'
    player.turn_right
    puts 'You turn right'
  when 'W'
    if !player.move_forward
      puts 'Cannot move forward'
    end
  when 'Q'
    exit!
  else
    puts "Invalid move"
  end
end
