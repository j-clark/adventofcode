
input = File.read(File.join(File.dirname(__FILE__), "input.txt"))

commands = input.strip.lines.map(&:strip)

horizontal = 0
depth = 0
aim = 0

commands.each do |command|
  direction, amount = command.split(" ")
  amount = amount.to_i

  case direction
  when "forward"
    horizontal += amount
    depth = depth + (aim * amount)
  when "down"
    aim += amount
  when "up"
    aim -= amount
  end
end

puts horizontal * depth
