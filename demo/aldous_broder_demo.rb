require_relative '../lib/grid'
require_relative '../lib/aldous_broder'

grid = Grid.new(20, 20)
AldousBroder.on(grid)

filename = 'aldous_broder.png'
grid.to_png.save(filename)
puts "saved to #{filename}"

puts "#{grid.deadends.count} dead-ends"