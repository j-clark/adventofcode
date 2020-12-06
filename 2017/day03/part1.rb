val = 347991
x = 0
y = 0
num_moves = 0
dirs = %w(r u l d)
dir = "r"

until val <= 0
  case dir
  when "r"
    num_moves += 1
    x += [num_moves, val].min
  when "l"
    num_moves += 1
    x -= [num_moves, val].min
  when "u"
    y += [num_moves, val].min
  when "d"
    y -= [num_moves, val].min
  end
  val -= num_moves
  dir = dirs[(dirs.index(dir) + 1) % 4]
end

part1 = x.abs + y.abs - 1
puts x, y
puts "part 1: #{part1}"
