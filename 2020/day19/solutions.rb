input = File.read(File.join(File.dirname(__FILE__), "input.txt"))
# input = File.read(File.join(File.dirname(__FILE__), "input2.txt"))
# input = File.read(File.join(File.dirname(__FILE__), "input_sample2.txt"))

raw_rules, raw_messages = input.split(/^$/)
messages = raw_messages.strip.lines.map(&:strip)
rules = raw_rules.lines.map do |raw_rule|
  num, rules = raw_rule.strip.split(": ")

  [
    num,
    rules.split(" | ").map do |rule|
      rule.split(" ").map do |char|
        char.gsub('"', "")
      end
    end
  ]
end.to_h
rules_tree = Hash.new { |h, k| h[k] = { children: [] } }
rules.each do |rule_name, children|
  if children.flatten.one? && children.flatten.first =~ /[ab]/
    rules_tree[rule_name][:value] = children.flatten.first
  else
    rules_tree[rule_name][:children] = children
  end
end

def validate(message, rules_tree, rule_name, index = 0)
  rule = rules_tree[rule_name]
  return [true, index] if index == message.length
  return [message[index] == rule[:value], index + 1] unless rule[:value].nil?

  current_index = index
  valid_child = rule[:children].find do |names|
    current_index = index
    names.all? do |name|
      # next false if current_index >= message.length
      is_valid, new_index = validate(message, rules_tree, name, current_index)
      current_index = new_index if is_valid
      is_valid
    end
  end
  [!valid_child.nil?, current_index]
end

valid_messages = messages.select do |message|
  is_valid, last_index = validate(message, rules_tree, "0")
  is_valid && last_index == message.length
end.uniq
p valid_messages.count
