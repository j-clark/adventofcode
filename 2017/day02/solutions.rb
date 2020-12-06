lines = File.read(File.join(File.dirname(__FILE__), "input.txt"))
  .lines
  .map(&:split)
  .map { |line| line.map(&:to_i).sort }

part1 = lines
  .map { |line| line.last - line.first }
  .reduce(&:+)

puts "part 1: #{part1}"

sum = 0

lines.each do |line|
  line.each do |a|
    line.each do |b|
      next if a <= b

      sum += (a / b) if (a / b.to_f) == (a / b)
    end
  end
end

puts "part 2: #{sum}"
