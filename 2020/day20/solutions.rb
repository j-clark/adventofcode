input = File.read(File.join(File.dirname(__FILE__), "input.txt"))

def parse(input)
  tiles = input.split(/^$/).map(&:strip).each_with_object({}) do |raw_tile, hash|
    tile_number = raw_tile.lines.first.match(/\d+/)[0].to_i
    hash[tile_number] = raw_tile.lines[1..-1].map do |line|
      line.strip.split("")
    end
  end

  matches = Hash.new { |h, k| h[k] = {} }

  tiles.keys.each do |number_i|
    tile_i = tiles[number_i]
    top    = (0..9).to_a.map { |k| tile_i[0][k] }
    right  = (0..9).to_a.map { |k| tile_i[k][9] }
    bottom = (0..9).to_a.map { |k| tile_i[9][k] }
    left   = (0..9).to_a.map { |k| tile_i[k][0] }

    tiles.keys.each do |number_j|
      next if number_j == number_i
      tile_j = tiles[number_j]
      j_sides = [
        (0..9).to_a.map { |k| tile_j[0][k] },
        (0..9).to_a.map { |k| tile_j[0][k] }.reverse,
        (0..9).to_a.map { |k| tile_j[k][9] },
        (0..9).to_a.map { |k| tile_j[k][9] }.reverse,
        (0..9).to_a.map { |k| tile_j[9][k] },
        (0..9).to_a.map { |k| tile_j[9][k] }.reverse,
        (0..9).to_a.map { |k| tile_j[k][0] },
        (0..9).to_a.map { |k| tile_j[k][0] }.reverse
      ]
      j_sides.each do |j_side|
        matches[number_i][:t] = number_j if j_side == top
        matches[number_i][:r] = number_j if j_side == right
        matches[number_i][:b] = number_j if j_side == bottom
        matches[number_i][:l] = number_j if j_side == left
      end
    end
  end
  [tiles, matches]
end

def transpose(tile:, tiles:, matches:)
  tiles[tile] = tiles[tile].transpose
  old_t = matches[tile][:t]
  old_r = matches[tile][:r]
  old_b = matches[tile][:b]
  old_l = matches[tile][:l]
  matches[tile][:l] = old_t
  matches[tile][:t] = old_l
  matches[tile][:b] = old_r
  matches[tile][:r] = old_b
end

def flip_horizontal_axis(tile:, tiles:, matches:)
  (0..4).each do |i|
    tmp = tiles[tile][i]
    tiles[tile][i] = tiles[tile][9 - i]
    tiles[tile][9 - i] = tmp
  end
  tmp = matches[tile][:b]
  matches[tile][:b] = matches[tile][:t]
  matches[tile][:t] = tmp
end

def flip_vertical_axis(tile:, tiles:, matches:)
  (0..9).each do |i|
    (0..4).each do |j|
      tmp = tiles[tile][i][j]
      tiles[tile][i][j] = tiles[tile][i][9 - j]
      tiles[tile][i][9 - j] = tmp
    end
  end
  tmp = matches[tile][:l]
  matches[tile][:l] = matches[tile][:r]
  matches[tile][:r] = tmp
end

def rotate_clockwise(tile:, tiles:, matches:)
  transpose(tile: tile, tiles: tiles, matches: matches)
  flip_vertical_axis(tile: tile, tiles: tiles, matches: matches)
end

def rotate_counter_clockwise(tile:, tiles:, matches:)
  transpose(tile: tile, tiles: tiles, matches: matches)
  flip_horizontal_axis(tile: tile, tiles: tiles, matches: matches)
end

def rotate(tile:, to_tile:, matches:, tiles:)
  if matches[to_tile][:r] == tile
    if matches[tile][:r] == to_tile
      flip_vertical_axis(tile: tile, tiles: tiles, matches: matches)
    elsif matches[tile][:b] == to_tile
      rotate_clockwise(tile: tile, tiles: tiles, matches: matches)
    elsif matches[tile][:t] == to_tile
      rotate_counter_clockwise(tile: tile, tiles: tiles, matches: matches)
    end
    return if (0..9).all? { |i| tiles[to_tile][i][9] == tiles[tile][i][0] }
    flip_horizontal_axis(tile: tile, tiles: tiles, matches: matches)
  elsif matches[to_tile][:b] == tile
    if matches[tile][:b] == to_tile
      flip_horizontal_axis(tile: tile, tiles: tiles, matches: matches)
    elsif matches[tile][:r] == to_tile
      rotate_counter_clockwise(tile: tile, tiles: tiles, matches: matches)
    elsif matches[tile][:l] == to_tile
      rotate_clockwise(tile: tile, tiles: tiles, matches: matches)
    end
    return if (0..9).all? { |i| tiles[to_tile][9][i] == tiles[tile][0][i] }
    flip_vertical_axis(tile: tile, tiles: tiles, matches: matches)
  else
    raise "bad"
  end
end

def count_monsters(img)
  body_1_offsets = [0, 5, 6, 11, 12, 17, 18, 19]
  body_2_offsets = [1, 4, 7, 10, 13, 16]
  i = 0
  num_monsters = 0
  while i <= img.length - 2
    possible_heads = (18..(img.first.length - 1)).to_a.select { |j| img[i][j] == "#" }
    heads = possible_heads.count do |h|
      body_1_offsets.all? { |b| img[i + 1][b + (h - 18)] == "#" } &&
        body_2_offsets.all? { |b| img[i + 2][b + (h - 18)] == "#" }
    end

    num_monsters += heads
    i += 1
  end
  num_monsters
end

tiles, matches = parse(input)

corners = matches
  .select { |number, match| match.values.length == 2 }
  .map(&:first)

puts "part 1: #{corners.reduce(&:*)}"

top_left = corners[1]
numbers = tiles.keys
numbers.delete(top_left)

if matches[top_left][:b].nil?
  flip_horizontal_axis(tile: top_left, tiles: tiles, matches: matches)
end
if matches[top_left][:r].nil?
  flip_vertical_axis(tile: top_left, tiles: tiles, matches: matches)
end

stitched = [[top_left]]
until numbers.empty?
  curr = nil
  prev = stitched.last.last
  if matches[prev][:r]
    curr = matches[prev][:r]
  else
    stitched.push([])
    prev = stitched[-2].first
    curr = matches[prev][:b]
  end
  rotate(tile: curr, to_tile: prev, matches: matches, tiles: tiles)
  stitched.last.push(curr)
  numbers.delete(curr)
end

img = []
stitched.each do |tile_row|
  (1..8).each do |i|
    img.push([])
    tile_row.each do |tile|
      img.last.concat(tiles[tile][i][1..8])
    end
  end
end

def flip_vertical(img)
  width = img.first.length - 1
  (0..(img.length - 1)).each do |i|
    (0..(width / 2).floor).each do |j|
      tmp = img[i][j]
      img[i][j] = img[i][width - j]
      img[i][width - j] = tmp
    end
  end
end

num_monsters = count_monsters(img)
rotations = 0
until num_monsters > 0 || rotations == 3
  img = img.transpose
  flip_vertical(img)
  num_monsters = count_monsters(img)
  rotations += 1
end

if num_monsters == 0
  img = img.transpose
  flip_vertical(img)
  flip_vertical(img)

  num_monsters = count_monsters(img)
  rotations = 0
  until num_monsters > 0 || rotations == 3
    img = img.transpose
    flip_vertical(img)
    num_monsters = count_monsters(img)
    rotations += 1
  end
end

monster_cells = num_monsters * 15
puts "part 2: #{img.flatten.count("#") - monster_cells}"
