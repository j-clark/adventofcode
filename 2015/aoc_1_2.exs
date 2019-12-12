{ _status, contents } = File.read(Path.expand("~/workspace/adventofcode/2015/aoc_1_input.txt"))
String.split(contents, "", trim: true)
|> Enum.with_index
|> Enum.reduce(0, fn({ x, idx }, acc) ->
  cond do
    x == "(" ->
      acc + 1
    x == ")" ->
      if acc == 0 do
        IO.puts idx
      end
      acc - 1
    x != ")" ->
      acc
  end
end
)
