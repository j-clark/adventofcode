input_text = File.read(File.join(File.dirname(__FILE__), "aoc_8_input.txt")).strip

WIDTH = 25
HEIGHT = 6

data = input_text.split("").map(&:to_i)
layers = data.each_slice(HEIGHT * WIDTH)
layer = layers.min_by { |layer| layer.count { |a| a == 0 } }
puts layer.count { |a| a == 1 } * layer.count { |a| a == 2 }
