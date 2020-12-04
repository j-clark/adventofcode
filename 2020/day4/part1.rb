input = File.read(File.join(File.dirname(__FILE__), "input.txt"))

REQUIRED_FIELDS = %w(byr iyr eyr hgt hcl ecl pid)

def parse_passport(text)
  text.lines
    .flat_map { |line| line.split(" ") }
    .map { |entry| entry.split(":") }
    .to_h
end

passport_texts = input.split(/^\s*$/).map(&:strip)
passports = passport_texts.map(&method(:parse_passport))

p passports.count { |p| (REQUIRED_FIELDS - p.keys).empty? }
