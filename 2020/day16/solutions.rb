require "pp"

input = File.read(File.join(File.dirname(__FILE__), "input.txt"))
raw_rules, raw_ticket, raw_all_tickets = input.split(/^$/).map(&:strip)

rules = raw_rules.split("\n").map do |rule|
  name, raw_ranges = rule.strip.split(": ")
  ranges = raw_ranges
    .split(" or ")
    .flat_map { |a| a.split("-") }
    .map(&:to_i)
    .each_slice(2)
    .to_a

  [name, ranges]
end.to_h
my_ticket = raw_ticket.lines.last.split(",").map(&:to_i)
tickets = raw_all_tickets.lines[1..-1].map { |l| l.split(",").map(&:to_i) }

baddies = tickets.flat_map do |ticket|
  ticket.select do |value|
    rules.values.none? do |bound1, bound2|
      value.between?(*bound1) || value.between?(*bound2)
    end
  end
end

puts "part 1: #{baddies.reduce(&:+)}"

valid_tickets = tickets.reject do |ticket|
  ticket.any? do |value|
    rules.values.none? do |bound1, bound2|
      value.between?(*bound1) || value.between?(*bound2)
    end
  end
end

rules_to_positions = {}
rules.each do |name, ranges|
  positions = (0..(valid_tickets.first.length - 1)).to_a.select do |pos|
    valid_tickets.all? do |ticket|
      ticket[pos].between?(*ranges[0]) || ticket[pos].between?(*ranges[1])
    end
  end
  rules_to_positions[name] = positions
end

until rules_to_positions.values.all?(&:one?) do
  pos_to_remove = rules_to_positions.select { |_, ps| ps.one? }.map(&:last).flatten
  names_to_remove_from = rules_to_positions.reject { |_, ps| ps.one? }.map(&:first).flatten

  pos_to_remove.each do |pos|
    names_to_remove_from.each do |name|
      rules_to_positions[name].delete(pos)
    end
  end
end

part2 = rules_to_positions
  .transform_values(&:first)
  .select { |k, v| k =~ /depart/ }
  .map(&:last)
  .map { |i| my_ticket[i] }
  .reduce(&:*)

puts "part 2: #{part2}"
