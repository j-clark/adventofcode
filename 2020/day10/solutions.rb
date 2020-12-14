numbers = File.read(File.join(File.dirname(__FILE__), "input.txt")).lines.map(&:strip).map(&:to_i).sort

ones = 1
threes = 1
prev = numbers.first
numbers[1, numbers.length].each do |curr|
  ones += 1 if (curr - prev) == 1
  threes += 1 if (curr - prev) == 3

  prev = curr
end

puts "part 1: #{ones * threes}"

numbers = numbers.reverse
numbers.push(0)

tree = numbers.each_with_object({}).with_index do |(num, tree), index|
  tree[num] = [1,2,3]
    .filter { |n| index <= numbers.length - (n + 1) && num - numbers[index + n] <= 3 }
    .map { |n| numbers[index + n] }
end

def count(t, num, count: 0, memo: {})
  return 1 if t[num].empty?
  return memo[num] if memo.key?(num)

  memo[num] = t[num].map { |n| count(t, n, count: count, memo: memo) }.reduce(&:+)
end


puts "part 2: #{count(tree, numbers.first)}"
