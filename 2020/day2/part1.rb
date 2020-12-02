input = File.read(File.join(File.dirname(__FILE__), "input.txt")).lines

rules = input.map do |line|
  match = line.match(/(?<lower>\d+)-(?<upper>\d+) (?<letter>[a-z]): (?<password>[a-z]+)/)
  {
    lower: match[:lower].to_i,
    upper: match[:upper].to_i,
    letter: match[:letter],
    password: match[:password]
  }
end

total = rules.count do |rule|
  count = rule[:password].count(rule[:letter])
  rule[:lower] <= count && count <= rule[:upper]
end

puts total
