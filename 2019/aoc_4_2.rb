input = "248345-746315"

def matches?(num)
  num_to_s = num.to_s
  num_to_s.each_char.with_index do |char, index|
    digit = char.to_i
    next_char = num_to_s[index + 1]

    return false if next_char && next_char.to_i < digit
  end

  num_to_s.each_char.to_a.group_by { |a| a }.any? { |char, chars| chars.length == 2 }
end

puts 248345.upto(746315).count(&method(:matches?))
