map = File.read(File.join(File.dirname(__FILE__), "aoc_10_input.txt")).split("\n").map { |row| row.split("") }

def visible?(map, point1, point2)
  points = points_between(point1, point2)
  points.all? { |point| map[point[0]][point[1]] == "." }
end

def points_between(point1, point2)
  if point1.first == point2.first
    if point1.last < point2.last
      return (point1.last..point2.last).to_a[1..-2].map { |y| [point1.first, y] }
    else
      return (point2.last..point1.last).to_a[1..-2].map { |y| [point1.first, y] }
    end
  else
    slope = (point2.last - point1.last).to_f / (point2.first - point1.first).to_f

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

asteroid_visibility = {}

asteroids.each do |asteroid1|
  asteroid_visibility[asteroid1] = 0

  asteroids.each do |asteroid2|
    next if asteroid1 == asteroid2
    asteroid_visibility[asteroid1] += 1 if visible?(map, asteroid1, asteroid2)
  end
end

p asteroid_visibility.max_by(&:last).last
