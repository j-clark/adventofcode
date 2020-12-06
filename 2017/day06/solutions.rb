def cycle(banks)
  bank = banks.max
  index = banks.index(bank)
  banks[index] = 0

  until bank == 0
    index = (index + 1) % banks.length
    banks[index] += 1
    bank -= 1
  end
  banks
end

def find
  num = 0
  current_banks = File.read(File.join(File.dirname(__FILE__), "input.txt")).split.map(&:to_i)
  banks = {}
  banks[current_banks] = 0

  loop do
    next_banks = cycle(current_banks.dup)
    num += 1
    if banks.key?(next_banks)
      puts "part 1: #{num}"
      puts "part 2: #{num - banks[next_banks]}"
      return
    end
    banks[next_banks] = num
    current_banks = next_banks
  end
end
find
