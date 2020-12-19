input = File.read(File.join(File.dirname(__FILE__), "input.txt"))

def evaluate(symbols, first, last)
  operator = nil
  total = 0
  symbols[first..last].each_with_index do|symbol, i|
    case symbol
    when Integer
      if operator.nil?
        total = symbol
      else
        total = total.send(operator, symbol)
      end
    when String
      operator = symbol
    end
    symbols[i + first] = nil
  end
  symbols[last] = total
end

def evaluate_advanced(symbols, first, last)
  while symbols[first..last].include?("+")
    plus_index = symbols[first..last].index("+") + first
    left_index = (plus_index - 1).downto(first).to_a.find { |i| symbols[i].is_a?(Integer) }
    right_index = (plus_index + 1).upto(last).to_a.find { |i| symbols[i].is_a?(Integer) }

    symbols[plus_index] = symbols[left_index] + symbols[right_index]
    symbols[left_index] = nil
    symbols[right_index] = nil
  end
  total = nil
  first.upto(last).each do |i|
    if symbols[i].is_a?(Integer)
      total = total.nil? ? symbols[i] : total = total * symbols[i]
    end
    symbols[i] = nil
  end
  symbols[last] = total
end

def run(input, eval_method)
  input.lines.map do |line|
    symbols = line.strip.split("").reject { |a| a == " " }
    opens = []
    symbols.each_with_index do |symbol, index|
      if symbol =~ /^\d+$/
        symbols[index] = symbol.to_i
      elsif symbol == "("
        opens.push(index)
      elsif symbol == ")"
        eval_method.call(symbols, opens.last + 1, index - 1)

        symbols[opens.last] = nil
        symbols[index] = nil
        opens.pop
      end
    end

    eval_method.call(symbols, 0, symbols.length - 1)
    symbols.last
  end.reduce(&:+)
end

puts "part 1: #{run(input, method(:evaluate))}"
puts "part 2: #{run(input, method(:evaluate_advanced))}"
