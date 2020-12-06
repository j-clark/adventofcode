lines = File.read(File.join(File.dirname(__FILE__), "input.txt")).lines

registers = Hash.new(0)
instructions = lines.map do |line|
  matches = line.match(/(?<target>\S+) (?<operator>\S+) (?<amount>\S+) if (?<condition_register>\S+) (?<condition_operator>\S+) (?<condition_amount>\S+)/)

  {
    target: matches[:target],
    operator: matches[:operator],
    amount: matches[:amount].to_i,
    condition: {
      register: matches[:condition_register],
      operator: matches[:condition_operator],
      amount: matches[:condition_amount].to_i
    }
  }
end

max = 0
instructions.each do |instruction|
  condition = instruction[:condition]
  next unless registers[condition[:register]].send(condition[:operator], condition[:amount])
  if instruction[:operator] == "inc"
    registers[instruction[:target]] += instruction[:amount]
  else
    registers[instruction[:target]] -= instruction[:amount]
  end
  max = [max, registers[instruction[:target]]].max
end

puts "part 1: #{registers.values.max}"
puts "part 2: #{max}"
