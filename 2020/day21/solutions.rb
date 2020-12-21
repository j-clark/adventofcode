require "set"

input = File.read(File.join(File.dirname(__FILE__), "input.txt"))

allergens_to_foods = {}
input.lines.each do |line|
  raw_foods, raw_allergens = line.strip.split(" (contains ")
  allergens = raw_allergens.gsub(")", "").split(", ")
  foods = raw_foods.split(" ").to_set
  allergens.each do |allergen|
    if allergens_to_foods.key?(allergen)
      allergens_to_foods[allergen] = allergens_to_foods[allergen] & foods
    else
      allergens_to_foods[allergen] = foods
    end
  end
end

all_foods = input.lines.flat_map do |line|
  raw_foods, _ = line.strip.split(" (contains ")
  foods = raw_foods.split(" ")
end

puts "part 1: #{(all_foods - allergens_to_foods.values.reduce(&:|).to_a).count}"

until allergens_to_foods.values.all?(&:one?)
  allergens_to_foods.values.select(&:one?).each do |allergen|
    allergens_to_foods.values.reject(&:one?).each do |set|
      set.delete(allergen.first)
    end
  end
end
puts "part 2: #{allergens_to_foods.transform_values(&:first).sort_by(&:first).map(&:last).join(",")}"
