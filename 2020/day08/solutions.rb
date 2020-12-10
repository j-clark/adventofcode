require "set"

lines = File.read(File.join(File.dirname(__FILE__), "input.txt")).lines.map(&:strip)

def run(lines)
  acc = 0
  line_num = 0
  seen_line_numbers = Set.new

  loop do
    line = lines[line_num]
    return [acc, true] if line.nil?
    instr, amt = line.split(" ")
    amt = amt.to_i

    return [acc, false] if seen_line_numbers.include?(line_num)
    seen_line_numbers.add(line_num)

    case instr
    when "acc"
      acc += amt
      line_num += 1
    when "jmp"
      line_num += amt
    when "nop"
      line_num += 1
    end
  end
end

puts "part 1: #{run(lines).first}"

lines.each_with_index do |line, index|
  next if line =~ /acc/
  instr, amt = line.split(" ")
  new_line = "#{instr == 'jmp' ? 'nop' : 'jmp'} #{amt}"
  acc, done = run(lines[0, index] + [new_line] + lines[index + 1, lines.length])
  puts "part 2: #{acc}" and break if done
end
