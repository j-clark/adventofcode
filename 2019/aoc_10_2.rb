map = File.read(File.join(File.dirname(__FILE__), "aoc_10_input.txt")).split("\n").map { |row| row.split("") }.transpose

def slope_for(point1, point2)
  return nil if point1.first == point2.first

  (point2.last - point1.last).to_f / (point2.first - point1.first).to_f
end

def angle(base, asteroid)
  a = Math.atan2(asteroid.first - base.first, asteroid.last - base.last) * 180 / Math::PI
  (a - 180).abs
end

def asteroids_between(map, point1, point2)
  points = points_between(point1, point2)
  points.select { |point| map[point[0]][point[1]] == "#" }.count
end

def points_between(point1, point2)
  slope = slope_for(point1, point2)
  if slope.nil?
    if point1.last < point2.last
      return (point1.last..point2.last).to_a[1..-2].map { |y| [point1.first, y] }
    else
      return (point2.last..point1.last).to_a[1..-2].map { |y| [point1.first, y] }
    end
  else
    ltr = point1.first < point2.first
    points = []
    point = point1
    # p [point1, point2, slope]
    loop do
      x = ltr ? point.first + 1 : point.first - 1
      y = ltr ? point.last + slope : point.last - slope

      point = [x, y]
      valid_point = ((x - x.round).abs < 0.00000001) && ((y - y.round).abs < 0.00000001)
      point = point.map(&:round) if valid_point
      # p point

      return points if point == point2

      points.push(point) if valid_point
    end
  end
end

asteroids = []

map.each_with_index do |row, row_index|
  row.each_with_index do |cell, cell_index|
    asteroids << [row_index, cell_index] if cell == "#"
  end
end

current_asteroid = [11, 13]

p (asteroids - [current_asteroid]).sort_by { |a| [asteroids_between(map, current_asteroid, a), angle(current_asteroid, a)] }[199]
