numbers = input.split(" ").map(&:strip).map(&:to_i)
numbers.map { |num| num / 3 - 2 }.reduce(:+)
