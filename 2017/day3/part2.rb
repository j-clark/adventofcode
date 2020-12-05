def calc(grid, x, y)
  if x == 0 && y == 0
    grid[[x, y]] = 1
  else
    grid[[x, y]] = [
      grid[[x - 1, y - 1]],
      grid[[x - 1, y]],
      grid[[x - 1, y + 1]],
      grid[[x, y - 1]],
      grid[[x, y + 1]],
      grid[[x + 1, y - 1]],
      grid[[x + 1, y]],
      grid[[x + 1, y + 1]],
    ].map(&:to_i).reduce(&:+)
  end
end

def part2(val)
  x = 0
  y = 0
  num_moves = 0
  dirs = %w(r u l d)
  dir = "r"
  grid = { [0, 0] => 1}

  loop do
    num_moves += 1 if dir == "r" || dir == "l"
    num_moves.times do
      case dir
      when "r" then x += 1
      when "l" then x -= 1
      when "u" then y += 1
      when "d" then y -= 1
      end
      calc(grid, x, y)
      return grid[[x, y]] if grid[[x, y]] > val
    end
    dir = dirs[(dirs.index(dir) + 1) % 4]
  end
end

puts "part 2: #{part2(347991)}"
