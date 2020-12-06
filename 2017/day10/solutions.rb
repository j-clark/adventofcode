input = File.read(File.join(File.dirname(__FILE__), "input.txt"))

def sparse_hash(lengths, runs)
  sequence = 0.upto(255).to_a
  pos = 0
  skip = 0

  runs.times do
    lengths.each do |length|
      sub = []

      0.upto(length - 1) do |i|
        sub[i] = sequence[(pos + i) % sequence.length]
      end

      sub.reverse.each_with_index do |val, index|
        sequence[(pos + index) % sequence.length] = val
      end

      pos = (pos + length + skip) % sequence.length
      skip += 1
    end
  end

  sequence
end

lengths = input.split(",").map(&:to_i)
sequence = sparse_hash(lengths, 1)
puts "part 1: #{sequence[0] * sequence[1]}"

lengths = input.strip.each_char.map(&:ord).dup + [17, 31, 73, 47, 23]
sequence = sparse_hash(lengths, 64)
hash = sequence.each_slice(16).map { |group| group.reduce(&:^) }.map { |a| "%02x" % a }.join("")
puts "part 2: #{hash}"
