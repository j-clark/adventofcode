
numbers = File.read(File.join(File.dirname(__FILE__), "input.txt")).lines.map(&:to_i)
curr = 0
jumps = 0
until curr >= numbers.length
  offset = numbers[curr]
  numbers[curr] += 1
  curr += offset
  jumps += 1
end
p jumps

numbers = File.read(File.join(File.dirname(__FILE__), "input.txt")).lines.map(&:to_i)
curr = 0
jumps = 0
until curr >= numbers.length
  offset = numbers[curr]
  offset < 3 ? numbers[curr] += 1 : numbers[curr] -= 1
  curr += offset
  jumps += 1
end
p jumps
