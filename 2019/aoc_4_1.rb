input = "248345-746315"

def matches?(num)
  num_to_s = num.to_s
  doubles = false
  num_to_s.each_char.with_index do |char, index|
    digit = char.to_i
    next_char = num_to_s[index + 1]

    doubles ||= char == next_char

    return false if next_char && next_char.to_i < digit
  end

  return doubles
end

puts 248345.upto(746315).count(&method(:matches?))
