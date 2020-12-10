require "set"

groups = File.read(File.join(File.dirname(__FILE__), "input.txt"))
  .split(/^$/)
  .map do |g|
    g.strip.lines.map(&:strip).map { |l| l.split("") }
  end

part1 = groups.map do |group|
  group
    .flatten
    .uniq
    .count
end.reduce(&:+)

part2 = groups.map do |group|
  group
    .map(&:to_set)
    .reduce(&:&)
    .count
end.reduce(&:+)

puts "part 1: #{part1}"
puts "part 2: #{part2}"
