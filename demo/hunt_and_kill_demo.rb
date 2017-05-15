require_relative '../lib/grid'
require_relative '../lib/hunt_and_kill'

grid = Grid.new(20, 20)
HuntAndKill.on(grid)

filename = 'hunt_and_kill.png'
grid.to_png.save(filename)
puts "saving to #{filename}"

puts "#{grid.deadends.count} dead-ends"
