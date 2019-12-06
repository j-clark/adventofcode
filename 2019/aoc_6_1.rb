require "set"

input = File.read(File.join(File.dirname(__FILE__), "aoc_6_input.txt"))

class SpaceThing
  attr_accessor :orbiters, :orbitee
  def initialize(id)
    @id = id
    @orbiters = Set.new
  end

  def distance_to_root
    return 0 if orbitee.nil?

    @distance_to_root ||= 1 + orbitee.distance_to_root
  end
end

def count_them(space_thing)
  space_thing.distance_to_root + space_thing.orbiters.map { |o| count_them(o) }.reduce(0, :+)
end

objects = input.split("\n").each_with_object({}) do |line, objects|
  left, right = line.split(")")
  orbitee = objects[left] ||= SpaceThing.new(left)
  orbiter = objects[right] ||= SpaceThing.new(right)

  orbiter.orbitee = orbitee
  orbitee.orbiters << orbiter
end

root = objects.values.find { |o| o.orbitee.nil? }

puts count_them(root)
