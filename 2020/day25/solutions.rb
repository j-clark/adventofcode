require "pp"
input = File.read(File.join(File.dirname(__FILE__), "input.txt"))
# input = <<~a
# 5764801
# 17807724
# a

pk1, pk2 = input.lines.map(&:strip).map(&:to_i)

def find_loop_size(public_key)
  curr = 1
  (1..).lazy.find do |loop_size|
    curr = (curr * 7) % 20201227
    return loop_size if curr == public_key
  end
end

curr = 1
find_loop_size(pk1).times { curr = (curr * pk2) % 20201227 }
puts curr
