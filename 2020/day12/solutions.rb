require "set"

input = File.read(File.join(File.dirname(__FILE__), "input.txt"))
instructions = input.lines.map(&:strip)

DIRS = %w(N E S W)

def next_dir(dir, instruction)
  degrees = instruction.gsub(/^./, "").to_i
  steps = degrees /= 90
  index =
    if instruction[0] == "R"
      (DIRS.index(dir) + steps) % 4
    else
      DIRS.index(dir) - steps
    end

  DIRS[index]
end

def rotate(instruction, wp_x, wp_y)
  case instruction
  when "R90", "L270"
    [-1 * wp_y, wp_x]
  when "R180", "L180"
    [-1 * wp_x, -1 * wp_y]
  when "R270", "L90"
    [wp_y, -1 * wp_x]
  end
end

dir = "E"
x = 0
y = 0

instructions.each do |instruction|
  amt = instruction.gsub(/^./, "").to_i
  instruction = instruction.gsub("F", dir)
  case instruction[0]
  when "N"
    x += amt
  when "E"
    y += amt
  when "S"
    x -= amt
  when "W"
    y -= amt
  when "R", "L"
    dir = next_dir(dir, instruction)
  end
end

puts "part 1: #{x.abs + y.abs}"

ship_x = 0
ship_y = 0
wp_x = 1
wp_y = 10

instructions.each do |instruction|
  amt = instruction.gsub(/^./, "").to_i
  case instruction[0]
  when "N"
    wp_x += amt
  when "E"
    wp_y += amt
  when "S"
    wp_x -= amt
  when "W"
    wp_y -= amt
  when "R", "L"
    wp_x, wp_y = rotate(instruction, wp_x, wp_y)
  when "F"
    ship_x += (wp_x * amt)
    ship_y += (wp_y * amt)
  end
end

puts "part 2: #{ship_x.abs + ship_y.abs}"
