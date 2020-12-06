input = File.read(File.join(File.dirname(__FILE__), "input.txt")).strip

score = 0
depth = 0
garbage_chars = 0
garbage = false
cancelled = false

input.each_char do |char|
  if cancelled
    cancelled = false
    next
  end
  if garbage
    if char == "!"
      cancelled = true
    elsif char == ">"
      garbage = false
    else
      garbage_chars += 1
    end
    next
  end

  case char
  when "!"
    cancelled = true
  when "<"
    garbage = true
  when "{"
    depth += 1
  when "}"
    score += depth
    depth -= 1
  end
end

puts "part 1: #{score}"
puts "part 2: #{garbage_chars}"
