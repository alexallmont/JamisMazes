require_relative 'grid'
require 'chunky_png'

class ColouredGrid < Grid
  def distances=(distances)
    @distances = distances
    _farthest, @maximum = distances.max
  end

  def background_colour_for(cell)
    return nil if @distances[cell].nil?

    distance = @distances[cell]
    intensity = (@maximum - distance).to_f / @maximum
    dark = (255 * intensity).round
    bright = 128 + (127 * intensity).round
    ChunkyPNG::Color.rgb(dark, bright, dark)
  end
end
