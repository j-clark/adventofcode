input = File.read(File.join(File.dirname(__FILE__), "input.txt"))
instrs = input.lines.map(&:strip)

def to_b_str(val)
  "%036b" % val
end

def apply_mask(mask, val)
  bval = to_b_str(val)

  mask.each_char.with_index { |c, i| bval[i] = c unless c == "X" }

  bval.to_i(2)
end

def addrs(mask, value, index: 0)
  return [value] if index == mask.length

  if mask[index] == "X"
    v1 = value.dup
    v1[index] = "0"
    v2 = value.dup
    v2[index] = "1"
    return addrs(mask, v1, index: index + 1) + addrs(mask, v2, index: index + 1)
  else
    v1 = value.dup
    v1[index] = (v1[index].to_i | mask[index].to_i).to_s
    return addrs(mask, v1, index: index + 1)
  end
end

mask = ""
mem1 = {}
mem2 = {}
instrs.each do |instr|
  if instr =~ /mask/
    mask = instr.split(" ").last
  else
    matches = instr.match(/mem\[(?<addr>\d+)\] = (?<val>\d+)/)
    addr = matches[:addr].to_i
    val = matches[:val].to_i
    mem1[addr] = apply_mask(mask, val)
    addrs(mask, to_b_str(addr)).each { |a| mem2[a] = val }
  end
end
puts "part 1: #{mem1.values.reduce(&:+)}"
puts "part 2: #{mem2.values.reduce(&:+)}"
