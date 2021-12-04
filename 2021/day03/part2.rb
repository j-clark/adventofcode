numbers = File.read(File.join(File.dirname(__FILE__), "input.txt")).strip.lines.map(&:strip)

pass = 0
while numbers.length > 1 do
  ones = numbers.count { |n| n[pass] == "1" }
  target = ones >= (numbers.length / 2.0) ? "1" : "0"

  numbers.filter! do |number|
    number[pass] == target
  end

  pass += 1
end
p numbers
oxygen_generator_rating = numbers.join.to_i(2)

numbers = File.read(File.join(File.dirname(__FILE__), "input.txt")).strip.lines.map(&:strip)
pass = 0
while numbers.length > 1 do
  ones = numbers.count { |n| n[pass] == "1" }
  target = ones >= (numbers.length / 2.0) ? "0" : "1"

  numbers.filter! do |number|
    number[pass] == target
  end

  pass += 1
end
p numbers
co2_scrubber_rating = numbers.join.to_i(2)

p oxygen_generator_rating * co2_scrubber_rating
