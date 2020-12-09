require "set"

numbers = File.read(File.join(File.dirname(__FILE__), "input.txt")).lines.map(&:strip).map(&:to_i)

def find_key(numbers)
  numbers.each_cons(26) do |chunk|
    set = chunk[0, 25].to_set

    return chunk.last if set.none? do |num|
      num * 2 != chunk.last && set.include?(chunk.last - num)
    end
  end
end

key = find_key(numbers)
puts "part 1: #{key}"

def find_range(numbers, key)
  0.upto(numbers.length - 2) do |lower|
    sum = numbers[lower]
    (lower + 1).upto(numbers.length - 1) do |upper|
      sum += numbers[upper]

      return [lower, upper] if sum == key
    end
  end
end

lower, upper = find_range(numbers, key)
range = numbers[(lower..upper)]

puts "part 2: #{range.min + range.max}"
