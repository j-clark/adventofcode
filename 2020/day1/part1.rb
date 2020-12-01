require "set"

input = File.read(File.join(File.dirname(__FILE__), "input.txt"))
numbers = input.split("\n").map(&:to_i).to_set

match = numbers.find { |number| numbers.include?(2020 - number) }
puts match * (2020 - match)
