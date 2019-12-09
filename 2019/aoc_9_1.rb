class IntcodeComputer
  OUTPUTTERS = [1, 2, 3, 7, 8]
  INSTRUCTIONS = {
    1 => :add,
    2 => :multiply,
    3 => :input,
    4 => :output,
    5 => :jump_if_true,
    6 => :jump_if_false,
    7 => :less_than?,
    8 => :equal?,
    9 => :adjust_relative_base,
    99 => :terminate
  }

  def self.run(program, input: nil)
    new(program, input).tap(&:run)
  end

  def initialize(program, input_value)
    @program = program
    @input_value = input_value
    @pointer = 0
    @relative_base = 0
    @terminated = false
  end

  def run
    loop do
      value = @program[@pointer].to_s
      opcode = opcode_from_value(value)
      modes = modes_from_value(value)

      instruction = method(INSTRUCTIONS[opcode])
      inputs = @program[(@pointer + 1)..(@pointer + instruction.arity)]
      inputs.each_with_index do |input, index|
        mode = modes[index].to_i
        if OUTPUTTERS.include?(opcode) && index == inputs.length - 1
          inputs[index] = @relative_base + input if mode == 2
        else
          if mode == 0
            inputs[index] = @program[input].to_i
          elsif mode == 2
            inputs[index] = @program[@relative_base + input].to_i
          end
        end
      end

      @pointer = instruction.call(*inputs) || @pointer + instruction.arity + 1
    end
  rescue Stop
  end

  def terminated?
    @terminated
  end

  def send_input(input)
    @input_value = input
    run
  end

  private

  def add(a, b, loc)
    @program[loc] = a + b
    nil
  end

  def multiply(a, b, loc)
    @program[loc] = a * b
    nil
  end

  def input(loc)
    raise "missing input" unless @input_value

    @program[loc] = @input_value
    @input_value = nil
  end

  def output(value)
    puts value
    nil
  end

  def jump_if_true(bool, jump_location)
    bool != 0 ? jump_location : nil
  end

  def jump_if_false(bool, jump_location)
    bool == 0 ? jump_location : nil
  end

  def less_than?(left, right, loc)
    @program[loc] = left < right ? 1 : 0
    nil
  end

  def equal?(left, right, loc)
    @program[loc] = left == right ? 1 : 0
    nil
  end

  def adjust_relative_base(val)
    @relative_base += val
    nil
  end

  def terminate(*)
    @terminated = true
    raise Stop
  end

  def opcode_from_value(value)
    return value.to_i if value.length <= 2

    value[-2..-1].to_i
  end

  def modes_from_value(value)
    return [] if value.length <= 2

    value[0...-2].split("").reverse.map(&:to_i)
  end

  class Stop < StandardError; end
end

input_text = File.read(File.join(File.dirname(__FILE__), "aoc_9_input.txt"))

# part 1
IntcodeComputer.run(input_text.split(",").map(&:to_i), input: 1)
# part 2
IntcodeComputer.run(input_text.split(",").map(&:to_i), input: 2)
