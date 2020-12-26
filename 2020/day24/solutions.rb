require "pp"
input = File.read(File.join(File.dirname(__FILE__), "input.txt"))

OFFSETS = {
  w: [0, -1],
  e: [0, 1],
  nw: [-1, -1],
  ne: [-1, 0],
  sw: [1, 0],
  se: [1, 1]
}
WHITE = 0
BLACK = 1
WHITE_NEXT = 2
BLACK_NEXT = 3

paths = input.lines.map(&:strip).map do |line|
  len = line.length
  i = 0

  dirs = []
  while i < len
    if line[i..-1] =~ /^[we]/
      dirs.push(line[i].to_sym)
      i += 1
    else
      dirs.push(line[i..(i+1)].to_sym)
      i += 2
    end
  end
  dirs
end

grid = {}

paths.each do |path|
  x = 0
  y = 0
  path.each do |dir|
    x_offset, y_offset = OFFSETS[dir]
    x += x_offset
    y += y_offset
  end
  grid[[x,y]] = grid[[x,y]] == BLACK ? WHITE : BLACK
end
puts "part 1: #{grid.values.count(BLACK)}"

def neighbors(x, y)
  OFFSETS.values.map do |(x_offset, y_offset)|
    [x + x_offset, y + y_offset]
  end
end

def black?(val)
  [BLACK, WHITE_NEXT].include?(val)
end

def iterate(grid)
  coords = (grid.keys + grid.keys.flat_map { |x, y| neighbors(x, y) }).uniq

  coords.each do |(x, y)|
    black_nabe_count = neighbors(x, y).map { |coord| grid[coord] }.count(&method(:black?))
    if black?(grid[[x, y]]) && (black_nabe_count == 0 || black_nabe_count > 2)
      grid[[x, y]] = WHITE_NEXT
    elsif !black?(grid[[x, y]]) && black_nabe_count == 2
      grid[[x, y]] = BLACK_NEXT
    end
  end

  coords.each do |coord|
    if grid[coord] == BLACK_NEXT
      grid[coord] = BLACK
    elsif grid[coord] == WHITE_NEXT
      grid[coord] = WHITE
    end
  end
end

100.times { |i| iterate(grid) }
puts "part 2: #{grid.values.count(BLACK)}"
