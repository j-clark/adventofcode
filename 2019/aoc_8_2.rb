input_text = File.read(File.join(File.dirname(__FILE__), "aoc_8_input.txt")).strip

WIDTH = 25
HEIGHT = 6

data = input_text.split("").map(&:to_i)
layers = data.each_slice(HEIGHT * WIDTH)
img = Array.new(HEIGHT * WIDTH)

layers.each do |layer|
  layer.each_slice(WIDTH).each_with_index do |row, row_index|
    row.each_with_index do |cell, cell_index|
      img[WIDTH * row_index + cell_index] ||= cell if [0, 1].include?(cell)
    end
  end
end

img = img.map do |cell|
  case cell
  when 0 then " "
  when 1 then "█"
  when nil then "."
  end
end

puts img.each_slice(WIDTH).map { |a| a.join("") }.join("\n")
