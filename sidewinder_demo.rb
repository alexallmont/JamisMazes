require_relative 'grid'
require_relative 'sidewinder'

grid = Grid.new(4, 4)
Sidewinder.on(grid)

img = grid.to_png
img.save 'maze.png'

puts "#{grid.deadends.count} dead-ends"
