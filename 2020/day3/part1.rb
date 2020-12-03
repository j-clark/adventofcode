require_relative "./count_trees.rb"

input = File.read(File.join(File.dirname(__FILE__), "input.txt"))

puts count_trees(
  map: input.lines.map { |l| l.chomp.split("") },
  right: 3,
  down: 1
)
