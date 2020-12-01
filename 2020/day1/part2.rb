require "set"

input = File.read(File.join(File.dirname(__FILE__), "input.txt"))
numbers = input.split("\n").map(&:to_i).to_set

numbers.each do |a|
  numbers.each do |b|
    match = 2020 - (a + b)

    if (numbers.include?(match))
      puts match * a * b
      exit
    end
  end
end

puts "dunno"
