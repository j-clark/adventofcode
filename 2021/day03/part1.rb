numbers = File.read(File.join(File.dirname(__FILE__), "input.txt")).strip.lines.map(&:strip)

number_length = numbers.first.length
most_common_digits = number_length.times.map do |index|
  zeroes = 0
  ones = 0
  input.each do |line|
    if line[index] == "0"
      zeroes += 1
    else
      ones += 1
    end
  end

  zeroes > ones ? "0" : "1"
end

num =  most_common_digits.join("").to_i(2)

p num * (num ^ ("1" * number_length).to_i(2))
