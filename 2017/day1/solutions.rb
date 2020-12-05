nums = File.read(File.join(File.dirname(__FILE__), "input.txt"))
  .strip
  .each_char
  .map(&:to_i)

sum1 = 0
sum2 = 0

nums.each_with_index do |num, index|
  sum1 += num if num == nums[(index + 1) % nums.length]
end

nums.each_with_index do |num, index|
  sum2 += num if num == nums[(index + (nums.length / 2)) % nums.length]
end

puts "part 1: #{sum1}"
puts "part 2: #{sum2}"
