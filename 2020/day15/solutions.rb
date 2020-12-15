input = "0,13,16,17,1,10,6"

numbers = input.split(",").map(&:to_i)
numbers_by_index = numbers
  .each_with_object({}).with_index
  .each { |(number, map), index| map[number] = index + 1 }

prev = 0
index = numbers.length + 2

until index > 30000000 do
  curr =
    if numbers_by_index.key?(prev)
      index - numbers_by_index[prev] - 1
    else
      0
    end

  numbers_by_index[prev] = index - 1

  puts "part 1: #{curr}" if index == 2020
  puts "part 2: #{curr}" if index == 30_000_000

  prev = curr
  index += 1
end
