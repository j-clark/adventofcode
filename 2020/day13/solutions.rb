require "set"

input = File.read(File.join(File.dirname(__FILE__), "input.txt"))
timestamp = input.lines.first.to_i
buses = input.lines.last.split(",")

part1 = buses
  .reject { |b| b == "x" }
  .map(&:to_i)
  .map { |b| [b, ((timestamp / b.to_f).ceil * b) - timestamp] }
  .min_by(&:last)

puts "part 1: #{part1.reduce(&:*)}"

buses_with_indexes = buses
  .map.with_index { |bus, index| [bus.to_i, index] }
  .filter { |b, _| b > 0 }

inc = 1
curr = 1
buses_with_indexes.each do |bus, index|
  curr += inc until (curr + index) % bus == 0
  inc *= bus
end

puts "part 2: #{curr}"
