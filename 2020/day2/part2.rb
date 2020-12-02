input = File.read(File.join(File.dirname(__FILE__), "input.txt")).lines

rules = input.map do |line|
  match = line.match(/(?<first>\d+)-(?<second>\d+) (?<letter>[a-z]): (?<password>[a-z]+)/)
  {
    first: match[:first].to_i - 1,
    second: match[:second].to_i - 1,
    letter: match[:letter],
    password: match[:password]
  }
end

total = rules.count do |rule|
  (rule[:password][rule[:first]] == rule[:letter]) ^ (rule[:password][rule[:second]] == rule[:letter])
end

puts total
