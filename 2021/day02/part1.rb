input = File.read(File.join(File.dirname(__FILE__), "input.txt"))

commands = input.strip.lines.map(&:strip)

horizontal = 0
depth = 0

commands.each do |command|
  direction, amount = command.split(" ")
  amount = amount.to_i

  case direction
  when "forward"
    horizontal += amount
  when "down"
    depth += amount
  when "up"
    depth -= amount
  end
end

puts horizontal * depth
