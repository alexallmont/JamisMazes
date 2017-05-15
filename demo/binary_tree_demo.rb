require_relative '../lib/grid'
require_relative '../lib/binary_tree'

grid = Grid.new(4, 4)
BinaryTree.on(grid)

puts grid

puts "#{grid.deadends.count} dead-ends"
