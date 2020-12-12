require "set"

input = File.read(File.join(File.dirname(__FILE__), "input.txt"))

FLOOR = "."
EMPTY = "L"
EMPTY_NEXT = "l"
OCCUPIED = "#"
OCCUPIED_NEXT = "3"

def print_board(board)
  puts board.map { |row| row.join(" ") }.join("\n")
  puts
end

def neighbors(board, x, y)
  nabes = []
  nabes.push(board[x + 1][y - 1]) if x < board.length - 1 && y > 0
  nabes.push(board[x + 1][y]) if x < board.length - 1
  nabes.push(board[x + 1][y + 1]) if x < board.length - 1 && y < board.first.length - 1
  nabes.push(board[x][y - 1]) if y > 0
  nabes.push(board[x][y + 1]) if y < board.first.length - 1
  nabes.push(board[x - 1][y - 1]) if x > 0 && y > 0
  nabes.push(board[x - 1][y]) if x > 0
  nabes.push(board[x - 1][y + 1]) if x > 0 && y < board.first.length - 1
  nabes
end

def visible_neighbors(board, x, y)
  nabes = []

  increments = [[-1, -1], [-1, 0], [-1,  1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

  increments.each do |x_inc, y_inc|
    curr_x = x
    curr_y = y

    while (curr_x + x_inc).between?(0, board.length - 1) && (curr_y + y_inc).between?(0, board.first.length - 1)
      curr_x += x_inc
      curr_y += y_inc
      break if board[curr_x][curr_y] != FLOOR
    end
    nabes.push(board[curr_x][curr_y]) if curr_x != x || curr_y != y
  end

  nabes
end

def iterate(board, nabes_func, nabes_allowed)
  changed = false

  board.each_with_index do |row, x|
    row.each_with_index do |cell, y|
      nabes = nabes_func.call(board, x, y)
      if cell == EMPTY && nabes.all? { |c| [FLOOR, EMPTY, OCCUPIED_NEXT].include?(c) }
        board[x][y] = OCCUPIED_NEXT
        changed = true
      elsif cell == OCCUPIED && nabes.filter { |c| [OCCUPIED, EMPTY_NEXT].include?(c) }.count > nabes_allowed
        board[x][y] = EMPTY_NEXT
        changed = true
      end
    end
  end

  board.each_with_index do |row, x|
    row.each_with_index do |cell, y|
      if cell == EMPTY_NEXT
        board[x][y] = EMPTY
      elsif cell == OCCUPIED_NEXT
        board[x][y] = OCCUPIED
      end
    end
  end

  changed
end

b = input
  .lines
  .map { |line| line.strip.split("") }

while iterate(b, method(:neighbors),3); end

puts "part 1: #{b.flatten.count { |c| c == OCCUPIED }}"

b = input
  .lines
  .map { |line| line.strip.split("") }

while iterate(b, method(:visible_neighbors), 4); end

puts "part 2: #{b.flatten.count { |c| c == OCCUPIED }}"
