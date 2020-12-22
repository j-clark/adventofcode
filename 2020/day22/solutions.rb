require "set"
require "pp"

input = File.read(File.join(File.dirname(__FILE__), "input.txt"))

raw_players = input.split(/^$/).map(&:strip)
p1, p2 = raw_players
  .map { |raw_player, hash| raw_player.lines[1..-1].map(&:to_i) }

until [p1, p2].any?(&:empty?)
  i = p1.shift
  j = p2.shift
  if i > j
    p1.push(i)
    p1.push(j)
  else
    p2.push(j)
    p2.push(i)
  end
end

scores = [p1, p2].max_by(&:length)

score = scores.map.with_index do |val, i|
  val * (scores.length - i)
end.reduce(&:+)

puts "part 1: #{score}"
def to_key(p1, p2)
  "p1(#{p1.join(",")})-p2(#{p2.join(",")})"
end

def combat(p1, p2)
  previous = Set.new
  until [p1, p2].any?(&:empty?)
    key = to_key(p1, p2)
    return [p1, p2] if previous.include?(key)
    previous.add(key)

    i = p1.shift
    j = p2.shift
    if i <= p1.length && j <= p2.length
      sub_p1, _ = combat(p1.first(i), p2.first(j))
      if sub_p1.empty?
        p2.push(j)
        p2.push(i)
      else
        p1.push(i)
        p1.push(j)
      end
    elsif i > j
      p1.push(i)
      p1.push(j)
    else
      p2.push(j)
      p2.push(i)
    end
  end
  [p1, p2]
end

p1, p2 = raw_players
  .map { |raw_player, hash| raw_player.lines[1..-1].map(&:to_i) }
end_p1, end_p2 = combat(p1, p2)

scores = [end_p1, end_p2].max_by(&:length)

score = scores.map.with_index do |val, i|
  val * (scores.length - i)
end.reduce(&:+)

puts "part 2: #{score}"
