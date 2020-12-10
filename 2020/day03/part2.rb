require_relative "./count_trees.rb"

input = File.read(File.join(File.dirname(__FILE__), "input.txt"))
map = input.lines.map { |l| l.chomp.split("") }

slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]

puts slopes
  .map { |right, down| count_trees(map: map, right: right, down: down) }
  .reduce(&:*)
