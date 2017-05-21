require_relative '../../lib/recursive_backtracker'
require_relative 'bitgrid'

grid = BitGrid.new(10 ,10)
RecursiveBacktracker.on(grid)

filename = 'recursive_backtracker.png'
puts(grid)
