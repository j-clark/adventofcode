require "set"

input = File.read(File.join(File.dirname(__FILE__), "input.txt")).lines.map(&:strip)

def find_seat(str)
  row_lower = 0
  row_upper = 127
  col_lower = 0
  col_upper = 7

  str.each_char do |ch|
    case ch
    when "F" then row_upper = ((row_upper + row_lower) / 2.0).floor
    when "B" then row_lower = ((row_upper + row_lower) / 2.0).round
    when "L" then col_upper = ((col_upper + col_lower) / 2.0).floor
    when "R" then col_lower = ((col_upper + col_lower) / 2.0).round
    end
  end

  (8 * row_lower) + col_lower
end

seats = input.map { |l| find_seat(l) }

part1 = seats.max

part2 = seats
  .sort
  .each_cons(2)
  .find { |a, b| a + 2 == b }
  .first + 1


puts "part 1: #{part1}"
puts "part 2: #{part2}"
