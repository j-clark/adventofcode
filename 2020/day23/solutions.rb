input = "284573961"

cup_nums = input.strip.split("").map(&:to_i)

def build_cups(cup_nums)
  cup_nums.each_with_object({}).with_index do |(cup, hash), index|
    hash[cup] = {
      prev: cup_nums[index - 1],
      next: cup_nums[(index + 1) % cup_nums.length]
    }
  end
end

def play(cups, num_iterations)
  cup_nums = cups.keys
  max = cup_nums.max
  curr = cup_nums.first
  num_iterations.times do |i|
    three = [cups[curr][:next], cups[cups[curr][:next]][:next], cups[cups[cups[curr][:next]][:next]][:next]]

    dest = curr > 1 ? curr - 1 : max
    dest = dest > 1 ? dest - 1 : max while three.include?(dest)

    before_three = cups[three.first][:prev]
    after_three = cups[three.last][:next]
    cups[before_three][:next] = after_three
    cups[after_three][:prev] = before_three

    after_dest = cups[dest][:next]
    cups[dest][:next] = three.first
    cups[three.first][:prev] = dest
    cups[after_dest][:prev] = three.last
    cups[three.last][:next] = after_dest

    curr = cups[curr][:next]
  end
end

cups = build_cups(cup_nums)
play(cups, 100)
str = ""
val = cups[1][:next]
while val != 1
  str += val.to_s
  val = cups[val][:next]
end
puts "part 1: #{str}"

cups = build_cups(cup_nums + (10..1_000_000).to_a)
play(cups, 10_000_000)
puts "part 2: #{cups[1][:next] * cups[cups[1][:next]][:next]}"
