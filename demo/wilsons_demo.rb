require_relative '../lib/grid'
require_relative '../lib/wilsons'

grid = Grid.new(20, 20)
Wilsons.on(grid)

filename = 'wilsons.png'

grid.to_png.save(filename)
puts "saved to #{filename}"

puts "#{grid.deadends.count} dead-ends"
