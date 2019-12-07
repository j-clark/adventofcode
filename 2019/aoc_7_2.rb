class Program
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
    99 => :terminate
  }

  def self.run(phase)
    new(phase).tap(&:run)
  end

  def initialize(phase)
    @input_value = phase
    @output_value = nil
    @pointer = 0
    @terminated = false
  end

  def run
    loop do
      value = program[@pointer].to_s
      opcode = opcode_from_value(value)
      modes = modes_from_value(value)

      instruction = method(INSTRUCTIONS[opcode])
      inputs = program[(@pointer + 1)..(@pointer + instruction.arity - 1)]
      inputs[0..(OUTPUTTERS.include?(opcode) ? -2 : -1)].each_with_index do |input, index|
        inputs[index] = program[input] if modes[index].to_i == 0
      end

      @pointer = instruction.call(program, *inputs) || @pointer + instruction.arity
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

  def fetch_output
    @output_value
  end

  private

  def add(program, a, b, loc)
    program[loc] = a + b
    nil
  end

  def multiply(program, a, b, loc)
    program[loc] = a * b
    nil
  end

  def input(program, loc)
    raise Stop unless @input_value

    program[loc] = @input_value
    @input_value = nil
  end

  def output(program, value)
    @output_value = value
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

  def program
    @program ||= input_text.split(",").map(&:to_i)
  end

  def input_text
    @input_text ||= File.read(File.join(File.dirname(__FILE__), "aoc_7_input.txt"))
  end

  class Stop < StandardError; end
end

max_signal = 0

5.upto(9).to_a.permutation do |values|
  programs = values.map { |v| Program.run(v) }

  current_thruster = 0
  current_program = programs.first
  current_program.send_input(0)

  loop do
    break if programs.all?(&:terminated?)

    next_thruster = (current_thruster + 1) % 5
    next_program = programs[next_thruster]

    next_program.send_input(current_program.fetch_output)

    current_thruster = next_thruster
    current_program = next_program
  end

  max_signal = current_program.fetch_output if max_signal < current_program.fetch_output
end

puts max_signal
