def add(program, a, b, loc)
  program[loc] = a + b
  nil
end

def multiply(program, a, b, loc)
  program[loc] = a * b
  nil
end

def input(program, loc)
  program[loc] = $io_values[$io_value_pointer]
  $io_value_pointer += 1
  nil
end

def output(program, value)
  $io_values[$io_value_pointer + 1] = value
  nil
end

def jump_if_true(_program, bool, jump_location)
  bool != 0 ? jump_location : nil
end

def jump_if_false(_program, bool, jump_location)
  bool == 0 ? jump_location : nil
end

def less_than?(program, left, right, loc)
  program[loc] = left < right ? 1 : 0
  nil
end

def equal?(program, left, right, loc)
  program[loc] = left == right ? 1 : 0
  nil
end

class Terminate < StandardError; end

def terminate(*)
  raise Terminate
end

INSTRUCTIONS = {
  1 => method(:add),
  2 => method(:multiply),
  3 => method(:input),
  4 => method(:output),
  5 => method(:jump_if_true),
  6 => method(:jump_if_false),
  7 => method(:less_than?),
  8 => method(:equal?),
  99 => method(:terminate)
}

OUTPUTTERS = [1, 2, 3, 7, 8]

def run_program
  input_text = File.read(File.join(File.dirname(__FILE__), "aoc_7_input.txt"))
  program = input_text.split(",").map(&:to_i)

  pointer = 0

  def opcode_from_value(value)
    return value.to_i if value.length <= 2

    value[-2..-1].to_i
  end

  def modes_from_value(value)
    return [] if value.length <= 2

    value[0...-2].split("").reverse.map(&:to_i)
  end

  loop do
    value = program[pointer].to_s
    opcode = opcode_from_value(value)
    modes = modes_from_value(value)

    instruction = INSTRUCTIONS[opcode]
    fail "bad code #{opcode}" if instruction.nil?
    inputs = program[(pointer + 1)..(pointer + instruction.arity - 1)]
    inputs[0..(OUTPUTTERS.include?(opcode) ? -2 : -1)].each_with_index do |input, index|
      inputs[index] = program[input] if modes[index].to_i == 0
    end

    begin
      pointer = instruction.call(program, *inputs) || pointer + instruction.arity
    rescue Terminate
      return
    end
  end
end

max_signal = 0

0.upto(4).to_a.permutation do |a, b, c, d, e|
  # hacky
  $io_value_pointer = 0
  $io_values = [a, 0, b, nil, c, nil, d, nil, e]

  5.times { run_program }
  max_signal = $io_values.last if max_signal < $io_values.last
end

puts max_signal
