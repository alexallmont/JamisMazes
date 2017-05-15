require_relative '../lib/grid'
require_relative '../lib/sidewinder'

grid = Grid.new(4, 4)
Sidewinder.on(grid)

img = grid.to_png
img.save 'maze.png'
puts 'saved to maze.png'

puts "#{grid.deadends.count} dead-ends"
