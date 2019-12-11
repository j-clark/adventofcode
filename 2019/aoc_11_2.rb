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
    @output_values = []
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

  def fetch_output
    val = @output_values
    fail "no output" unless val
    @output_values = []
    val
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
    raise Stop unless @input_value

    @program[loc] = @input_value
    @input_value = nil
  end

  def output(value)
    @output_values << value
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

program = File.read(File.join(File.dirname(__FILE__), "aoc_11_input.txt")).split(",").map(&:to_i)

program = IntcodeComputer.run(program)

SIZE = 200
map = Array.new(SIZE) { Array.new(SIZE) { nil } }
dirs = [:up, :right, :down, :left]
dir_index = 0
x = SIZE / 2
y = SIZE / 2
map[x][y] = 1

loop do
  break if program.terminated?

  program.send_input(map[x][y].to_i)
  color, direction = program.fetch_output
  map[x][y] = color
  if direction == 1
    dir_index = (dir_index + 1) % 4
  else
    dir_index = (dir_index - 1) % 4
  end

  case dirs[dir_index]
  when :up
    x -= 1
  when :down
    x += 1
  when :right
    y += 1
  when :left
    y -= 1
  end

  fail "out of bounds" if x < 0 || y < 0
end

puts map.flatten.compact.count

map = map.map do |row|
  row.map do |cell|
    case cell
    when 0 then " "
    when 1 then "█"
    when nil then " "
    end
  end
end

puts map.map { |a| a.join("") }.join("\n")
