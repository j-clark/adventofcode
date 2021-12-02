input = File.read(File.join(File.dirname(__FILE__), "input.txt"))
depths = input.split("\n").map(&:to_i)

puts depths.each_cons(3).map { |a, b, c| a + b + c }.each_cons(2).filter { |a, b| b > a }.count
