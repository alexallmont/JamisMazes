require_relative '../lib/distance_grid'
require_relative '../lib/binary_tree'

grid = DistanceGrid.new(5, 5)
BinaryTree.on(grid)

start = grid[0, 0]
distances = start.distances

grid.distances = distances
puts grid

puts 'path from northwest corner to southwest corner:'
grid.distances = distances.path_to(grid[grid.rows - 1, 0])
puts grid
