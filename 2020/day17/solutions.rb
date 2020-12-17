input = File.read(File.join(File.dirname(__FILE__), "input.txt"))

class NDimensionGameOfLife
  ACTIVE = "#"
  INACTIVE = "."
  ACTIVE_NEXT = "A"
  INACTIVE_NEXT = "I"

  def initialize(dimensions:, input:)
    @dimensions = dimensions
    @input = input
  end

  def iterate(num_iterations = 6)
    num_iterations.times do
      grid[:bounds].map { |bound| ((bound[:min] - 1)..(bound[:max] + 1)).to_a }.reduce(&:product).map(&:flatten).each do |coords|
        nabes = neighbors(grid, coords)
        cell = grid[:data][coords]
        if is_active?(cell) && !nabes.count(&method(:is_active?)).between?(2, 3)
          grid[:data][coords] = INACTIVE_NEXT
        elsif !is_active?(cell) && nabes.count(&method(:is_active?)) == 3
          grid[:data][coords] = ACTIVE_NEXT
          grid[:bounds].each.with_index do |bound, index|
            bound[:min] = [bound[:min], coords[index]].min
            bound[:max] = [bound[:max], coords[index]].max
          end
        end
      end
      grid[:bounds].map { |bound| ((bound[:min] - 1)..(bound[:max] + 1)).to_a }.reduce(&:product).map(&:flatten).each do |coords|
        cell = grid[:data][coords]
        if cell == INACTIVE_NEXT
          grid[:data][coords] = INACTIVE
        elsif cell == ACTIVE_NEXT
          grid[:data][coords] = ACTIVE
        end
      end
    end
  end

  def count_active
    grid[:data].values.count { |v| v == ACTIVE }
  end

  private
  attr_reader :dimensions, :input


  def grid
    @grid ||= build_grid
  end

  def is_active?(cell)
    [ACTIVE, INACTIVE_NEXT].include?(cell)
  end

  def build_grid
    grid = {
      bounds: [],
      data: {}
    }

    dimensions.times do |i|
      if i == 0
        grid[:bounds].push(min: 0, max: input.lines.first.strip.length)
      elsif i == 1
        grid[:bounds].push(min: 0, max: input.lines.length)
      else
        grid[:bounds].push(min: 0, max: 0)
      end
    end

    input.lines.map { |l| l.strip.split("") }.each_with_index do |row, row_i|
      row.each_with_index do |cell, col_i|
        coords = dimensions.times.map { 0 }
        coords[0] = row_i
        coords[1] = col_i
        grid[:data][coords] = cell
      end
    end
    grid
  end

  def neighbors(grid, coords)
    dimensions.times.map { [-1, 0, 1] }
      .reduce(&:product)
      .map(&:flatten)
      .reject { |a| a == dimensions.times.map { 0 } }
      .map { |deltas| deltas.map.with_index { |d, i| d + coords[i] } }
      .map { |coords| grid[:data][coords] || INACTIVE }
  end
end

board = NDimensionGameOfLife.new(dimensions: 3, input: input)
board.iterate
puts "part 1: #{board.count_active}"

board = NDimensionGameOfLife.new(dimensions: 4, input: input)
board.iterate
puts "part 2: #{board.count_active}"
