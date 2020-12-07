require "set"

rule_lines = File.read(File.join(File.dirname(__FILE__), "input.txt")).lines

rules = rule_lines.each_with_object({}) do |rule_line, rules|
  matches = rule_line.match(/(?<color>.+) bags contain (?<contents>.+)/)
  color = matches[:color]

  if matches[:contents] == "no other bags."
    rules[color] = { contains: {} }
  else
    contains = matches[:contents].split(", ").map do |contents|
      contents_matches = contents.match(/(?<count>\d+) (?<color>.+) bags?/)
      [
        contents_matches[:color],
        contents_matches[:count].to_i
      ]
    end
    rules[color] = { contains: contains.to_h }
  end
end

rules.each do |color, config|
  config[:contains].keys.each do |contained|
    rules[contained][:contained_by] ||= []
    rules[contained][:contained_by].push(color)
  end
end

def count_top_level(color, rules, containing_colors: Set.new)
  rules[color][:contained_by].to_a.each { |c| containing_colors.add(c) }

  rules[color][:contained_by].to_a.each do |contained_by|
    count_top_level(contained_by, rules, containing_colors: containing_colors)
  end

  containing_colors.count
end

puts "part 1: #{count_top_level('shiny gold', rules)}"

def count_contained(color, rules)
  return 0 if rules[color][:contains].empty?

  rules[color][:contains]
    .map { |contained, count| count + count * count_contained(contained, rules) }
    .reduce(&:+)
end

puts "part 2: #{count_contained('shiny gold', rules)}"
