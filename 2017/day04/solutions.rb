require "set"

passphrases = File.read(File.join(File.dirname(__FILE__), "input.txt")).lines.map(&:strip)

part1 = passphrases.map(&:split).count { |p| p.length == p.to_set.length }

puts "part 1: #{part1}"

part2 = passphrases.map do |passphrase|
  passphrase.split.map { |word| word.chars.sort }
end.count { |p| p.length == p.to_set.length }

puts "part 2: #{part2}"
