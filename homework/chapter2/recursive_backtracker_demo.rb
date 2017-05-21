require_relative '../../lib/recursive_backtracker'
require_relative 'bitgrid'

grid = BitGrid.new(20, 20)
RecursiveBacktracker.on(grid)

filename = 'recursive_backtracker.png'
grid.to_png.save(filename)
puts "saved to #{filename}"
