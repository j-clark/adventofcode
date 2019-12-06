require "set"

input = File.read(File.join(File.dirname(__FILE__), "aoc_6_input.txt"))

class SpaceThing
  attr_accessor :orbiters, :orbitee, :id
  def initialize(id)
    @id = id
    @orbiters = Set.new
  end

  def distance_to_root
    return 0 if orbitee.nil?

    @distance_to_root ||= 1 + orbitee.distance_to_root
  end

  def path_to_root
    return [] if orbitee.nil?

    @path_to_root ||= [orbitee] + orbitee.path_to_root
  end
end

objects = input.split("\n").each_with_object({}) do |line, objects|
  left, right = line.split(")")
  orbitee = objects[left] ||= SpaceThing.new(left)
  orbiter = objects[right] ||= SpaceThing.new(right)

  orbiter.orbitee = orbitee
  orbitee.orbiters << orbiter
end

me = objects["YOU"]
santa = objects["SAN"]

common_ancestor = me.path_to_root.find { |node| santa.path_to_root.include?(node) }

puts me.path_to_root.index(common_ancestor) + santa.path_to_root.index(common_ancestor)
