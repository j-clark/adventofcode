input = File.read(File.join(File.dirname(__FILE__), "input.txt"))

def parse_passport(text)
  text.lines
    .flat_map { |line| line.split(" ") }
    .map { |entry| entry.split(":") }
    .to_h
end

passport_texts = input.split(/^\s*$/).map(&:strip)
passports = passport_texts.map(&method(:parse_passport))

def valid_hgt?(text)
  if text =~ /\d+cm/
    text.to_i.between?(150, 193)
  elsif text =~ /\d+in/
    text.to_i.between?(59, 76)
  else
    false
  end
end

RULES = {
  "byr" => ->(val) { val.to_i.between?(1920, 2002) },
  "iyr" => ->(val) { val.to_i.between?(2010, 2020) },
  "eyr" => ->(val) { val.to_i.between?(2020, 2030) },
  "hgt" => ->(val) { valid_hgt?(val) },
  "hcl" => ->(val) { val =~ /^#[[a-f][0-9]]{6}$/ },
  "ecl" => ->(val) { %w(amb blu brn gry grn hzl oth).include?(val) },
  "pid" => ->(val) { val =~ /^\d{9}$/ }
}

# puts passports.map { |p| p["pid"] }.compact.uniq.sort

count = passports.count do |passport|
  RULES.all? { |field, rule| rule.call(passport[field]) }
end

p count
